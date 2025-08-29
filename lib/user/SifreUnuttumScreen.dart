import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kangaroom/all_import.dart';
import 'package:kangaroom/user/PasswordResetScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Şifre Unuttum',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Modern bir font kullanımı
      ),
      home: SifreUnuttumScreen(),
    );
  }
}

class SifreUnuttumScreen extends StatefulWidget {
  @override
  _SifreUnuttumScreenState createState() => _SifreUnuttumScreenState();
}

class _SifreUnuttumScreenState extends State<SifreUnuttumScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _sifreYenile() {
    if (_formKey.currentState!.validate()) {
      // Yönlendirme işlemi
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordResetScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue.shade200,),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.red],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Şifreyi Sıfırla',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Telefon numaranızı girin, size doğrulama kodu gönderelim.',
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Telefon Numarası',
                          labelStyle: TextStyle(color: Colors.black26, fontSize: 17),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen telefon numaranızı girin';
                          }
                          if (value.length != 10) {
                            return 'Geçerli bir telefon numarası girin (10 haneli)';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _sifreYenile,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.0), backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: Text(
                            'Şifreyi Yenile',
                            style: TextStyle(fontSize: 18.0 ,color: colorWhite),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
