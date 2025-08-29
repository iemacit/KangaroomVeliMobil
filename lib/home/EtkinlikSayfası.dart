import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kangaroom/home/etkinlik.dart';
import 'package:kangaroom/model/etkinlik_model.dart';
import 'package:kangaroom/model/etkinlikdetay_model.dart';

import 'package:kangaroom/generated/l10n.dart';
//S.of(context).aidat

class EtkinlikSayfasi extends StatefulWidget {
  final int etkinlikId;
  final int ogrenciId;

  EtkinlikSayfasi({
    required this.etkinlikId,
    required this.ogrenciId,
  });

  @override
  _EtkinlikSayfasiState createState() => _EtkinlikSayfasiState();
}

class _EtkinlikSayfasiState extends State<EtkinlikSayfasi> {
  File? dekontDosyasi;
  bool dekontYuklendi = false;
  bool islemOnaylandi = false;
  bool islemReddedildi = false;
  List<EtkinlikDetay_model> etkinlik = [];
  bool isLoading = true;

  Future<void> sendEventData() async {
    // API URL
    String url = 'http://37.148.210.227:8001/api/KangaroomEtkinlik';

    // Gönderilecek veri (JSON)
    Map<String, dynamic> requestData = {
      "id": 0,
      "etkinlikId": widget.etkinlikId,
      "durum": 0,
      "ogrenciId": widget.ogrenciId,
      "tarih": DateTime.now().toIso8601String(),
      "dekont": null
    };

    try {
      // POST isteği gönderme
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      // İsteğin sonucu
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Veri başarıyla gönderildi.');
        setState(() {
          dekontYuklendi = true;
        });
      } else {
        print('İstek başarısız oldu. Durum kodu: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  Future<void> EtkinlikDetayGetir(int ogrenciId, int etkinlikId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomEtkinlik/etkinlikdetay?ogrenciId=$ogrenciId&etkinlikId=$etkinlikId'));

      if (response.statusCode == 200) {
        print("Ekinlikler detay  ${response.statusCode}");
        setState(() {
          etkinlik = (jsonDecode(response.body) as List)
              .map((data) => EtkinlikDetay_model.fromJson(data))
              .toList();
          isLoading = false;
          if (etkinlik.isNotEmpty) {
            print('etkinlik[0].resimPath: ${etkinlik[0].resimPath}');
          }
        });
      } else {
        throw Exception('Duyuruları yüklerken hata: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Duyuruları yüklerken hata: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  _reddet() {
    etkinlikdurum(widget.ogrenciId, widget.etkinlikId, 2);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('etkinlik reddedildi'),
    //     backgroundColor: Colors.red,
    //   ),
    // );
  }

  _onayla() {
    etkinlikdurum(widget.ogrenciId, widget.etkinlikId, 1);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('etkinlik onaylandı '),
    //     backgroundColor: Colors.green,
    //   ),
    // );
  }

  Future<void> etkinlikdurum(int ogrenciId, int etkinlikId, int durum) async {
    final response = await http.get(Uri.parse(
        'http://37.148.210.227:8001/api/KangaroomEtkinlik/etkinlikler/onay?ogrenciId=$ogrenciId&etkinlikId=$etkinlikId&durum=$durum'));

    if (response.statusCode == 500) {
      print("Ekinlikler onay  ${response.statusCode}");
      setState(() {
        etkinlik[0].durum = durum;
      });
    } else {
      throw Exception('Ekinlikler onay hata: ${response.reasonPhrase}');
    }
  }

  _onayladekont() {
    _uploadDekont(dekontDosyasi!, widget.etkinlikId, widget.ogrenciId);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('etkinlik onaylandı '),
    //     backgroundColor: Colors.green,
    //   ),
    // );
  }

  Future<void> _pdfYukle() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      dekontDosyasi = File(result.files.single.path!);
      print("*******************************deokont deçildi ");
      setState(() {
        dekontYuklendi = true;
      });
      sendEventData();
    }
  }

