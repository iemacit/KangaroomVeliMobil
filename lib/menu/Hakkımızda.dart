import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kangaroom/model/hakkimizda_model.dart';
import 'package:kangaroom/theme.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'dart:convert';

import 'package:kangaroom/generated/l10n.dart';
import 'package:kangaroom/generated/l10n.dart';

class Hakkimizda extends StatefulWidget {
  final int okulid;

  Hakkimizda(this.okulid);

  @override
  State<Hakkimizda> createState() => _HakkimizdaState();
}

class _HakkimizdaState extends State<Hakkimizda> with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;
  List<HakkimizdaModel>? _items;
  bool _isloading = true; // Başlangıçta yükleniyor olarak ayarla
  late String baseurl;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
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
      final response = await Dio().get(baseurl);
      if (response.statusCode == 200) {
        final _datas = response.data;

        if (_datas is String) {
          final jsonData = json.decode(_datas);
          setState(() {
            if (jsonData is List) {
              _items =
                  jsonData.map((e) => HakkimizdaModel.fromJson(e)).toList();
            } else if (jsonData is Map<String, dynamic>) {
              _items = [HakkimizdaModel.fromJson(jsonData)];
            } else {
              throw Exception(
                  "Beklenmeyen JSON formatı: Liste veya nesne bekleniyordu.");
            }
          });
        } else if (_datas is Map<String, dynamic>) {
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
    } catch (e) {
      print("Hata: $e");
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
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var oran = MediaQuery.of(context);
    var genislik = oran.size.width;
    var uzunluk = oran.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).hakkimizda,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: S.of(context).hakkimizda,
        labels: [
          S.of(context).hakkimizda,
          S.of(context).misyon,
          S.of(context).vizyon
        ],
        icons: const [
          Icons.info_outline,
          Icons.flag,
          Icons.remove_red_eye_sharp
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: primaryColor500,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: primaryColor500,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController.index = value;
          });
        },
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
          : _items == null || _items!.isEmpty
              ? Center(child: Text(S.of(context).veriBulunamadi))
              : TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _motionTabBarController,
                  children: <Widget>[
                    Sayfa(
                      genislik: genislik,
                      uzunluk: uzunluk,
                      baslik: S.of(context).hakkimizda,
                      icerik: "${_items![0].hakkimizda}",
                      logo:
                          'http://37.148.210.227:8001/api/KangaroomFirma/logo/${widget.okulid}',
                    ),
                    Sayfa(
                      genislik: genislik,
                      uzunluk: uzunluk,
                      baslik: S.of(context).misyon,
                      icerik: "${_items![0].misyon}",
                      logo:
                          'http://37.148.210.227:8001/api/KangaroomFirma/logo/${widget.okulid}',
                    ),
                    Sayfa(
                      genislik: genislik,
                      uzunluk: uzunluk,
                      baslik: S.of(context).vizyon,
                      icerik: "${_items![0].vizyon}",
                      logo:
                          'http://37.148.210.227:8001/api/KangaroomFirma/logo/${widget.okulid}',
                    ),
                  ],
                ),
    );
  }
}

class Sayfa extends StatelessWidget {
  const Sayfa({
    super.key,
    required this.genislik,
    required this.uzunluk,
    required this.baslik,
    required this.icerik,
    required this.logo,
  });

  final double genislik;
  final double uzunluk;
  final String baslik;
  final String icerik;
  final String logo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: genislik / 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: uzunluk / 30),
              SizedBox(
                  width: genislik / 1.4,
                  child: CachedNetworkImage(
                      imageUrl: logo,
                      placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                      errorWidget: (context, url, error) => Container())),
              SizedBox(height: uzunluk / 20),
              Text(
                "~ $baslik ~",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: genislik / 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: uzunluk / 20),
              Text(
                icerik,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: genislik / 19,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
