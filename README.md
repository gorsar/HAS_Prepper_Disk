# HAS_PrepperDisk — Windows

**[Türkçe](#türkçe) · [English](#english)**

---

## Türkçe

Windows bilgisayarda çalışan çevrimdışı bilgi arşivi. Wikipedia, tıbbi başvuru kaynakları, tamir rehberleri ve hayatta kalma kitapları tek bir ana sayfadan açılır. İçerikler bir kez indirildikten sonra **internet gerekmez**. Aynı ağdaki telefonlar ve bilgisayarlar da tarayıcıdan erişebilir.

Bu repo, Raspberry Pi için hazırlanmış [schematrix/HAS_Prepper_Disk](https://github.com/schematrix/HAS_Prepper_Disk) projesinin **Windows'a uyarlanmış forkudur**. İçerikler [Kiwix](https://kiwix.org)'ten gelir, Internet-in-a-Box ya da Raspberry Pi gerekmez.

### Gereksinimler

- Windows 10 veya 11 (64-bit)
- İçerikler için disk alanı: küçük bir seçki için 10–20 GB, varsayılan listenin tamamı için ~150 GB
- Kurulum yok, yönetici yetkisi gerekmez. Her şey bu klasörün içinde kalır.

### Hızlı başlangıç

1. **İndir.** Yeşil **Code** düğmesi → **Download ZIP**, ardından zip'i bir klasöre aç. Ya da:
   ```
   git clone https://github.com/gorsar/HAS_Prepper_Disk.git
   ```
2. **İçerikleri seç.** `config\content.conf` dosyasını Not Defteri ile aç. İstemediğin satırların başına `#` koy (aşağıdaki tabloya bak).
3. **İçerikleri indir.** **`Icerik-Indir.bat`** dosyasına çift tıkla. İlk çalıştırmada gerekli iki küçük program da (kiwix-serve ve Caddy, toplam ~35 MB) `windows\bin` klasörüne iner. İndirme yarıda kalırsa tekrar çalıştır, kaldığı yerden devam eder.
4. **Başlat.** **`Baslat.bat`** dosyasına çift tıkla. Tarayıcıda **http://localhost:8080/home/** açılır. Kapatmak için siyah pencereyi kapat.

İçerikleri güncellemek için `Icerik-Indir.bat` dosyasını ara ara tekrar çalıştır. Yeni sürüm varsa indirir ve eskisini siler.

### Hangi içerikleri indirmeli?

| İçerik | Boyut | Not |
|---|---|---|
| Türkçe Vikipedi (`wikipedia_tr_all_maxi`) | ~9 GB | Genel bilgi, Türkçe |
| WikiMed (`wikipedia_en_medicine_maxi`) | ~2 GB | İngilizce Wikipedia'nın tıp maddeleri |
| WikEM, MDWiki, NHS, sahra tıbbı | ~2,5 GB | Acil tıp ve ilaç bilgisi |
| Hayatta kalma kitapları (`zimgit-*`, ready.gov, Low-tech Magazine) | ~3,3 GB | Su, gıda, düğümler, afet sonrası |
| iFixit + StackExchange siteleri | ~7 GB | Tamir, bahçe, yemek, araç bakımı, telsiz |
| İngilizce Wikipedia (`wikipedia_en_all_maxi`) | ~120 GB | İsteğe bağlı. Bunu indirirsen WikiMed'e gerek kalmaz |

**Öneri:** İlk seferde İngilizce Wikipedia'yı `#` ile kapat. Kalanlar yaklaşık 24 GB tutar.

**İndirme hızı:** Kiwix'in sunucusu bazı bağlantılarda çok yavaş olabiliyor (Türkiye'den yapılan testte ~85 KB/s ölçüldü). Büyük dosyaları [download.kiwix.org/zim](https://download.kiwix.org/zim/) adresindeki `.torrent` linkleriyle ya da [Kiwix Desktop](https://kiwix.org/en/applications/) uygulamasıyla indirip `library\zims` klasörüne kopyalayabilirsin. Klasöre konan her `.zim` dosyası bir sonraki başlatmada kendiliğinden tanınır.

### Ayarlar

`config\windows.conf` dosyasında üç ayar var:

| Ayar | Varsayılan | Ne işe yarar |
|---|---|---|
| `LIBRARY` | `library` (bu klasörün içi) | ZIM dosyalarının duracağı yer. Büyük bir disk seçmek için ör. `LIBRARY=D:\PrepperLibrary` |
| `PORT` | `8080` | Ana sayfanın portu |
| `KIWIX_PORT` | `8081` | Kiwix'in iç portu (sadece bu bilgisayardan erişilir) |

### Telefondan ve diğer cihazlardan erişim

`Baslat.bat` penceresinde `http://192.168.1.20:8080/home/` gibi adresler yazar. Aynı Wi-Fi ağındaki cihazlar bu adresleri kullanabilir.

- Windows Güvenlik Duvarı ilk seferde `caddy.exe` için izin sorar. **Özel ağlar** için izin ver.
- **İnternet ya da modem yoksa:** Windows'un **Ayarlar → Ağ ve İnternet → Mobil etkin nokta** özelliğini aç. Bilgisayar kendi Wi-Fi ağını yayınlar. Ona bağlanan telefonlar **http://192.168.137.1:8080/home/** adresini açar.

### Windows sürümünde olmayanlar

Orijinal Pi sürümündeki şu özellikler Internet-in-a-Box'a bağlı olduğu için burada yok: **haritalar**, **Kolibri** (çevrimdışı dersler), **yönetim paneli** ve ağa bağlanınca ana sayfayı kendiliğinden açan **captive portal**. Ana sayfa bunları otomatik olarak gri gösterir.

### Sorun giderme

- **Pencere açılıp hemen kapanıyor ya da "port kullanımda" diyor.** 8080 portunu başka bir program kullanıyor olabilir. `config\windows.conf` içinde `PORT=8090` gibi başka bir değer ver.
- **Ana sayfada her şey gri, "Henüz yüklenmedi" yazıyor.** `library\zims` klasöründe (ya da `LIBRARY` olarak ayarladığın yerde) `.zim` dosyası yok demektir. `Icerik-Indir.bat` dosyasını çalıştır ya da dosyaları oraya kopyala, sonra `Baslat.bat` ile yeniden başlat.
- **Telefon sayfayı açamıyor.** Telefonun bilgisayarla aynı ağda olduğundan emin ol. Güvenlik duvarı izni verilmemiş olabilir: **Windows Güvenlik → Güvenlik duvarı → Bir uygulamaya izin ver** ekranında `caddy.exe` için "Özel" kutusunu işaretle.
- **Windows "Bilgisayarınız korundu" (SmartScreen) uyarısı veriyor.** İnternetten indirilen `.bat` dosyalarında bu uyarı normal. **Ek bilgi → Yine de çalıştır** ile devam edebilirsin.
- **Kitap koleksiyonları (Su Arıtma, Düğümler, Gıda, Afet Sonrası, Tıp) sürekli "yükleniyor" diyor.** Bu koleksiyonlar kitap listesini tarayıcının yerel veritabanında tutuyor. Gizli sekmeler buna izin vermiyor, sayfayı normal bir sekmede aç.
- **Bir indirme yarıda kaldı.** `Icerik-Indir.bat` dosyasını tekrar çalıştır. Yarım dosyalar `.part` uzantısıyla durur ve kaldığı yerden tamamlanır.

### Raspberry Pi sürümü

Pi kurulum betikleri (`install.sh`, `scripts\`, `config\iiab-overrides.yml`) bu repoda değişmeden duruyor. Pi kurulumu için [orijinal reponun README'sine](https://github.com/schematrix/HAS_Prepper_Disk#readme) bak.

### Repo yapısı

```
Baslat.bat                    sunucuyu başlatır ve ana sayfayı açar
Icerik-Indir.bat              içerikleri indirir/günceller
config/content.conf           indirilecek içerik listesi
config/windows.conf           Windows ayarları (klasör, portlar)
windows/start.ps1             kiwix-serve + Caddy'yi başlatır
windows/download-content.ps1  ZIM dosyalarını Kiwix'ten indirir
windows/setup.ps1             kiwix-serve ve Caddy'yi windows/bin içine indirir
windows/Caddyfile             /home ve /kiwix adreslerini tek portta birleştirir
www/home/index.html           ana sayfa
library/zims/                 indirilen içerikler (git'e eklenmez)
install.sh, scripts/          Raspberry Pi kurulumu (orijinal proje)
```

### Lisans ve teşekkür

Orijinal proje: [schematrix/HAS_Prepper_Disk](https://github.com/schematrix/HAS_Prepper_Disk). Betikler ve ana sayfa [MIT Lisansı](LICENSE) ile yayınlanmıştır. Kiwix, Caddy ve indirilen tüm içerikler (Wikipedia vb.) kendi lisanslarına tabidir. Bu proje Kiwix ya da Internet-in-a-Box ile bağlantılı değildir.

---

## English

An offline knowledge archive for Windows. Wikipedia, medical references, repair guides and survival books open from a single homepage. Once the content is downloaded, **no internet is needed**. Phones and computers on the same network can use it from a browser.

This is a **Windows fork** of [schematrix/HAS_Prepper_Disk](https://github.com/schematrix/HAS_Prepper_Disk), which was built for the Raspberry Pi. Content comes from [Kiwix](https://kiwix.org). No Raspberry Pi or Internet-in-a-Box is required.

### Requirements

- Windows 10 or 11 (64-bit)
- Disk space for content: 10–20 GB for a small selection, ~150 GB for the full default list
- Nothing is installed and no admin rights are needed. Everything stays inside this folder.

### Quick start

1. **Download.** Green **Code** button → **Download ZIP**, then extract it. Or `git clone https://github.com/gorsar/HAS_Prepper_Disk.git`.
2. **Choose content.** Open `config\content.conf` in Notepad and put `#` in front of lines you don't want. English Wikipedia alone is ~120 GB, so consider disabling it at first. Without it the list is about 24 GB.
3. **Download content.** Double-click **`Icerik-Indir.bat`** ("download content"). The first run also fetches kiwix-serve and Caddy (~35 MB) into `windows\bin`. Re-run it to resume or update.
4. **Start.** Double-click **`Baslat.bat`** ("start"). The homepage opens at **http://localhost:8080/home/**. Close the window to stop.

Kiwix's download server can be slow. You can also get large files via the `.torrent` links on [download.kiwix.org/zim](https://download.kiwix.org/zim/) or with Kiwix Desktop, and copy them into `library\zims`. They are picked up on the next start.

**Settings** live in `config\windows.conf`: `LIBRARY` (where ZIM files are stored, e.g. `D:\PrepperLibrary`), `PORT` (default 8080) and `KIWIX_PORT` (default 8081, localhost only).

**Other devices:** the window prints addresses like `http://192.168.1.20:8080/home/`. Allow `caddy.exe` on private networks when Windows Firewall asks. With no router, turn on Windows **Mobile hotspot**. Phones that join it open `http://192.168.137.1:8080/home/`.

**Not available on Windows:** maps, Kolibri, the admin console and the captive portal. These come from Internet-in-a-Box, and the homepage greys them out automatically. The Raspberry Pi scripts are still in this repo unchanged. See the [original README](https://github.com/schematrix/HAS_Prepper_Disk#readme) for the Pi setup.

**License:** scripts and homepage are under the [MIT License](LICENSE). Kiwix, Caddy and all downloaded content keep their own licenses.
