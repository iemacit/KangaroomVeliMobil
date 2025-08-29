import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kangaroom/main.dart';
import 'package:kangaroom/user/SifreUnuttumScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme.dart';
import '../home/homescreen.dart';
import '../model/login.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // late Map<String, dynamic> _users = {};
  late String _username;
  late String _password;
  List<dynamic> _users = [];

  // late String formattedDateTime;
  // List<Login> newuser = [];

  // List<int> sorulacak = [];
  // List<int> sorulmayacak = [];
  // List<int> adimsayisi = [];

  @override
  void initState() {
    super.initState();
    // _loadUserData();
    // fetchData();
    // formattedDateTime =
    //     "${DateTime.now().year}-${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month}-${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day}";
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Bekleme ekranını gösteren fonksiyon
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog ekrandan tıklamayla kapanmaz
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Giriş yapılıyor...'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _login() async {
    if (_username.isEmpty || _password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen kullanıcı adı ve şifreyi doldurun')),
      );
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = await prefs.getString('deviceToken');
    // Bekleme ekranını gösteriyoruz
    _showLoadingDialog();

    // API'ya POST isteği gönderiyoruz
    var url = Uri.parse(
        'http://37.148.210.227:8001/api/KangaroomOgrenci/VeliGiris/$_username/$_password');

    try {
      var response = await http.get(url);

      // Bekleme ekranını kapatıyoruz
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        setState(() {
          _users = json.decode(response.body);
        });
        await prefs.setInt('login', 1);
        await prefs.setString('username', _users[0]['telefon']);
        await prefs.setString('sifre', _users[0]['sifre']);
        await prefs.setInt('veliId', _users[0]['id']);

        print("login yapıldı ");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AnaSayfa()),
        );
      } else if (response.statusCode == 404) {
        // Giriş hatalı
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kullanıcı adı veya şifre yanlış')),
        );
      } else {
        // Diğer durumlar için
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bir hata oluştu, tekrar deneyin')),
        );
      }
    } catch (e) {
      print("Error: $e");
      // Bekleme ekranını kapatıyoruz
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sunucuya bağlanırken bir hata oluştu')),
      );
    }
  }

  // Future<void> fetchData() async {
  //   try {
  //     final LoginResponse = await http.get(Uri.parse(
  //         'http://37.148.210.227:8001/api/KangaroomVeliLogin'));

  //     if (LoginResponse.statusCode == 200) {
  //       setState(() {
  //         newuser = (jsonDecode(LoginResponse.body) as List)
  //             .map((e) => Login.fromJson(e))
  //             .toList();
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Bağlantı Kuruldu...'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     print('Error fetching data: $e');

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //             'Sunucuyla iletişim kurarken bir hata oluştu...\nLütfen internet bağlantınızı kontrol ediniz.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  // Future<File> _updateLoginJson(Map<String, dynamic> newUser) async {
  //   final file = await _localFile;

  //   try {
  //     // Yeni kullanıcı bilgilerini login.json dosyasına kaydet
  //     await file.writeAsString(json.encode(newUser));

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Kullanıcı bilgileri başarıyla doğrulandı!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );

  //     // Ana sayfaya yönlendirme
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => AnaSayfa()),
  //     );
  //   } catch (e) {
  //     print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Kullanıcı bilgileri doğrulanırken bir hata oluştu!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }

  //   return file;
  // }

  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/login.json');
  // }

  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return directory.path;
  // }

  // Future<void> _loadUserData() async {
  //   try {
  //     final file = await _localFile;
  //     final contents = await file.readAsString();
  //     setState(() {
  //       _users = jsonDecode(contents);
  //     });
  //   } catch (e) {
  //     print("Error loading user data: $e");
  //   }
  // }

  // void _authenticateUser() async {
  //   List<Login> login = newuser
  //       .where((loginn) =>
  //           loginn.Telefon.compareTo(_username) == 0 &&
  //           loginn.Sifre.compareTo(_password) == 0)
  //       .toList();

  //   if (_username == null || _username.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Lütfen telefon numaranızı girin:('),
  //         backgroundColor: Colors.orange,
  //       ),
  //     );
  //   } else if (_username.length != 10) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Lütfen telefon numaranızı 10 hane girin:('),
  //         backgroundColor: Colors.orange,
  //       ),
  //     );
  //   } else if (_password == null || _password.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Lütfen şifrenizi girin:('),
  //         backgroundColor: Colors.orange,
  //       ),
  //     );
  //   } else if (login.isNotEmpty) {
  //     Map<String, dynamic> newUser = {
  //       "id": login[0].Id,
  //       "ad": login[0].Ad,
  //       "soyad": login[0].Soyad,
  //       "telefon": login[0].Telefon,
  //       "sifre": login[0].Sifre,
  //       "okulid": login[0].OkulId,
  //       "login": 1,
  //     };

  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setInt('login', 1);
  //     _updateLoginJson(newUser);
  //   } else if (login.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Kullanıcı Bulunamadı:('),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Kullanıcı bilgileri doğrulanamadı:('),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor500,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text(
          'Giriş Yap',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icon/wal.png'),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'Telefon:'),
              onChanged: (value) {
                _username = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Şifre:'),
              onChanged: (value) {
                _password = value;
              },
              obscureText: true,
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Şifremi unuttum ekranına yönlendirme
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SifreUnuttumScreen()),
                  );
                },
                child: Text(
                  'Şifremi Unuttum',
                  style: TextStyle(color: primaryColor500),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // _authenticateUser();
                    _login();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor500,
                  ),
                  icon: Icon(Icons.done_outline, color: Colors.white),
                  label: Text(
                    'Giriş Yap',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
