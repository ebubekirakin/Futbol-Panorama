-- 1. ADIM: "analyses" tablosuna topluluğun ağırlıklı ortalama puanlamasını tutacak sütunu ekleyelim
ALTER TABLE public.analyses 
ADD COLUMN IF NOT EXISTS community_score NUMERIC(4, 2); -- 10.00'a kadar formatlı

-- 2. ADIM: Ağırlıklı ortalamayı hesaplayan Trigger (Tetikleyici) Fonksiyonu
CREATE OR REPLACE FUNCTION public.calculate_weighted_community_score()
RETURNS TRIGGER AS $$
DECLARE
  v_total_weighted_score NUMERIC := 0;
  v_total_weight NUMERIC := 0;
  v_new_community_score NUMERIC := 0;
BEGIN
  -- Tüm değerlendirmeleri (ilgili analysis_id için) topla
  -- Ağırlık Formülü: GREATEST(0.2, (u.trust_score / 100.0) * 2.0)
  -- Açıklama:
  -- Minimum katsayı (ağırlık) 0.2'dir (yeni veya düşük puanlı kullanıcı trollingini engeller).
  -- Eğer trust_score örneğin 100 (Scout) ise: (100/100) * 2.0 = 2.0 katsayı (1 verisi 10 kişinin oyunun gücüne eşit değil ama 10 katı ağırlığa sahip olur).
  -- Eğer trust_score 50 ise: (50/100) * 2.0 = 1.0 katsayı (Standart ortalama ağırlık).

  SELECT 
    COALESCE(SUM(e.score_1_to_10 * GREATEST(0.2, (u.trust_score / 100.0) * 2.0)), 0),
    COALESCE(SUM(GREATEST(0.2, (u.trust_score / 100.0) * 2.0)), 0)
  INTO 
    v_total_weighted_score, 
    v_total_weight
  FROM public.evaluations e
  JOIN public.users u ON e.user_id = u.id
  WHERE e.analysis_id = COALESCE(NEW.analysis_id, OLD.analysis_id);

  -- 0'a bölme hatasını (Division by Zero) önlemek için kontrol
  IF v_total_weight > 0 THEN
    v_new_community_score := v_total_weighted_score / v_total_weight;
  ELSE
    v_new_community_score := NULL;
  END IF;

  -- Hesaplanan yeni Topluluk Skorunu (Ağırlıklı Ortalama) Analiz tablosuna yazdır
  UPDATE public.analyses
  SET community_score = v_new_community_score
  WHERE id = COALESCE(NEW.analysis_id, OLD.analysis_id);

  RETURN NULL; -- AFTER Row-level Trigger'larda genelde NULL dönülür
END;
$$ LANGUAGE plpgsql;

-- 3. ADIM: Trigger'ın Bağlanması
-- Yeni puan verildiğinde (INSERT), puan değiştirildiğinde (UPDATE) veya puan geri çekildiğinde/silindiğinde (DELETE) tetiklenecek.
DROP TRIGGER IF EXISTS trigger_update_analysis_community_score ON public.evaluations;

CREATE TRIGGER trigger_update_analysis_community_score
AFTER INSERT OR UPDATE OR DELETE ON public.evaluations
FOR EACH ROW
EXECUTE FUNCTION public.calculate_weighted_community_score();
