-- ==============================================
-- 03_ai_analysis_trigger.sql
-- Yeni bir analiz eklendiğinde RAG Edge Function'ı tetiklemek için pg_net kullanan Webhook tetikleyici.
-- ==============================================

-- 1. ADIM: Dışarıya HTTP isteği atabilmek için Supabase'in 'pg_net' eklentisini aktif ediyoruz
CREATE EXTENSION IF NOT EXISTS pg_net;

-- 2. ADIM: Webhook'u (Edge Function) çağıracak olan veritabanı fonksiyonu oluşturuluyor
CREATE OR REPLACE FUNCTION public.invoke_ai_analysis_webhook()
RETURNS TRIGGER AS $$
DECLARE
  request_id BIGINT;
  payload JSONB;
BEGIN
  -- Fonksiyona gönderilecek JSON Payload hazırlanıyor (Edge Function'da beklediğimiz 'record' yapısı)
  payload := jsonb_build_object(
    'type', TG_OP,
    'table', TG_TABLE_NAME,
    'schema', TG_TABLE_SCHEMA,
    'record', row_to_json(NEW),
    'old_record', null
  );

  -- 3. ADIM: pg_net ile Supabase Edge Function'a (prepare-rag-context) POST isteği atıyoruz
  -- NOT: Canlı ortamda (Production) bu URL 'https://[PROJE_REF].supabase.co/functions/v1/prepare-rag-context' 
  -- olarak ve anon_key yetkili şekilde güncellenmelidir.
  SELECT
    net.http_post(
      url:='http://host.docker.internal:54321/functions/v1/prepare-rag-context',
      headers:='{"Content-Type": "application/json"}'::jsonb, -- Lokal testler için temel başlık, projeye göre Auth eklenebilir
      body:=payload
    ) INTO request_id;

  -- Kaydı (Analizi) veritabanına sorunsuz yazmaya devam et
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. ADIM: Eğer eski bir trigger varsa temizleyelim
DROP TRIGGER IF EXISTS trigger_ai_analysis ON public.analyses;

-- 5. ADIM: 'analyses' tablosunda her INSERT (analiz eklendiğinde) işleminden SONRA Webhook'u tetikleyelim
CREATE TRIGGER trigger_ai_analysis
AFTER INSERT ON public.analyses
FOR EACH ROW
EXECUTE FUNCTION public.invoke_ai_analysis_webhook();
