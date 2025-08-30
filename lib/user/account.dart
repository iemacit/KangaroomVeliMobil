import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../theme.dart';
import '../home/homescreen.dart';
import '../menu/Ayarlar.dart';
import 'login.dart';
import '../model/UserManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRegistrationScreen2 extends StatefulWidget {
  @override
  _UserRegistrationScreen2State createState() =>
      _UserRegistrationScreen2State();
}

class _UserRegistrationScreen2State extends State<UserRegistrationScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _passwordController;
  late TextEditingController _fullNameController;
  late TextEditingController _fullSurNameController;
  late TextEditingController _phoneController;
  late String ad = '';
  late String soyad = '';
  late String sifre = '';
  late String telefon = '';
  late String formattedDateTime;
  Map<String, dynamic> newUser = {}; // Initialize empty map
  late Map<String, dynamic> _users = {};
  late int Id;
  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _fullNameController = TextEditingController();
    _fullSurNameController = TextEditingController();
    _phoneController = TextEditingController();
    formattedDateTime =
        "${DateTime.now().year}-${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month}-${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day}";
    _loadUserData();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _fullNameController.dispose();
    _fullSurNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  //dosya oluşturma
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/login.json');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sifre = prefs.getString('sifre') ?? "";
    String username = prefs.getString('username') ?? "";
    var url = Uri.parse(
        'http://37.148.210.227:8001/api/KangaroomOgrenci/VeliGiris/$username/$sifre');

    try {
      var response = await http.get(url);
      List<dynamic> userList = json.decode(response.body);
      if (userList.isNotEmpty) {
        setState(() {
          _users = userList[0];
          Id = _users["id"];
          ad = _users["ad"];
          soyad = _users["soyad"];
        });
        // UserManager'a da ata (isteğe bağlı)
        UserManager().users = _users;
        print("_loadUserData() çalışıyor...$_users");
        print("id---->$Id");
      } else {
        print("Kullanıcı verisi bulunamadı.");
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<File> _updateLoginJson(Map<String, dynamic> newUser) async {
    final file = await _localFile;
    try {
      // Yeni kullanıcı bilgilerini login.json dosyasına kaydet
      print("yazma işlemi başladı*****************************************");
      await file.writeAsString(json.encode(newUser));
      // Başarılı güncelleme bildirimi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kullanıcı bilgileri başarıyla güncellendi!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigator ile ekranı değiştir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print(e);
      // Hata durumunda bildirim
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kullanıcı bilgileri güncellenirken bir hata oluştu!'),
          backgroundColor: Colors.red,
        ),
      );
    }
    // Dosyayı döndür
    return file;
  }

  Future<File> _updateLoginJson2(Map<String, dynamic> newUser) async {
    final file = await _localFile;
    try {
      // Yeni kullanıcı bilgilerini login.json dosyasına kaydet
      print("yazma işlemi başladı*****************************************");
      await file.writeAsString(json.encode(newUser));
      // Navigator ile ekranı değiştir
    } catch (e) {
      print(e);
      // Hata durumunda bildirim
    }
    // Dosyayı döndür
    return file;
  }

  Future<void> updateData() async {
    try {
      print("updateData $Id");
      final response = await http.put(
        Uri.parse('http://37.148.210.227:8001/api/KangaroomVeliLogin/$Id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "id": Id,
          "ad": ad,
          "soyad": soyad,
          "telefon": telefon,
          "sifre": sifre,
          "okulId": _users["okulId"],
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        print("updateData() veriler başarıyla güncellendi");
        // SharedPreferences'taki username ve sifre'yi temizle
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        // UserManager'dan da çıkış yap
        UserManager().clear();
      } else {
        throw Exception('veriler güncellenemedi...');
      }
    } catch (e) {
      print('Error updating data: $e');
      // Hata durumunda yapılacak işlemleri buraya ekleyebilirsiniz
    }
  }

  Future<void> deleteData() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hesabınız Siliniyor...'),
          backgroundColor: Colors.deepOrange,
        ),
      );
      final response = await http.delete(
        Uri.parse('http://37.148.210.227:8001/api/KangaroomVeliLogin/$Id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode != 204) {
        throw Exception('Hesabınız silinirken bir hata oluştu');
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hesabınız başarıyla silindi'),
            backgroundColor: Colors.green,
          ),
        );
        print("veri güncellendi...");
      }
    } catch (e) {
      print('veriler silinirken bir hata oluştu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hesabınız silinirken hata oluştu...'),
          backgroundColor: Colors.red,
        ),
      );
      // Hata durumunda yapılacak işlemleri buraya ekleyebilirsiniz
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          var users = UserManager().ogrenciBilgileri;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Ayarlar(
                      okulId: users != null && users.okulId != null
                          ? users.okulId as int
                          : -1,
                    )),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor500, // Arka plan rengi beyaz
            elevation: 0, // Gerekirse gölgeyi kaldır
            centerTitle: true, // Başlığı ortala
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30), // Oval şekil
              ),
            ),
            title: Text(
              'Hesap İşlemleri',
              style: TextStyle(color: Colors.white), // Başlık rengi beyaz
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AnaSayfa()),
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 250, // Fotoğrafın yüksekliği
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icon/wal.png'),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Telefon:'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen Telefon Numaranızı Girin.';
                        }
                        if (value.length != 10) {
                          return 'Telefon Numaranız 10 haneli olmalıdır.';
                        }
                        telefon = value;
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Şifre'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen şifrenizi girin.';
                        }
                        sifre = value;
                        return null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> newUser = {
                            // "avatar": _users["avatar"],
                            "id": Id,
                            "ad": ad,
                            "soyad": soyad,
                            "telefon": telefon,
                            "sifre": sifre,
                            "okulid": _users["okulid"],
                          };
                          _updateLoginJson(newUser);
                          updateData();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            primaryColor500, // Butonun arkaplan rengi
                      ),
                      icon: Icon(Icons.check,
                          color: Colors.white), // Güncelleme iconu
                      label: Text(
                        'Güncelle',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> newUser = {
                            // "avatar": "",
                            "id": Id,
                            "ad": "",
                            "soyad": "",
                            "telefon": "",
                            "sifre": "",
                            "okulid": -1,
                          };
                          _updateLoginJson2(newUser);
                          deleteData();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.redAccent, // Butonun arkaplan rengi
                      ),
                      icon: Icon(Icons.delete,
                          color: Colors.white), // Hesabı Sil iconu
                      label: Text(
                        'Hesabımı Sil',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
