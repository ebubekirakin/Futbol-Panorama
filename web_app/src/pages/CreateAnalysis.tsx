import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { PlusCircle, Trash2, Image as ImageIcon, X } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import './CreateAnalysis.css';

interface FloodItem {
  id: string;
  text: string;
  imageAdded: boolean;
}

const CreateAnalysis: React.FC = () => {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [title, setTitle] = useState('');
  const [floodItems, setFloodItems] = useState<FloodItem[]>([
    { id: '1', text: '', imageAdded: false }
  ]);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleAddItem = () => {
    setFloodItems([...floodItems, { id: Date.now().toString(), text: '', imageAdded: false }]);
  };

  const handleRemoveItem = (id: string) => {
    setFloodItems(floodItems.filter(item => item.id !== id));
  };

  const handleTextChange = (id: string, newText: string) => {
    setFloodItems(floodItems.map(item => item.id === id ? { ...item, text: newText } : item));
  };

  const handleToggleImage = (id: string) => {
    setFloodItems(floodItems.map(item => item.id === id ? { ...item, imageAdded: !item.imageAdded } : item));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!title.trim()) {
      alert('Lütfen bir başlık giriniz!');
      return;
    }

    if (!user) {
      alert('Lütfen önce giriş yapın!');
      navigate('/login');
      return;
    }

    setIsSubmitting(true);

    try {
      let finalContent = `# ${title}\n\n`;
      for (const item of floodItems) {
        if (item.text.trim()) {
          finalContent += `${item.text}\n\n`;
        }
        if (item.imageAdded) {
          finalContent += '![Görsel](simulated_dummy_path)\n\n';
        }
      }

      const { error } = await supabase.from('analyses').insert({
        author_id: user.id,
        type: 'pre-match',
        content: finalContent.trim(),
      });

      if (error) throw error;

      alert('Analiz başarıyla paylaşıldı!');
      navigate('/');
    } catch (err: any) {
      alert(`Hata: ${err.message}`);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="create-analysis-container">
      <div className="page-header">
        <h1>Analiz Oluştur</h1>
        <button className="btn-primary" onClick={handleSubmit} disabled={isSubmitting}>
          {isSubmitting ? 'Paylaşılıyor...' : 'Paylaş'}
        </button>
      </div>

      <div className="card">
        <label className="input-label">Analizine bir başlık ver</label>
        <input 
          type="text" 
          className="title-input" 
          placeholder="Örn: Bayern Münih Taktik Analizi" 
          value={title}
          onChange={(e) => setTitle(e.target.value)}
        />

        <div className="section-title-row">
          <h2>Analiz Detayları</h2>
          <span className="badge-text">Flood Formatı</span>
        </div>

        <div className="flood-list">
          {floodItems.map((item, index) => (
            <div key={item.id} className="flood-item">
              <div className="flood-item-header">
                <span className="madde-badge">Madde {index + 1}</span>
                {floodItems.length > 1 && (
                  <button className="delete-btn" onClick={() => handleRemoveItem(item.id)}>
                    <Trash2 size={18} />
                  </button>
                )}
              </div>

              <textarea 
                className="flood-textarea" 
                placeholder="Taktiksel detayınızı buraya yazın..."
                value={item.text}
                onChange={(e) => handleTextChange(item.id, e.target.value)}
                maxLength={400}
                rows={4}
              />
              <div className="char-count">{item.text.length}/400</div>

              {item.imageAdded ? (
                <div className="mock-image-container">
                  <div className="mock-image-content">
                    <ImageIcon size={24} className="icon-green" />
                    <span>Görsel Eklendi (Simülasyon)</span>
                  </div>
                  <button className="close-img-btn" onClick={() => handleToggleImage(item.id)}>
                    <X size={16} />
                  </button>
                </div>
              ) : (
                <button className="add-img-btn" onClick={() => handleToggleImage(item.id)}>
                  <ImageIcon size={18} />
                  <span>Görsel / Taktik Tahtası Ekle</span>
                </button>
              )}
            </div>
          ))}
        </div>

        <button className="add-item-btn" onClick={handleAddItem}>
          <PlusCircle size={20} />
          <span>Yeni Madde Ekle</span>
        </button>
      </div>
    </div>
  );
};

export default CreateAnalysis;
