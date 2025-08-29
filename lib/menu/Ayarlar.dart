import 'package:http/http.dart' as http;
import 'package:kangaroom/model/hakkimizda_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../theme.dart';
import '../home/homescreen.dart';
import '../user/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kangaroom/main.dart';
import 'package:kangaroom/user/account.dart';

import 'package:kangaroom/generated/l10n.dart';

class Ayarlar extends StatefulWidget {
  final int okulId;

  Ayarlar({required this.okulId});

  @override
  _AyarlarState createState() => _AyarlarState();
}

class _AyarlarState extends State<Ayarlar> {
  String Tema = "Dahili Tema";

  Map<String, dynamic> tema = {
    "Renk1": "FFEE6A68",
    "Renk2": "FF28235D",
    "Renk3": "FFBCDAFF",
    "Tema": "Dahili Tema",
  };

  Map<String, dynamic> tema2 = {
    "Renk1": "FF123456",
    "Renk2": "FF654321",
    "Renk3": "FFABCDEF",
    "Tema": "Kreş Teması",
  };

  Future<void> getOkulData() async {
    try {
      final loginResponse = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomFirma/${widget.okulId}'));

      if (loginResponse.statusCode == 200) {
        final responseData = jsonDecode(loginResponse.body);
        print("-------------------------  teme2 gğncellendi ");
        setState(() {
          final okul = HakkimizdaModel.fromJson(responseData);

          tema2 = {
            "Renk1": okul.renk1,
            "Renk2": okul.renk2,
            "Renk3": okul.renk3,
            "Tema": "Kreş Teması"
          };
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    getOkulData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).ayarlar,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              S.of(context).hesap,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserRegistrationScreen2()),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/icon/profil.png"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).hesapIslemleri,
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              S.of(context).tema,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                _showThemeDialog(context);
              },
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      CupertinoIcons.moon_circle,
                      size: 24,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).temaSecimi,
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Tema,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              S.of(context).dil,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                _showLanguageDialog(context);
              },
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.language,
                      size: 24,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).dilSecimi,
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "...................",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              S.of(context).uygulamaHakkinda,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                _showAboutDialog(context);
              },
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      CupertinoIcons.info_circle_fill,
                      size: 24,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).kangaroomUygulama,
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Version 1.0.0",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => launchUrl(Uri.parse("https://missoft.com.tr/")),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      CupertinoIcons.globe,
                      size: 24,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).missoft,
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "missoft.com.tr",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            InkWell(
              onTap: () {
                _logoutUser();
              },
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      CupertinoIcons.power,
                      size: 24,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      S.of(context).cikis,
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).temaSecimi),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Dahili Tema'),
                onTap: () {
                  setState(() {
                    //_updateTemaJson(tema);
                    Tema = tema['Tema'];
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Tema Güncellendi Lütfen Uygulamayı Yeniden Başlatın...'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Kreş Teması'),
                onTap: () {
                  setState(() {
                    //_updateTemaJson(tema2);
                    Tema = tema2['Tema'];
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Tema Güncellendi Lütfen Uygulamayı Yeniden Başlatın...'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).dilSecimi),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Türkçe'),
                onTap: () {
                  _changeLanguage(Locale('tr'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('العربية'),
                onTap: () {
                  _changeLanguage(Locale('ar'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('English'),
                onTap: () {
                  _changeLanguage(Locale('en'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Русский'),
                onTap: () {
                  _changeLanguage(Locale('ru'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Italiano'),
                onTap: () {
                  _changeLanguage(Locale('it'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Français'),
                onTap: () {
                  _changeLanguage(Locale('fr'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Deutsche'),
                onTap: () {
                  _changeLanguage(Locale('de'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kangaroom Hakkında'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('${S.of(context).kangaroomUygulama}, Version 1.0.0'),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => launchUrl(Uri.parse("https://missoft.com.tr/")),
                child: Text(
                  S.of(context).missoft,
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).tamam),
            ),
          ],
        );
      },
    );
  }

  void _changeLanguage(Locale locale) async {
    MyApp.of(context)?.setLocale(locale);
  }

  Future<File> _updateTemaJson(Map<String, dynamic> newTema) async {
    final file = await _localFile2;
    await file.writeAsString(json.encode(newTema));
    return file;
  }

  Future<File> get _localFile2 async {
    final path = await getApplicationDocumentsDirectory();
    return File('$path/tema.json');
  }

  void _logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }
}
