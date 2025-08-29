import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kangaroom/theme.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';

import 'package:kangaroom/generated/l10n.dart';

class Sosyal extends StatefulWidget {
  final int okulid;

  Sosyal(this.okulid);

  @override
  State<Sosyal> createState() => _SosyalState();
}

class _SosyalState extends State<Sosyal> {
  Map<String, dynamic>? _items;
  bool _isloading = false;
  late String _baseurl;

  @override
  void initState() {
    super.initState();
    _baseurl =
        "http://37.148.210.227:8001/api/KangaroomFirma/${widget.okulid}";
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
      final response = await Dio().get(_baseurl);
      if (response.statusCode == 200) {
        final _datas = response.data;

        if (_datas is Map<String, dynamic>) {
          // Eğer _datas bir Map ise
          setState(() {
            _items = _datas;
          });
        } else {
          print("Beklenmeyen veri formatı: ${_datas.runtimeType}");
        }
      } else {
        throw Exception("Failed to load data sosyal");
      }
    } catch (e) {
      print("Hata: $e");
    } finally {
      changeloading();
    }
  }

  @override
  Widget build(BuildContext context) {
    var oran = MediaQuery.of(context);
    var genislik = oran.size.width;
    var uzunluk = oran.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).sosyalMedya,
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
          : _items != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "~ ${S.of(context).sosyalMedyaHesaplarimiz} ~",
                        style: TextStyle(
                          fontFamily: "Social",
                          fontWeight: FontWeight.bold,
                          fontSize: genislik / 18,
                        ),
                      ),
                      OtherText(
                        icon: "assets/icon/website.png",
                        genislik: genislik,
                        text: "Website",
                        etkilesim: GestureDetector(
                          onTap: () {
                            EasyLauncher.url(url: _items!['website']);
                          },
                        ),
                      ),
                      OtherText(
                        icon: "assets/icon/facebook.png",
                        genislik: genislik,
                        text: "Facebook",
                        etkilesim: GestureDetector(
                          onTap: () {
                            EasyLauncher.url(url: _items!['facebook']);
                          },
                        ),
                      ),
                      OtherText(
                        icon: "assets/icon/linkedln.png",
                        genislik: genislik,
                        text: "Linkedln",
                        etkilesim: GestureDetector(
                          onTap: () {
                            EasyLauncher.url(url: _items!['linkedin']);
                          },
                        ),
                      ),
                      OtherText(
                        icon: "assets/icon/instagram.png",
                        genislik: genislik,
                        text: "İnstagram",
                        etkilesim: GestureDetector(
                          onTap: () {
                            EasyLauncher.url(url: _items!['instagram']);
                          },
                        ),
                      ),
                      OtherText(
                        icon: "assets/icon/youtube.png",
                        genislik: genislik,
                        text: "Youtube",
                        etkilesim: GestureDetector(
                          onTap: () {
                            EasyLauncher.url(url: _items!['youtube']);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    'Veri bulunamadı.',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor500,
                    ),
                  ),
                ),
    );
  }
}

class OtherText extends StatelessWidget {
  const OtherText({
    super.key,
    required this.icon,
    required this.genislik,
    required this.text,
    required this.etkilesim,
  });

  final String icon;
  final double genislik;
  final String text;
  final GestureDetector etkilesim;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        etkilesim.onTap?.call();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Image.asset(icon, width: 50, height: 50),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: genislik / 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
