import React from 'react';
import { BrainCircuit } from 'lucide-react';
import './PreMatch.css';

const PreMatch: React.FC = () => {
  return (
    <div className="prematch-container">
      <div className="page-header">
        <h1>Maç Öncesi Analiz</h1>
      </div>

      <div className="card match-overview-card">
        <h2 className="match-title">Fenerbahçe vs Galatasaray</h2>
        
        <div className="probabilities-row">
          <div className="prob-col">
            <span className="prob-label">Ev</span>
            <span className="prob-value">%45</span>
            <div className="prob-bar-container">
              <div className="prob-bar" style={{ width: '45%', backgroundColor: 'var(--primary-green)' }}></div>
            </div>
          </div>
          
          <div className="prob-col">
            <span className="prob-label">Brb</span>
            <span className="prob-value">%25</span>
            <div className="prob-bar-container">
              <div className="prob-bar" style={{ width: '25%', backgroundColor: 'var(--text-muted)' }}></div>
            </div>
          </div>
          
          <div className="prob-col">
            <span className="prob-label">Dep</span>
            <span className="prob-value">%30</span>
            <div className="prob-bar-container">
              <div className="prob-bar" style={{ width: '30%', backgroundColor: '#ef4444' }}></div>
            </div>
          </div>
        </div>
      </div>

      <div className="ai-tactical-section">
        <div className="section-title-row">
          <BrainCircuit className="icon-green" size={24} />
          <h2>Yapay Zeka Taktiksel Önizlemesi</h2>
        </div>
        
        <div className="card ai-content-card">
          <p>
            Bu derbide orta saha üstünlüğü belirleyici olacak. Ev sahibi takımın agresif ön alan baskısı, deplasman takımının geriden oyun kurma planını zorlayabilir. Kanat beklerinin ofansif katkısı, savunma zafiyetleri yaratma potansiyeli taşıyor. Yapay zeka analizimize göre ilk golü bulan takımın maçı kazanma ihtimali oldukça yüksek.
          </p>
        </div>
      </div>
    </div>
  );
};

export default PreMatch;
