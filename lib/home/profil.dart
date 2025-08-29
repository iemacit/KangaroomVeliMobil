import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:kangaroom/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import 'package:kangaroom/generated/l10n.dart';

class Profil extends StatefulWidget {
  final String ad;
  final String ogretmen;
  final String soyad;
  final String dogumTarihi;
  final String sinifAd;
  final String ogrenciId;

  Profil({
    required this.ad,
    required this.soyad,
    required this.dogumTarihi,
    required this.sinifAd,
    required this.ogrenciId,
    required this.ogretmen,
  });

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  File? _image;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    resimyukle(int.parse(widget.ogrenciId));
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog ekrandan tıklamayla kapanmaz
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 75,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }

  // int YasHesapla(String dogumTarihi) {
  //   try {
  //     DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  //     DateTime dogumTarih = dateFormat.parse(dogumTarihi);
  //     DateTime today = DateTime.now();

  //     int age = today.year - dogumTarih.year;
  //     if (today.month < dogumTarih.month ||
  //         (today.month == dogumTarih.month && today.day < dogumTarih.day)) {
  //       age--;
  //     }

  //     return age;
  //   } catch (e) {
  //     return -1;
  //   }
  // }

//profil  resim yükleme
  Future<void> resimyukle(int ogrenciId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/profil_foto_$ogrenciId.jpg';

      final imageFile = File(imagePath);

      if (imageFile.existsSync()) {
        setState(() {
          _image = imageFile;
        });
        print('Image loaded from local storage');
      } else {
        final response = await http.get(Uri.parse(
            'http://37.148.210.227:8001/api/KangaroomOgrenci/$ogrenciId/ProfilFoto'));

        if (response.statusCode == 200) {
          await imageFile.writeAsBytes(response.bodyBytes);
          setState(() {
            _image = imageFile;
          });
          print('Image downloaded and saved to local storage');
        } else {
          print(
              'Image download failed with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  // profil resim güncelleme
  Future<void> resimGuncelle(File newImage, int ogrenciId) async {
    final uri = Uri.parse(
        'http://37.148.210.227:8001/api/KangaroomOgrenci/$ogrenciId/UploadProfil');
    final request = http.MultipartRequest('POST', uri);

    request.files
        .add(await http.MultipartFile.fromPath('ProfilFoto', newImage.path));

    try {
      setState(() {
        isloading = true;
      });
      if (isloading == true) {
        _showLoadingDialog();
      }
      final response = await request.send();
      if (response.statusCode == 204) {
        setState(() {
          isloading = false;
        });
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/profil_foto_$ogrenciId.jpg';
        final imageFile = File(imagePath);

        if (await imageFile.exists()) {
          await imageFile.delete();
          print('Old image deleted');
        }

        await imageFile.writeAsBytes(await newImage.readAsBytes());

        await clearImageCache();
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                S.of(context).basarili,
                textAlign: TextAlign.center,
              ),
              content: Text('${S.of(context).resimyuklendi}',
                  style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).tamam),
                ),
              ],
            );
          },
        );

        setState(() {
          _image = imageFile;
        });
      } else {
        setState(() {
          isloading = false;
        });
        print(
            'Resim güncelleme başarısız. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      Navigator.of(context).pop();
      print('Error during image update: $e');
    }
  }

// Helper method to clear image cache
  Future<void> clearImageCache() async {
    imageCache.clear();
    imageCache.clearLiveImages();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final newImage = File(pickedFile.path);
      await resimGuncelle(newImage, int.parse(widget.ogrenciId));
    }
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).profilResmi),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showFullImage();
              },
              child: Text(S.of(context).goruntule),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
              child: Text(S.of(context).galeridenSec),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
              child: Text(S.of(context).kameraIleCek),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.all(0),
        child: Stack(
          children: [
            Center(
              child: _image != null
                  ? Image.file(
                      _image!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Text("resim yok!!!"),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ekranGenisligi = MediaQuery.of(context).size.width;
    //int yas = YasHesapla(widget.dogumTarihi);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white, // Geri dönüş okunun rengini beyaz yapar
        ),
        title: Text(
          S.of(context).ogrenciProfili,
          style: titleTextStyle,
        ),
        centerTitle: true, // Başlığı ortalar
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: ekranGenisligi,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _showImageDialog,
                          child: Container(
                            width: ekranGenisligi / 2,
                            height: ekranGenisligi / 2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _image != null
                                    ? FileImage(_image!)
                                    : AssetImage('assets/icon/profil2.jpg')
                                        as ImageProvider,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${widget.ad} ${widget.soyad}',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.person,
                              color: Theme.of(context).primaryColor),
                          title:
                              //  yas != -1
                              //     ? Text('${S.of(context).yas}: $yas',
                              //         style: TextStyle(fontSize: 20))
                              //    :
                              Text(
                                  '${S.of(context).dogumtarihi}: ${widget.dogumTarihi}',
                                  style: TextStyle(fontSize: 20)),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.class_,
                              color: Theme.of(context).primaryColor),
                          title: Text(
                              "${S.of(context).sinif}: ${widget.sinifAd}",
                              style: TextStyle(fontSize: 20)),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.person,
                              color: Theme.of(context).primaryColor),
                          title: Text(
                              "${S.of(context).ogretmen}: ${widget.ogretmen}",
                              style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
