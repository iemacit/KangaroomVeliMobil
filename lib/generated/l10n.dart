// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings`
  String get ayarlar {
    return Intl.message(
      'Settings',
      name: 'ayarlar',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get hesap {
    return Intl.message(
      'Account',
      name: 'hesap',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get diger {
    return Intl.message(
      'Other',
      name: 'diger',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get dil {
    return Intl.message(
      'Language',
      name: 'dil',
      desc: '',
      args: [],
    );
  }

  /// `theme`
  String get tema {
    return Intl.message(
      'theme',
      name: 'tema',
      desc: '',
      args: [],
    );
  }

  /// `Select Theme`
  String get temaSecimi {
    return Intl.message(
      'Select Theme',
      name: 'temaSecimi',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get dilSecimi {
    return Intl.message(
      'Select Language',
      name: 'dilSecimi',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get cikis {
    return Intl.message(
      'Logout',
      name: 'cikis',
      desc: '',
      args: [],
    );
  }

  /// `Error updating user information.`
  String get guncellemeHatasi {
    return Intl.message(
      'Error updating user information.',
      name: 'guncellemeHatasi',
      desc: '',
      args: [],
    );
  }

  /// `Health`
  String get saglik {
    return Intl.message(
      'Health',
      name: 'saglik',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get anaSayfa {
    return Intl.message(
      'Home',
      name: 'anaSayfa',
      desc: '',
      args: [],
    );
  }

  /// `Corporate`
  String get kurumsal {
    return Intl.message(
      'Corporate',
      name: 'kurumsal',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get hakkimizda {
    return Intl.message(
      'About Us',
      name: 'hakkimizda',
      desc: '',
      args: [],
    );
  }

  /// `Social Media`
  String get sosyalMedya {
    return Intl.message(
      'Social Media',
      name: 'sosyalMedya',
      desc: '',
      args: [],
    );
  }

  /// `Education Staff`
  String get egitimKadrosu {
    return Intl.message(
      'Education Staff',
      name: 'egitimKadrosu',
      desc: '',
      args: [],
    );
  }

  /// `Feedback and Suggestions`
  String get gorusVeOneri {
    return Intl.message(
      'Feedback and Suggestions',
      name: 'gorusVeOneri',
      desc: '',
      args: [],
    );
  }

  /// `Status Information`
  String get durumBilgisi {
    return Intl.message(
      'Status Information',
      name: 'durumBilgisi',
      desc: '',
      args: [],
    );
  }

  /// `Sad`
  String get mutsuz {
    return Intl.message(
      'Sad',
      name: 'mutsuz',
      desc: '',
      args: [],
    );
  }

  /// `Rested`
  String get dinlendi {
    return Intl.message(
      'Rested',
      name: 'dinlendi',
      desc: '',
      args: [],
    );
  }

  /// `Did a big toilet`
  String get buyukTuvalet {
    return Intl.message(
      'Did a big toilet',
      name: 'buyukTuvalet',
      desc: '',
      args: [],
    );
  }

  /// `Took the medicine`
  String get ilacAldi {
    return Intl.message(
      'Took the medicine',
      name: 'ilacAldi',
      desc: '',
      args: [],
    );
  }

  /// `Morning`
  String get sabah {
    return Intl.message(
      'Morning',
      name: 'sabah',
      desc: '',
      args: [],
    );
  }

  /// `Noon`
  String get ogle {
    return Intl.message(
      'Noon',
      name: 'ogle',
      desc: '',
      args: [],
    );
  }

  /// `Afternoon`
  String get ikindi {
    return Intl.message(
      'Afternoon',
      name: 'ikindi',
      desc: '',
      args: [],
    );
  }

  /// `No Attendance Information Entered.`
  String get yoklamabilgisigirilmedi {
    return Intl.message(
      'No Attendance Information Entered.',
      name: 'yoklamabilgisigirilmedi',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profil {
    return Intl.message(
      'Profile',
      name: 'profil',
      desc: '',
      args: [],
    );
  }

  /// `Bell`
  String get zil {
    return Intl.message(
      'Bell',
      name: 'zil',
      desc: '',
      args: [],
    );
  }

  /// `Dues`
  String get aidat {
    return Intl.message(
      'Dues',
      name: 'aidat',
      desc: '',
      args: [],
    );
  }

  /// `Appointments`
  String get randevular {
    return Intl.message(
      'Appointments',
      name: 'randevular',
      desc: '',
      args: [],
    );
  }

  /// `Report Card`
  String get karne {
    return Intl.message(
      'Report Card',
      name: 'karne',
      desc: '',
      args: [],
    );
  }

  /// `Attendance`
  String get yoklama {
    return Intl.message(
      'Attendance',
      name: 'yoklama',
      desc: '',
      args: [],
    );
  }

  /// `Height/Weight`
  String get boyKilo {
    return Intl.message(
      'Height/Weight',
      name: 'boyKilo',
      desc: '',
      args: [],
    );
  }

  /// `Announcements`
  String get duyurular {
    return Intl.message(
      'Announcements',
      name: 'duyurular',
      desc: '',
      args: [],
    );
  }

  /// `Newsletter`
  String get bulten {
    return Intl.message(
      'Newsletter',
      name: 'bulten',
      desc: '',
      args: [],
    );
  }

  /// `Our Social Media Accounts`
  String get sosyalMedyaHesaplarimiz {
    return Intl.message(
      'Our Social Media Accounts',
      name: 'sosyalMedyaHesaplarimiz',
      desc: '',
      args: [],
    );
  }

  /// `Mission`
  String get misyon {
    return Intl.message(
      'Mission',
      name: 'misyon',
      desc: '',
      args: [],
    );
  }

  /// `Vision`
  String get vizyon {
    return Intl.message(
      'Vision',
      name: 'vizyon',
      desc: '',
      args: [],
    );
  }

  /// `Activity`
  String get etkinlik {
    return Intl.message(
      'Activity',
      name: 'etkinlik',
      desc: '',
      args: [],
    );
  }

  /// `Class Schedule`
  String get dersProgrami {
    return Intl.message(
      'Class Schedule',
      name: 'dersProgrami',
      desc: '',
      args: [],
    );
  }

  /// `Meal Plan`
  String get yemekProgrami {
    return Intl.message(
      'Meal Plan',
      name: 'yemekProgrami',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Class Hours`
  String get haftalikDersSaati {
    return Intl.message(
      'Weekly Class Hours',
      name: 'haftalikDersSaati',
      desc: '',
      args: [],
    );
  }

  /// `Account Transactions`
  String get hesapIslemleri {
    return Intl.message(
      'Account Transactions',
      name: 'hesapIslemleri',
      desc: '',
      args: [],
    );
  }

  /// `About the Application`
  String get uygulamaHakkinda {
    return Intl.message(
      'About the Application',
      name: 'uygulamaHakkinda',
      desc: '',
      args: [],
    );
  }

  /// `Kangaroom Nursery Management App`
  String get kangaroomUygulama {
    return Intl.message(
      'Kangaroom Nursery Management App',
      name: 'kangaroomUygulama',
      desc: '',
      args: [],
    );
  }

  /// `Missoft Digital Transformation`
  String get missoft {
    return Intl.message(
      'Missoft Digital Transformation',
      name: 'missoft',
      desc: '',
      args: [],
    );
  }

  /// `Student Profile`
  String get ogrenciProfili {
    return Intl.message(
      'Student Profile',
      name: 'ogrenciProfili',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get yas {
    return Intl.message(
      'Age',
      name: 'yas',
      desc: '',
      args: [],
    );
  }

  /// `Class`
  String get sinif {
    return Intl.message(
      'Class',
      name: 'sinif',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get ogretmen {
    return Intl.message(
      'Teacher',
      name: 'ogretmen',
      desc: '',
      args: [],
    );
  }

  /// `Profile Picture`
  String get profilResmi {
    return Intl.message(
      'Profile Picture',
      name: 'profilResmi',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get goruntule {
    return Intl.message(
      'View',
      name: 'goruntule',
      desc: '',
      args: [],
    );
  }

  /// `Select from Gallery`
  String get galeridenSec {
    return Intl.message(
      'Select from Gallery',
      name: 'galeridenSec',
      desc: '',
      args: [],
    );
  }

  /// `Take a Photo with Camera`
  String get kameraIleCek {
    return Intl.message(
      'Take a Photo with Camera',
      name: 'kameraIleCek',
      desc: '',
      args: [],
    );
  }

  /// `Please use the buttons above to inform the teacher... 😊`
  String get lutfenOgretmeniBilgilendir {
    return Intl.message(
      'Please use the buttons above to inform the teacher... 😊',
      name: 'lutfenOgretmeniBilgilendir',
      desc: '',
      args: [],
    );
  }

  /// `Someone Else Will Pick Up My Child`
  String get cocugumuBaskaBiriAlacak {
    return Intl.message(
      'Someone Else Will Pick Up My Child',
      name: 'cocugumuBaskaBiriAlacak',
      desc: '',
      args: [],
    );
  }

  /// `I Will Pick Up`
  String get benAlacagim {
    return Intl.message(
      'I Will Pick Up',
      name: 'benAlacagim',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get iptal {
    return Intl.message(
      'Cancel',
      name: 'iptal',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get tamam {
    return Intl.message(
      'Confirm',
      name: 'tamam',
      desc: '',
      args: [],
    );
  }

  /// `Who Will Pick Up?`
  String get kimAlacak {
    return Intl.message(
      'Who Will Pick Up?',
      name: 'kimAlacak',
      desc: '',
      args: [],
    );
  }

  /// `Enter the name of the person picking up`
  String get kiminAlacaginiGiriniz {
    return Intl.message(
      'Enter the name of the person picking up',
      name: 'kiminAlacaginiGiriniz',
      desc: '',
      args: [],
    );
  }

  /// `When Will You Pick Up?`
  String get nezamanAlacaksiniz {
    return Intl.message(
      'When Will You Pick Up?',
      name: 'nezamanAlacaksiniz',
      desc: '',
      args: [],
    );
  }

  /// `I’m at the Door`
  String get kapidayim {
    return Intl.message(
      'I’m at the Door',
      name: 'kapidayim',
      desc: '',
      args: [],
    );
  }

  /// `5 minutes`
  String get dk5 {
    return Intl.message(
      '5 minutes',
      name: 'dk5',
      desc: '',
      args: [],
    );
  }

  /// `10 minutes`
  String get dk10 {
    return Intl.message(
      '10 minutes',
      name: 'dk10',
      desc: '',
      args: [],
    );
  }

  /// `15 minutes`
  String get dk15 {
    return Intl.message(
      '15 minutes',
      name: 'dk15',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get odeme {
    return Intl.message(
      'Payment',
      name: 'odeme',
      desc: '',
      args: [],
    );
  }

  /// `Loading Data...`
  String get verilerYukleniyor {
    return Intl.message(
      'Loading Data...',
      name: 'verilerYukleniyor',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get toplamTutar {
    return Intl.message(
      'Total Amount',
      name: 'toplamTutar',
      desc: '',
      args: [],
    );
  }

  /// `Payment Date`
  String get odemeTarihi {
    return Intl.message(
      'Payment Date',
      name: 'odemeTarihi',
      desc: '',
      args: [],
    );
  }

  /// `Not Paid`
  String get odenmemis {
    return Intl.message(
      'Not Paid',
      name: 'odenmemis',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get yil {
    return Intl.message(
      'Year',
      name: 'yil',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get ay {
    return Intl.message(
      'Month',
      name: 'ay',
      desc: '',
      args: [],
    );
  }

  /// `Stationery`
  String get kirtasiye {
    return Intl.message(
      'Stationery',
      name: 'kirtasiye',
      desc: '',
      args: [],
    );
  }

  /// `Explanation`
  String get aciklama {
    return Intl.message(
      'Explanation',
      name: 'aciklama',
      desc: '',
      args: [],
    );
  }

  /// `January`
  String get january {
    return Intl.message(
      'January',
      name: 'january',
      desc: '',
      args: [],
    );
  }

  /// `February`
  String get february {
    return Intl.message(
      'February',
      name: 'february',
      desc: '',
      args: [],
    );
  }

  /// `March`
  String get march {
    return Intl.message(
      'March',
      name: 'march',
      desc: '',
      args: [],
    );
  }

  /// `April`
  String get april {
    return Intl.message(
      'April',
      name: 'april',
      desc: '',
      args: [],
    );
  }

  /// `May`
  String get may {
    return Intl.message(
      'May',
      name: 'may',
      desc: '',
      args: [],
    );
  }

  /// `June`
  String get june {
    return Intl.message(
      'June',
      name: 'june',
      desc: '',
      args: [],
    );
  }

  /// `July`
  String get july {
    return Intl.message(
      'July',
      name: 'july',
      desc: '',
      args: [],
    );
  }

  /// `August`
  String get august {
    return Intl.message(
      'August',
      name: 'august',
      desc: '',
      args: [],
    );
  }

  /// `September`
  String get september {
    return Intl.message(
      'September',
      name: 'september',
      desc: '',
      args: [],
    );
  }

  /// `October`
  String get october {
    return Intl.message(
      'October',
      name: 'october',
      desc: '',
      args: [],
    );
  }

  /// `November`
  String get november {
    return Intl.message(
      'November',
      name: 'november',
      desc: '',
      args: [],
    );
  }

  /// `December`
  String get december {
    return Intl.message(
      'December',
      name: 'december',
      desc: '',
      args: [],
    );
  }

  /// `No appointments assigned to you`
  String get sizeTanimliRandevuBulunmamaktadir {
    return Intl.message(
      'No appointments assigned to you',
      name: 'sizeTanimliRandevuBulunmamaktadir',
      desc: '',
      args: [],
    );
  }

  /// `Teacher Name`
  String get ogretmenAd {
    return Intl.message(
      'Teacher Name',
      name: 'ogretmenAd',
      desc: '',
      args: [],
    );
  }

  /// `Student Name`
  String get ogrenciAd {
    return Intl.message(
      'Student Name',
      name: 'ogrenciAd',
      desc: '',
      args: [],
    );
  }

  /// `Approve`
  String get onayla {
    return Intl.message(
      'Approve',
      name: 'onayla',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get redEt {
    return Intl.message(
      'Reject',
      name: 'redEt',
      desc: '',
      args: [],
    );
  }

  /// `Delete Operation`
  String get silmeIslemi {
    return Intl.message(
      'Delete Operation',
      name: 'silmeIslemi',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this appointment?`
  String get eminMisiniz {
    return Intl.message(
      'Are you sure you want to delete this appointment?',
      name: 'eminMisiniz',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get evet {
    return Intl.message(
      'Yes',
      name: 'evet',
      desc: '',
      args: [],
    );
  }

  /// `Appointment successfully deleted.`
  String get randevuSilindi {
    return Intl.message(
      'Appointment successfully deleted.',
      name: 'randevuSilindi',
      desc: '',
      args: [],
    );
  }

  /// `No Report Card Information Available !!!`
  String get karneBilgisiYok {
    return Intl.message(
      'No Report Card Information Available !!!',
      name: 'karneBilgisiYok',
      desc: '',
      args: [],
    );
  }

  /// `Select Term`
  String get donemSecin {
    return Intl.message(
      'Select Term',
      name: 'donemSecin',
      desc: '',
      args: [],
    );
  }

  /// `Term`
  String get donem {
    return Intl.message(
      'Term',
      name: 'donem',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get tur {
    return Intl.message(
      'Type',
      name: 'tur',
      desc: '',
      args: [],
    );
  }

  /// `Development Area`
  String get gelisimAlani {
    return Intl.message(
      'Development Area',
      name: 'gelisimAlani',
      desc: '',
      args: [],
    );
  }

  /// `Attendance`
  String get devamsizlik {
    return Intl.message(
      'Attendance',
      name: 'devamsizlik',
      desc: '',
      args: [],
    );
  }

  /// `Present`
  String get devam {
    return Intl.message(
      'Present',
      name: 'devam',
      desc: '',
      args: [],
    );
  }

  /// `Absent`
  String get devamsiz {
    return Intl.message(
      'Absent',
      name: 'devamsiz',
      desc: '',
      args: [],
    );
  }

  /// `2 Weeks`
  String get ikiHafta {
    return Intl.message(
      '2 Weeks',
      name: 'ikiHafta',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get hafta {
    return Intl.message(
      'Week',
      name: 'hafta',
      desc: '',
      args: [],
    );
  }

  /// `Data fetching error`
  String get veriGetirmeHatasi {
    return Intl.message(
      'Data fetching error',
      name: 'veriGetirmeHatasi',
      desc: '',
      args: [],
    );
  }

  /// `No data found for this student.`
  String get veriBulunamadi {
    return Intl.message(
      'No data found for this student.',
      name: 'veriBulunamadi',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get kilo {
    return Intl.message(
      'Weight',
      name: 'kilo',
      desc: '',
      args: [],
    );
  }

  /// `Height`
  String get boy {
    return Intl.message(
      'Height',
      name: 'boy',
      desc: '',
      args: [],
    );
  }

  /// `Table`
  String get tablo {
    return Intl.message(
      'Table',
      name: 'tablo',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get tarih {
    return Intl.message(
      'Date',
      name: 'tarih',
      desc: '',
      args: [],
    );
  }

  /// `Height`
  String get boyCm {
    return Intl.message(
      'Height',
      name: 'boyCm',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get kiloKg {
    return Intl.message(
      'Weight',
      name: 'kiloKg',
      desc: '',
      args: [],
    );
  }

  /// `Loading Announcements...`
  String get duyurularYukleniyor {
    return Intl.message(
      'Loading Announcements...',
      name: 'duyurularYukleniyor',
      desc: '',
      args: [],
    );
  }

  /// `Announcements`
  String get duyurularBaslik {
    return Intl.message(
      'Announcements',
      name: 'duyurularBaslik',
      desc: '',
      args: [],
    );
  }

  /// `Loading Announcements...`
  String get duyuruYukleniyor {
    return Intl.message(
      'Loading Announcements...',
      name: 'duyuruYukleniyor',
      desc: '',
      args: [],
    );
  }

  /// `Announcement`
  String get duyuru {
    return Intl.message(
      'Announcement',
      name: 'duyuru',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get aylik {
    return Intl.message(
      'Monthly',
      name: 'aylik',
      desc: '',
      args: [],
    );
  }

  /// `Health Information`
  String get saglikBilgileri {
    return Intl.message(
      'Health Information',
      name: 'saglikBilgileri',
      desc: '',
      args: [],
    );
  }

  /// `Update Health Information`
  String get saglikBilgisiGuncelleme {
    return Intl.message(
      'Update Health Information',
      name: 'saglikBilgisiGuncelleme',
      desc: '',
      args: [],
    );
  }

  /// `Medication Information`
  String get ilacBilgisi {
    return Intl.message(
      'Medication Information',
      name: 'ilacBilgisi',
      desc: '',
      args: [],
    );
  }

  /// `Medication Time`
  String get ilacSaati {
    return Intl.message(
      'Medication Time',
      name: 'ilacSaati',
      desc: '',
      args: [],
    );
  }

  /// `Chronic Disease Status`
  String get kronikHastalikDurumu {
    return Intl.message(
      'Chronic Disease Status',
      name: 'kronikHastalikDurumu',
      desc: '',
      args: [],
    );
  }

  /// `Allergy Status`
  String get alerjiDurumu {
    return Intl.message(
      'Allergy Status',
      name: 'alerjiDurumu',
      desc: '',
      args: [],
    );
  }

  /// `Update Information`
  String get bilgileriGuncelle {
    return Intl.message(
      'Update Information',
      name: 'bilgileriGuncelle',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get basarili {
    return Intl.message(
      'Success',
      name: 'basarili',
      desc: '',
      args: [],
    );
  }

  /// `Information updated successfully.`
  String get bilgilerGuncellendi {
    return Intl.message(
      'Information updated successfully.',
      name: 'bilgilerGuncellendi',
      desc: '',
      args: [],
    );
  }

  /// `Activity Page`
  String get etkinlikSayfasi {
    return Intl.message(
      'Activity Page',
      name: 'etkinlikSayfasi',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get saat {
    return Intl.message(
      'Time',
      name: 'saat',
      desc: '',
      args: [],
    );
  }

  /// `Fee`
  String get ucret {
    return Intl.message(
      'Fee',
      name: 'ucret',
      desc: '',
      args: [],
    );
  }

  /// `IBAN`
  String get iban {
    return Intl.message(
      'IBAN',
      name: 'iban',
      desc: '',
      args: [],
    );
  }

  /// `Not specified`
  String get belirtilmedi {
    return Intl.message(
      'Not specified',
      name: 'belirtilmedi',
      desc: '',
      args: [],
    );
  }

  /// `Upload Receipt (PDF)`
  String get dekontYukle {
    return Intl.message(
      'Upload Receipt (PDF)',
      name: 'dekontYukle',
      desc: '',
      args: [],
    );
  }

  /// `Uploaded Receipt: {fileName}`
  String yuklenenDekont(Object fileName) {
    return Intl.message(
      'Uploaded Receipt: $fileName',
      name: 'yuklenenDekont',
      desc: '',
      args: [fileName],
    );
  }

  /// `Reject`
  String get reddet {
    return Intl.message(
      'Reject',
      name: 'reddet',
      desc: '',
      args: [],
    );
  }

  /// `Registration completed`
  String get kayitYapildi {
    return Intl.message(
      'Registration completed',
      name: 'kayitYapildi',
      desc: '',
      args: [],
    );
  }

  /// `Participation rejected`
  String get katilimReddedildi {
    return Intl.message(
      'Participation rejected',
      name: 'katilimReddedildi',
      desc: '',
      args: [],
    );
  }

  /// `Receipt uploaded: {fileName}`
  String dekontYuklendi(Object fileName) {
    return Intl.message(
      'Receipt uploaded: $fileName',
      name: 'dekontYuklendi',
      desc: '',
      args: [fileName],
    );
  }

  /// `Activity Main Page`
  String get etkinlikAnaSayfasi {
    return Intl.message(
      'Activity Main Page',
      name: 'etkinlikAnaSayfasi',
      desc: '',
      args: [],
    );
  }

  /// `Activity Name`
  String get etkinlikAdi {
    return Intl.message(
      'Activity Name',
      name: 'etkinlikAdi',
      desc: '',
      args: [],
    );
  }

  /// `Activity Date`
  String get etkinlikTarihi {
    return Intl.message(
      'Activity Date',
      name: 'etkinlikTarihi',
      desc: '',
      args: [],
    );
  }

  /// `Activity Approval Status`
  String get onaylanmaDurumu {
    return Intl.message(
      'Activity Approval Status',
      name: 'onaylanmaDurumu',
      desc: '',
      args: [],
    );
  }

  /// `Recipient Account`
  String get aliciHesap {
    return Intl.message(
      'Recipient Account',
      name: 'aliciHesap',
      desc: '',
      args: [],
    );
  }

  /// `File Name`
  String get dosyaAdi {
    return Intl.message(
      'File Name',
      name: 'dosyaAdi',
      desc: '',
      args: [],
    );
  }

  /// `Download PDF`
  String get indir {
    return Intl.message(
      'Download PDF',
      name: 'indir',
      desc: '',
      args: [],
    );
  }

  /// `Data could not be loaded`
  String get veriYuklenemedi {
    return Intl.message(
      'Data could not be loaded',
      name: 'veriYuklenemedi',
      desc: '',
      args: [],
    );
  }

  /// `No closest class found.`
  String get enYakinDersBulunamadi {
    return Intl.message(
      'No closest class found.',
      name: 'enYakinDersBulunamadi',
      desc: '',
      args: [],
    );
  }

  /// `No date`
  String get tarihYok {
    return Intl.message(
      'No date',
      name: 'tarihYok',
      desc: '',
      args: [],
    );
  }

  /// `No time`
  String get saatYok {
    return Intl.message(
      'No time',
      name: 'saatYok',
      desc: '',
      args: [],
    );
  }

  /// `normal`
  String get normal {
    return Intl.message(
      'normal',
      name: 'normal',
      desc: '',
      args: [],
    );
  }

  /// `Happy`
  String get mutlu {
    return Intl.message(
      'Happy',
      name: 'mutlu',
      desc: '',
      args: [],
    );
  }

  /// `Sad`
  String get uzgun {
    return Intl.message(
      'Sad',
      name: 'uzgun',
      desc: '',
      args: [],
    );
  }

  /// `Angry`
  String get ofkeli {
    return Intl.message(
      'Angry',
      name: 'ofkeli',
      desc: '',
      args: [],
    );
  }

  /// `Did a big toilet on his self`
  String get buyukTuvaletaltinayati {
    return Intl.message(
      'Did a big toilet on his self',
      name: 'buyukTuvaletaltinayati',
      desc: '',
      args: [],
    );
  }

  /// `Did a small toilet on his self`
  String get kucukTuvaletaltinayati {
    return Intl.message(
      'Did a small toilet on his self',
      name: 'kucukTuvaletaltinayati',
      desc: '',
      args: [],
    );
  }

  /// `Did a small toilet`
  String get kucukTuvalet {
    return Intl.message(
      'Did a small toilet',
      name: 'kucukTuvalet',
      desc: '',
      args: [],
    );
  }

  /// `Didn't take the medicine`
  String get ilacAlmadi {
    return Intl.message(
      'Didn\'t take the medicine',
      name: 'ilacAlmadi',
      desc: '',
      args: [],
    );
  }

  /// `Bell sent`
  String get zilgonderildi {
    return Intl.message(
      'Bell sent',
      name: 'zilgonderildi',
      desc: '',
      args: [],
    );
  }

  /// `Bell not sent`
  String get zilgonderilmedi {
    return Intl.message(
      'Bell not sent',
      name: 'zilgonderilmedi',
      desc: '',
      args: [],
    );
  }

  /// `Today is a holiday`
  String get buguntatil {
    return Intl.message(
      'Today is a holiday',
      name: 'buguntatil',
      desc: '',
      args: [],
    );
  }

  /// `Status information`
  String get durumbilgisi {
    return Intl.message(
      'Status information',
      name: 'durumbilgisi',
      desc: '',
      args: [],
    );
  }

  /// `Image not uploaded`
  String get resimyuklenmedi {
    return Intl.message(
      'Image not uploaded',
      name: 'resimyuklenmedi',
      desc: '',
      args: [],
    );
  }

  /// `Image uploaded`
  String get resimyuklendi {
    return Intl.message(
      'Image uploaded',
      name: 'resimyuklendi',
      desc: '',
      args: [],
    );
  }

  /// `I did not go to school`
  String get okulagelmdim {
    return Intl.message(
      'I did not go to school',
      name: 'okulagelmdim',
      desc: '',
      args: [],
    );
  }

  /// `Did not sleep`
  String get uyumadi {
    return Intl.message(
      'Did not sleep',
      name: 'uyumadi',
      desc: '',
      args: [],
    );
  }

  /// `Slept`
  String get uyudu {
    return Intl.message(
      'Slept',
      name: 'uyudu',
      desc: '',
      args: [],
    );
  }

  /// `no data`
  String get yok {
    return Intl.message(
      'no data',
      name: 'yok',
      desc: '',
      args: [],
    );
  }

  /// `Leason`
  String get ders {
    return Intl.message(
      'Leason',
      name: 'ders',
      desc: '',
      args: [],
    );
  }

  /// `store `
  String get puan {
    return Intl.message(
      'store ',
      name: 'puan',
      desc: '',
      args: [],
    );
  }

  /// `accepted`
  String get onaylandi {
    return Intl.message(
      'accepted',
      name: 'onaylandi',
      desc: '',
      args: [],
    );
  }

  /// `No appointment is assigned`
  String get noAppointment {
    return Intl.message(
      'No appointment is assigned',
      name: 'noAppointment',
      desc: '',
      args: [],
    );
  }

  /// `↓ The response from the institution will be forwarded below. ↓`
  String get institutionResponse {
    return Intl.message(
      '↓ The response from the institution will be forwarded below. ↓',
      name: 'institutionResponse',
      desc: '',
      args: [],
    );
  }

  /// `Response received`
  String get responseReceived {
    return Intl.message(
      'Response received',
      name: 'responseReceived',
      desc: '',
      args: [],
    );
  }

  /// `Your feedback and suggestions have been received and will be forwarded to the response area as soon as possible, thank you...`
  String get feedbackReceived {
    return Intl.message(
      'Your feedback and suggestions have been received and will be forwarded to the response area as soon as possible, thank you...',
      name: 'feedbackReceived',
      desc: '',
      args: [],
    );
  }

  /// `send`
  String get gonder {
    return Intl.message(
      'send',
      name: 'gonder',
      desc: '',
      args: [],
    );
  }

  /// `Principal`
  String get mudur {
    return Intl.message(
      'Principal',
      name: 'mudur',
      desc: '',
      args: [],
    );
  }

  /// `Vice Principal`
  String get mudurYardimcisi {
    return Intl.message(
      'Vice Principal',
      name: 'mudurYardimcisi',
      desc: '',
      args: [],
    );
  }

  /// `No Message!`
  String get noMessage {
    return Intl.message(
      'No Message!',
      name: 'noMessage',
      desc: '',
      args: [],
    );
  }

  /// `Write your message`
  String get writeMessage {
    return Intl.message(
      'Write your message',
      name: 'writeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Application`
  String get mobil {
    return Intl.message(
      'Mobile Application',
      name: 'mobil',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get reddedildi {
    return Intl.message(
      'Rejected',
      name: 'reddedildi',
      desc: '',
      args: [],
    );
  }

  /// `Lesson images`
  String get dersresimleri {
    return Intl.message(
      'Lesson images',
      name: 'dersresimleri',
      desc: '',
      args: [],
    );
  }

  /// `There is a debt for the period`
  String get borc {
    return Intl.message(
      'There is a debt for the period',
      name: 'borc',
      desc: '',
      args: [],
    );
  }

  /// `Payment Alert`
  String get aidetborc {
    return Intl.message(
      'Payment Alert',
      name: 'aidetborc',
      desc: '',
      args: [],
    );
  }

  /// `questionnaire`
  String get anket {
    return Intl.message(
      'questionnaire',
      name: 'anket',
      desc: '',
      args: [],
    );
  }

  /// `questionnaire`
  String get anketSayfasi {
    return Intl.message(
      'questionnaire',
      name: 'anketSayfasi',
      desc: '',
      args: [],
    );
  }

  /// `chatbot`
  String get chatbot {
    return Intl.message(
      'chatbot',
      name: 'chatbot',
      desc: '',
      args: [],
    );
  }

  /// `Birth Date`
  String get dogumtarihi {
    return Intl.message(
      'Birth Date',
      name: 'dogumtarihi',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get baslik {
    return Intl.message(
      'Title',
      name: 'baslik',
      desc: '',
      args: [],
    );
  }

  /// `Please write the reason for rejection`
  String get redsebebiyaz {
    return Intl.message(
      'Please write the reason for rejection',
      name: 'redsebebiyaz',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get iletisim {
    return Intl.message(
      'Contact',
      name: 'iletisim',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'tr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
