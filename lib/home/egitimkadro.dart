import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kangaroom/all_import.dart';
import 'package:kangaroom/model/egitimkadro_model.dart';

import 'package:kangaroom/generated/l10n.dart';

class Egitimkadro extends StatefulWidget {
  final int okulId;

  Egitimkadro(this.okulId);

  @override
  State<Egitimkadro> createState() => _EgitimkadroState();
}

class _EgitimkadroState extends State<Egitimkadro> {
  List<Egitimkadromodel>? items;
  bool isloading = false;

  String get baseurl =>
      "http://37.148.210.227:8001/api/KangaroomOgrenci/Kadro/${widget.okulId}";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchitems();
  }

  void _changeloading() {
    isloading = !isloading;
  }

  Future<void> _fetchitems() async {
    try {
      _changeloading();

      final response = await Dio().get(baseurl);

      if (response.statusCode == 200) {
        final _datas = response.data;

        if (_datas is List) {
          setState(() {
            items = _datas.map((e) => Egitimkadromodel.fromJson(e)).toList();
          });
        }
      } else {
        throw Exception("failed load data hakkımızda ");
      }

      _changeloading();
    } catch (e) {
      print("hata egitimkadro $e");
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
          S.of(context).egitimKadrosu,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isloading
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
          : ListView.builder(
              itemCount: items?.length,
              itemBuilder: (context, indeks) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                        height: uzunluk / 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "~ ${items?[indeks].ad}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: genislik / 20),
                                ),
                                SizedBox(
                                  width: genislik / 10,
                                ),
                                Text(
                                  "${items?[indeks].soyad} ~",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: genislik / 20),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: uzunluk / 80,
                            ),
                            Text(
                              "Eğitim : ${items?[indeks].egitim}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: genislik / 25),
                            ),
                            SizedBox(
                              height: uzunluk / 90,
                            ),
                            Text(
                              "~ ${items?[indeks].tecrube}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: genislik / 25),
                            ),
                          ],
                        )),
                  ),
                );
              },
            ),
    );
  }
}
