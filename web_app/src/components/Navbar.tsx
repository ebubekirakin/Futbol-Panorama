import React from 'react';
import { Link } from 'react-router-dom';
import { Activity, Trophy, LogOut } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import './Navbar.css';

const Navbar: React.FC = () => {
  const { user, signOut } = useAuth();

  return (
    <nav className="navbar">
      <div className="navbar-container">
        <Link to="/" className="navbar-logo">
          <Activity className="logo-icon" size={24} />
          <span>Futbol Panorama</span>
        </Link>
        
        <div className="navbar-links">
          <Link to="/" className="nav-link">Keşfet</Link>
          <Link to="/analyses" className="nav-link">Analizler</Link>
          <Link to="/leaderboard" className="nav-link">
            <Trophy size={18} /> Lider Tablosu
          </Link>
        </div>

        <div className="navbar-actions">
          {user ? (
            <>
              <Link to="/create-analysis" className="btn-primary" style={{ padding: '0.5rem 1rem', fontSize: '0.9rem' }}>
                Yeni Analiz
              </Link>
              <span style={{ fontSize: '0.9rem', color: 'var(--text-muted)' }}>
                {user.user_metadata?.name || 'Kullanıcı'}
              </span>
              <button onClick={signOut} className="nav-icon-btn" title="Çıkış Yap">
                <LogOut size={20} />
              </button>
            </>
          ) : (
            <>
              <Link to="/login" className="btn-secondary" style={{ padding: '0.5rem 1rem', fontSize: '0.9rem' }}>
                Giriş Yap
              </Link>
              <Link to="/signup" className="btn-primary" style={{ padding: '0.5rem 1rem', fontSize: '0.9rem' }}>
                Kayıt Ol
              </Link>
            </>
          )}
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
