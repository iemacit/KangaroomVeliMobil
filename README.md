# Kangaroom - Flutter Uygulaması

Bu Flutter uygulaması, öğrenci ve veli takip sistemi için geliştirilmiştir.

## 📱 Özellikler

- Öğrenci profil yönetimi
- Yoklama takibi
- Ders programı görüntüleme
- Yemek programı
- Aidat takibi
- Duyuru sistemi
- Etkinlik yönetimi
- Sağlık takibi
- Çoklu dil desteği (Türkçe, İngilizce, Almanca, Fransızca, İtalyanca, Rusça, Arapça)

## 🚀 Kurulum

### Gereksinimler

- Flutter SDK (>=3.2.6)
- Dart SDK
- Android Studio / VS Code

### Adımlar

1. **Projeyi klonlayın:**
   ```bash
   git clone [repository-url]
   cd kangaroom-main
   ```

2. **Bağımlılıkları yükleyin:**
   ```bash
   flutter pub get
   ```

3. **Firebase yapılandırması:**
   - Kendi Firebase projenizi oluşturun
   - `google-services.json` (Android) ve `GoogleService-Info.plist` (iOS) dosyalarını ekleyin
   - `lib/firebase_options.dart` dosyasını güncelleyin

4. **Uygulamayı çalıştırın:**
   ```bash
   flutter run
   ```

## 📦 Build

### Android APK
```bash
flutter build apk --release
```

### Web
```bash
flutter build web
```

## 📁 Proje Yapısı

```
lib/
├── home/           # Ana sayfa ve modüller
├── menu/           # Menü sayfaları
├── model/          # Veri modelleri
├── user/           # Kullanıcı işlemleri
├── l10n/           # Çoklu dil desteği
└── generated/      # Otomatik oluşturulan dosyalar
```

## 🌐 Çoklu Dil Desteği

Uygulama 7 dilde desteklenmektedir:
- Türkçe (tr)
- İngilizce (en)
- Almanca (de)
- Fransızca (fr)
- İtalyanca (it)
- Rusça (ru)
- Arapça (ar)

## 🔒 Güvenlik

- Firebase Authentication kullanılmaktadır
- API endpoint'leri güvenli HTTPS üzerinden çalışır
- Hassas bilgiler environment variables ile korunur

## 📞 Destek

Herhangi bir sorun yaşarsanız, lütfen iletişime geçin.

## 📄 Lisans

Bu proje özel kullanım için geliştirilmiştir.

---

**Not:** Bu proje paylaşım için optimize edilmiştir. Platform-specific build dosyaları ve gereksiz dosyalar temizlenmiştir.
