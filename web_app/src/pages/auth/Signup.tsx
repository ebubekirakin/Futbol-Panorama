import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Mail, Lock, EyeOff, Eye, User, CircleDashed } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import './Auth.css';

const Signup: React.FC = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSignup = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError(null);
    
    try {
      const { error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            name: username,
          }
        }
      });

      if (error) {
        setError(error.message);
      } else {
        alert('Kayıt başarılı! Lütfen giriş yapın.');
        navigate('/login');
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
          <h1>Kayıt Ol</h1>
          <p>Topluluğa katıl ve analizlerini paylaş.</p>
        </div>

        {error && (
          <div style={{ color: '#ef4444', backgroundColor: 'rgba(239, 68, 68, 0.1)', padding: '0.75rem', borderRadius: '8px', marginBottom: '1rem', width: '100%', textAlign: 'center', fontSize: '0.9rem' }}>
            {error}
          </div>
        )}

        <form className="auth-form" onSubmit={handleSignup}>
          <div className="input-group">
            <User className="input-icon" size={20} />
            <input 
              type="text" 
              className="auth-input" 
              placeholder="Kullanıcı Adı" 
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required 
            />
          </div>

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
              placeholder="Şifre (En az 6 karakter)" 
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required 
              minLength={6}
            />
            <button 
              type="button" 
              className="password-toggle"
              onClick={() => setShowPassword(!showPassword)}
            >
              {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
            </button>
          </div>

          <button type="submit" className="btn-primary auth-submit-btn" disabled={isLoading}>
            {isLoading ? 'Hesap Oluşturuluyor...' : 'Hesap Oluştur'}
          </button>
        </form>

        <div className="auth-footer">
          <span>Zaten hesabın var mı?</span>
          <Link to="/login">Giriş Yap</Link>
        </div>
      </div>
    </div>
  );
};

export default Signup;
