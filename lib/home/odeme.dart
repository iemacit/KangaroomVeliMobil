import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kangaroom/theme.dart';

import 'package:kangaroom/generated/l10n.dart';

class OdemePage extends StatefulWidget {
  final int ogrenciId;

  OdemePage({required this.ogrenciId});

  @override
  _OdemePageState createState() => _OdemePageState();
}

class _OdemePageState extends State<OdemePage> {
  bool _isloading = false;
  List<OdemeCardData> odemeCards = [];

  void chanceloading() {
    setState(() {
      _isloading = !_isloading;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadOdemeData(widget.ogrenciId);
  }

  Future<void> _loadOdemeData(int ogrenciId) async {
    try {
      chanceloading();
      final response = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomAidat/getAidatByOgrenci/$ogrenciId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        odemeCards = data.map((item) {
          return OdemeCardData(
            item['id'],
            item['ogrenciId'],
            item['yıl'].toString(),
            getMonthName(int.parse(item['donem'].toString())),
            item['aidat'].toString(),
            formatDate(item['odemeTarihi'].toString().substring(0, 10)),
            item['kirtasiye'].toString(),
            item['mobil'].toString(),
            item['odemeTutari'] > 0,
            item['aciklama'].toString(),
            item['toplam'].toDouble(),
          );
        }).toList();

        setState(() {});
      } else {
        print("Hata: ${response.statusCode}");
      }
      chanceloading();
    } catch (e) {
      print("Ödeme verilerini yüklerken hata: $e");
      chanceloading();
    }
  }

  String formatDate(String date) {
    List<String> parts = date.split('-');
    if (parts.length != 3) {
      return date;
    }
    String monthName = getMonthName(int.parse(parts[1]));
    return '${parts[2]} $monthName ${parts[0]}';
  }

  String getMonthName(int month) {
    List<String> monthNames = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
    if (month < 1 || month > 12) {
      return 'Bilinmeyen';
    }
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(
          color: colorWhite,
        ),
        title: Text(
          S.of(context).aidat,
          style: titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: _isloading
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
          : odemeCards.isEmpty
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
                  itemCount: odemeCards.length,
                  itemBuilder: (context, index) {
                    return OdemeCard(odemeCards[index]);
                  },
                ),
    );
  }
}

class OdemeCardData {
  final int id;
  final int ogrenciId;
  final String yil;
  final String donem;
  final String aidat;
  final String odemeTarihi;
  final String kirtasiye;
  final String mobil;
  final bool odemeYapildi;
  final String aciklama;
  final double toplamTutar;

  OdemeCardData(
    this.id,
    this.ogrenciId,
    this.yil,
    this.donem,
    this.aidat,
    this.odemeTarihi,
    this.kirtasiye,
    this.mobil,
    this.odemeYapildi,
    this.aciklama,
    this.toplamTutar,
  );
}

class OdemeCard extends StatelessWidget {
  final OdemeCardData data;

  OdemeCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.payment,
                          color: Theme.of(context).primaryColor),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${data.yil} - ${data.donem}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${S.of(context).toplamTutar}: ${data.toplamTutar} TL',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${S.of(context).odemeTarihi}: ${data.odemeYapildi ? data.odemeTarihi : S.of(context).odenmemis}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                data.odemeYapildi ? Icons.check_circle : Icons.cancel,
                color: data.odemeYapildi ? Colors.green : Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
        children: <Widget>[
          ListTile(
            title: Text('${S.of(context).yil}: ${data.yil}',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text('${S.of(context).ay}: ${data.donem}',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text(
                '${S.of(context).odemeTarihi}: ${data.odemeYapildi ? data.odemeTarihi : S.of(context).odenmemis}',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text('${S.of(context).aidat}: ${data.aidat} TL',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text('${S.of(context).kirtasiye}: ${data.kirtasiye} TL',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text('${S.of(context).mobil}: ${data.mobil} TL',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text('${S.of(context).toplamTutar}: ${data.toplamTutar} TL',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text('${S.of(context).aciklama}: ${data.aciklama}',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
