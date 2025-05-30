# Veritabanı Yedekleme ve Otomasyon Çalışması

Mustafa Girgin
21290649

https://github.com/antelcha/sqlprojeler

## Otomatik Yedekleme Sistemi Kurulumu ve Testi

Bu projede, SQL Server veritabanları için kapsamlı bir yedekleme sistemi geliştirdim. Sistem, yedekleme işlemlerini takip ediyor, geçmişi kaydediyor ve olası hataları raporluyor.

### 1. Veritabanı ve Tablo Yapılarının Oluşturulması

İlk adım olarak, yedekleme sisteminin ihtiyaç duyduğu veritabanı ve tabloları oluşturdum. TestDB adında bir test veritabanı ve içerisinde örnek veriler için Customers tablosu ile yedekleme kayıtları için BackupHistory tablosu yer alıyor.

[Fotoğraf 1: TestDB veritabanı ve tablolarının oluşturulması - DataGrip'te çalıştırılan create database ve create table komutlarının başarılı sonuçlarını gösteren ekran görüntüsü]

### 2. Yedekleme Prosedürünün Oluşturulması

Yedekleme işlemlerini yönetmek için sp_CreateBackup adında bir stored procedure oluşturdum. Bu prosedür:
- Yedekleme başlangıç kaydını oluşturuyor
- Yedekleme işlemini gerçekleştiriyor
- İşlem sonucunu kaydediyor
- Hata durumunda uygun şekilde raporluyor

[Fotoğraf 2: Stored procedure kodunun DataGrip'te başarıyla oluşturulduğunu gösteren ekran görüntüsü]

### 3. Yedekleme İzleme Sistemi

Yedekleme işlemlerini izlemek için vw_BackupReport adında bir view oluşturdum. Bu view sayesinde:
- Tüm yedekleme işlemlerinin geçmişi
- Başarılı/başarısız yedeklemeler
- Yedekleme süreleri ve boyutları
- Yedekleme dosyalarının konumları

kolayca görüntülenebiliyor.

[Fotoğraf 3: vw_BackupReport view'ının yapısı ve örnek sorgu sonuçları]

### 4. Test ve Doğrulama

Sistemin düzgün çalıştığından emin olmak için çeşitli testler gerçekleştirdim:

#### Manuel Yedekleme Testi
İlk olarak manuel bir yedekleme işlemi başlattım:

[Fotoğraf 4: Manuel yedekleme komutunun çalıştırılması ve başarılı sonucu gösteren ekran görüntüsü]

#### Yedekleme Geçmişi Kontrolü
vw_BackupReport view'ı kullanarak yedekleme geçmişini kontrol ettim:

[Fotoğraf 5: Yedekleme geçmişini gösteren sorgu sonucu - başarılı yedeklemelerin listesi]

### 5. Hata Senaryoları ve Çözümleri

Sistemin hata durumlarında nasıl davrandığını test etmek için çeşitli senaryolar denedim:

#### Disk Alanı Yetersizliği Testi
Yedekleme dizininde yetersiz alan durumunu simüle ettim:

[Fotoğraf 6: Disk alanı yetersizliği durumunda oluşan hata mesajı ve BackupHistory tablosundaki ilgili kayıt]

#### Erişim İzni Kontrolü
Yedekleme dizinine yazma izni olmadığı durumu test ettim:

[Fotoğraf 7: Erişim izni hatası ve sistemin bu durumu nasıl kaydettiğini gösteren ekran görüntüsü]

### 6. Yedekleme Otomasyonu

Yedekleme işlemlerinin otomatikleştirilmesi için iki farklı yaklaşım sundum:

1. PowerShell Script ile Otomasyon
2. Cron Job ile Zamanlanmış Görev

[Fotoğraf 8: PowerShell script örneği ve zamanlanmış görev ayarları]

### 7. Güvenlik Önlemleri

Yedekleme sisteminde aldığım güvenlik önlemleri:
- Yedekleme dizini erişim kontrolü
- Şifrelenmiş yedekleme dosyaları
- Yedekleme dosyası adlandırma standardı

[Fotoğraf 9: Güvenlik ayarlarının yapılandırılmasını gösteren ekran görüntüsü]

### 8. Performans ve İzleme

Yedekleme performansını ve sistem durumunu izlemek için oluşturduğum raporlar:

[Fotoğraf 10: Performans metrikleri ve sistem durumu raporu örneği]

Bu proje sayesinde, veritabanı yedeklemelerinin güvenli ve izlenebilir bir şekilde alınmasını sağlayan kapsamlı bir sistem geliştirmiş oldum. Sistem, olası hata durumlarına karşı dayanıklı ve kolayca takip edilebilir bir yapıda tasarlandı. 