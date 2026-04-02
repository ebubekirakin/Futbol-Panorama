import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const API_FOOTBALL_KEY = Deno.env.get('API_FOOTBALL_KEY') ?? '';
const API_URL = 'https://v3.football.api-sports.io'; 

const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? '';
const supabaseServiceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';
// Supabase istemcisini başlatıyoruz
const supabase = createClient(supabaseUrl, supabaseServiceRoleKey);

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

serve(async (req: Request) => {
  try {
    const headers = {
      'x-rapidapi-host': 'v3.football.api-sports.io',
      'x-rapidapi-key': API_FOOTBALL_KEY
    };
    
    // Maçları (Fixtures) çekiyoruz
    const fixtureResponse = await fetch(`${API_URL}/fixtures?league=203&season=2023&last=5`, { headers });
    const fixtureData = await fixtureResponse.json();
    const fetchedMatches = fixtureData.response || [];

    for (const match of fetchedMatches) {
        const matchId = match.fixture.id;
        await delay(1000); // Rate Limit önlemi

        // İstek: Oyuncu istatistiklerini (fixtures/players endpointi API-Football'da oyuncuları döner) çek
        const playerStatResponse = await fetch(`${API_URL}/fixtures/players?fixture=${matchId}`, { headers });
        const playerStatData = await playerStatResponse.json();

        // ------------------------------------------------------------------
        // 1. ADIM: "TEAMS" (Takımlar) Tablosunu UPSERT Yapmak
        // ------------------------------------------------------------------
        const homeTeam = {
          id: match.teams.home.id,
          name: match.teams.home.name,
          logo: match.teams.home.logo,
        };
        const awayTeam = {
          id: match.teams.away.id,
          name: match.teams.away.name,
          logo: match.teams.away.logo,
        };

        // Supabase tarafında upsert fonksiyonuna '{ onConflict: "kilit_kolon" }' parametresi verilir.
        // Bu, PostgreSQL'deki ON CONFLICT (id) DO UPDATE komutunun tam karşılığıdır.
        await supabase
          .from('teams')
          .upsert([homeTeam, awayTeam], { onConflict: 'id' });

        // ------------------------------------------------------------------
        // 2. ADIM: "MATCHES" (Maçlar) Tablosunu UPSERT Yapmak
        // ------------------------------------------------------------------
        const matchRecord = {
          id: matchId,
          home_team_id: match.teams.home.id,
          away_team_id: match.teams.away.id,
          goals_home: match.goals.home,
          goals_away: match.goals.away,
          date: match.fixture.date,
          status: match.fixture.status.short, // Örn: 'FT' (Full Time)
        };

        await supabase
          .from('matches')
          .upsert(matchRecord, { onConflict: 'id' });

        // ------------------------------------------------------------------
        // 3. ADIM: "PLAYERS" (Oyuncular) Tablosunu UPSERT Yapmak
        // ------------------------------------------------------------------
        // API-Football response yapısında takımlar içinde oyuncular dizisi döner.
        if (playerStatData.response && playerStatData.response.length > 0) {
          // Gelen JSON'daki içiçe (nested) array'i flatMap ile düz ve tek bir oyuncu listesine çeviriyoruz.
          const playerRecords = playerStatData.response.flatMap((teamData: any) => 
            teamData.players.map((p: any) => ({
              id: p.player.id,
              team_id: teamData.team.id, // Oyuncunun ait olduğu takımın ID'si
              name: p.player.name,
              photo: p.player.photo,
              last_rating: p.statistics[0].games.rating ? parseFloat(p.statistics[0].games.rating) : null
            }))
          );

          // Toplu (Bulk) Upsert İşlemi: Yüzlerce oyuncu verisi tek sorguyla atılır.
          // Eğer aynı 'id'ye sahip oyuncu varsa, adı, fotoğrafı ve son rating verisi yeni veriyle ezilir (güncellenir).
          await supabase
            .from('players')
            .upsert(playerRecords, { onConflict: 'id' });
        }
    }

    return new Response(JSON.stringify({ message: "İlişkisel tablolar başarıyla UPSERT edildi." }), { status: 200 });

  } catch (error: any) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
});
