import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Mail, Lock, EyeOff, Eye, CircleDashed } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import './Auth.css';

const Login: React.FC = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError(null);
    
    try {
      const { error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) {
        setError(error.message);
      } else {
        navigate('/');
      }
    } catch (err: any) {
      setError(err.message || 'Beklenmeyen bir hata oluştu');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="auth-container">
      <div className="auth-card">
        <div className="auth-header">
          <div className="auth-logo-bg">
            <CircleDashed size={40} className="icon" />
          </div>
          <h1>Futbol Panorama</h1>
          <p>Analizlerinle oyunu yönet.</p>
        </div>

        {error && (
          <div style={{ color: '#ef4444', backgroundColor: 'rgba(239, 68, 68, 0.1)', padding: '0.75rem', borderRadius: '8px', marginBottom: '1rem', width: '100%', textAlign: 'center', fontSize: '0.9rem' }}>
            {error}
          </div>
        )}

        <form className="auth-form" onSubmit={handleLogin}>
          <div className="input-group">
            <Mail className="input-icon" size={20} />
            <input 
              type="email" 
              className="auth-input" 
              placeholder="E-posta" 
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required 
            />
          </div>

          <div className="input-group">
            <Lock className="input-icon" size={20} />
            <input 
              type={showPassword ? "text" : "password"} 
              className="auth-input" 
              placeholder="Şifre" 
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required 
            />
            <button 
              type="button" 
              className="password-toggle"
              onClick={() => setShowPassword(!showPassword)}
            >
              {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
            </button>
          </div>

          <div className="forgot-password">
            <Link to="#">Şifremi Unuttum?</Link>
          </div>

          <button type="submit" className="btn-primary auth-submit-btn" disabled={isLoading}>
            {isLoading ? 'Giriş Yapılıyor...' : 'Giriş Yap'}
          </button>
        </form>

        <div className="auth-footer">
          <span>Hesabın yok mu?</span>
          <Link to="/signup">Kayıt Ol</Link>
        </div>
      </div>
    </div>
  );
};

export default Login;
