import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.4";

// Type tanımlamaları
interface WebhookPayload {
  type: "INSERT" | "UPDATE" | "DELETE";
  table: string;
  schema: string;
  record: {
    id: string;
    author_id: string;
    type: "pre-match" | "post-match" | "player";
    content: string;
    match_id?: string;  
    player_id?: string; 
    ai_validation_score?: number;
    created_at: string;
  };
  old_record: null | any;
}

serve(async (req: Request) => {
  try {
    const payload: WebhookPayload = await req.json();
    const analysis = payload.record;

    console.log(`[RAG Context] Yeni Analiz Tetiklendi. Analiz ID: ${analysis.id}, Tip: ${analysis.type}`);

    // Sadece INSERT işlemlerinde ve yapay zeka puanı henüz verilmemişse çalış
    if (payload.type !== "INSERT" || analysis.ai_validation_score !== null) {
      return new Response(JSON.stringify({ message: "İşlem gerekli değil" }), { status: 200 });
    }

    // Supabase Admin İstemcisini Başlat (Gerçek verilere erişmek için Service Role Key kullanılır)
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const supabase = createClient(supabaseUrl, supabaseKey);

    let contextText = "";

    // 1. ADIM: İlgili Gerçek Veriyi Veritabanından Çek (RAG - Retrieval)
    if ((analysis.type === "pre-match" || analysis.type === "post-match") && analysis.match_id) {
      const { data: matchData, error } = await supabase
        .from("matches")
        .select("*")
        .eq("id", analysis.match_id)
        .single();

      if (error) {
        console.error("Maç verisi çekilirken hata:", error.message);
      } else if (matchData) {
        contextText = `
--- GERÇEK MAÇ VERİSİ (SİSTEM BAĞLAMI) ---
Tarih: ${matchData.date}
Karşılaşma: ${matchData.home_team} vs ${matchData.away_team}
Lig: ${matchData.competition}
Skor: ${matchData.home_score ?? "?"} - ${matchData.away_score ?? "?"}
Maç İstatistikleri: ${JSON.stringify(matchData.stats || "Mevcut Değil")}
Önemli Olaylar: ${matchData.key_events || "Mevcut Değil"}
-------------------------------------------
`;
      }
    } else if (analysis.type === "player" && analysis.player_id) {
      const { data: playerData, error } = await supabase
        .from("players")
        .select(`
          *,
          teams (name)
        `)
        .eq("id", analysis.player_id)
        .single();

      if (error) {
        console.error("Oyuncu verisi çekilirken hata:", error.message);
      } else if (playerData) {
        contextText = `
--- GERÇEK OYUNCU VERİSİ (SİSTEM BAĞLAMI) ---
Oyuncu Adı: ${playerData.name}
Mevcut Takımı: ${playerData.teams?.name || "Bilinmiyor"}
Pozisyon: ${playerData.position}
Son Form Durumu: ${playerData.form_rating || "Bilinmiyor"}
---------------------------------------------
`;
      }
    }

    // 2. ADIM: LLM için Prompt (Bağlam + Kullanıcı İçeriği) Oluştur
    const systemPrompt = `Sana verilen gerçek futbol istatistiklerini kullanarak, kullanıcının yaptığı taktiksel analizin ne kadar tutarlı olduğunu 1-100 arası değerlendir ve SADECE rakamsal sonucu dön. Eğer analiz saçmaysa veya gerçeklerle çelişiyorsa çok düşük puan ver. Halüsinasyon yapma. \n\nGerçek İstatistikler (Bağlam):\n${contextText}`;

    console.log("[RAG Context] Groq API'ye istek atılıyor...");

    // 3. ADIM: Groq API'ye REST İsteği Atılması
    const groqApiKey = Deno.env.get("GROQ_API_KEY") ?? "";
    
    if (!groqApiKey) {
      throw new Error("GROQ_API_KEY environment variable bulunamadı.");
    }

    const llmResponse = await fetch("https://api.groq.com/openai/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${groqApiKey}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        model: "llama3-8b-8192", 
        messages: [
          { role: "system", content: systemPrompt },
          { role: "user", content: analysis.content }
        ],
        temperature: 0.1, 
        max_tokens: 10 
      })
    });

    if (!llmResponse.ok) {
      const errBody = await llmResponse.text();
      throw new Error(`Groq API Hatası: ${llmResponse.status} - ${errBody}`);
    }

    const llmData = await llmResponse.json();
    const resultText = llmData.choices[0]?.message?.content?.trim();
    
    console.log(`[RAG Context] Groq Modeli Yanıtı: ${resultText}`);

    // Yanıttan rakamı ayıklama (Regex ile)
    const extractedNumber = resultText.match(/\d+/)?.[0];
    const aiValidationScore = extractedNumber ? parseInt(extractedNumber, 10) : null;

    if (aiValidationScore === null) {
      throw new Error(`LLM geçerli bir rakam dönmedi. Gelen yanıt: ${resultText}`);
    }

    // 4. ADIM: Analizi score ile Güncelle
    const { error: updateError } = await supabase
      .from("analyses")
      .update({ ai_validation_score: aiValidationScore })
      .eq("id", analysis.id);

    if (updateError) {
      throw new Error(`ai_validation_score güncellenirken hata oluştu: ${updateError.message}`);
    }

    console.log(`[RAG Context] Analiz skorları başarıyla güncellendi: ${aiValidationScore}`);

    return new Response(JSON.stringify({ success: true, ai_validation_score: aiValidationScore }), { 
      status: 200, 
      headers: { "Content-Type": "application/json" } 
    });

  } catch (error) {
    console.error("Webhook işlenirken hata oluştu:", error);
    return new Response(JSON.stringify({ error: error.message }), { 
      status: 500, 
      headers: { "Content-Type": "application/json" } 
    });
  }
});
