import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kangaroom/generated/l10n.dart';
import 'package:kangaroom/model/ogretmen_model.dart';
import 'package:kangaroom/theme.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart'; // Import the intl package
import '../model/UserManager.dart';

class MessageListPage extends StatefulWidget {
  final String ogretmenAdi;
  final String ogrenciAdi;
  final int senderId;
  final int kimeId;

  MessageListPage(
      {required this.senderId,
      required this.kimeId,
      required this.ogretmenAdi,
      required this.ogrenciAdi});

  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Uygulama tekrar öne gelince mesajları güncelle
      fetchMessages(widget.kimeId, yil, ay, gun);
    }
  }

  List<dynamic> messages = [];
  List<dynamic> filteredMessages = [];
  TextEditingController _messageController = TextEditingController();
  int ay = DateTime.now().month;
  int yil = DateTime.now().year;
  int gun = DateTime.now().day;
  String langKode = "";
  late String accessToken;
  final translator = GoogleTranslator();
  OgretmenModel? ogretmen;
  // Dropdown için rol seçenekleri ve seçili rol
  List<String> roles = ['Öğretmen', 'Müdür'];
  String selectedRole = 'Öğretmen';
  var users;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getAccessTokenOgretmen().then((_) {
      print("******************    :  $accessToken");
    });
    _loadLanguageCode();
    users = UserManager().ogrenciBilgileri;
    // Muhasebeci -1'den farklıysa roles'a ekle
    if (users?.muhasebeci != null && users?.muhasebeci != -1) {
      roles.insert(1, 'Muhasebe');
    }
    fetchMessages(widget.kimeId, yil, ay, gun);
  }

  Future<void> _loadLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      langKode = prefs.getString('language_code') ?? "tr";
    });
    print("/////////////////////////////////////$langKode");
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

  Future<void> notification(String body) async {
    final token = await OgretmenBilgileriGetirToken(widget.kimeId);
    final String apiUrl =
        'https://fcm.googleapis.com/v1/projects/kangaroommobileogretmen/messages:send';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer ${accessToken}',
        },
        body: jsonEncode(<String, dynamic>{
          "message": {
            "token": token,
            "notification": {"body": body, "title": widget.ogrenciAdi}
          }
        }),
      );

      if (response.statusCode == 200) {
        print("/////////////-------göndeildi------//////////////// ");
        print("Mesaj gönderildi: ${token}");
        print("Mesaj gönderildi: ${accessToken}");
      } else {
        print("/////////////-------hatta------////////////////");
        print("Mesaj gönderilmedi: ${token}");
        print("Mesaj gönderilmedi: ${accessToken}");
      }
    } catch (e) {
      print(e);
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
          String? temp = ogretmen?.token ?? "boş"; // Ogretmen id'sini al
          return temp;
        } else {
          return "else hata"; // Veri boşsa 0 döndür
        }
      } else {
        return "200 değil"; // Yanıt 200 değilse 0 döndür
      }
    } catch (e) {
      print(e);
      return "catch hata"; // Hata durumunda 0 döndür
    }
  }

  Future<void> fetchMessages(int kimeId, int yil, int ay, int gun) async {
    try {
      final response = await http.get(Uri.parse(
          "http://37.148.210.227:8001/api/KangaroomMesaj/ogrenciId/$kimeId/$yil-$ay-$gun"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          messages =
              data.map((message) => message as Map<String, dynamic>).toList();
        });
        users = UserManager().ogrenciBilgileri;
        filterMessages();
      } else {
        print('Failed to load messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void filterMessages() {
    setState(() {
      int filterId;
      if (selectedRole == 'Öğretmen') {
        filterId = widget.senderId;
      } else if (selectedRole == 'Muhasebe') {
        filterId = users?.muhasebeci ?? -2;
      } else if (selectedRole == 'Müdür') {
        filterId = users?.mudur ?? -1;
      } else {
        filterId = widget.kimeId;
      }
      filteredMessages = messages
          .where((msg) =>
              msg['kime'] == filterId || msg['createUserId'] == filterId)
          .toList();
    });
    // Sadece kullanıcıya gelen mesajlar için okundu isteği at
    markIncomingMessagesAsRead(filteredMessages);
  }

  Future<void> markIncomingMessagesAsRead(List<dynamic> messages) async {
    int myId;
    if (selectedRole == 'Öğretmen') {
      myId = widget.senderId;
    } else if (selectedRole == 'Muhasebe') {
      myId = users?.muhasebeci ?? -2;
    } else if (selectedRole == 'Müdür') {
      myId = users?.mudur ?? -1;
    } else {
      myId = widget.kimeId;
    }

    for (var msg in messages) {
      // Sana gelen mesajlar: kime alanı o anki id ise
      if (msg['createUserId'] == myId) {
        final id = msg['id'];
        if (id != null) {
          try {
            await http.post(
              Uri.parse(
                  'http://37.148.210.227:8001/api/KangaroomMesaj/okundu/$id'),
            );
          } catch (e) {
            print('Okundu işareti hatası: $e');
          }
        }
      }
    }
  }

  Future<void> mesajGonder(String mesaj, int senderId, int kimeId) async {
    final String apiUrl = 'http://37.148.210.227:8001/api/KangaroomMesaj';
    // Alıcı id'sini role göre belirle
    int aliciId;
    if (selectedRole == 'Öğretmen') {
      aliciId = senderId;
    } else if (selectedRole == 'Müdür') {
      aliciId = users?.mudur ?? -1;
    } else if (selectedRole == 'Muhasebe') {
      aliciId = users?.muhasebeci ?? -2;
    } else {
      aliciId = widget.kimeId;
    }
    try {
      final translatedMessage =
          await translator.translate(mesaj, from: langKode, to: 'tr');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "id": 0,
          "icerik": "${translatedMessage.text}",
          "kime": aliciId,
          "createUserId": kimeId,
          "gondericitur": 6,
          "createDate": DateTime.now().toIso8601String(),
          "statu": 1,
        }),
      );

      if (response.statusCode == 201) {
        // Sadece öğretmen seçili ise bildirim gönder
        if (selectedRole == 'Öğretmen') {
          notification(mesaj);
        }
        setState(() {
          messages.add({
            "id": 0,
            "icerik": "${translatedMessage.text}",
            "kime": aliciId,
            "createUserId": kimeId,
            "gondericitur": 6,
            "createDate": DateTime.now().toIso8601String(),
            "statu": 1,
          });
        });
        _messageController.clear();
        fetchMessages(widget.kimeId, yil, ay, gun); // Mesajlar güncellensin
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mesaj Gönderildi'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Mesaj Gönderilirken bir hata oluştu: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bir hata oluştu, lütfen tekrar deneyin! $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// Mesajları çeviren fonksiyon
  Future<String> translateMessage(
      String originalMessage, String langCode) async {
    try {
      final translation =
          await translator.translate(originalMessage, from: 'tr', to: langCode);
      return translation.text;
    } catch (e) {
      print("Translation error: $e");
      return "Çeviri başarısız";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor500,
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedRole,
            dropdownColor: Colors.white,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            items: [
              DropdownMenuItem(
                value: 'Öğretmen',
                child: Text(widget.ogretmenAdi),
              ),
              if (users?.muhasebeci != null && users?.muhasebeci != -1)
                DropdownMenuItem(
                  value: 'Muhasebe',
                  child: Text('Muhasebe'),
                ),
              DropdownMenuItem(
                value: 'Müdür',
                child: Text('Müdür'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedRole = value!;
              });
              filterMessages();
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: filteredMessages.isEmpty
                ? Center(child: Text(S.of(context).noMessage))
                : ListView.builder(
                    itemCount: filteredMessages.length,
                    itemBuilder: (context, index) {
                      final message = filteredMessages[index];
                      final isSentByCurrentUser = message['gondericiTur'] == 1;

                      // Orijinal mesaj
                      String originalMessage = message['icerik'];

                      return FutureBuilder<String>(
                        future: translateMessage(originalMessage, langKode),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("");
                          } else if (snapshot.hasError) {
                            return Text('Çeviri başarısız');
                          }

                          String translatedMessage =
                              snapshot.data ?? "Çeviri başarısız";

                          return Align(
                            alignment: isSentByCurrentUser
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSentByCurrentUser
                                    ? Colors.blue[100]
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    originalMessage,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  langKode != "tr"
                                      ? Text(
                                          translatedMessage,
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 12,
                                          ),
                                        )
                                      : SizedBox(
                                          height: 1,
                                        ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (!isSentByCurrentUser)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: Icon(
                                            message['okundu'] == 1
                                                ? Icons.done_all
                                                : Icons.done,
                                            size: 18,
                                            color: message['okundu'] == 1
                                                ? Colors.blue
                                                : Colors.grey,
                                          ),
                                        ),
                                      Text(
                                        DateFormat.Hm().format(DateTime.parse(
                                            message['createDate'])),
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: S.of(context).writeMessage,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        mesajGonder(_messageController.text, widget.senderId,
                            widget.kimeId);
                        // notification(_messageController.text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    super.dispose();
  }
}
