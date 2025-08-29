import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../model/karne_model.dart';
import 'package:kangaroom/theme.dart';

import 'package:kangaroom/generated/l10n.dart';

//S.of(context).aidat
class Karne extends StatefulWidget {
  final int ogrenciId;
  const Karne({super.key, required this.ogrenciId});

  @override
  State<Karne> createState() => _KarneState();
}

class _KarneState extends State<Karne> {
  bool _isloading = true;
  bool bilgiVarMi = true;
  List<KarneModel> karnebilgileri = [];
  List<KarneModel> ogrenciKarnesi = [];
  int? secilenDonem;
  List<int> donem = [];

  @override
  void initState() {
    super.initState();
    karnebilgileriGetir(widget.ogrenciId);
    print("*************** ${widget.ogrenciId}");
  }

  Future<void> karnebilgileriGetir(int ogrenciId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomKarne/KarneOku/$ogrenciId'));
      if (response.statusCode == 200) {
        setState(() {
          karnebilgileri = (jsonDecode(response.body) as List)
              .map((data) => KarneModel.fromJson(data))
              .toList();

          // Extract unique terms
          donem =
              karnebilgileri.map((k) => k.donem).toSet().cast<int>().toList();
          if (donem.isNotEmpty) {
            secilenDonem =
                donem.reduce((a, b) => a > b ? a : b); // en büyük dönemi al

            bilgiVarMi = false;
            ogrenciKarnesi =
                karnebilgileri.where((k) => k.donem == secilenDonem).toList();
          }
          _isloading = false;
        });
      } else {
        setState(() {
          _isloading = false;
        });
        throw Exception('Failed to load student');
      }
    } catch (e) {
      print(e);
      _isloading = false;
    }
  }

  // Puan ve emoji eşleşmesi
  Map<int, String> emoji = {
    1: "☹️",
    2: "😐",
    3: "😊",
    4: "❤️",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          S.of(context).karne,
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
          : bilgiVarMi
              ? Center(
                  child: Text(
                    S.of(context).karneBilgisiYok,
                    style: TextStyle(fontSize: 25),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              S.of(context).donemSecin,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            DropdownButton<int>(
                              value: secilenDonem,
                              onChanged: (int? newValue) {
                                setState(() {
                                  secilenDonem = newValue!;
                                  ogrenciKarnesi = karnebilgileri
                                      .where((k) => k.donem == secilenDonem)
                                      .toList();
                                });
                              },
                              items:
                                  donem.map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child:
                                      Text("${value}. ${S.of(context).donem}"),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: ogrenciKarnesi.length,
                        itemBuilder: (context, index) {
                          KarneModel karneModel = ogrenciKarnesi[index];
                          return Card(
                            margin: EdgeInsets.all(3.0),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${S.of(context).tur}: ${karneModel.gelisimTurAd}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${S.of(context).gelisimAlani}: ${karneModel.gelisimAd}',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: emoji.keys.map<Widget>((puan) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: karneModel.puan == puan
                                              ? Colors.green.withOpacity(0.5)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(180.0),
                                        ),
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          emoji[puan]!,
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
