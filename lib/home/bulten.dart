import 'package:dio/dio.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kangaroom/all_import.dart';
import 'package:kangaroom/model/bulten_model.dart';

import 'package:kangaroom/generated/l10n.dart';
//S.of(context).aidat

class Bulten extends StatefulWidget {
  int okulid;

  Bulten(this.okulid);

  @override
  State<Bulten> createState() => _BultenState();
}

class _BultenState extends State<Bulten> {
  List<BultenModel>? _items;
  late String _baseurl;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _baseurl =
        "http://37.148.210.227:8001/api/KangaroomBulten/${widget.okulid}";
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await Dio().get(_baseurl);
      if (response.statusCode == 200) {
        final _datas = response.data;

        if (_datas is List) {
          setState(() {
            _items = _datas.map((e) => BultenModel.fromJson(e)).toList();
          });
        }
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error loading data: $e");
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
          S.of(context).bulten,
          style: TextStyle(
            color: Colors.white,
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
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
                                "http://37.148.210.227:8001/api/KangaroomBulten/pdf/${_items?[indeks].id ?? ''} ");
                      },
                      child: SizedBox(
                        height: uzunluk / 10,
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
                                  child: Row(
                                    children: [
                                      Text(
                                        "${_items?[indeks].aylik ?? ''}",
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: genislik / 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: genislik / 25,
                                      ),
                                      if ((_items?[indeks].hafta ?? 0) != 0)
                                        Text(
                                          "(${_items?[indeks].hafta}.${S.of(context).hafta})",
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: genislik / 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      SizedBox(
                                        width: genislik / 10,
                                      ),
                                      Text(
                                        " ~ ${_items?[indeks].yil ?? ''}",
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: genislik / 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
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
