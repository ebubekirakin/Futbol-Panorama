-- Futbol-Panorama Supabase Veritabanı Şeması

-- 1. Analiz tipleri için özel bir ENUM veri tipi oluşturuyoruz
CREATE TYPE public.analysis_type AS ENUM ('pre-match', 'post-match', 'player');

-- ==========================================
-- TABLO 1: users
-- ==========================================
-- Not: Supabase'de genellikle bu tablo 'public.profiles' olarak adlandırılır
-- ve id sütunu 'auth.users(id)' tablosuna referansla bağlanır.
CREATE TABLE public.users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  trust_score NUMERIC DEFAULT 0.0, -- Güven skoru ondalıklı hesaplanabilir
  badges TEXT[] DEFAULT '{}',      -- Kullanıcı rozetlerini tutan metin dizisi (Array)
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==========================================
-- TABLO 2: analyses
-- ==========================================
CREATE TABLE public.analyses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id UUID NOT NULL,
  type public.analysis_type NOT NULL,
  content TEXT NOT NULL,
  ai_score NUMERIC, -- AI tarafından 100 üzerinden verilecek puan
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Foreign Key İlişkisi: author_id -> users(id)
  -- Analizi yazan kullanıcı silinirse, analizi de silinir (CASCADE).
  CONSTRAINT fk_analyses_author 
    FOREIGN KEY (author_id) 
    REFERENCES public.users (id) 
    ON DELETE CASCADE
);

-- ==========================================
-- TABLO 3: evaluations
-- ==========================================
CREATE TABLE public.evaluations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  analysis_id UUID NOT NULL,
  score_1_to_10 INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),

  -- Foreign Key İlişkisi 1: user_id -> users(id)
  -- Değerlendiren kullanıcı silinirse değerlendirmesi de silinsin.
  CONSTRAINT fk_evaluations_user 
    FOREIGN KEY (user_id) 
    REFERENCES public.users (id) 
    ON DELETE CASCADE,

  -- Foreign Key İlişkisi 2: analysis_id -> analyses(id)
  -- Değerlendirilen analiz silinirse değerlendirme de silinsin.
  CONSTRAINT fk_evaluations_analysis 
    FOREIGN KEY (analysis_id) 
    REFERENCES public.analyses (id) 
    ON DELETE CASCADE,

  -- Constraint: Verilen puan sadece 1 ile 10 arasında (dahil) olmak zorundadır.
  CONSTRAINT chk_score_range 
    CHECK (score_1_to_10 >= 1 AND score_1_to_10 <= 10),

  -- Constraint: Bir kullanıcı aynı analize birden fazla değerlendirme/puan VEREMEZ.
  CONSTRAINT uq_user_analysis 
    UNIQUE (user_id, analysis_id)
);

-- ==========================================
-- INDEXLER
-- ==========================================
-- Hızlı sorgulamalar için bazı önemli indekslemeler
CREATE INDEX idx_analyses_author ON public.analyses(author_id);
CREATE INDEX idx_analyses_type ON public.analyses(type);
CREATE INDEX idx_evaluations_analysis ON public.evaluations(analysis_id);
