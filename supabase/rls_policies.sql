-- Analyses Tablosu için Güvenlik İlkeleri (RLS Policies)
ALTER TABLE public.analyses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Analizleri herkes görebilir" ON public.analyses;
CREATE POLICY "Analizleri herkes görebilir" ON public.analyses
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Kullanıcılar kendi analizlerini ekleyebilir" ON public.analyses;
CREATE POLICY "Kullanıcılar kendi analizlerini ekleyebilir" ON public.analyses
  FOR INSERT WITH CHECK (auth.uid() = author_id);

DROP POLICY IF EXISTS "Kullanıcılar kendi analizlerini güncelleyebilir" ON public.analyses;
CREATE POLICY "Kullanıcılar kendi analizlerini güncelleyebilir" ON public.analyses
  FOR UPDATE USING (auth.uid() = author_id);

DROP POLICY IF EXISTS "Kullanıcılar kendi analizlerini silebilir" ON public.analyses;
CREATE POLICY "Kullanıcılar kendi analizlerini silebilir" ON public.analyses
  FOR DELETE USING (auth.uid() = author_id);
