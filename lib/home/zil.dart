import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kangaroom/theme.dart';

class Zil extends StatefulWidget {
  @override
  _ZilState createState() => _ZilState();
}

class _ZilState extends State<Zil> {
  TextEditingController _controller = TextEditingController();
  String _selectedTime = '5dk';

  @override
  void initState() {
    super.initState();
    showToast();
  }

  Future<void> showToast() async {
    Fluttertoast.showToast(
      msg:
          "lütfen Öğretmenimizi bilgilendirmek için yukarıdaki butonları kullanın... 😊",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showDialogZil() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Row(
            children: [
              Image.asset('assets/icon/question.png', width: 24, height: 24),
              SizedBox(width: 10),
              Text('Zil', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: _showDialogBaskasiAlacak,
                  icon: Image.asset('assets/icon/users.png',
                      width: 36, height: 36),
                  label: Text(
                    'Çocuğumu Başka Biri Alacak',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 5,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 10), // İki buton arasına boşluk koyar
                ElevatedButton.icon(
                  onPressed: _showDialogBenAlacak,
                  icon: Image.asset('assets/icon/kapıdayım.png',
                      width: 45, height: 45),
                  label: Text(
                    'Ben Alacağım',
                    style: TextStyle(
                        color:
                            Colors.white), // Set the text color to white here
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 5,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.cancel, color: Colors.white),
              label: Text('İptal', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton.icon(
              onPressed: () {
                print('Kimin alacağı: ${_controller.text}');
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.check, color: Theme.of(context).primaryColor),
              label: Text('Tamam'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Colors
                    .white, // Buton metni rengini Theme.of(context).primaryColor yapıyoruz
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDialogBenAlacak() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Row(
            children: [
              Image.asset('assets/icon/question.png', width: 24, height: 24),
              SizedBox(width: 10),
              Text('Nezaman Alacaksınız?',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ],
          ),
          content: Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: _selectedTime,
                dropdownColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                underline: Container(),
                // Remove the underline
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTime = newValue!;
                  });
                },
                items: <String>['Kapıdayım', '5dk', '10dk', '15dk']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ],
          )),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.cancel, color: Colors.white),
              label: Text('İptal', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton.icon(
              onPressed: () {
                print('Kimin alacağı: ${_controller.text}');
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.check, color: Theme.of(context).primaryColor),
              label: Text('Tamam'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Colors
                    .white, // Buton metni rengini Theme.of(context).primaryColor yapıyoruz
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDialogBaskasiAlacak() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Row(
            children: [
              Image.asset('assets/icon/question.png', width: 24, height: 24),
              SizedBox(width: 10),
              Text('Kim Alacak?', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Kimin alacağını giriniz',
                    hintStyle: TextStyle(
                        color: Colors
                            .white70), // Hint metni rengini beyaz yapıyoruz
                  ),
                  style: TextStyle(
                      color:
                          Colors.white), // Girdi metni rengini beyaz yapıyoruz
                ),
                SizedBox(height: 20),
                // TextField ve DropdownButton arasında boşluk ekler
                DropdownButton<String>(
                  value: _selectedTime,
                  dropdownColor: Theme.of(context).primaryColor,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: Container(),
                  // Remove the underline
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTime = newValue!;
                    });
                  },
                  items: <String>['Kapıdayım', '5dk', '10dk', '15dk']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.cancel, color: Colors.white),
              label: Text('İptal', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton.icon(
              onPressed: () {
                print('Kimin alacağı: ${_controller.text}');
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.check, color: Theme.of(context).primaryColor),
              label: Text('Tamam'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Colors
                    .white, // Buton metni rengini Theme.of(context).primaryColor yapıyoruz
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white, // Geri dönüş okunun rengini beyaz yapar
        ),
        title: Text(
          'Zil',
          style: titleTextStyle,
        ),
        centerTitle: true, // Başlığı ortalar
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icon/zil2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _showDialogZil();
                      },
                      icon: Image.asset('assets/icon/kapıdayım.png',
                          width: 45, height: 45),
                      label: Text(
                        'Kapıdayım',
                        style: TextStyle(
                            color: Colors
                                .white), // Set the text color to white here
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        elevation: 5,
                        shadowColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // İki buton arasına boşluk koyar
                    ElevatedButton.icon(
                      onPressed: () {
                        print('$_selectedTime ya geliyorum');
                      },
                      icon: Image.asset('assets/icon/5dk.png',
                          width: 36, height: 36, color: Colors.white),
                      label: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<String>(
                            value: _selectedTime,
                            dropdownColor: Theme.of(context).primaryColor,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            underline: Container(),
                            // Remove the underline
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedTime = newValue!;
                              });
                            },
                            items: <String>['5dk', '10dk', '15dk']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        elevation: 5,
                        shadowColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Butonlar ve yeni buton arasına boşluk ekler
                ElevatedButton.icon(
                  onPressed: _showDialogBaskasiAlacak,
                  icon: Image.asset('assets/icon/users.png',
                      width: 36, height: 36),
                  label: Text(
                    'Çocuğumu Başka Biri Alacak',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 5,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
