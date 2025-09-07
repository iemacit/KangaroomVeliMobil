import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

// Renk sabitleri
const Color primaryColor100 = Color(0xffbcdaff); // Açık mavi
const Color primaryColor300 = Color(0xFF28235D); // Koyu mavi
const Color primaryColor500 = Color(0xFFEE6A68); // Kırmızı (AppBar için)
const Color colorWhite = Colors.white; // Beyaz arka plan
const Color backgroundColor = Color(0xffF5F9FF); // Açık mavi arka plan
const Color lightBlue100 = Color(0xff1463ae); // Çok açık mavi
const Color lightBlue300 = Color(0xff009daf); // Açık mavi
const Color lightBlue400 = Color(0xffBFC8D2); // Açık gri mavi
const Color darkBlue300 = Color(0xff526983); // Orta koyulukta mavi
const Color darkBlue500 = Color(0xff293948); // Koyu mavi
const Color darkBlue700 = Color(0xff17212B); // Çok koyu mavi

const double borderRadiusSize = 16.0; // Kenar yuvarlaklığı boyutu

// Metin stilleri
TextStyle greetingTextStyle = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: darkBlue500); // Selamlama metin stili

TextStyle titleTextStyle = GoogleFonts.poppins(
    fontSize: 23,
    fontWeight: FontWeight.bold,
    color: Colors.white); // Başlık metin stili

TextStyle subTitleTextStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: darkBlue500); // Alt başlık metin stili

TextStyle normalTextStyle =
    GoogleFonts.poppins(color: darkBlue500 // Normal metin stili
        );

TextStyle descTextStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: darkBlue300); // Açıklama metin stili

TextStyle descTextStyle2 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: darkBlue300); // Büyük açıklama metin stili

TextStyle addressTextStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: darkBlue300); // Adres metin stili

TextStyle facilityTextStyle = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: darkBlue300); // Tesis metin stili

TextStyle priceTextStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: darkBlue500); // Fiyat metin stili

TextStyle buttonTextStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: colorWhite); // Buton metin stili

TextStyle bottomNavTextStyle = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: primaryColor500); // Alt navigasyon metin stili

TextStyle tabBarTextStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
    color: primaryColor500); // Sekme çubuğu metin stili

// Belirli bir renkten MaterialColor oluşturma fonksiyonu
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05]; // Güç seviyeleri listesi
  Map<int, Color> swatch = {}; // Renk tonları haritası
  final int r = color.red, g = color.green, b = color.blue; // Renk bileşenleri

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i); // Güç seviyelerini 0.1 artışlarla ekleme
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength; // Güç seviyesi farkı
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    ); // Her güç seviyesi için renk tonu oluşturma
  }
  return MaterialColor(
      color.value, swatch); // Oluşturulan MaterialColor'ı döndürme
}

class ThemeHelper {
  Future<File> get _localFile2 async {
    final path = await _localPath2;
    final directory = Directory(path);

    if (!directory.existsSync()) {
      // If the directory doesn't exist, create it
      directory.createSync(recursive: true);
    }

    return File('$path/tema.json');
  }

  Future<String> get _localPath2 async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  
  Future<Map<String, dynamic>> _loadUserData() async {
    try {
      final file = await _localFile2;
       if (!file.existsSync()) {
        await _copyTemaFromAssets();
      }
      final contents = await file.readAsString();
      final Map<String, dynamic> tema = jsonDecode(contents);
      print("Tema verisi yüklendi: $tema");
      // Hata durumunda varsayılan tema döndür
      return {
        "Renk1": "FFEE6A68",
        "Renk2": "FF28235D", 
        "Renk3": "FFBCDAFF"
      };
    } catch (e) {
      print("Hata: Tema verisi yüklenirken bir hata oluştu: $e");
      return {}; // Hata durumunda boş bir harita döndür
    }
  }
  Future<void> _copyTemaFromAssets() async {
    try {
      final file = await _localFile2;
      final defaultTema = '{"Renk1": "FFEE6A68","Renk2": "FF28235D","Renk3":"FF28235D"}';
      await file.writeAsString(defaultTema);
      print("Varsayılan tema dosyası oluşturuldu");
    } catch (e) {
      print("Tema dosyası oluşturulurken hata: $e");
    }
  }
  static Future<Map<String, Color>> loadColors() async {
    final helper = ThemeHelper();
    final tema = await helper._loadUserData();

    return {
      'Renk1': _colorFromHex(tema['Renk1'] ?? 'FFEE6A68'),
      'Renk2': _colorFromHex(tema['Renk2'] ?? 'FF28235D'),
      'Renk3': _colorFromHex(tema['Renk3'] ?? 'FFBCDAFF'),
    };
  }

  // Hex kodundan Color oluşturma fonksiyonu
  static Color _colorFromHex(String hexString) {
    String hex = hexString.replaceAll('#', '').replaceAll('0x', '').replaceAll('0X', '').toUpperCase();
     // Eğer FF ile başlamıyorsa FF ekle (alpha channel)
    if (!hex.startsWith('FF')) {
      hex = 'FF$hex';
    }
    final intColor = int.parse(hex, radix: 16);
    return Color(intColor);
  }
}
