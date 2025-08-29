import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:kangaroom/model/randevu_model.dart';
import 'package:kangaroom/theme.dart';
import 'package:http/http.dart' as http;
import 'package:kangaroom/generated/l10n.dart';

class Randevu extends StatefulWidget {
  final int VeliId;

  Randevu({required this.VeliId});

  @override
  State<Randevu> createState() => _RandevuState();
}

class _RandevuState extends State<Randevu> {
  List<RandevuModel>? _items;
  bool _isLoading = false;
  String? _errorMessage;
  final veilMesajContoller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> _fetchItems() async {
    try {
      _changeLoading();
      final response = await Dio().get(
        'http://37.148.210.227:8001/api/KangaroomRandevu/randevuogretmen/${widget.VeliId}',
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        var _datas = response.data;
        if (_datas is List) {
          setState(() {
            _items = _datas.map((e) {
              DateTime parsedDate = DateTime.parse(e['tarih']);
              String formattedDate =
                  DateFormat('dd-MM-yyyy').format(parsedDate);
              return RandevuModel.fromJson(e)..tarih = formattedDate;
            }).toList();
          });
        } else {
          setState(() {
            _errorMessage = 'Beklenmeyen veri formatı: ${response.data}';
          });
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = S.of(context).noAppointment;
          _items = [];
        });
      } else {
        throw Exception(
            "Randevu verileri yüklenemedi, durum kodu: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Veri yükleme hatası: $e";
      });
    } finally {
      _changeLoading();
    }
  }

  Future<void> updateDurum(int id, int yeniDurum) async {
    final url = Uri.parse(
        'http://37.148.210.227:8001/api/KangaroomRandevu/$id/durum/-${veilMesajContoller.text}');
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(yeniDurum),
      );

      if (response.statusCode == 204) {
        _fetchItems();
      } else {
        setState(() {
          _errorMessage =
              '${S.of(context).guncellemeHatasi}: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'İstek gönderilemedi: $e';
      });
    }
  }

  // Future<void> _deleteItem(int randevuID) async {
  //   try {
  //     _changeLoading();
  //     final url = Uri.parse(
  //         'http://37.148.210.227:8001/api/KangaroomRandevu/$randevuID');
  //     final response = await http.delete(url);

  //     if (response.statusCode == 204) {
  //       setState(() {
  //         _items?.removeWhere((item) => item.randevuID == randevuID);
  //       });
  //     } else {
  //       throw Exception("Randevu silinemedi, kod: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = "Silme hatası: $e";
  //     });
  //   } finally {
  //     _changeLoading();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var oran = MediaQuery.of(context);
    var genislik = oran.size.width;
    var uzunluk = oran.size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(S.of(context).randevular, style: titleTextStyle),
        centerTitle: true,
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
                    _errorMessage ??
                        S.of(context).sizeTanimliRandevuBulunmamaktadir,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: genislik / 60),
                  child: SingleChildScrollView(
                    child: Column(
                      children: _items!
                          .map((item) => RandevuWidget(
                                genislik: genislik,
                                uzunluk: uzunluk,
                                ogretmen_ad:
                                    "${item.ogretmenAd} ${item.ogretmenSoyad}",
                                tarih: item.tarih!,
                                saat: item.saat ?? '',
                                ogrenciAd:
                                    "${item.ogrenciAd} ${item.ogrenciSoyad}",
                                aciklama: item.icerik ?? '',
                                onayDurum: item.durum,
                                RandevuId: item.randevuID,
                                onUpdateDurum: updateDurum,
                                //onDeleteItem: _deleteItem,
                                veilMesaj: veilMesajContoller,
                              ))
                          .toList(),
                    ),
                  ),
                ),
    );
  }
}

class RandevuWidget extends StatelessWidget {
  const RandevuWidget({
    super.key,
    required this.genislik,
    required this.uzunluk,
    required this.ogretmen_ad,
    required this.ogrenciAd,
    required this.tarih,
    required this.saat,
    required this.aciklama,
    required this.onayDurum,
    required this.RandevuId,
    required this.onUpdateDurum,
    //required this.onDeleteItem,
    this.veilMesaj,
  });

  final double genislik;
  final double uzunluk;
  final String ogretmen_ad;
  final String ogrenciAd;
  final String tarih;
  final String saat;
  final String aciklama;
  final int? onayDurum;
  final int? RandevuId;
  final Function(int, int) onUpdateDurum;
  //final Future<void> Function(int) onD eleteItem;
  final TextEditingController? veilMesaj;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(genislik / 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: " $tarih   ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: genislik / 20,
                      ),
                    ),
                    WidgetSpan(
                      child: Icon(Icons.access_time,
                          color: Colors.black, size: genislik / 20),
                    ),
                    TextSpan(
                      text: "   $saat",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: genislik / 20,
                      ),
                    ),
                    // TextSpan(
                    //   text: "\n$ogrenciAd",
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: genislik / 18,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Text(
              aciklama,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: genislik / 20,
              ),
            ),
            SizedBox(height: uzunluk / 70),
            if (onayDurum == 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => onUpdateDurum(RandevuId!, 1),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text(
                      S.of(context).onayla,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(S.of(context).redsebebiyaz),
                            content: TextField(controller: veilMesaj),
                            actions: [
                              TextButton.icon(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Icon(Icons.cancel),
                                label: Text(S.of(context).iptal),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  onUpdateDurum(RandevuId!, 2);
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.check),
                                label: Text(S.of(context).tamam),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(
                      S.of(context).reddet,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () async {
                  //     final confirmDelete = await showDialog<bool>(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: Text(S.of(context).silmeIslemi),
                  //           content: Text(S.of(context).eminMisiniz),
                  //           actions: [
                  //             TextButton(
                  //               onPressed: () =>
                  //                   Navigator.of(context).pop(false),
                  //               child: Text(S.of(context).iptal),
                  //             ),
                  //             TextButton(
                  //               onPressed: () =>
                  //                   Navigator.of(context).pop(true),
                  //               child: Text(S.of(context).evet),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //     if (confirmDelete == true) {
                  //       await onDeleteItem(RandevuId!);
                  //     }
                  //   },
                  //   icon: Icon(Icons.delete, color: Colors.black),
                  // ),
                ],
              ),
            Text(
              onayDurum == 1
                  ? S.of(context).onaylandi
                  : onayDurum == 2
                      ? S.of(context).reddedildi
                      : '',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: onayDurum == 1
                    ? Colors.green
                    : onayDurum == 2
                        ? Colors.red
                        : Colors.orange,
              ),
            ),
            SizedBox(height: uzunluk / 70),
          ],
        ),
      ),
    );
  }
}
