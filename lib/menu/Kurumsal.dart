import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kangaroom/model/hakkimizda_model.dart';
import 'package:kangaroom/theme.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'dart:convert';

import 'package:kangaroom/generated/l10n.dart';

class Kurumsal extends StatefulWidget {
  final int okulid;

  Kurumsal(this.okulid);

  @override
  _KurumsalState createState() => _KurumsalState();
}

class _KurumsalState extends State<Kurumsal> {
  List<HakkimizdaModel>? _items;
  bool _isloading = false;
  late String baseurl;

  @override
  void initState() {
    super.initState();
    baseurl = 'http://37.148.210.227:8001/api/KangaroomFirma/${widget.okulid}';
    _fetchitems();
  }

  void changeloading() {
    setState(() {
      _isloading = !_isloading;
    });
  }

  Future<void> _fetchitems() async {
    try {
      changeloading();
      final response = await Dio().get(baseurl);

      print("Gelen Veri: ${response.data}"); // Gelen veriyi konsola yazdırır

      if (response.statusCode == 200) {
        final _datas = response.data;

        if (_datas is String) {
          final jsonData = json.decode(_datas);
          if (jsonData is List) {
            setState(() {
              _items =
                  jsonData.map((e) => HakkimizdaModel.fromJson(e)).toList();
            });
          } else if (jsonData is Map<String, dynamic>) {
            setState(() {
              _items = [HakkimizdaModel.fromJson(jsonData)];
            });
          } else {
            throw Exception(
                "Beklenmeyen JSON formatı: Liste veya nesne bekleniyordu.");
          }
        } else if (_datas is Map<String, dynamic>) {
          // Tek bir nesne dönüyorsa bu koşul çalışır
          setState(() {
            _items = [_datas].map((e) => HakkimizdaModel.fromJson(e)).toList();
          });
        } else if (_datas is List) {
          setState(() {
            _items = _datas.map((e) => HakkimizdaModel.fromJson(e)).toList();
          });
        } else {
          throw Exception("Beklenmeyen veri formatı.");
        }
      } else {
        throw Exception(
            "Sunucudan geçersiz yanıt kodu alındı: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Hata: $e");
      print("Hata Ayrıntıları: $stackTrace");

      // Kullanıcıya hatayı gösterebilirsiniz (opsiyonel)
      setState(() {
        _items = []; // Bu, verilerin yüklenemediği anlamına gelir.
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${S.of(context).veriYuklenemedi}: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      changeloading();
    }
  }

  @override
  Widget build(BuildContext context) {
    var oran = MediaQuery.of(context);
    var genislik = oran.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).iletisim,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isloading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFadingCircle(
                    color: primaryColor500,
                    size: 50.0,
                  ),
                  SizedBox(height: 10),
                  Text(
                    S.of(context).verilerYukleniyor,
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor500,
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: genislik / 11),
                child: _items != null && _items!.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: genislik / 1.4,
                              child: CachedNetworkImage(
                                  imageUrl:
                                      'http://37.148.210.227:8001/api/KangaroomFirma/logo/${widget.okulid}',
                                  placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Container())),
                          OtherText(
                            text: _items![0].firmaAdi ??
                                "Firma Adı Yükleniyor...",
                            boyut: genislik / 14,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OtherText(
                                text:
                                    "${S.of(context).mudur}: ${_items![0].mudurAdi ?? "Bilinmiyor"}",
                                boyut: genislik / 19,
                              ),
                              OtherText(
                                text:
                                    "${S.of(context).mudurYardimcisi}: ${_items![0].mudurYardimcisiAdi ?? "Bilinmiyor"}",
                                boyut: genislik / 19,
                              ),
                            ],
                          ),
                          iletisim(
                            icon: Icon(Icons.location_on_sharp),
                            genislik: genislik,
                            text: _items![0].il ?? "Konum Yükleniyor...",
                            etkilesim: GestureDetector(
                              onTap: () {
                                EasyLauncher.url(
                                  url: _items![0].konum ?? "URL Yükleniyor...",
                                );
                              },
                            ),
                          ),
                          iletisim(
                            icon: Icon(Icons.phone),
                            genislik: genislik,
                            text: _items![0].telNo1 ?? "Telefon Yükleniyor...",
                            etkilesim: GestureDetector(
                              onTap: () {
                                EasyLauncher.call(
                                    number: _items![0].telNo1 ?? "");
                              },
                            ),
                          ),
                          iletisim(
                            icon: Icon(Icons.mail),
                            genislik: genislik,
                            text: _items![0].email ?? "Email Yükleniyor...",
                            etkilesim: GestureDetector(
                              onTap: () {
                                EasyLauncher.email(
                                    email: _items![0].email ?? "");
                              },
                            ),
                          ),
                        ],
                      )
                    : Text(
                        S.of(context).veriBulunamadi,
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
              ),
            ),
    );
  }
}

class iletisim extends StatelessWidget {
  const iletisim({
    super.key,
    required this.icon,
    required this.genislik,
    required this.text,
    required this.etkilesim,
  });

  final Icon icon;
  final double genislik;
  final String text;
  final GestureDetector etkilesim;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        etkilesim.onTap?.call();
      },
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: genislik / 17,
            fontWeight: FontWeight.bold,
          ),
          children: [
            WidgetSpan(
              child: icon,
            ),
            TextSpan(text: ' '),
            TextSpan(text: text),
          ],
        ),
      ),
    );
  }
}

class OtherText extends StatelessWidget {
  const OtherText({
    super.key,
    required this.text,
    required this.boyut,
  });

  final String text;
  final double boyut;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: boyut,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
