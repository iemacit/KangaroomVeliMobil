import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kangaroom/generated/l10n.dart';
import 'package:kangaroom/model/anket_model.dart';
import 'package:http/http.dart' as http;
import 'package:kangaroom/theme.dart';

class AnketSayfasi extends StatefulWidget {
  final int VeliId;
  const AnketSayfasi({super.key, required this.VeliId});

  @override
  State<AnketSayfasi> createState() => _AnketSayfasiState();
}

class _AnketSayfasiState extends State<AnketSayfasi> {
  List<Anket> anketler = [];
  bool _isloading = true;
  bool anketVarMi = false;

  String duzeltMetin(String metin) {
    if (metin.isEmpty) return metin;
    
    // Özel metin değişiklikleri
    String duzeltilmis = metin
        .replaceAll('Bu anket okulumuz ile kurmuş olduğunuz iletişimden', 'Bu anket, okulumuzun sizinle kurduğu iletişimden memnuniyetinizi ölçmek amacıyla hazırlanmıştır.');
    
    return duzeltilmis;
  }

  @override
  void initState() {
    super.initState();
    fetchAnketler(widget.VeliId);
  }

  Future<void> fetchAnketler(int veliId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomAnket/$veliId'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);

        Map<int, List<Soru>> groupedSorular = {};
        Map<int, Map<String, dynamic>> anketData = {};

        jsonResponse.forEach((anketJson) {
          int anketId = anketJson['id'];
          Soru soru = Soru.fromJson(anketJson);

          if (!groupedSorular.containsKey(anketId)) {
            groupedSorular[anketId] = [];
            anketData[anketId] = anketJson;
          }
          groupedSorular[anketId]!.add(soru);
        });

        List<Anket> anketler = groupedSorular.entries.map((entry) {
          int anketId = entry.key;
          List<Soru> sorular = entry.value;
          return Anket.fromJson(anketData[anketId]!, sorular);
        }).toList();

        setState(() {
          this.anketler = anketler;
          _isloading = false;
          anketVarMi = anketler.isNotEmpty;
        });
      } else {
        setState(() {
          _isloading = false;
          anketVarMi = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anket bulunamadı.')),
        );
      }
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veri yüklenemedi: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(S.of(context).anket, style: titleTextStyle),
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
                  const SizedBox(height: 10),
                  Text(
                    S.of(context).verilerYukleniyor,
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            )
          : !anketVarMi
              ? Center(
                  child: Text(
                    S.of(context).veriBulunamadi,
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).primaryColor),
                  ),
                )
              : ListView.builder(
                  itemCount: anketler.length,
                  itemBuilder: (context, index) {
                    final anket = anketler[index];
                    return Card(
                      margin: const EdgeInsets.all(3.0),
                      child: ListTile(
                        title: Text(
                          duzeltMetin(anket.anketAd),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          duzeltMetin(anket.aciklama),
                          style: const TextStyle(fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AnketDetailPage(
                                anket: anket,
                                veliId: widget.VeliId,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class AnketDetailPage extends StatefulWidget {
  final Anket anket;
  final int veliId;

  const AnketDetailPage({super.key, required this.anket, required this.veliId});

  @override
  State<AnketDetailPage> createState() => _AnketDetailPageState();
}

class _AnketDetailPageState extends State<AnketDetailPage> {
  Map<int, String?> selectedCevaplar = {};
  bool loading = false;

  String duzeltMetin(String metin) {
    if (metin.isEmpty) return metin;
    
    // Özel metin değişiklikleri
    String duzeltilmis = metin
        .replaceAll('Bu anket okulumuz ile kurmuş olduğunuz iletişimden', 'Bu anket, okulumuzun sizinle kurduğu iletişimden memnuniyetinizi ölçmek amacıyla hazırlanmıştır.');
    
    return duzeltilmis;
  }

  @override
  void initState() {
    super.initState();
    for (var soru in widget.anket.sorular) {
      if (soru.verilenCevap != null && soru.verilenCevap!.isNotEmpty) {
        selectedCevaplar[soru.soruId] = soru.verilenCevap;
      }
    }
  }

  Future<void> sendCevaplar(List<AnketCevap> cevaplar) async {
    final String apiUrl =
        'http://37.148.210.227:8001/api/KangaroomAnket/cevap';

    setState(() => loading = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    print(
        "**************Cevaplar: ${cevaplar.map((e) => e.toJson()).toList()}");
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            cevaplar.map((e) => e.toJson()).toList()), // sadece liste gönder
      );

      Navigator.pop(context);
      setState(() => loading = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cevaplar kaydedildi.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gönderme başarısız: ${response.body}")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata oluştu: $e")),
      );
    }
  }

  Widget buildSoru(Soru soru) {
    List<String> cevaplar = [
      soru.cevap1,
      soru.cevap2,
      soru.cevap3,
      soru.cevap4,
      soru.cevap5,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Soru: ${soru.soruAd}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ...cevaplar
            .where((cevap) => cevap.isNotEmpty)
            .map(
              (cevap) => RadioListTile<String>(
                title: Text(
                  cevap,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                value: cevap,
                groupValue: selectedCevaplar[soru.soruId],
                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                dense: true,
                visualDensity: VisualDensity.compact,
                onChanged: (value) {
                  setState(() {
                    selectedCevaplar[soru.soruId] = value;
                  });
                },
              ),
            )
            .toList(),
        SizedBox(height: 8),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.anket.anketAd),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Açıklama: ${duzeltMetin(widget.anket.aciklama)}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: widget.anket.sorular.map(buildSoru).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                List<AnketCevap> cevaplar = [];
                selectedCevaplar.forEach((soruId, cevap) {
                  if (cevap != null) {
                    cevaplar.add(AnketCevap(
                      soruId: soruId,
                      cevap: cevap,
                      anketId: widget.anket.id,
                      cevaplayanId: widget.veliId,
                      durum: true,
                    ));
                  }
                });
                sendCevaplar(cevaplar);
              },
              child: const Text("Cevapları Gönder"),
            ),
          ],
        ),
      ),
    );
  }
}
