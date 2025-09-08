import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import '../model/UserManager.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:kangaroom/home/EtkinlikAnaSayfas%C4%B1.dart';
import 'package:kangaroom/home/anket.dart';
import 'package:kangaroom/home/bulten.dart';
import 'package:kangaroom/home/egitimkadro.dart';
import 'package:kangaroom/home/etkinlik.dart';
import 'package:kangaroom/home/karne.dart';
import 'package:kangaroom/home/randevu.dart';
import 'package:kangaroom/home/Devamsizlik.dart';
import 'package:kangaroom/menu/Hakk%C4%B1m%C4%B1zda.dart';
import 'package:kangaroom/menu/Sosyal.dart';
// import 'package:kangaroom/menu/chatbot.dart';
import 'package:kangaroom/menu/gorusoneri.dart';
import 'package:kangaroom/menu/mesajlar.dart';
import 'package:kangaroom/model/hakkimizda_model.dart';
import 'package:video_player/video_player.dart';
import '../model/ogrenci_bilgileri.dart';
import 'package:kangaroom/menu/saglik.dart';
// import 'package:path_provider/path_provider.dart';
import 'dart:convert';
// import 'dart:io';
import 'package:kangaroom/all_import.dart';
import 'package:http/http.dart' as http;
import 'package:kangaroom/model/kangarom_mesaj.dart';
import '../model/ogretmen_model.dart';
import 'HaftalikDers.dart';
import 'yemekprogramı.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kangaroom/generated/l10n.dart';

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> with WidgetsBindingObserver {
  // DateTime? _lastCacheClearDate; // Kullanılmıyor, kaldırıldı
  int ay = DateTime.now().month;
  int yil = DateTime.now().year;
  Map<String, dynamic> _users = {};
  List<HakkimizdaModel>? _items;
  OgrenciBilgileri? ogrenciBilgileri;
  double yildizsabah = 0;
  double yildizogle = 0;
  double yildizikindi = 0;
  OgretmenModel? ogretmen;
  int toilet = 0;
  int uyku = 0;
  int medicine = 0;
  int duygu = 0;
  String Not = "Mehmet Ali";
  List<OgrenciBilgileri> ogrenciler = [];
  String? _selectedOgrenci;
  late int ogrenciId;
  late String ogrenciAd;
  late String ogrenciSoyad;
  //String gelenMesaj = "Mesajlar Yükleniyor...";
  String gonderilenMesaj = "";
  List<String> imagePaths = [];
  //TextEditingController _gonderilenMesajtext = TextEditingController();
  List<KangaroomMesaj> newmesage = [];
  TextEditingController _controller = TextEditingController();
  String _selectedTime = '5dk';
  String veli = "veli";
  Map<String, dynamic> GizlenecekOgeler = {};
  Map<String, dynamic> borcluMuList = {};
  List<ImageModel> imageList = [];
  bool isLoading = true;
  bool resimVarMi = true;
  bool? yoklama;
  bool tatilMi = false;
  bool isPageLoading = true;
  late String accessToken;
  late Timer timer;
  Timer? sliderTimer;
  late PageController _pageController;
  int _currentPage = 0;
  String _formatTime(String? time) {
    if (time == null || time.isEmpty) {
      return S.of(context).yok;
    }
    try {
      final parsedTime = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("HH:mm").format(parsedTime);
    } catch (e) {
      return S.of(context).yok;
    }
  }

  void _clearCacheIfNeeded() async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final lastClearString = prefs.getString('lastCacheClearDate');
    DateTime? lastClear =
        lastClearString != null ? DateTime.tryParse(lastClearString) : null;
    if (lastClear == null || now.difference(lastClear).inDays > 0) {
      await CachedNetworkImage.evictFromCache(''); // Tüm cache'i temizle
      await prefs.setString('lastCacheClearDate', now.toIso8601String());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();
    _clearCacheIfNeeded();

    _loadUserData().then((_) {
      loadGizlenecekOgeler();
      getAccessTokenOgretmen();
      OgrenciBilgileriGetir(_users['id']).then((_) {
        borcluMu(ogrenciId).then((_) {
          if (borcluMuList.isNotEmpty) {
            burcVarUyari();
          }
          setState(() {
            isPageLoading = false;
          });
        });
      });
      _fetchitems(_users['okulId']);
      timer = Timer.periodic(Duration(seconds: 8), (t) {
        OgrenciBilgileriGetir(_users['id']);
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Uygulama tekrar foreground'a geldiğinde verileri yenile
      if (_users.isNotEmpty && _users['id'] != null) {
        OgrenciBilgileriGetir(_users['id']);
        var users = UserManager().ogrenciBilgileri;
        fetchImages(users?.id ?? 0);
        _fetchitems(_users['okulId']);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    timer.cancel();
    sliderTimer?.cancel();
    super.dispose();
  }

  String sayiToAy(int sayi) {
    switch (sayi) {
      case 1:
        return 'Ocak';
      case 2:
        return 'Şubat';
      case 3:
        return 'Mart';
      case 4:
        return 'Nisan';
      case 5:
        return 'Mayıs';
      case 6:
        return 'Haziran';
      case 7:
        return 'Temmuz';
      case 8:
        return 'Ağustos';
      case 9:
        return 'Eylül';
      case 10:
        return 'Ekim';
      case 11:
        return 'Kasım';
      case 12:
        return 'Aralık';
      default:
        return sayi.toString();
    }
  }

  burcVarUyari() {
    int donemSayisi = int.tryParse(borcluMuList['donem'].toString()) ?? 0;
    String donemAdi = sayiToAy(donemSayisi);

    Flushbar(
      title: S.of(context).aidetborc,
      message: "${borcluMuList['yıl']} $donemAdi ${S.of(context).borc}",
      duration: Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.red,
      icon: Icon(
        Icons.warning_amber_rounded,
        color: Colors.white,
      ),
    ).show(context);
  }

  Future<void> borcluMu(int ogrenciId) async {
    final response = await http.get(Uri.parse(
        'http://37.148.210.227:8001/api/KangaroomAidat/burcluMu/$ogrenciId'));
    if (response.statusCode == 200) {
      setState(() {
        borcluMuList = json.decode(response.body)[0];
      });
      print(borcluMuList);
    } else if (response.statusCode == 404) {
      print("borc bulunmadı ");
    } else {
      print("borclu bilgiler hata");
    }
  }

  Future<void> yoklamaDurumu(int ogrenciId, int ay, int yil) async {
    try {
      DateTime today = DateTime.now();
      if (today.weekday == DateTime.saturday ||
          today.weekday == DateTime.sunday) {
        setState(() {
          tatilMi = true;
        });
        return;
      }
      final response = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomYoklama/yoklama?ogrenciId=$ogrenciId&ay=$ay&yil=$yil'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        DateTime todayWithoutTime =
            DateTime(today.year, today.month, today.day);
        bool? yoklama1;
        for (var item in data) {
          DateTime date = DateTime.parse(item['tarih']);
          DateTime dateWithoutTime = DateTime(date.year, date.month, date.day);
          if (dateWithoutTime == todayWithoutTime) {
            yoklama1 = item['durum'];
            break;
          }
        }
        setState(() {
          yoklama = yoklama1;
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAccessTokenOgretmen() async {
    try {
      final serviceAccountJson = await rootBundle.loadString(
          'assets/firebase/kangaroommobileogretmen-firebase-adminsdk-fbsvc-2851ac58ac.json');

      final accountCredentials = ServiceAccountCredentials.fromJson(
        json.decode(serviceAccountJson),
      );

      const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final client = http.Client();
      try {
        final accessCredentials =
            await obtainAccessCredentialsViaServiceAccount(
          accountCredentials,
          scopes,
          client,
        );

        setState(() {
          accessToken = accessCredentials.accessToken.data;
        });
      } catch (e) {
        print('Error obtaining access token: $e');
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error loading service account JSON: $e');
    }
  }

  Future<void> fetchImages(int ogrenciId) async {
    try {
      print('Fetching images for student ID: $ogrenciId');
      final response = await http.get(
        Uri.parse(
            'http://37.148.210.227:8001/api/KangaroomDers/dersResim/$ogrenciId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 10));

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          imageList = data.map((item) => ImageModel.fromJson(item)).toList();
          isLoading = false;
          resimVarMi = imageList.isNotEmpty;
          print('Loaded ${imageList.length} images');
        });

        // Otomatik geçiş timer'ını başlat (sadece bir tane olsun)
        sliderTimer?.cancel();
        if (imageList.length > 1) {
          sliderTimer = Timer.periodic(Duration(seconds: 7), (timer) {
            if (_pageController.hasClients) {
              if (_currentPage < imageList.length - 1) {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                );
              } else {
                _pageController.animateToPage(
                  0,
                  duration: Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                );
              }
            }
          });
        }
      } else if (response.statusCode == 404) {
        print('No images found for student ID: $ogrenciId (404)');
        setState(() {
          isLoading = false;
          resimVarMi = false;
          // 404 durumunda resim listesini boş bırak
          imageList = [];
        });
      } else {
        print('Failed to load images: HTTP ${response.statusCode}');
        setState(() {
          isLoading = false;
          resimVarMi = false;
        });
      }
    } catch (e) {
      print('Error fetching images: $e');
      setState(() {
        isLoading = false;
        resimVarMi = false;
        // Hata durumunda resim listesini boş bırak
        imageList = [];
      });
    }
  }

  Future<void> loadGizlenecekOgeler() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('gizlenecekOgeler')) {
      setState(() {
        GizlenecekOgeler = json.decode(prefs.getString('gizlenecekOgeler')!);
      });
      print("gizlenecek bilgiler from shred");
    } else {
      await fetchGizlenecekOgeler(_users['okulId']);
      print("gizlenecek bilgiler from API");
    }
  }

  Future<void> fetchGizlenecekOgeler(int okulId) async {
    final response = await http.get(Uri.parse(
        'http://37.148.210.227:8001/api/KangaroomVeliLogin/veliEkran/$okulId'));
    if (response.statusCode == 200) {
      setState(() {
        GizlenecekOgeler = json.decode(response.body)[0];
      });

      // Debug: GizlenecekOgeler içeriğini yazdır
      print("🔍 GizlenecekOgeler: $GizlenecekOgeler");
      print("🔍 _Anket değeri: ${GizlenecekOgeler['_Anket']}");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('gizlenecekOgeler', json.encode(GizlenecekOgeler));
    } else {
      print("gizlenecek bilgiler hata");
    }
  }

  Future<void> _fetchitems(int okulId) async {
    try {
      final response = await Dio()
          .get("http://37.148.210.227:8001/api/KangaroomFirma/firma/$okulId");
      if (response.statusCode == 200) {
        final _datas = response.data;
        if (_datas is List) {
          setState(() {
            _items = _datas.map((e) => HakkimizdaModel.fromJson(e)).toList();
          });
        }
      } else {
        throw Exception("failed load data sosyal");
      }
    } catch (e) {
      print("hatasosyal");
    }
  }

  Future<void> OgrenciBilgileriGetir(int babaId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomOgrenci/kardesler/$babaId'));
      if (response.statusCode == 200) {
        print("ogrenci bilgileri sfsgfd");
        setState(() {
          ogrenciler = (jsonDecode(response.body) as List)
              .map((data) => OgrenciBilgileri.fromJson(data))
              .toList();
          if (ogrenciler.isNotEmpty) {
            _selectedOgrenci = ogrenciler.first.ad;
            ogrenciBilgileri = ogrenciler.first;
            UserManager().ogrenciBilgileri = ogrenciBilgileri;
            toilet = ogrenciBilgileri?.tuvalet ?? 0;
            uyku = ogrenciBilgileri?.uyku ?? 0;
            ogrenciId = ogrenciBilgileri?.id ?? 0;
            ogrenciAd = ogrenciBilgileri?.ad ?? " ";
            ogrenciSoyad = ogrenciBilgileri?.soyad ?? " ";
            medicine = ogrenciBilgileri?.ilac ?? 0;
            duygu = ogrenciBilgileri?.duygu ?? 0;
            yildizsabah = ogrenciBilgileri?.sabah?.toDouble() ?? 0.0;
            yildizikindi = ogrenciBilgileri?.ikindi?.toDouble() ?? 0.0;
            yildizogle = ogrenciBilgileri?.ogle?.toDouble() ?? 0.0;
            print(ogrenciBilgileri?.id);
            fetchImages(ogrenciBilgileri?.id ?? 0);
            yoklamaDurumu(ogrenciBilgileri?.id ?? 0, ay, yil);
          }
        });
      } else {
        throw Exception('Failed to load student');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> OgretmenBilgileriGetirSms(int ogrenciId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomOgrenci/ogretmen/$ogrenciId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Örnek olarak, ilk öğeyi alıp OgretmenModel'e çeviriyoruz
        if (data.isNotEmpty) {
          ogretmen = OgretmenModel.fromJson(data[0]);
          String? temp = ogretmen?.iletisim ?? ""; // Ogretmen id'sini al
          return temp;
        } else {
          return ""; // Veri boşsa 0 döndür
        }
      } else {
        return ""; // Yanıt 200 değilse 0 döndür
      }
    } catch (e) {
      print(e);
      return ""; // Hata durumunda 0 döndür
    }
  }

  Future<int> OgretmenBilgileriGetir(int ogrenciId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomOgrenci/ogretmen/$ogrenciId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Örnek olarak, ilk öğeyi alıp OgretmenModel'e çeviriyoruz
        if (data.isNotEmpty) {
          ogretmen = OgretmenModel.fromJson(data[0]);
          int? temp = ogretmen?.id ?? 0; // Ogretmen id'sini al
          return temp;
        } else {
          return 0; // Veri boşsa 0 döndür
        }
      } else {
        return 0; // Yanıt 200 değilse 0 döndür
      }
    } catch (e) {
      print(e);
      return 0; // Hata durumunda 0 döndür
    }
  }

  Future<String> SmsGonder() async {
    const String apiUrl = 'https://api.vatansms.net/api/v1/1toN';
    final kime = await OgretmenBilgileriGetirSms(ogrenciId);
    Map<String, dynamic> smsData = {
      "api_id": "22276b28072392b4d7767b21",
      "api_key": "8f91c6038a85325c2bc9eb8d",
      "message": veli,
      "message_type": "normal",
      "sender": "MIS SOFT D.",
      "phones": [kime]
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(smsData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Zil Gönderildi"),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        veli = "";
      });
      print(response.statusCode);
      return response.body; // Successful response
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Zil Gönderilmedi"),
          backgroundColor: Colors.red,
        ),
      );
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to send SMS');
    }
  }

  void sendMasej() async {
    try {
      String response = await SmsGonder();
      print("Response: $response");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> zilGonder() async {
    final String apiUrl = 'http://37.148.210.227:8001/api/KangaroomZil';
    try {
      final kime = await OgretmenBilgileriGetir(ogrenciId);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "id": 0,
          "aliciid": kime,
          "gondericiid": ogrenciId,
          "sure": extractNumber(_selectedTime),
          "kim": veli,
          "tarih": DateTime.now().toIso8601String(),
        }),
      );
      if (response.statusCode == 201) {
        //    final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Zil Gönderildi"),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          veli = "";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Zil Gönderilmedi"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(
          '****************************************************************************** $e');
      print('HTTP isteği sırasında bir hata oluştu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Zil Gönderilmedi"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/login.json');
  // }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //accessToken = prefs.getString('accessTokenOgretmen') ?? "";
    String sifre = prefs.getString('sifre') ?? "";
    String username = prefs.getString('username') ?? "";
    var url = Uri.parse(
        'http://37.148.210.227:8001/api/KangaroomOgrenci/VeliGiris/$username/$sifre');

    try {
      var response = await http.get(url);

      List<dynamic> userList = json.decode(response.body);
      if (userList.isNotEmpty) {
        setState(() {
          _users = userList[0]; // Access the first user in the list
          UserManager().users = _users;

          print("Homescreen_loadUserData() çalışıyor...$_users");
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<void> notification() async {
    final token = await OgretmenBilgileriGetirToken(ogrenciId);

    final String apiUrl =
        'https://fcm.googleapis.com/v1/projects/kangaroommobileogretmen/messages:send';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "message": {
            "token": token,
            "notification": {
              "title": ogrenciAd + " " + ogrenciSoyad,
              "body": veli,
            },
            // opsiyonel: Android ayarları
            "android": {
              "priority": "HIGH",
            },
          }
        }),
      );

      if (response.statusCode == 200) {
        print("Mesaj gönderildi: $token");
      } else {
        print("Mesaj gönderilemedi: ${response.statusCode}");
        print("Body: ${response.body}");
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<String> OgretmenBilgileriGetirToken(int ogrenciId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomOgrenci/ogretmen/$ogrenciId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Örnek olarak, ilk öğeyi alıp OgretmenModel'e çeviriyoruz
        if (data.isNotEmpty) {
          ogretmen = OgretmenModel.fromJson(data[0]);
          String? temp = ogretmen?.token ?? ""; // Ogretmen id'sini al
          return temp;
        } else {
          return ""; // Veri boşsa 0 döndür
        }
      } else {
        return ""; // Yanıt 200 değilse 0 döndür
      }
    } catch (e) {
      print(e);
      return ""; // Hata durumunda 0 döndür
    }
  }

  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return directory.path;
  // }

  @override
  Widget build(BuildContext context) {
    var oran = MediaQuery.of(context);
    var genislik = oran.size.width;
    var uzunluk = oran.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment(-0.15, 0),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(),
          child: DropdownButton<String>(
            value: _selectedOgrenci,
            dropdownColor: Theme.of(context).primaryColor,
            iconEnabledColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
            onChanged: (String? newValue) {
              setState(() {
                _selectedOgrenci = newValue;
                ogrenciBilgileri =
                    ogrenciler.firstWhere((student) => student.ad == newValue);
                toilet = ogrenciBilgileri?.tuvalet ?? 0;
                uyku = ogrenciBilgileri?.uyku ?? 0;
                medicine = ogrenciBilgileri?.ilac ?? 0;
                duygu = ogrenciBilgileri?.duygu ?? 0;
                ogrenciId = ogrenciBilgileri?.id ?? 0;
                yildizsabah = ogrenciBilgileri?.sabah?.toDouble() ?? 0.0;
                yildizikindi = ogrenciBilgileri?.ikindi?.toDouble() ?? 0.0;
                yildizogle = ogrenciBilgileri?.ogle?.toDouble() ?? 0.0;
                print(ogrenciBilgileri?.id);
                fetchImages(ogrenciBilgileri?.id ?? 0);
                yoklamaDurumu(ogrenciBilgileri?.id ?? 0, ay, yil);
                isLoading = true;
              });
            },
            items: ogrenciler
                .map<DropdownMenuItem<String>>((OgrenciBilgileri ogrenci) {
              return DropdownMenuItem<String>(
                value: ogrenci.ad,
                child: Text("${ogrenci.ad}"),
              );
            }).toList(),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              "assets/icon/message.png",
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MessageListPage(
                        ogretmenAdi: "${ogrenciBilgileri?.ogretmen}",
                        senderId: ogrenciBilgileri?.ogretmenId ?? 0,
                        ogrenciAdi: "$ogrenciAd $ogrenciSoyad",
                        kimeId:
                            ogrenciId)), // Replace with your message page widget
              );
            },
          ),
        ],
      ),
      drawer: FractionallySizedBox(
        widthFactor: 0.55,
        child: Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        if (_items != null && _items!.isNotEmpty)
                          Expanded(
                            child: SizedBox(
                              width: genislik / 3,
                              height: uzunluk / 3,
                              child: GestureDetector(
                                onTap: () {
                                  EasyLauncher.url(
                                      url: "${_items![0].website}");
                                },
                                child: Image.network(
                                  "http://37.148.210.227:8001/api/KangaroomFirma/logo/${_users['okulId']}",
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container();
                                  },
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          )
                        else
                          CircularProgressIndicator(),
                        Text(
                          S.of(context).menu,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text(S.of(context).anaSayfa),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text(S.of(context).hakkimizda),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Hakkimizda(_users["okulId"])),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.facebook_rounded),
                      title: Text(S.of(context).sosyalMedya),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Sosyal(_users["okulId"])));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.people),
                      title: Text(S.of(context).egitimKadrosu),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Egitimkadro(_users["okulId"])),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(S.of(context).iletisim),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Kurumsal(_users["okulId"])),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.question_mark),
                      title: Text(S.of(context).gorusVeOneri),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Gorusoneri(
                              OkulId: _users["okulId"],
                              createUserId: _users["id"],
                            ),
                          ),
                        );
                      },
                    ),
                    // ListTile(
                    //   leading:
                    //       Image.asset("assets/icon/chatbot.png", width: 30),
                    //   title: Text(
                    //     S.of(context).chatbot,
                    //   ),
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => Chatbot()),
                    //     );
                    //   },
                    // ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text(S.of(context).ayarlar),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Ayarlar(
                                    okulId: _users["okulId"],
                                  )),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/icon/mis.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
      body: isPageLoading
          ? Center(
              child: Image.asset(
                'assets/icon/mis.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (tatilMi)
                    Center(
                      child: Column(children: [
                        Image.asset("assets/icon/tatil.png",
                            width: 150, height: 150),
                        Text(
                          S.of(context).buguntatil,
                          style: TextStyle(fontSize: 25, color: Colors.blue),
                        )
                      ]),
                    ),
                  if (!tatilMi && yoklama == null)
                    Center(
                      child: Column(children: [
                        Image.asset("assets/icon/yoklama2.png",
                            width: 150, height: 150),
                        Text(
                          S.of(context).yoklamabilgisigirilmedi,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25, color: Colors.green),
                        )
                      ]),
                    ),
                  if (!tatilMi &&
                      yoklama ==
                          true) // yoklama bugün  true ise öğrenci durumu göster
                    Column(
                      children: [
                        ExpansionTile(
                          title: Center(
                            child: Text(S.of(context).durumbilgisi),
                          ),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Toilet alanı ekranda gösterilmeyecek, aşağıdaki kod yorum satırına alınmıştır.
                                  /*
                                  if (isMenuVisible('toilet'))
                                    toilet != -1
                                        ? Expanded(
                                            child: _buildToiletBox(toilet),
                                          )
                                        : SizedBox(width: 1.0),
                                  SizedBox(width: 8.0),
                                  */
                                  // Sadece duygu, uyku ve ilaç kutuları ekranda gösterilecek
                                  Expanded(
                                    child: _buildEmotionBox(duygu),
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: _buildSleepBox(uyku),
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: _buildmedicineBox(medicine),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => YemekProgrami(
                                          okulId: _users["okulId"],
                                          ogrenciId: ogrenciId,
                                        )),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 25,
                                ),

                                _buildTimeBox(
                                    S.of(context).sabah,
                                    yildizsabah,
                                    ogrenciBilgileri?.kahvaltiBas ?? 'N/A',
                                    ogrenciBilgileri?.kahvaltiBit ?? 'N/A'),
                                // SizedBox(width: 8.0), //
                                Spacer(), // Öğeler arasına esnek alan ekler
                                _buildTimeBox(
                                    S.of(context).ogle,
                                    yildizogle,
                                    ogrenciBilgileri?.ogleBas ?? 'N/A',
                                    ogrenciBilgileri?.oglebit ?? 'N/A'),
                                // SizedBox(width: 8.0), //
                                Spacer(),
                                _buildTimeBox(
                                    S.of(context).ikindi,
                                    yildizikindi,
                                    ogrenciBilgileri?.ikindibas ?? 'N/A',
                                    ogrenciBilgileri?.ikindibit ?? 'N/A'),
                                SizedBox(
                                  width: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : (imageList.isEmpty || !resimVarMi)
                                ? SizedBox.shrink() // Resim yoksa bölümü gizle
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    child: PageView.builder(
                                      controller: _pageController,
                                      itemCount: imageList.length,
                                      onPageChanged: (index) {
                                        setState(() {
                                          _currentPage = index;
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        final image = imageList[index];
                                        bool isVideo = image.resimVerisi
                                                .toLowerCase()
                                                .endsWith('.mp4') ||
                                            image.resimVerisi
                                                .toLowerCase()
                                                .endsWith('.mov') ||
                                            image.resimVerisi
                                                .toLowerCase()
                                                .endsWith('.avi') ||
                                            image.resimVerisi
                                                .toLowerCase()
                                                .endsWith('.mkv') ||
                                            image.resimVerisi
                                                .toLowerCase()
                                                .endsWith('.wmv') ||
                                            image.resimVerisi
                                                .toLowerCase()
                                                .endsWith('.flv') ||
                                            image.resimVerisi
                                                .toLowerCase()
                                                .endsWith('.webm');

                                        return GestureDetector(
                                          onTap: () {
                                            print(
                                                'Image tapped with dersId: {image.dersId}');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Etkinlik(
                                                        ogrenciId:
                                                            ogrenciBilgileri
                                                                ?.id,
                                                        images: imageList,
                                                      )),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300]),
                                            child: isVideo
                                                ? Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      VideoPlayerWidget(
                                                          url: image
                                                              .resimVerisi),
                                                      Icon(
                                                        Icons
                                                            .play_circle_filled,
                                                        color: Colors.white
                                                            .withOpacity(0.7),
                                                        size: 64.0,
                                                      ),
                                                    ],
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: image.resimVerisi,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                      ],
                    ),
                  if (!tatilMi &&
                      yoklama ==
                          false) // yoklama false ise uyarı göster (oğrenci okula gelmedi )
                    Center(
                      child: Column(children: [
                        Image.asset("assets/icon/gotoschool.jpg",
                            width: 150, height: 150),
                        Text(
                          S.of(context).okulagelmdim,
                          style: TextStyle(fontSize: 25, color: Colors.red),
                        )
                      ]),
                    ),
                  Divider(),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      if (isMenuVisible('Profil'))
                        _buildMenuItem(
                            S.of(context).profil, 'profil2.png', context),
                      if (isMenuVisible('Zil'))
                        _buildMenuItem(S.of(context).zil, 'zil1.png', context),
                      if (isMenuVisible('Aidat'))
                        _buildMenuItem(
                            S.of(context).aidat, 'aidat1.png', context),
                      if (isMenuVisible('Randevular'))
                        _buildMenuItem(
                            S.of(context).randevular, 'randevu2.png', context),
                      if (isMenuVisible(S.of(context).karne))
                        _buildMenuItem(
                            S.of(context).karne, 'karne1.png', context),
                      if (isMenuVisible('Yoklama'))
                        _buildMenuItem(
                            S.of(context).yoklama, 'yoklama1.png', context),
                      if (isMenuVisible('Boy/Kilo'))
                        _buildMenuItem(
                            S.of(context).boyKilo, 'kilo1.png', context),
                      if (isMenuVisible('Duyurular'))
                        _buildMenuItem(
                            S.of(context).duyurular, 'duyuru1.png', context),
                      if (isMenuVisible('Bülten'))
                        _buildMenuItem(
                            S.of(context).bulten, 'bulten1.png', context),
                      if (isMenuVisible('Sağlık'))
                        _buildMenuItem(
                            S.of(context).saglik, 'saglık1.png', context),
                      if (isMenuVisible('Etkinlik'))
                        _buildMenuItem(S.of(context).etkinlik,
                            'icons8-community-96.png', context),
                      if (isMenuVisible('Anket'))
                        _buildMenuItem(
                            S.of(context).anket, 'anket.png', context),
                      if (isMenuVisible('Ders Programı'))
                        _buildMenuItem(
                            S.of(context).dersProgrami, 'ders1.png', context),
                      if (isMenuVisible('Yemek Programı'))
                        _buildMenuItem(
                            S.of(context).yemekProgrami, 'yemek2.png', context),
                      if (isMenuVisible('Haftalık Ders Saati'))
                        _buildMenuItem(S.of(context).haftalikDersSaati,
                            'full-time.png', context),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  bool isMenuVisible(String menuName) {
    // Localization'a göre karşılaştırma yapalım
    if (menuName == S.of(context).zil) {
      return GizlenecekOgeler['_Zil'] == 1;
    } else if (menuName == S.of(context).aidat) {
      return GizlenecekOgeler['_Aidat'] == 1;
    } else if (menuName == S.of(context).dersProgrami) {
      return GizlenecekOgeler['_DersProgrami'] == 1;
    } else if (menuName == S.of(context).yemekProgrami) {
      return GizlenecekOgeler['_YemekProgrami'] == 1;
    } else if (menuName == S.of(context).randevular) {
      return GizlenecekOgeler['_Randevular'] == 1;
    } else if (menuName == S.of(context).karne) {
      return GizlenecekOgeler['_Karne'] == 1;
    } else if (menuName == S.of(context).yoklama) {
      return GizlenecekOgeler['_Yoklama'] == 1;
    } else if (menuName == S.of(context).boyKilo) {
      return GizlenecekOgeler['_BoyKilo'] == 1;
    } else if (menuName == S.of(context).bulten) {
      return GizlenecekOgeler['_Bulten'] == 1;
    } else if (menuName == S.of(context).etkinlik) {
      return GizlenecekOgeler['_Etkinlik'] == 1;
    } else if (menuName == S.of(context).anket) {
      return GizlenecekOgeler['_Anket'] == 1 ||
          GizlenecekOgeler['_Anket'] == null;
    } else if (menuName == 'medicine') {
      return GizlenecekOgeler['_Ilac'] == 1;
    } else if (menuName == 'toilet') {
      return GizlenecekOgeler['_tuvalet'] == 1;
    } else {
      return true; // Default to true if no specific rule exists
    }
  }

  Widget _buildSleepBox(int sleep) {
    String path = "assets/icon/sleep1.png";
    Color color = Colors.red; // Uyumadı için kırmızı
    if (sleep == 1) {
      color = Colors.blue; // Dinlendi için mavi
    } else if (sleep == 2) {
      color = Colors.green; // Uyudu için yeşil
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.asset(
            path,
            color: color,
            width: 48,
            height: 48,
          ),
          SizedBox(height: 8),
          Text(
            sleep == 0
                ? S.of(context).uyumadi
                : sleep == 1
                    ? S.of(context).dinlendi
                    : S.of(context).uyudu,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: primaryColor300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionBox(int emotion) {
    String path = "assets/icon/normal.jpg";
    //Color color = Colors.yellow;
    String text = S.of(context).normal;
    if (emotion == 0) {
      //color = Colors.green;
      text = S.of(context).mutlu;
      setState(() {
        path = "assets/icon/icons8-emotion-48.png";
      });
    }
    if (emotion == 1) {
      //color = Colors.yellow;
      text = S.of(context).normal;
      setState(() {
        path = "assets/icon/normal.jpg";
      });
    }
    if (emotion == 2) {
      // color = Colors.orange;
      text = S.of(context).mutsuz;
      setState(() {
        path = "assets/icon/icons8-sad-96.png";
      });
    } //duygu için alan
    if (emotion == 3) {
      // color = Colors.deepPurple;
      text = S.of(context).uzgun;
      setState(() {
        path = "assets/icon/icons8-disappointed-face-96.png";
      });
    }
    if (emotion == 4) {
      // color = Colors.red;
      text = S.of(context).ofkeli;
      setState(() {
        path = "assets/icon/icons8-angry-64.png";
      });
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.asset(
            path,
            //  color: color,
            width: 48,
            height: 48,
          ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: primaryColor300),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget _buildToiletBox(int toilet) {
  //   Color color = Colors.white;
  //   String text = "";
  //   if (toilet == 0) {
  //     color = Colors.red;
  //     text = S.of(context).buyukTuvalet;
  //   }
  //   if (toilet == 1) {
  //     color = Colors.green;
  //     text = S.of(context).buyukTuvaletaltinayati;
  //   }
  //   if (toilet == 2) {
  //     color = Colors.redAccent;
  //     text = S.of(context).kucukTuvaletaltinayati;
  //   }
  //   if (toilet == 3) {
  //     color = Colors.lightGreen;
  //     text = S.of(context).kucukTuvalet;
  //   } //burası tuvalet için
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       color: Colors.white,
  //     ),
  //     padding: EdgeInsets.all(20),
  //     child: Column(
  //       children: [
  //         Image.asset(
  //           'assets/icon/toilet.png',
  //           color: color,
  //           width: 48,
  //           height: 48,
  //         ),
  //         SizedBox(height: 8),
  //         Text(
  //           text,
  //           style: TextStyle(
  //               fontSize: 12,
  //               fontWeight: FontWeight.bold,
  //               color: primaryColor300),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildmedicineBox(int medicine) {
    Color color = Colors.red;
    String text = S.of(context).ilacAlmadi;
    if (medicine == 1) {
      color = Colors.green;
      text = S.of(context).ilacAldi;
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.asset(
            'assets/icon/medicine1.png',
            color: color,
            width: 48,
            height: 48,
          ),
          // Text(
          //   'İlaç Durumu',
          //   style: TextStyle(
          //       fontSize: 15, fontWeight: FontWeight.bold, color: primaryColor300),
          // ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: primaryColor300),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(
      String time, double starCount, String startTime, String endTime) {
    String imagePath;
    if (starCount == 0) {
      imagePath = 'assets/icon/pizza0.png';
    } else if (starCount == 1) {
      imagePath = 'assets/icon/pizza1.png';
    } else if (starCount == 2) {
      imagePath = 'assets/icon/pizza2.png';
    } else {
      imagePath = 'assets/icon/pizza3.png';
    }
    // Saati yalnızca saatleri ve dakikaları gösterecek şekilde veya saat bilgisi yok ise "yok" olarak yazılıyor
    String formattedStartTime = _formatTime(startTime);
    String formattedEndTime = _formatTime(endTime);
    return Container(
      decoration: BoxDecoration(),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(imagePath),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primaryColor300,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '$formattedStartTime\n$formattedEndTime',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  //Ders Saati pdf açabilmek için yazılan kodlar
  // void _openPDF() async {
  //   final filePath = await _copyAssetToLocal(
  //       'assets/pdfler/25-36-ay-ders-programi-2024-1.pdf');
  //   OpenFile.open(filePath);
  // }

  // Future<String> _copyAssetToLocal(String assetPath) async {
  //   final byteData = await rootBundle.load(assetPath);
  //   final file = File(
  //       '${(await getTemporaryDirectory()).path}/25-36-ay-ders-programi-2024-1.pdf');
  //   await file.writeAsBytes(byteData.buffer.asUint8List());
  //   return file.path;
  // }

  Widget _buildMenuItem(String title, String iconName, BuildContext context) {
    // hangi menü hangi alanı kontrol edecek (0 ise ünlem çıkar)
    final Map<String, int?> kontrolMap = {
      S.of(context).duyurular: ogrenciBilgileri?.duyuru,
      S.of(context).bulten: ogrenciBilgileri?.bulten,
      S.of(context).boyKilo: ogrenciBilgileri?.boykilo,
      S.of(context).yemekProgrami: ogrenciBilgileri?.beslenme,
      S.of(context).etkinlik: ogrenciBilgileri?.etkinlik,
      S.of(context).anket: ogrenciBilgileri?.anket,
      S.of(context).haftalikDersSaati: ogrenciBilgileri?.dersSaat,
      S.of(context).randevular: ogrenciBilgileri?.randevu,
      S.of(context).dersProgrami:
          ogrenciBilgileri?.mufredat, // ✅ Müfredat dersProgramına bağlı
    };

    // ünlem işareti gösterilecek mi?
    bool showAlert = (kontrolMap[title] == 0);

    return InkWell(
      onTap: () {
        if (title == S.of(context).dersProgrami) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DersProgrami(
                  okulId: _users["okulId"],
                  ogrenciId: ogrenciId), // ✅ Müfredat da DersProgramı sayfasına yönlendiriyor
            ),
          );
        }

        if (title == S.of(context).profil) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profil(
                ad: "${ogrenciBilgileri?.ad}",
                soyad: "${ogrenciBilgileri?.soyad}",
                ogrenciId: "$ogrenciId",
                sinifAd: "${ogrenciBilgileri?.sinifAd}",
                ogretmen: "${ogrenciBilgileri?.ogretmen}",
                dogumTarihi: "${ogrenciBilgileri?.dogumTarihi}",
              ),
            ),
          );
        }
        if (title == S.of(context).zil) {
          _showDialogZil();
        }
        if (title == S.of(context).aidat) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OdemePage(ogrenciId: ogrenciId)),
          );
        }
        if (title == S.of(context).boyKilo) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BoyKilo(ogrenciId: ogrenciId)),
          );
        }
        if (title == S.of(context).yoklama) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Yoklama(ogrenciId: ogrenciId)),
          );
        }
        if (title == S.of(context).dersProgrami) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DersProgrami(okulId: _users["okulId"], ogrenciId: ogrenciId)),
          );
        }
        if (title == S.of(context).duyurular) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Duyurular(okulId: _users["okulId"],
                    ogrenciId: ogrenciId)),
          );
        }
        if (title == S.of(context).randevular) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Randevu(VeliId: _users['id'],
                    ogrenciId: ogrenciId)),
          );
        }
        if (title == S.of(context).karne) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Karne(ogrenciId: ogrenciId)),
          );
        }
        if (title == S.of(context).yemekProgrami) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => YemekProgrami(okulId: _users["okulId"], ogrenciId: ogrenciId)),
          );
        }

        if (title == S.of(context).bulten) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Bulten(_users["okulId"], ogrenciId)),
          );
        }
        if (title == S.of(context).saglik) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Saglik(
                ogrenciId: ogrenciId,
                isim: "${ogrenciBilgileri?.ad}",
                soyisim: "${ogrenciBilgileri?.soyad}",
                ilacBilgisi: "${ogrenciBilgileri?.ilacAdi}",
                ilacSaati: "${ogrenciBilgileri?.ilacSaati}",
                alerjiDurumu: "${ogrenciBilgileri?.alerji}",
                kronikHastalikDurumu: "${ogrenciBilgileri?.hastalik}",
              ),
            ),
          );
        }
        if (title == S.of(context).etkinlik) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EtkinlikAnaSayfasi(ogrenciId: ogrenciId)),
          );
        }
        if (title == S.of(context).anket) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AnketSayfasi(VeliId: _users['id'],
                    ogrenciId: ogrenciId)),
          );
        }
        if (title == S.of(context).haftalikDersSaati) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DersEkrani(okulId: _users["okulId"],
                    ogrenciId: ogrenciId)),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none, // taşmasına izin ver

            children: [
              Image.asset(
                'assets/icon/$iconName',
                width: 64,
                height: 64,
                fit: BoxFit.contain,
              ),
              if (showAlert)
                Positioned(
                  left: -8, // biraz daha dışarı taşır
                  top: -8, // biraz daha yukarı taşır
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.shade700,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    // child: Center(
                    //   child: Container(
                    //     width: 15,
                    //     height: 15,
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       shape: BoxShape.circle,
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDialogZil() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Row(
            children: [
              Image.asset('assets/icon/zil3.png', width: 36, height: 36),
              SizedBox(width: 10),
              Text(S.of(context).zil, style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: _showDialogBaskasiAlacak,
                  icon: Image.asset('assets/icon/users.png',
                      width: 36, height: 36),
                  label: Text(
                    S.of(context).cocugumuBaskaBiriAlacak,
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 5,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 10), // İki buton arasına boşluk koyar
                ElevatedButton.icon(
                  onPressed: _showDialogBenAlacak,
                  icon: Image.asset('assets/icon/kapıdayım.png',
                      width: 45, height: 45),
                  label: Text(
                    S.of(context).benAlacagim,
                    style: TextStyle(
                        color:
                            Colors.white), // Set the text color to white here
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 5,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.cancel, color: Colors.white),
              label: Text(S.of(context).iptal,
                  style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton.icon(
              onPressed: () {
                print('Kimin alacağı: ${_controller.text}');
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.check, color: Theme.of(context).primaryColor),
              label: Text(S.of(context).tamam),
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Colors
                    .white, // Buton metni rengini Theme.of(context).primaryColor yapıyoruz
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDialogBenAlacak() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).primaryColor,
              title: Row(
                children: [
                  Image.asset('assets/icon/question.png',
                      width: 24, height: 24),
                  SizedBox(width: 10),
                  Text(
                    S.of(context).nezamanAlacaksiniz,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: _selectedTime,
                      dropdownColor: Theme.of(context).primaryColor,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      isExpanded: true,
                      itemHeight: 60,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTime = newValue!;
                        });
                      },
                      items: <String>['Kapıdayım', '5dk', '10dk', '15dk']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.cancel, color: Colors.white),
                  label: Text(S.of(context).iptal,
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      veli =
                          "$ogrenciAd $ogrenciSoyad  ${extractNumber(_selectedTime)} dakika sonra veli'si " +
                              _users['ad'] +
                              " " +
                              _users['soyad'] +
                              " alacak";
                    });
                    zilGonder(); // veritabanıa zil
                    notification(); // bildirim zil
                    //sendMasej(); // sms zil
                    Navigator.of(context).pop(); // close this dialog
                    Navigator.of(context).pop(); // close Zil dialog
                  },
                  icon:
                      Icon(Icons.check, color: Theme.of(context).primaryColor),
                  label: Text(S.of(context).tamam),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors
                        .white, // Buton metni rengini Theme.of(context).primaryColor yapıyoruz
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDialogBaskasiAlacak() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).primaryColor,
              title: Row(
                children: [
                  Image.asset('assets/icon/question.png',
                      width: 24, height: 24),
                  SizedBox(width: 10),
                  Text(S.of(context).kimAlacak,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: S.of(context).kiminAlacaginiGiriniz,
                        hintStyle: TextStyle(
                            color: Colors
                                .white70), // Hint metni rengini beyaz yapıyoruz
                      ),
                      style: TextStyle(
                          color: Colors
                              .white), // Girdi metni rengini beyaz yapıyoruz
                    ),
                    SizedBox(height: 20),
                    DropdownButton<String>(
                      value: _selectedTime,
                      dropdownColor: Theme.of(context).primaryColor,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      isExpanded: true,
                      itemHeight: 60,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTime = newValue!;
                        });
                      },
                      items: <String>['Kapıdayım', '5dk', '10dk', '15dk']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.cancel, color: Colors.white),
                  label: Text(S.of(context).iptal,
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    print('Kim alacağı: ${_controller.text}');
                    setState(() {
                      veli =
                          "$ogrenciAd $ogrenciSoyad 'i  ${extractNumber(_selectedTime)} dakika sonra ${_controller.text} alacak ";
                    });
                    zilGonder(); // veritabanıa zil
                    notification(); // bildirim zil
                    //sendMasej(); // sms zil
                    Navigator.of(context).pop(); // close this dialog
                    Navigator.of(context).pop(); // close Zil dialog
                  },
                  icon:
                      Icon(Icons.check, color: Theme.of(context).primaryColor),
                  label: Text(S.of(context).tamam),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors
                        .white, // Buton metni rengini Theme.of(context).primaryColor yapıyoruz
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  int extractNumber(String text) {
    // Metindeki rakamı bulmak için düzenli ifade kullanabiliriz
    RegExp regex = RegExp(r'\d+');
    // İlk eşleşen sayısal değeri al
    Match? match = regex.firstMatch(text);
    // Eğer eşleşme varsa ve dönüşüm başarılıysa sayıyı döndür, yoksa 0 döndür
    return match != null ? int.tryParse(match.group(0)!) ?? 0 : 0;
  }
}

class ImageModel {
  final int dersId;
  final String resimVerisi;
  ImageModel({required this.dersId, required this.resimVerisi});
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      dersId: json['dersId'],
      resimVerisi: json['dosyaUrl'],
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(
            () {}); // Ensure the first frame is shown after the video is initialized
      });
    _controller.setLooping(true);
    //_controller.play(); // Auto play the video
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}
