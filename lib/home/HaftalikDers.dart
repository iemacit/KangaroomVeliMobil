import 'dart:convert';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../model/haftalikDersProgrami.dart';
import 'homescreen.dart';
import 'package:dio/dio.dart';

import 'package:kangaroom/generated/l10n.dart';
//S.of(context).aidat

class DersEkrani extends StatefulWidget {
  final int okulId;
  final int ogrenciId;

  DersEkrani({required this.okulId, required this.ogrenciId});

  @override
  _DersEkraniState createState() => _DersEkraniState();
}

class _DersEkraniState extends State<DersEkrani> {
  DersModel2? _closestDers;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchClosestDers();
    _sendEHaftalikDersOkundu(widget.ogrenciId);
  }
  Future<void> _sendEHaftalikDersOkundu(int ogrenciId) async {
    try {
        await Dio().post(
          "http://37.148.210.227:8001/api/KangaroomDersProgramPdf/haftalıkDersOkundu/$ogrenciId",
        );
      } catch (e) {
        print("Error sending haftalıkDersOkundu: $e");
      }
  }
  Future<void> _fetchClosestDers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomDersProgramPdf/HaftalikDers/${widget.okulId}'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<DersModel2> dersList =
            jsonData.map((e) => DersModel2.fromJson(e)).toList();

        // Zamanı parse edip sıralama
        dersList.sort((a, b) {
          DateTime zamanA =
              DateTime.parse(a.zaman ?? DateTime.now().toString());
          DateTime zamanB =
              DateTime.parse(b.zaman ?? DateTime.now().toString());
          return zamanA.compareTo(zamanB);
        });

        // En yakın zamanlı dersi seçme
        setState(() {
          _closestDers = dersList.last;
        });
      } else {
        setState(() {
          _errorMessage =
              "${S.of(context).veriYuklenemedi}: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Hata: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var oran = MediaQuery.of(context);
    var genislik = oran.size.width;
    var uzunluk = oran.size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AnaSayfa()),
            );
          },
        ),
        title: Text(
          S.of(context).haftalikDersSaati,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor,
                    size: 50.0,
                  ),
                  SizedBox(height: 10),
                  Text(
                    S.of(context).verilerYukleniyor,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            )
          : _closestDers != null
              ? GestureDetector(
                  onTap: () {
                    EasyLauncher.url(
                        url:
                            "http://37.148.210.227:8001/api/KangaroomDersProgramPdf/HaftalikDerspdf/${_closestDers!.id ?? ''} ");
                  },
                  child: SizedBox(
                    height: uzunluk / 8,
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${_closestDers!.dosyaAdi}",
                                style: TextStyle(
                                  fontSize: genislik / 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "${_formatDate(_closestDers!.zaman)}",
                              style: TextStyle(
                                fontSize: genislik / 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    S.of(context).veriBulunamadi,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
    );
  }

// Tarih formatlama fonksiyonu
  String _formatDate(String? dateTimeString) {
    if (dateTimeString == null)
      return S.of(context).tarihYok; // Varsayılan değer
    DateTime dateTime = DateTime.parse(dateTimeString);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}"; // Tarih formatı: Gün/Ay/Yıl
  }

// Saat formatlama fonksiyonu
  String _formatTime(String? dateTimeString) {
    if (dateTimeString == null)
      return S.of(context).saatYok; // Varsayılan değer
    DateTime dateTime = DateTime.parse(dateTimeString);
    return "${dateTime.hour}:${dateTime.minute}"; // Saat formatı: Saat:Dakika
  }
}
