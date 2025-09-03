import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kangaroom/firebase_options.dart';
import 'package:kangaroom/generated/l10n.dart';
import 'package:kangaroom/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/homescreen.dart';
import 'user/login.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  final colors = await ThemeHelper.loadColors();
  final locale = await _loadSavedLocale();
  // ✅ Tekrar tekrar initialize olmasın diye kontrol ekliyoruz
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await _requestNotificationPermissionAndToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 🔄 Token değişimini dinle ve güncelle
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceToken', newToken);
    print('🔄 Yeni deviceToken: ' + newToken);
    // VeliId varsa, yeni token'ı veritabanına gönder
    var veliId = prefs.getInt('veliId');
    if (veliId != null) {
      // _MyAppState.saveToken statik değil, bu yüzden burada doğrudan http ile gönderiyoruz
      var url = Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomOgrenci/ogrenciToken/$veliId/$newToken');
      try {
        var response = await http.get(url);
        if (response.statusCode == 200) {
          print('Yeni token veritabanına kaydedildi.');
        } else {
          print(
              'Yeni token veritabanına kaydedilemedi. Status: \'${response.statusCode}\'');
        }
      } catch (e) {
        print('Yeni token gönderim hatası: $e');
      }
    }
  });

  runApp(MyApp(colors: colors, initialLocale: locale));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
} // SSL sertifika doğrulamasını geçici olarak devre dışı bırak

// 🔄 Arka planda mesaj alma
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  print("📩 [Arka Plan] Bildirim: ${message.notification?.title}");
}

// 🔔 Bildirim izni iste ve token kaydet
Future<void> _requestNotificationPermissionAndToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Bildirim izni iste
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('✅ Bildirim izni verildi');
  } else {
    print('❌ Bildirim izni reddedildi');
    return;
  }

  // Token al ve kaydet
  String? token = await messaging.getToken();
  if (token != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceToken', token);
    print("📱 Token:$token");
  }

  // Ön planda bildirim al
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📲 [Ön Plan] Başlık: ${message.notification?.title}");
    print("📲 [Ön Plan] İçerik: ${message.notification?.body}");
  });

  // Bildirime tıklayarak açma
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🚪 [Tıklama] Bildirime tıklanarak uygulama açıldı.");
  });
}

////////////////////////
Future<void> mesage(RemoteMessage massege) async {
  print(massege.messageId);
}

Future<Locale> _loadSavedLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('language_code');
  if (languageCode != null) {
    return Locale(languageCode);
  }
  return Locale('tr'); // Varsayılan Locale
}

class MyApp extends StatefulWidget {
  final Map<String, Color> colors;
  final Locale? initialLocale;

  MyApp({required this.colors, this.initialLocale});
  //MyApp({this.initialLocale});

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
// 🔐 Firebase admin access token alma
  // Future<void> getAccessTokenOgrenci() async {
  //   try {
  //     final serviceAccountJson = await rootBundle.loadString(
  //         'assets/firebase/kangarom-cf7dc-firebase-adminsdk-ytf2m-5b939011a6.json');
  //     final accountCredentials =
  //         ServiceAccountCredentials.fromJson(json.decode(serviceAccountJson));

  //     const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  //     final client = http.Client();

  //     try {
  //       final accessCredentials =
  //           await obtainAccessCredentialsViaServiceAccount(
  //         accountCredentials,
  //         scopes,
  //         client,
  //       );

  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString(
  //           'accessTokenOgrenci', accessCredentials.accessToken.data);

  //       print(
  //           '🎫 accessTokenOgrenci: ${prefs.getString('accessTokenOgrenci')}');
  //     } catch (e) {
  //       print('❌ Access token alınamadı: $e');
  //     } finally {
  //       client.close();
  //     }
  //   } catch (e) {
  //     print('❌ Service account JSON yüklenemedi: $e');
  //   }
  // }

  bool _isLoading = true;
  Map<String, dynamic> _users = {};
  Widget _homeWidget = Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );

  Locale _locale;

  _MyAppState() : _locale = Locale('tr'); // Varsayılan dil Türkçe

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    _saveLocale(locale);
  }

  Future<void> _saveLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale ??
        Locale('tr'); // Null kontrolü ile varsayılan Locale

    _loadUserData();
    // getAccessTokenOgrenci(); gerek yok
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/login.json');
  }

  Future<void> saveToken(int ogrenciId, String token) async {
    var url = Uri.parse(
      'http://37.148.210.227:8001/api/KangaroomOgrenci/ogrenciToken/$ogrenciId/$token',
    );

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print("ogrenciId: $ogrenciId token: $token kaynitildi.");
        print(
            "///////////////////////////////Token successfully saved in main page.");
      } else {
        print("ogrenciId: $ogrenciId token:$token kaydedilmedi.");
        print(
            "//////////////////////////////////////Failed to save token. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print(
          "////////////////////////////////////Error sending token to server: $e");
    }
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var login = await prefs.getInt('login');
      var veliId = await prefs.getInt('veliId');
      var token = await prefs.getString('deviceToken');
      setState(() {
        _isLoading = false;
        _homeWidget = login == 1 ? AnaSayfa() : LoginScreen();
      });

      print("---------------veli Id  $veliId----------------main.dart");

      if (token != null && veliId != null) {
        saveToken(veliId, "$token");
      } else {
        if (token != null && veliId != null) {
          saveToken(veliId, "$token");
        }
        print("---------------token null----------------");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _homeWidget = LoginScreen();
      });
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kangaroom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: widget.colors['Renk1'],
        primaryColorDark: widget.colors['Renk2'],
        primaryColorLight: widget.colors['Renk3'],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      locale: _locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.supportedLocales,
      home: _homeWidget,
    );
  }
}
