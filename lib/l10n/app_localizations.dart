import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('it'),
    Locale('ru'),
    Locale('tr')
  ];

  /// No description provided for @ayarlar.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get ayarlar;

  /// No description provided for @hesap.
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get hesap;

  /// No description provided for @diger.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get diger;

  /// No description provided for @dil.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get dil;

  /// No description provided for @tema.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get tema;

  /// No description provided for @temaSecimi.
  ///
  /// In tr, this message translates to:
  /// **'Tema Seçimi'**
  String get temaSecimi;

  /// No description provided for @dilSecimi.
  ///
  /// In tr, this message translates to:
  /// **'Dil Seçimi'**
  String get dilSecimi;

  /// No description provided for @cikis.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış'**
  String get cikis;

  /// No description provided for @guncellemeHatasi.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı bilgileri güncellenirken bir hata oluştu.'**
  String get guncellemeHatasi;

  /// No description provided for @saglik.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık'**
  String get saglik;

  /// No description provided for @menu.
  ///
  /// In tr, this message translates to:
  /// **'Menü'**
  String get menu;

  /// No description provided for @anaSayfa.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get anaSayfa;

  /// No description provided for @kurumsal.
  ///
  /// In tr, this message translates to:
  /// **'Kurumsal'**
  String get kurumsal;

  /// No description provided for @hakkimizda.
  ///
  /// In tr, this message translates to:
  /// **'Hakkımızda'**
  String get hakkimizda;

  /// No description provided for @sosyalMedya.
  ///
  /// In tr, this message translates to:
  /// **'Sosyal Medya'**
  String get sosyalMedya;

  /// No description provided for @egitimKadrosu.
  ///
  /// In tr, this message translates to:
  /// **'Eğitmen Kadrosu'**
  String get egitimKadrosu;

  /// No description provided for @gorusVeOneri.
  ///
  /// In tr, this message translates to:
  /// **'Görüş ve Öneri'**
  String get gorusVeOneri;

  /// No description provided for @durumBilgisi.
  ///
  /// In tr, this message translates to:
  /// **'Durum Bilgisi'**
  String get durumBilgisi;

  /// No description provided for @mutsuz.
  ///
  /// In tr, this message translates to:
  /// **'Mutsuz'**
  String get mutsuz;

  /// No description provided for @dinlendi.
  ///
  /// In tr, this message translates to:
  /// **'Dinlendi'**
  String get dinlendi;

  /// No description provided for @buyukTuvalet.
  ///
  /// In tr, this message translates to:
  /// **'Büyük tuvalet yaptı'**
  String get buyukTuvalet;

  /// No description provided for @ilacAldi.
  ///
  /// In tr, this message translates to:
  /// **'İlaç aldı'**
  String get ilacAldi;

  /// No description provided for @sabah.
  ///
  /// In tr, this message translates to:
  /// **'Sabah'**
  String get sabah;

  /// No description provided for @ogle.
  ///
  /// In tr, this message translates to:
  /// **'Öğle'**
  String get ogle;

  /// No description provided for @ikindi.
  ///
  /// In tr, this message translates to:
  /// **'İkindi'**
  String get ikindi;

  /// No description provided for @yoklamabilgisigirilmedi.
  ///
  /// In tr, this message translates to:
  /// **'Yoklama Bilgisi Girilmedi.'**
  String get yoklamabilgisigirilmedi;

  /// No description provided for @profil.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profil;

  /// No description provided for @zil.
  ///
  /// In tr, this message translates to:
  /// **'Zil'**
  String get zil;

  /// No description provided for @aidat.
  ///
  /// In tr, this message translates to:
  /// **'Aidat'**
  String get aidat;

  /// No description provided for @randevular.
  ///
  /// In tr, this message translates to:
  /// **'Randevular'**
  String get randevular;

  /// No description provided for @karne.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim Raporu'**
  String get karne;

  /// No description provided for @yoklama.
  ///
  /// In tr, this message translates to:
  /// **'Yoklama'**
  String get yoklama;

  /// No description provided for @boyKilo.
  ///
  /// In tr, this message translates to:
  /// **'Boy/Kilo'**
  String get boyKilo;

  /// No description provided for @duyurular.
  ///
  /// In tr, this message translates to:
  /// **'Duyurular'**
  String get duyurular;

  /// No description provided for @bulten.
  ///
  /// In tr, this message translates to:
  /// **'Bülten'**
  String get bulten;

  /// No description provided for @etkinlik.
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik'**
  String get etkinlik;

  /// No description provided for @dersProgrami.
  ///
  /// In tr, this message translates to:
  /// **'Ders Programı'**
  String get dersProgrami;

  /// No description provided for @yemekProgrami.
  ///
  /// In tr, this message translates to:
  /// **'Yemek Programı'**
  String get yemekProgrami;

  /// No description provided for @haftalikDersSaati.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Ders Saati'**
  String get haftalikDersSaati;

  /// No description provided for @sosyalMedyaHesaplarimiz.
  ///
  /// In tr, this message translates to:
  /// **'Sosyal Medya Hesaplarımız'**
  String get sosyalMedyaHesaplarimiz;

  /// No description provided for @misyon.
  ///
  /// In tr, this message translates to:
  /// **'Misyon'**
  String get misyon;

  /// No description provided for @vizyon.
  ///
  /// In tr, this message translates to:
  /// **'Vizyon'**
  String get vizyon;

  /// No description provided for @hesapIslemleri.
  ///
  /// In tr, this message translates to:
  /// **'Hesap İşlemleri'**
  String get hesapIslemleri;

  /// No description provided for @uygulamaHakkinda.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Hakkında'**
  String get uygulamaHakkinda;

  /// No description provided for @kangaroomUygulama.
  ///
  /// In tr, this message translates to:
  /// **'Kangaroom Kreş Yönetim Uygulaması'**
  String get kangaroomUygulama;

  /// No description provided for @missoft.
  ///
  /// In tr, this message translates to:
  /// **'Missoft Dijital Dönüşüm'**
  String get missoft;

  /// No description provided for @ogrenciProfili.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci Profili'**
  String get ogrenciProfili;

  /// No description provided for @yas.
  ///
  /// In tr, this message translates to:
  /// **'Yaş'**
  String get yas;

  /// No description provided for @sinif.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf'**
  String get sinif;

  /// No description provided for @ogretmen.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmen'**
  String get ogretmen;

  /// No description provided for @profilResmi.
  ///
  /// In tr, this message translates to:
  /// **'Profil Resmi'**
  String get profilResmi;

  /// No description provided for @goruntule.
  ///
  /// In tr, this message translates to:
  /// **'Görüntüle'**
  String get goruntule;

  /// No description provided for @galeridenSec.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden Seç'**
  String get galeridenSec;

  /// No description provided for @kameraIleCek.
  ///
  /// In tr, this message translates to:
  /// **'Kamera ile Çek'**
  String get kameraIleCek;

  /// No description provided for @lutfenOgretmeniBilgilendir.
  ///
  /// In tr, this message translates to:
  /// **'lütfen Öğretmenimizi bilgilendirmek için yukarıdaki butonları kullanın... 😊'**
  String get lutfenOgretmeniBilgilendir;

  /// No description provided for @cocugumuBaskaBiriAlacak.
  ///
  /// In tr, this message translates to:
  /// **'Çocuğumu Başka Biri Alacak'**
  String get cocugumuBaskaBiriAlacak;

  /// No description provided for @benAlacagim.
  ///
  /// In tr, this message translates to:
  /// **'Ben Alacağım'**
  String get benAlacagim;

  /// No description provided for @iptal.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get iptal;

  /// No description provided for @tamam.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get tamam;

  /// No description provided for @kimAlacak.
  ///
  /// In tr, this message translates to:
  /// **'Kim Alacak?'**
  String get kimAlacak;

  /// No description provided for @kiminAlacaginiGiriniz.
  ///
  /// In tr, this message translates to:
  /// **'Kimin alacağını giriniz'**
  String get kiminAlacaginiGiriniz;

  /// No description provided for @nezamanAlacaksiniz.
  ///
  /// In tr, this message translates to:
  /// **'Nezaman Alacaksınız?'**
  String get nezamanAlacaksiniz;

  /// No description provided for @kapidayim.
  ///
  /// In tr, this message translates to:
  /// **'Kapıdayım'**
  String get kapidayim;

  /// No description provided for @dk5.
  ///
  /// In tr, this message translates to:
  /// **'5dk'**
  String get dk5;

  /// No description provided for @dk10.
  ///
  /// In tr, this message translates to:
  /// **'10dk'**
  String get dk10;

  /// No description provided for @dk15.
  ///
  /// In tr, this message translates to:
  /// **'15dk'**
  String get dk15;

  /// No description provided for @odeme.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme'**
  String get odeme;

  /// No description provided for @verilerYukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Veriler Yükleniyor...'**
  String get verilerYukleniyor;

  /// No description provided for @toplamTutar.
  ///
  /// In tr, this message translates to:
  /// **'Toplam tutar'**
  String get toplamTutar;

  /// No description provided for @odemeTarihi.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Tarihi'**
  String get odemeTarihi;

  /// No description provided for @odenmemis.
  ///
  /// In tr, this message translates to:
  /// **'Ödenmemiş'**
  String get odenmemis;

  /// No description provided for @yil.
  ///
  /// In tr, this message translates to:
  /// **'Yıl'**
  String get yil;

  /// No description provided for @ay.
  ///
  /// In tr, this message translates to:
  /// **'Ay'**
  String get ay;

  /// No description provided for @kirtasiye.
  ///
  /// In tr, this message translates to:
  /// **'Kırtasiye'**
  String get kirtasiye;

  /// No description provided for @aciklama.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get aciklama;

  /// No description provided for @january.
  ///
  /// In tr, this message translates to:
  /// **'Ocak'**
  String get january;

  /// No description provided for @february.
  ///
  /// In tr, this message translates to:
  /// **'Şubat'**
  String get february;

  /// No description provided for @march.
  ///
  /// In tr, this message translates to:
  /// **'Mart'**
  String get march;

  /// No description provided for @april.
  ///
  /// In tr, this message translates to:
  /// **'Nisan'**
  String get april;

  /// No description provided for @may.
  ///
  /// In tr, this message translates to:
  /// **'Mayıs'**
  String get may;

  /// No description provided for @june.
  ///
  /// In tr, this message translates to:
  /// **'Haziran'**
  String get june;

  /// No description provided for @july.
  ///
  /// In tr, this message translates to:
  /// **'Temmuz'**
  String get july;

  /// No description provided for @august.
  ///
  /// In tr, this message translates to:
  /// **'Ağustos'**
  String get august;

  /// No description provided for @september.
  ///
  /// In tr, this message translates to:
  /// **'Eylül'**
  String get september;

  /// No description provided for @october.
  ///
  /// In tr, this message translates to:
  /// **'Ekim'**
  String get october;

  /// No description provided for @november.
  ///
  /// In tr, this message translates to:
  /// **'Kasım'**
  String get november;

  /// No description provided for @december.
  ///
  /// In tr, this message translates to:
  /// **'Aralık'**
  String get december;

  /// No description provided for @sizeTanimliRandevuBulunmamaktadir.
  ///
  /// In tr, this message translates to:
  /// **'Size tanımlı randevu bulunmamaktadır'**
  String get sizeTanimliRandevuBulunmamaktadir;

  /// No description provided for @ogretmenAd.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmen Adı'**
  String get ogretmenAd;

  /// No description provided for @ogrenciAd.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci Adı'**
  String get ogrenciAd;

  /// No description provided for @onayla.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get onayla;

  /// No description provided for @redEt.
  ///
  /// In tr, this message translates to:
  /// **'Red Et'**
  String get redEt;

  /// No description provided for @silmeIslemi.
  ///
  /// In tr, this message translates to:
  /// **'Silme İşlemi'**
  String get silmeIslemi;

  /// No description provided for @eminMisiniz.
  ///
  /// In tr, this message translates to:
  /// **'Bu randevuyu silmek istediğinizden emin misiniz?'**
  String get eminMisiniz;

  /// No description provided for @evet.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get evet;

  /// No description provided for @randevuSilindi.
  ///
  /// In tr, this message translates to:
  /// **'Randevu başarıyla silindi.'**
  String get randevuSilindi;

  /// No description provided for @karneBilgisiYok.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim Raporu Bilgisi Yok !!!'**
  String get karneBilgisiYok;

  /// No description provided for @donemSecin.
  ///
  /// In tr, this message translates to:
  /// **'Dönem seçin'**
  String get donemSecin;

  /// No description provided for @donem.
  ///
  /// In tr, this message translates to:
  /// **'Dönem'**
  String get donem;

  /// No description provided for @tur.
  ///
  /// In tr, this message translates to:
  /// **'Tür'**
  String get tur;

  /// No description provided for @gelisimAlani.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim Alanı'**
  String get gelisimAlani;

  /// No description provided for @devamsizlik.
  ///
  /// In tr, this message translates to:
  /// **'Devamsızlık'**
  String get devamsizlik;

  /// No description provided for @devam.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get devam;

  /// No description provided for @devamsiz.
  ///
  /// In tr, this message translates to:
  /// **'Devamsız'**
  String get devamsiz;

  /// No description provided for @ikiHafta.
  ///
  /// In tr, this message translates to:
  /// **'2 Hafta'**
  String get ikiHafta;

  /// No description provided for @hafta.
  ///
  /// In tr, this message translates to:
  /// **'Hafta'**
  String get hafta;

  /// No description provided for @veriGetirmeHatasi.
  ///
  /// In tr, this message translates to:
  /// **'Veri getirme hatası'**
  String get veriGetirmeHatasi;

  /// No description provided for @veriBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Bu öğrenci için veri bulunamadı.'**
  String get veriBulunamadi;

  /// No description provided for @kilo.
  ///
  /// In tr, this message translates to:
  /// **'Kilo'**
  String get kilo;

  /// No description provided for @boy.
  ///
  /// In tr, this message translates to:
  /// **'Boy'**
  String get boy;

  /// No description provided for @tablo.
  ///
  /// In tr, this message translates to:
  /// **'Tablo'**
  String get tablo;

  /// No description provided for @tarih.
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get tarih;

  /// No description provided for @boyCm.
  ///
  /// In tr, this message translates to:
  /// **'Boy'**
  String get boyCm;

  /// No description provided for @kiloKg.
  ///
  /// In tr, this message translates to:
  /// **'Kilo'**
  String get kiloKg;

  /// No description provided for @duyurularYukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Duyurular Yükleniyor...'**
  String get duyurularYukleniyor;

  /// No description provided for @duyurularBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Duyurular'**
  String get duyurularBaslik;

  /// No description provided for @duyuruYukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Duyurular Yükleniyor...'**
  String get duyuruYukleniyor;

  /// No description provided for @duyuru.
  ///
  /// In tr, this message translates to:
  /// **'Duyuru'**
  String get duyuru;

  /// No description provided for @aylik.
  ///
  /// In tr, this message translates to:
  /// **'Aylık'**
  String get aylik;

  /// No description provided for @saglikBilgileri.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık Bilgileri'**
  String get saglikBilgileri;

  /// No description provided for @saglikBilgisiGuncelleme.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık Bilgisi Güncelleme'**
  String get saglikBilgisiGuncelleme;

  /// No description provided for @ilacBilgisi.
  ///
  /// In tr, this message translates to:
  /// **'İlaç Bilgisi'**
  String get ilacBilgisi;

  /// No description provided for @ilacSaati.
  ///
  /// In tr, this message translates to:
  /// **'İlaç Saati'**
  String get ilacSaati;

  /// No description provided for @kronikHastalikDurumu.
  ///
  /// In tr, this message translates to:
  /// **'Kronik Hastalık Durumu'**
  String get kronikHastalikDurumu;

  /// No description provided for @alerjiDurumu.
  ///
  /// In tr, this message translates to:
  /// **'Alerji Durumu'**
  String get alerjiDurumu;

  /// No description provided for @bilgileriGuncelle.
  ///
  /// In tr, this message translates to:
  /// **'Bilgileri Güncelle'**
  String get bilgileriGuncelle;

  /// No description provided for @basarili.
  ///
  /// In tr, this message translates to:
  /// **'Başarılı'**
  String get basarili;

  /// No description provided for @bilgilerGuncellendi.
  ///
  /// In tr, this message translates to:
  /// **'Bilgiler başarıyla güncellendi.'**
  String get bilgilerGuncellendi;

  /// No description provided for @etkinlikSayfasi.
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik Sayfası'**
  String get etkinlikSayfasi;

  /// No description provided for @saat.
  ///
  /// In tr, this message translates to:
  /// **'Saat'**
  String get saat;

  /// No description provided for @ucret.
  ///
  /// In tr, this message translates to:
  /// **'Ücret'**
  String get ucret;

  /// No description provided for @iban.
  ///
  /// In tr, this message translates to:
  /// **'IBAN'**
  String get iban;

  /// No description provided for @belirtilmedi.
  ///
  /// In tr, this message translates to:
  /// **'Belirtilmedi'**
  String get belirtilmedi;

  /// No description provided for @dekontYukle.
  ///
  /// In tr, this message translates to:
  /// **'Dekont Yükle (PDF)'**
  String get dekontYukle;

  /// No description provided for @yuklenenDekont.
  ///
  /// In tr, this message translates to:
  /// **'Yüklenen Dekont: {fileName}'**
  String yuklenenDekont(Object fileName);

  /// No description provided for @reddet.
  ///
  /// In tr, this message translates to:
  /// **'Reddet'**
  String get reddet;

  /// No description provided for @kayitYapildi.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt yapıldı'**
  String get kayitYapildi;

  /// No description provided for @katilimReddedildi.
  ///
  /// In tr, this message translates to:
  /// **'Etkinliğe katılım reddedildi'**
  String get katilimReddedildi;

  /// No description provided for @dekontYuklendi.
  ///
  /// In tr, this message translates to:
  /// **'Dekont yüklendi: {fileName}'**
  String dekontYuklendi(Object fileName);

  /// No description provided for @etkinlikAnaSayfasi.
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik Ana Sayfası'**
  String get etkinlikAnaSayfasi;

  /// No description provided for @etkinlikAdi.
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik Adı'**
  String get etkinlikAdi;

  /// No description provided for @etkinlikTarihi.
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik Tarihi'**
  String get etkinlikTarihi;

  /// No description provided for @onaylanmaDurumu.
  ///
  /// In tr, this message translates to:
  /// **'Etkinliğin Onaylanma Durumu'**
  String get onaylanmaDurumu;

  /// No description provided for @aliciHesap.
  ///
  /// In tr, this message translates to:
  /// **'Alıcı Hesap'**
  String get aliciHesap;

  /// No description provided for @dosyaAdi.
  ///
  /// In tr, this message translates to:
  /// **'Dosya Adı'**
  String get dosyaAdi;

  /// No description provided for @indir.
  ///
  /// In tr, this message translates to:
  /// **'PDF\'i İndir'**
  String get indir;

  /// No description provided for @veriYuklenemedi.
  ///
  /// In tr, this message translates to:
  /// **'Veriler yüklenemedi'**
  String get veriYuklenemedi;

  /// No description provided for @enYakinDersBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'En yakın ders bulunamadı.'**
  String get enYakinDersBulunamadi;

  /// No description provided for @tarihYok.
  ///
  /// In tr, this message translates to:
  /// **'Tarih yok'**
  String get tarihYok;

  /// No description provided for @saatYok.
  ///
  /// In tr, this message translates to:
  /// **'Saat yok'**
  String get saatYok;

  /// No description provided for @normal.
  ///
  /// In tr, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @mutlu.
  ///
  /// In tr, this message translates to:
  /// **'Mutlu'**
  String get mutlu;

  /// No description provided for @uzgun.
  ///
  /// In tr, this message translates to:
  /// **'Üzgün'**
  String get uzgun;

  /// No description provided for @ofkeli.
  ///
  /// In tr, this message translates to:
  /// **'Öfkeli'**
  String get ofkeli;

  /// No description provided for @buyukTuvaletaltinayati.
  ///
  /// In tr, this message translates to:
  /// **'Büyük tuvaleti altına yaptı'**
  String get buyukTuvaletaltinayati;

  /// No description provided for @kucukTuvaletaltinayati.
  ///
  /// In tr, this message translates to:
  /// **'Küçük tuvaleti altına yaptı'**
  String get kucukTuvaletaltinayati;

  /// No description provided for @kucukTuvalet.
  ///
  /// In tr, this message translates to:
  /// **'Küçük tuvalet yaptı'**
  String get kucukTuvalet;

  /// No description provided for @ilacAlmadi.
  ///
  /// In tr, this message translates to:
  /// **'İlaç almadı'**
  String get ilacAlmadi;

  /// No description provided for @zilgonderildi.
  ///
  /// In tr, this message translates to:
  /// **'Zil gönderildi'**
  String get zilgonderildi;

  /// No description provided for @zilgonderilmedi.
  ///
  /// In tr, this message translates to:
  /// **'Zil gönderilmedi'**
  String get zilgonderilmedi;

  /// No description provided for @buguntatil.
  ///
  /// In tr, this message translates to:
  /// **'Bugün tatil'**
  String get buguntatil;

  /// No description provided for @durumbilgisi.
  ///
  /// In tr, this message translates to:
  /// **'Durum bilgisi'**
  String get durumbilgisi;

  /// No description provided for @resimyuklenmedi.
  ///
  /// In tr, this message translates to:
  /// **'Resim yüklenmedi'**
  String get resimyuklenmedi;

  /// No description provided for @resimyuklendi.
  ///
  /// In tr, this message translates to:
  /// **'Resim yüklendi'**
  String get resimyuklendi;

  /// No description provided for @okulagelmdim.
  ///
  /// In tr, this message translates to:
  /// **'Okula gelmedim'**
  String get okulagelmdim;

  /// No description provided for @uyumadi.
  ///
  /// In tr, this message translates to:
  /// **'Uyumadı'**
  String get uyumadi;

  /// No description provided for @uyudu.
  ///
  /// In tr, this message translates to:
  /// **'Uyudu'**
  String get uyudu;

  /// No description provided for @yok.
  ///
  /// In tr, this message translates to:
  /// **'yok'**
  String get yok;

  /// No description provided for @ders.
  ///
  /// In tr, this message translates to:
  /// **'Ders'**
  String get ders;

  /// No description provided for @puan.
  ///
  /// In tr, this message translates to:
  /// **' öğrenci puani'**
  String get puan;

  /// No description provided for @onaylandi.
  ///
  /// In tr, this message translates to:
  /// **'Onaylandı'**
  String get onaylandi;

  /// No description provided for @noAppointment.
  ///
  /// In tr, this message translates to:
  /// **'Size tanımlı randevu bulunmamaktadır.'**
  String get noAppointment;

  /// No description provided for @institutionResponse.
  ///
  /// In tr, this message translates to:
  /// **'↓ Kurum tarafından gelen cevap aşağıya iletilecektir. ↓'**
  String get institutionResponse;

  /// No description provided for @responseReceived.
  ///
  /// In tr, this message translates to:
  /// **'Gelen cevap'**
  String get responseReceived;

  /// No description provided for @feedbackReceived.
  ///
  /// In tr, this message translates to:
  /// **'Görüş ve önerileriniz alındı, en kısa zamanda cevap alanına iletilecektir, teşekkürler...'**
  String get feedbackReceived;

  /// No description provided for @gonder.
  ///
  /// In tr, this message translates to:
  /// **'gönder'**
  String get gonder;

  /// No description provided for @mudur.
  ///
  /// In tr, this message translates to:
  /// **'Müdür'**
  String get mudur;

  /// No description provided for @mudurYardimcisi.
  ///
  /// In tr, this message translates to:
  /// **'Müdür Yardımcısı'**
  String get mudurYardimcisi;

  /// No description provided for @noMessage.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj Yok!'**
  String get noMessage;

  /// No description provided for @writeMessage.
  ///
  /// In tr, this message translates to:
  /// **'Mesajınızı Yazın'**
  String get writeMessage;

  /// No description provided for @mobil.
  ///
  /// In tr, this message translates to:
  /// **'Mobil Uygulama'**
  String get mobil;

  /// No description provided for @reddedildi.
  ///
  /// In tr, this message translates to:
  /// **'reddedildi'**
  String get reddedildi;

  /// No description provided for @dersresimleri.
  ///
  /// In tr, this message translates to:
  /// **'Ders Resimleri'**
  String get dersresimleri;

  /// No description provided for @borc.
  ///
  /// In tr, this message translates to:
  /// **'dönemine ait borç bulunmaktadır!'**
  String get borc;

  /// No description provided for @aidetborc.
  ///
  /// In tr, this message translates to:
  /// **'Aidat Uyarısı'**
  String get aidetborc;

  /// No description provided for @anket.
  ///
  /// In tr, this message translates to:
  /// **'Anket'**
  String get anket;

  /// No description provided for @anketSayfasi.
  ///
  /// In tr, this message translates to:
  /// **'Anket'**
  String get anketSayfasi;

  /// No description provided for @chatbot.
  ///
  /// In tr, this message translates to:
  /// **'sohbet robotu'**
  String get chatbot;

  /// No description provided for @dogumtarihi.
  ///
  /// In tr, this message translates to:
  /// **'Doğum Tarihi'**
  String get dogumtarihi;

  /// No description provided for @baslik.
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get baslik;

  /// No description provided for @redsebebiyaz.
  ///
  /// In tr, this message translates to:
  /// **'ret nedeninizi Yazın'**
  String get redsebebiyaz;

  /// No description provided for @iletisim.
  ///
  /// In tr, this message translates to:
  /// **'İletişim'**
  String get iletisim;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'fr',
        'it',
        'ru',
        'tr'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
