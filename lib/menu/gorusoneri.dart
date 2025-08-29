import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kangaroom/all_import.dart';
import 'package:kangaroom/model/gorus_model.dart';

import 'package:kangaroom/generated/l10n.dart';

class Gorusoneri extends StatefulWidget {
  final int createUserId;
  final int OkulId;

  Gorusoneri({required this.createUserId, required this.OkulId});

  @override
  State<Gorusoneri> createState() => _GorusoneriState();
}

class _GorusoneriState extends State<Gorusoneri> {
  List<Gorus>? _items;
  bool _isloading = false;
  bool _isSubmitted = true;
  final _baseurl =
      "http://37.148.210.227:8001/api/KangaroomGorus";

  var key = GlobalKey<FormState>();
  var gorusoneri = TextEditingController();
  var baslik = TextEditingController();

  void changeloading() {
    setState(() {
      _isloading = !_isloading;
    });
  }

  Future<void> _fetchitems(int veliId) async {
    try {
      changeloading();
      final response = await Dio().get(
          "http://37.148.210.227:8001/api/KangaroomGorus/gorus/$veliId");
      if (response.statusCode == 200) {
        final _datas = response.data;
        if (_datas is List) {
          print("dddddddddddddddddddddddddddf");
          setState(() {
            _items = _datas.map((e) => Gorus.fromJson(e)).toList();
          });
        }
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      changeloading();
    }
  }

  Future<void> additems(Gorus gorus) async {
    try {
      changeloading();
      final responsepost = await Dio().post(
        _baseurl,
        data: gorus.toJson(),
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      if (responsepost.statusCode == 200) {
        print("Başarılı 200");
      } else {
        throw Exception("Failed to load data 400");
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      changeloading();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchitems(widget.createUserId);
    print('createUserId: ${widget.createUserId}, okulId: ${widget.OkulId}');
  }

  @override
  Widget build(BuildContext context) {
    var oran = MediaQuery.of(context);
    var genislik = oran.size.width;
    var uzunluk = oran.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).gorusVeOneri,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: _isloading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCircle(
                      color: primaryColor500,
                      size: 50.0,
                    ),
                    SizedBox(height: 20),
                    Text(
                      S.of(context).verilerYukleniyor,
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryColor500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header Card
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.feedback_outlined,
                              size: 50,
                              color: Colors.white,
                            ),
                            SizedBox(height: 15),
                            Text(
                              S.of(context).institutionResponse,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Response Card (if exists)
                    if (_isSubmitted && _items != null && _items!.isNotEmpty)
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.green.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Kurum Yanıtı",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                _items![0].cevap,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    SizedBox(height: 20),
                    
                    // Form Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Yeni Görüş/Öneri",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(height: 20),
                            
                            TextFormField(
                              controller: baslik,
                              decoration: InputDecoration(
                                labelText: "Başlık",
                                prefixIcon: Icon(Icons.title, color: primaryColor500),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: primaryColor500, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Başlık boş bırakılamaz";
                                }
                                return null;
                              },
                            ),
                            
                            SizedBox(height: 20),
                            
                            TextFormField(
                              controller: gorusoneri,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: S.of(context).gorusVeOneri,
                                prefixIcon: Icon(Icons.feedback, color: primaryColor500),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: primaryColor500, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Görüş ve öneriler boş bırakılamaz";
                                }
                                return null;
                              },
                            ),
                            
                            SizedBox(height: 25),
                            
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (gorusoneri.text.isNotEmpty &&
                                      baslik.text.isNotEmpty) {
                                    final model = Gorus(
                                      id: 0,
                                      tur: 2,
                                      baslik: baslik.text,
                                      icerik: gorusoneri.text,
                                      createUserId: widget.createUserId,
                                      createDate: DateTime.now().toIso8601String(),
                                      okulId: widget.OkulId,
                                      cevap: "Cevap Bekleniyor...",
                                    );
                                    await additems(model);
                                    gorusoneri.clear();
                                    baslik.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          S.of(context).feedbackReceived,
                                        ),
                                        backgroundColor: Colors.green,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                    await _fetchitems(widget.createUserId);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Lütfen tüm alanları doldurunuz",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        action: SnackBarAction(
                                          label: "Tamam",
                                          textColor: Colors.white,
                                          onPressed: () {},
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send, color: Colors.white, size: 20),
                                    SizedBox(width: 10),
                                    Text(
                                      S.of(context).gonder,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor500,
                                  shadowColor: Colors.black,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
