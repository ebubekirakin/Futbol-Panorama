import './App.css'

function App() {
  return (
    <>
      <header>
        <h1>Futbol-Panorama</h1>
        <nav aria-label="Ana navigasyon">
          <ul>
            <li><a href="#analiz-yaz">Analiz Yaz</a></li>
            <li><a href="#akis">Gündem (Akış)</a></li>
          </ul>
        </nav>
      </header>

      <main>
        <section id="analiz-yaz">
          <h2>Yeni Analiz Oluştur</h2>
          {/* Erişilebilir Form Yapısı */}
          <form action="#" method="POST">
            <div className="form-group">
              <label htmlFor="topic">Futbolcu / Takım Adı:</label>
              <input 
                type="text" 
                id="topic" 
                name="topic" 
                required 
                minLength={2} 
              />
            </div>

            <div className="form-group">
              <label htmlFor="analysis">Analiziniz:</label>
              <textarea 
                id="analysis" 
                name="analysis" 
                rows={5} 
                required 
                minLength={20}
                placeholder="Örn: Muçi bu yıl çok formda..."
              ></textarea>
            </div>

            <button type="submit">Analizi Paylaş</button>
          </form>
        </section>

        <section id="akis">
          <h2>Son Analizler</h2>
          <article>
            <h3>Muçi'nin Form Grafiği</h3>
            <p>Muçi bu yıl çok formda yüksek skor katkılarına şimdiden ulaştı. Trabzonspor'da başarılı bir grafik çiziyor ama geçen yıl Beşiktaş'ta bu kadar verimli olamadı...</p>
          </article>
        </section>
      </main>

      <footer>
        <p>&copy; 2026 Futbol-Panorama. Tüm hakları saklıdır.</p>
      </footer>
    </>
  )
}

export default App