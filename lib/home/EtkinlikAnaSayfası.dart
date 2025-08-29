import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kangaroom/home/EtkinlikSayfas%C4%B1.dart';
import 'package:kangaroom/model/etkinlik_model.dart';
import 'package:http/http.dart' as http;

import 'package:kangaroom/generated/l10n.dart';
//S.of(context).aidat

class EtkinlikAnaSayfasi extends StatefulWidget {
  final int ogrenciId;
  EtkinlikAnaSayfasi({required this.ogrenciId});

  @override
  _EtkinlikAnaSayfasiState createState() => _EtkinlikAnaSayfasiState();
}

class _EtkinlikAnaSayfasiState extends State<EtkinlikAnaSayfasi> {
  List<Etkinlik_Model> etkinlikbilgileri = [];
  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    EtkinlikleriGetir(widget.ogrenciId);
  }

  Future<void> EtkinlikleriGetir(int ogrenciId) async {
    try {
      var response = await http.get(Uri.parse(
          "http://37.148.210.227:8001/api/KangaroomEtkinlik/etkinlikler?ogrenciId=$ogrenciId"));
      if (response.statusCode == 200) {
        print("Ekinlikler kod  ${response.statusCode}");
        setState(() {
          etkinlikbilgileri = (jsonDecode(response.body) as List)
              .map((data) => Etkinlik_Model.fromJson(data))
              .toList();
          _isloading = false;
        });
      } else {
        setState(() {
          _isloading = false;
        });
        print("etlinlikler yüklenmedi");
      }
    } catch (e) {
      print(e);
      _isloading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).etkinlikAnaSayfasi,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
          : etkinlikbilgileri.isEmpty
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
                  padding: const EdgeInsets.all(16.0),
                  itemCount: etkinlikbilgileri.length,
                  itemBuilder: (context, index) {
                    Etkinlik_Model etkinlik = etkinlikbilgileri[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${S.of(context).etkinlikAdi}: ${etkinlik.ad}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                '${S.of(context).etkinlikTarihi}: ${etkinlik.tarih}'),
                            etkinlik.durum == 1
                                ? Text(
                                    '${S.of(context).onaylanmaDurumu}: onaylandı')
                                : etkinlik.durum == 2
                                    ? Text(
                                        '${S.of(context).onaylanmaDurumu}: rededildi')
                                    : Text(
                                        '${S.of(context).onaylanmaDurumu}: bekliyor'),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EtkinlikSayfasi(
                                        etkinlikId: etkinlik.id ?? 0,
                                        ogrenciId: widget.ogrenciId,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  S.of(context).goruntule,
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .redAccent, // Buton rengini değiştirdik
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
