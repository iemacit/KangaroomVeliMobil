import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:kangaroom/theme.dart';
import 'package:kangaroom/generated/l10n.dart';
import 'package:dio/dio.dart';

class Duyurular extends StatefulWidget {
  final int okulId;
  final int ogrenciId;

  const Duyurular({super.key, required this.okulId, required this.ogrenciId});

  @override
  _DuyurularState createState() => _DuyurularState();
}

class _DuyurularState extends State<Duyurular> {
  List<Map<String, dynamic>> duyuru = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnnouncements(widget.okulId);
    _sendDuyuruOkundu(widget.ogrenciId);
  }

  Future<void> _sendDuyuruOkundu(int ogrenciId) async {
    try {
      await Dio().post(
        "http://37.148.210.227:8001/api/KangaroomDuyuru/duyuruOkundu/$ogrenciId",
      );
    } catch (e) {
      print("Error sending duyuruOkundu: $e");
    }
  }
  Future<void> _loadAnnouncements(int okulId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomDuyuru/duyuru/$okulId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          duyuru = data
              .map((item) => {
                    'id': item['id'],
                    'baslik': item['baslik'],
                    'icerik': item['icerik'],
                    'tarih': item['tarih'],
                    'resimPath': item['resimPath'], // artık URL
                    'createUserId': item['createUserId'],
                    'okulId': item['okulId'],
                  })
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Duyuruları yüklerken hata: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Duyuruları yüklerken hata: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatTimeFromString(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final DateFormat format = DateFormat('dd.MM.yyyy - HH:mm');
    return format.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final ekranGenisligi = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          S.of(context).duyurular,
          style: titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCircle(
                      color: Theme.of(context).primaryColor,
                      size: 50.0,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      S.of(context).duyurularYukleniyor,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              )
            : (duyuru.isEmpty)
                ? Center(
                    child: Text(
                      S.of(context).veriBulunamadi,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: duyuru.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DuyuruPage(
                                baslik: duyuru[index]['baslik'],
                                foto: duyuru[index]['resimPath'],
                                aciklama: duyuru[index]['icerik'],
                                tarih: duyuru[index]['tarih'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor500.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    width: ekranGenisligi,
                                    height: ekranGenisligi / 2.5,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        duyuru[index]['resimPath'],
                                        fit: BoxFit.fill,
                                        loadingBuilder: (context, child,
                                            loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(Icons.broken_image,
                                                size: 50, color: Colors.grey),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            duyuru[index]['baslik'],
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          Text(
                                            formatTimeFromString(
                                                duyuru[index]['tarih']),
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class DuyuruPage extends StatelessWidget {
  final String baslik;
  final String foto;
  final String aciklama;
  final String tarih;

  const DuyuruPage({
    super.key,
    required this.baslik,
    required this.foto,
    required this.aciklama,
    required this.tarih,
  });

  @override
  Widget build(BuildContext context) {
    final ekranGenisligi = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          S.of(context).duyurular,
          style: titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black54.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.network(
                            foto,
                            fit: BoxFit.cover,
                            width: ekranGenisligi,
                            loadingBuilder:
                                (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(Icons.broken_image,
                                    size: 50, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: ekranGenisligi * 0.35,
                          child: Divider(
                            thickness: 3,
                            color: darkBlue700,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.announcement_outlined,
                            color: darkBlue500,
                          ),
                        ),
                        Container(
                          width: ekranGenisligi * 0.35,
                          child: Divider(
                            thickness: 3,
                            color: darkBlue700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      aciklama,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkBlue700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