  Future<void> _uploadDekont(File file, int etkinlikId, int ogrenciId) async {
    setState(() {
      isLoading = true;
    });
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://37.148.210.227:8001/api/KangaroomEtkinlik/$etkinlikId/$ogrenciId/UploadDekont'));

    request.files.add(await http.MultipartFile.fromPath('Dekont', file.path));
    try {
      final response = await request.send();
      if (response.statusCode == 204) {
        print(
            "****************************dekont yükle  ${response.statusCode}");
        setState(() {
          dekontYuklendi = true;

          isLoading = false;

          etkinlik[0].durum = 1;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content:
        //         Text('**************************Dekont başarıyla yüklendi'),
        //     backgroundColor: Colors.green,
        //   ),
        // );
      } else {
        print(
            "************************dekont yüklenmedi   ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dekont yükleme başarısız oldu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("****************************dekont yükleme e $e");
    }
  }

  @override
  void initState() {
    super.initState();
    print("etkinlik ıd  ${widget.etkinlikId}");
    print("etkinlik ogrenci ıd  ${widget.ogrenciId}");
    EtkinlikDetayGetir(widget.ogrenciId, widget.etkinlikId);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).etkinlikSayfasi,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoading
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
          : (etkinlik.isEmpty)
              ? Center(
                  child: Text(
                    S.of(context).veriBulunamadi,
                    style: TextStyle(fontSize: 25),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: etkinlik[0].resimPath != null &&
                                      etkinlik[0].resimPath!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: etkinlik[0].resimPath!,
                                      height: screenWidth,
                                      width: screenWidth,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => Center(
                                        child: SpinKitFadingCircle(
                                          color: Theme.of(context).primaryColor,
                                          size: 50.0,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height: screenWidth,
                                        width: screenWidth,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.image_not_supported,
                                            size: 64, color: Colors.grey),
                                      ),
                                    )
                                  : Container(
                                      height: screenWidth,
                                      width: screenWidth,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.image_not_supported,
                                          size: 64, color: Colors.grey),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: Text(
                            "${etkinlik[0].ad}",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 16),
                        //_buildInfoCard(context, 'Öğretmen', ogretmenAdi),
                        Container(
                          width: screenWidth,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "${etkinlik[0].aciklama}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                        _buildInfoCard(context, S.of(context).tarih,
                            "${etkinlik[0].tarih}"),
                        _buildInfoCard(
                            context, S.of(context).saat, "${etkinlik[0].saat}"),
                        if (int.parse("${etkinlik[0].tutar}") > 0) ...[
                          _buildInfoCard(context, S.of(context).ucret,
                              '₺${etkinlik[0].tutar}'),
                          _buildInfoCard(context, S.of(context).iban,
                              "${etkinlik[0].iban}"),
                        ],
                        SizedBox(height: 16),
                        // etkinlik durum  bekiliyor
                        if (etkinlik[0].durum == 0) ...[
                          if (int.parse("${etkinlik[0].tutar}") > 0) ...[
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: ((etkinlik[0].durum == 1) ||
                                        (etkinlik[0].durum == 0))
                                    ? _pdfYukle
                                    : null,
                                icon: Icon(Icons.upload_file),
                                label: Text(S.of(context).dekontYukle),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      (islemOnaylandi || islemReddedildi)
                                          ? Colors.grey
                                          : null,
                                  disabledForegroundColor:
                                      Colors.grey.withOpacity(0.38),
                                  disabledBackgroundColor:
                                      Colors.grey.withOpacity(0.12),
                                ),
                              ),
                            ),
                            if (dekontYuklendi && dekontDosyasi != null) ...[
                              SizedBox(height: 16),
                              Text(
                                  '${S.of(context).yuklenenDekont}: $dekontDosyasi',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ],
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: (!islemOnaylandi &&
                                        !islemReddedildi &&
                                        (int.parse("${etkinlik[0].tutar}") ==
                                                0 ||
                                            !dekontYuklendi))
                                    ? _reddet
                                    : null,
                                icon: Icon(Icons.cancel),
                                label: Text(S.of(context).reddet),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (islemReddedildi ||
                                          (dekontYuklendi &&
                                              int.parse(
                                                      "${etkinlik[0].tutar}") >
                                                  0))
                                      ? Colors.grey
                                      : Colors.red,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: (int.parse("${etkinlik[0].tutar}") ==
                                        0)
                                    ? _onayla
                                    : (int.parse("${etkinlik[0].tutar}") > 0 &&
                                                dekontYuklendi) &&
                                            !islemOnaylandi &&
                                            !islemReddedildi
                                        ? _onayladekont
                                        : null,
                                icon: Icon(Icons.check_circle),
                                label: Text(S.of(context).onayla),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: islemOnaylandi
                                      ? Colors.grey
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ]
                        //etkinlik durum onaylandı
                        else if (etkinlik[0].durum == 1) ...[
                          Center(
                            child: Text(
                              S.of(context).onaylandi,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ]
                        //etkinlik durum reddedildi
                        else if (etkinlik[0].durum == 2) ...[
                          Center(
                            child: Text(
                              S.of(context).katilimReddedildi,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              content,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
