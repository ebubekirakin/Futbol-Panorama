# Futbol-Panorama Proje Gereksinim Dokümanı (PRD)

## 1. Proje Özeti
**Futbol-Panorama**, futbol analizlerinin ve yorumlarının niteliğini artırmayı hedefleyen, yapay zeka ve kitle kaynaklı (crowdsourced) doğrulama mekanizmalarını kullanan yeni nesil bir analiz ve veri ağıdır. Kullanıcıların futbolcular, teknik direktörler, takımlar ve maçlar hakkında girdikleri detaylı analizler, sistem ve topluluk tarafından değerlendirilerek yazarlarına bir "Güven Skoru" kazandırır.

## 2. Teknoloji Yığını
* **Frontend / Mobil Uygulama:** Flutter (iOS ve Android için tek kod tabanı, hızlı ve akıcı UI/UX)
* **Backend as a Service (BaaS):** Supabase (Kullanıcı doğrulama, PostgreSQL veritabanı, gerçek zamanlı veri akışı ve dosya depolama)
* **Yapay Zeka (AI) Entegrasyonu:** OpenAI / Claude veya güncel bir LLM API çözümü (Futbol mantığını ve taktiksel verileri analiz edebilecek yetkinlikte yapılandırılmış prompt mimarisi)

## 3. Kapsam Dışı Bırakılanlar (Out of Scope)
Futbol-Panorama'nın odak noktasının salt veri, taktik ve nitelikli analiz olması amacıyla aşağıdaki popüler modüller sisteme **dahil edilmeyecektir**:
* ❌ İddaa, bahis tahminleri ve bahis oran yönlendirmeleri.
* ❌ Canlı maç yayınları (streaming) veya yasadışı maç izleme bağlantıları.

## 4. Sistem Özellikleri ve Temel İşlevler

### 4.1. Analiz ve İçerik Üretimi
* Kullanıcılar seçili maçlar, oyuncular, hocalar veya takımlar özelinde detaylı (örneğin; "Fatih Tekke'nin Muçi'ye verdiği serbest rolün etkileri" gibi) analiz yazıları yazabilir.
* Analizlere görsel, taktik tahtası çizimleri eklenebilir.

### 4.2. Yapay Zeka Değerlendirme Modülü (AI Review)
* Kullanıcı analizini yayınladığı anda, Yapay Zeka metni tarar.
* Metindeki taktiksel argümanların futbol gerçekleri ve (mümkünse) sisteme entegre veri sağlayıcılarının verileri ile ne kadar örtüştüğünü hesaplar.
* Analize bir "Haklılık Payı Yüzdesi" (% doğruluk) ve 100 üzerinden objektif bir puan atar.

### 4.3. Topluluk Onay Sistemi (Community Review)
* Platformdaki diğer kullanıcılar, paylaşılan analizi okuyup kendi futbol vizyonlarına göre değerlendirip puan verirler.
* Düşük ve yüksek güven skorlu kullanıcıların verdikleri oyların etki ağırlığı farklılaştırılabilir (Ağırlıklı Puanlama).

### 4.4. İçerik Formatı ve Okunabilirlik (UI/UX Stratejisi)
Kullanıcıların okunması zor, uzun metin yığınları ("wall of text") oluşturmasını engellemek için sistemde şu arayüz standartları zorunlu tutulacaktır:
* **Karakter Sınırı ve "Flood" Yapısı:** Her bir metin bloğu Twitter sistemindeki gibi karakter limitiyle (örn: 300-500 karakter) sınırlandırılacaktır. Kullanıcı daha uzun bir analiz yazmak isterse, art arda sıralanan bloklar (Thread/Flood) oluşturmaya yönlendirilecektir.
* **Şablonlar ve Madde İmleri (Bullet Points):** Kullanıcılara "Öne Çıkanlar", "Taktiksel Zafiyetler", "Kilit Oyuncu" gibi hazır Markdown şablonları sunulacak ve düşüncelerini listeler halinde aktarmaları teşvik edilecektir. Okunabilirlik için bol boşluklu (whitespace) bir UI tasarımı benimsenecektir.
* **Görsel/Veri Merkeziyetçi Tasarım:** Analiz yazıları, ağırlıklı olarak bir taktik tahtası görüntüsü, pas ağları veya oyuncu ısı haritalarının "açıklaması" olarak kurgulanacaktır. Cümleler grafikleri destekleyici bir yapıda olacaktır.
* **Yapay Zeka Destekli Formatlayıcı (AI Formatter):** Kullanıcılara analizlerini paylaşmadan önce "AI ile Okunabilir Yap" butonu sunulacak; AI uzun paragrafı otomatik olarak madde imlerine, vurgulu kelimelere ve kısa cümlelere bölerek kullanıcıya sunacaktır.

## 5. Güven Skoru ve Oyunlaştırma (Gamification)

Sistemin kalbini oluşturan **Güven Skoru**, her bir kullanıcının analizlerine Yapay Zeka ve Topluluk tarafından verilen puanların harmanlanmasıyla hesaplanır. Platformda yüksek kaliteyi teşvik etmek için aşağıdaki **Oyunlaştırma (Gamification)** kurgusu uygulanacaktır:

### 5.1. Dinamik Güven Skoru Algoritması
* %50 Yapay Zeka değerlendirmesi + %50 Topluluk Puanı formülü ile (zamanla dengeleme oranları değişebilir) yazının nihai skoru belirlenir.
* Bu skorlar istikrarlı bir şekilde yüksek geldikçe, kullanıcının profilindeki genel **Güven Skoru** artar. Yanlış, troll veya asılsız analizler güven skorunu düşürür.

### 5.2. Rozet ve Unvan Sistemi (Badge System)
Kaliteli içerik üreticilerini onurlandırmak ve diğer projelere/kulüplere gerçek bir veri havuzu sunmak amacıyla seviye bazlı unvanlar tanımlanmıştır:

* **Çaylak / Seyirci (0 - 49 Puan):** Platforma yeni üye olmuş veya henüz yeterli doğru analiz sayısına ulaşmamış kullanıcılar.
* **Analist (50 - 74 Puan):** Taktiksel bilgisi ortalamanın üzerinde olan ve onaylanmış analizleri bulunan kullanıcılar.
* **Uzman (75 - 89 Puan):** Hem yapay zeka hem de topluluk tarafından görüşlerine sıklıkla başvurulan ve doğrulanan profiller.
* **Taktik Dehası (90 - 95 Puan):** Yalnızca keskin futbol zekasına ve veriye dayalı isabetli okumalara sahip olan, platformun en saygıdeğer elit kullanıcıları. Rozet sahibi kullanıcıların gönderileri akışta ("Feed") daha üstlerde gösterilir ve verdikleri oylar, yeni yazıları değerlendirirken daha yüksek katsayıya sahiptir.
* **Scout (96 - 100+ Puan):** En üst düzey rütbe. Özellikle futbolcu performans tahminlerinde ve potansiyel analizlerinde kusursuza yakın doğruluk payı tutturan kullanıcılar. Bu seviyedeki kullanıcı profillerinin, gerçek hayattaki profesyonel kulüplerle veya futbol ajanslarıyla iletişimde "Verified" (Onaylanmış) yetenek avcıları olarak sunulması projenin gelecek hedeflerindendir.

---
*Bu doküman projenin ana çerçevesini çizer. Mimari ilerledikçe veri tabanı şemaları (Supabase) ve Flutter UI tasarımları bu gereksinimler etrafında şekillendirilecektir.*
