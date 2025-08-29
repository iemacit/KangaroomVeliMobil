import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:kangaroom/generated/l10n.dart';
import 'package:kangaroom/theme.dart';

class Saglik extends StatefulWidget {
  final int ogrenciId;
  final String isim;
  final String soyisim;
  String ilacBilgisi;
  String ilacSaati;
  String alerjiDurumu;
  String kronikHastalikDurumu;

  Saglik({
    required this.isim,
    required this.soyisim,
    this.ilacBilgisi = '',
    this.ilacSaati = '',
    this.alerjiDurumu = '',
    this.kronikHastalikDurumu = '',
    required this.ogrenciId,
  });

  @override
  _SaglikState createState() => _SaglikState();
}

class _SaglikState extends State<Saglik> {
  late TextEditingController _ilacBilgisiController;
  late TextEditingController _ilacSaatiController;
  late TextEditingController _alerjiDurumuController;
  late TextEditingController _kronikHastalikDurumuController;

  @override
  void initState() {
    super.initState();
    _ilacBilgisiController = TextEditingController(text: widget.ilacBilgisi);
    _ilacSaatiController = TextEditingController(text: widget.ilacSaati);
    _alerjiDurumuController = TextEditingController(text: widget.alerjiDurumu);
    _kronikHastalikDurumuController =
        TextEditingController(text: widget.kronikHastalikDurumu);
  }

  // @override
  // void dispose() {
  //   _ilacBilgisiController.dispose();
  //   _ilacSaatiController.dispose();
  //   _alerjiDurumuController.dispose();
  //   _kronikHastalikDurumuController.dispose();
  //   super.dispose();
  // }

  Future<void> updateStudentHealthInfo(int ogrenciId, String hastalik,
      String alerji, String ilacAdi, String ilacsaati) async {
    final url = Uri.parse('http://37.148.210.227:8001/api/KangaroomOgrenci');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'ogrenciId': ogrenciId,
      'hastalik': hastalik,
      'alerji': alerji,
      'ilacAdi': ilacAdi,
      'ilacsaati': ilacsaati,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print(S.of(context).bilgilerGuncellendi);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                S.of(context).basarili,
                textAlign: TextAlign.center,
              ),
              content: Text(S.of(context).bilgilerGuncellendi,
                  style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(S.of(context).tamam),
                ),
              ],
            );
          },
        );
        setState(() {
          widget.ilacBilgisi = _ilacBilgisiController.text;
          widget.ilacSaati = _ilacSaatiController.text;
          widget.kronikHastalikDurumu = _kronikHastalikDurumuController.text;
          widget.alerjiDurumu = _alerjiDurumuController.text;
        });
      } else {
        print('bilgiler güncellenmedi Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          S.of(context).saglikBilgileri,
          style: titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      S.of(context).saglikBilgisiGuncelleme,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _ilacBilgisiController,
                    labelText: S.of(context).ilacBilgisi,
                    icon: Icons.medical_services_outlined,
                  ),
                  SizedBox(height: 15),
                  _timepicker(),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _kronikHastalikDurumuController,
                    labelText: S.of(context).kronikHastalikDurumu,
                    icon: Icons.local_hospital,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: _alerjiDurumuController,
                    labelText: S.of(context).alerjiDurumu,
                    icon: Icons.warning_amber_outlined,
                  ),
                  SizedBox(height: 30),
                  _buildUpdateButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _timepicker() {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          final formattedTime =
              '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
          setState(() {
            _ilacSaatiController.text = formattedTime;
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: _ilacSaatiController,
          decoration: InputDecoration(
            labelText: S.of(context).ilacSaati,
            labelStyle: TextStyle(
              fontSize: 20, // Yazı boyutunu büyüt
            ),
            prefixIcon: Icon(Icons.access_time, color: Colors.redAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 20, // Yazı boyutunu büyüt
          fontWeight: FontWeight.bold, // Kalın yap
          color: Colors.blueAccent, // İstediğiniz renk
        ),
        prefixIcon: Icon(icon, color: Colors.redAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      style: TextStyle(fontSize: 18),
    );
  }

  Widget _buildUpdateButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          updateStudentHealthInfo(
              widget.ogrenciId,
              _kronikHastalikDurumuController.text,
              _alerjiDurumuController.text,
              _ilacBilgisiController.text,
              _ilacSaatiController.text);
        },
        icon: Icon(Icons.save, color: Colors.white),
        label: Text(
          S.of(context).bilgileriGuncelle,
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
