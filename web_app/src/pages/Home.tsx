import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { TrendingUp, ShieldCheck, MessageCircle } from 'lucide-react';
import { supabase } from '../lib/supabase';
import './Home.css';

interface Analysis {
  id: string;
  author_id: string;
  type: string;
  content: string;
  ai_score: number;
  created_at: string;
  users?: {
    name: string;
    trust_score: number;
    badges: string[];
  };
}

const Home: React.FC = () => {
  const [analyses, setAnalyses] = useState<Analysis[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchAnalyses = async () => {
      try {
        const { data, error } = await supabase
          .from('analyses')
          .select(`
            *,
            users (
              name,
              trust_score,
              badges
            )
          `)
          .order('created_at', { ascending: false });
        
        if (error) throw error;
        
        if (data) {
          setAnalyses(data as unknown as Analysis[]);
        }
      } catch (error) {
        console.error('Error fetching analyses:', error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchAnalyses();
  }, []);

  // Helper to extract title from content
  const extractTitle = (content: string) => {
    const firstLine = content.split('\n')[0];
    return firstLine.replace('# ', '');
  };

  // Helper to extract excerpt
  const extractExcerpt = (content: string) => {
    const lines = content.split('\n');
    return lines.length > 1 ? lines[1] : content;
  };

  // Helper to calculate time ago
  const getTimeAgo = (dateString: string) => {
    const date = new Date(dateString);
    const now = new Date();
    const diffInHours = Math.abs(now.getTime() - date.getTime()) / 36e5;
    
    if (diffInHours < 1) {
      return `${Math.round(diffInHours * 60)} dakika önce`;
    } else if (diffInHours < 24) {
      return `${Math.round(diffInHours)} saat önce`;
    } else {
      return `${Math.round(diffInHours / 24)} gün önce`;
    }
  };

  return (
    <div className="home-container">
      <header className="home-hero">
        <h1>Futbolun Taktiksel<br/>Kalbine İn.</h1>
        <p>Yapay zeka destekli analizler ve topluluk onayı ile futbol bilgisini bir üst seviyeye taşı. Kendi Güven Skorunu yükselt ve uzman bir analist ol.</p>
        <div className="hero-actions">
          <Link to="/create-analysis" className="btn-primary">Hemen Analiz Yaz</Link>
          <Link to="/pre-match" className="btn-secondary">Maç Öncesi Örneği</Link>
        </div>
      </header>

      <section className="feed-section">
        <div className="section-header">
          <h2>Son Analizler</h2>
          <div className="filter-tabs">
            <button>En İyiler</button>
            <button className="active">En Yeniler</button>
          </div>
        </div>

        {isLoading ? (
          <div style={{ textAlign: 'center', padding: '2rem' }}>Yükleniyor...</div>
        ) : analyses.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '2rem', color: 'var(--text-muted)' }}>
            Henüz analiz paylaşılmamış. İlk analizi sen yaz!
          </div>
        ) : (
          <div className="analysis-grid">
            {analyses.map((analysis) => (
              <div key={analysis.id} className="card analysis-card">
                <div className="card-header">
                  <div className="user-info">
                    <div className="avatar bg-blue">
                      {analysis.users?.name?.substring(0, 2).toUpperCase() || 'U'}
                    </div>
                    <div className="user-meta">
                      <span className="username">{analysis.users?.name || 'Bilinmeyen Kullanıcı'}</span>
                      {analysis.users?.badges && analysis.users.badges.length > 0 && (
                        <span className="badge expert">{analysis.users.badges[0]}</span>
                      )}
                    </div>
                  </div>
                  <div className="time-ago">{getTimeAgo(analysis.created_at)}</div>
                </div>
                
                <h3 className="analysis-title">{extractTitle(analysis.content)}</h3>
                <p className="analysis-excerpt">
                  {extractExcerpt(analysis.content)}
                </p>
                
                <div className="card-footer">
                  <div className="ai-score">
                    <ShieldCheck size={16} className="text-green" />
                    <span>AI Güven: <strong>%{analysis.ai_score || 0}</strong></span>
                  </div>
                  <div className="engagement">
                    <span className="stat"><TrendingUp size={16} /> 0</span>
                    <span className="stat"><MessageCircle size={16} /> 0</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </section>
    </div>
  );
};

export default Home;
