-- 1. YENİ KULLANICI KAYDEDİLDİĞİNDE ÇALIŞACAK FONKSİYON
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  -- Supabase Auth servisinden gelen (new.id) veriyi uygulamanın public.users tablosuna yazdırıyoruz
  INSERT INTO public.users (id, name, trust_score, badges)
  VALUES (
    new.id, -- auth.users tablosundaki ID ile aynı olmalı
    -- Kullanıcı adı gönderilmişse onu al, gönderilmemişse varsayılan 'İsimsiz Analist' ata
    COALESCE(new.raw_user_meta_data->>'name', 'İsimsiz Analist'), 
    50.0, -- Yeni üyeye varsayılan 50 (Ortalama) Güven Skoru
    ARRAY['Çaylak'] -- Array formatında varsayılan 'Çaylak' rozeti
  );
  
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. AUTH.USERS TABLOSUNA TETİKLEYİCİ (TRIGGER) BAĞLAMASI
-- Eğer daha önce bu isimde bir tetikleyici varsa çakışmaması için siliyoruz
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Yeni bir kullanıcı Supabase 'auth.users' sistemine kayıt edildiğinde bu trigger devreye girer
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
