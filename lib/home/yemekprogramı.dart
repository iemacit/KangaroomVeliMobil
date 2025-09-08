import 'package:dio/dio.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kangaroom/model/YemekProgramı.dart';

import 'homescreen.dart';

import 'package:kangaroom/generated/l10n.dart';
//S.of(context).aidat

class YemekProgrami extends StatefulWidget {
  final int okulId;
  final int ogrenciId;
  YemekProgrami({required this.okulId, required this.ogrenciId});

  @override
  State<YemekProgrami> createState() => _YemekProgramiState();
}

class _YemekProgramiState extends State<YemekProgrami> {
  List<YemekModel>? _items;
  bool _isloading = false;
  late String _baseurl;

  @override
  void initState() {
    super.initState();
    _baseurl =
        "http://37.148.210.227:8001/api/KangaroomYemekProgramPdf/DersProgram/${widget.okulId}";
    _fetchItems();
    _sendYemekOkundu(widget.ogrenciId);
  }

  void changeLoading() {
    setState(() {
      _isloading = !_isloading;
    });
  }
  Future<void> _sendYemekOkundu(int ogrenciId) async {
  try {
      await Dio().post(
        "http://37.148.210.227:8001/api/KangaroomYemekProgramPdf/yemekListesiOkundu/$ogrenciId",
      );
    } catch (e) {
      print("Error sending yemekOkundu: $e");
    }
  }
  Future<void> _fetchItems() async {
    try {
      changeLoading();
      final response = await Dio().get(_baseurl);

      if (response.statusCode == 200) {
        final _datas = response.data;

        if (_datas is List) {
          setState(() {
            _items = _datas.map((e) => YemekModel.fromJson(e)).toList();
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Hatalı işlem: $e");
    } finally {
      changeLoading();
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
          S.of(context).yemekProgrami,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
          : _items != null
              ? ListView.builder(
                  itemCount: _items?.length,
                  itemBuilder: (context, indeks) {
                    return GestureDetector(
                      onTap: () {
                        EasyLauncher.url(
                            url: "${_items?[indeks].dosyaYolu ?? ''}");
                      },
                      child: SizedBox(
                        height: uzunluk / 8,
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${_items?[indeks].fileName ?? ''}",
                                    style: TextStyle(
                                      fontSize: genislik / 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  " ${_items?[indeks].hafta ?? ''}",
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
                    );
                  },
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
}
