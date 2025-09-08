import 'package:dio/dio.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kangaroom/all_import.dart';
import '../model/DersProgramı.dart';

import 'package:kangaroom/generated/l10n.dart';
//S.of(context).aidat

class DersProgrami extends StatefulWidget {
  final int okulId;
  final int ogrenciId;

  DersProgrami({required this.okulId, required this.ogrenciId});

  @override
  State<DersProgrami> createState() => _DersProgramiState();
}

class _DersProgramiState extends State<DersProgrami> {
  List<DersModel>? _items;
  bool _isloading = false;
  late String _baseurl; // Declare without initialization

  @override
  void initState() {
    super.initState();
    _baseurl =
        "http://37.148.210.227:8001/api/KangaroomDersProgramPdf/DersProgram/${widget.okulId}"; // Initialize here
    _fetchitems();
    _sendMufredatOkundu(widget.ogrenciId);
  }

  void changeloading() {
    setState(() {
      _isloading = !_isloading;
    });
  }
  Future<void> _sendMufredatOkundu(int ogrenciId) async {
    try {
        await Dio().post(
          "http://37.148.210.227:8001/api/KangaroomDersProgramPdf/mufredatOkundu/$ogrenciId",
        );
      } catch (e) {
        print("Error sending mufredatOkundu: $e");
      }
  }
  Future<void> _fetchitems() async {
    try {
      changeloading();
      final response = await Dio().get(_baseurl);

      if (response.statusCode == 200) {
        final _datas = response.data;

        if (_datas is List) {
          setState(() {
            _items = _datas.map((e) => DersModel.fromJson(e)).toList();
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Hatalı işlem: $e");
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
          S.of(context).dersProgrami,
          style: TextStyle(
            color: Colors.white,
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
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
          : (_items == null || _items!.isEmpty)
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
                  itemCount: _items?.length,
                  itemBuilder: (context, indeks) {
                    return GestureDetector(
                      onTap: () {
                        EasyLauncher.url(
                            url:
                                "http://37.148.210.227:8001/api/KangaroomDersProgramPdf/download/${_items?[indeks].id ?? ''} ");
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
                                  " ${_items?[indeks].fileDate ?? ''}",
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
                ),
    );
  }
}
