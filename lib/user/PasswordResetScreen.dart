import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String correctVerificationCode = "123456"; // Doğru onay kodu

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      if (_verificationCodeController.text == correctVerificationCode) {
        // Şifre yenileme işlemi burada gerçekleştirilir
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Şifreniz başarıyla yenilendi')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Onay kodu hatalı!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Şifreyi Yenile'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Text(
                        'Şifreyi Yenile',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Lütfen size gönderilen onay kodunu ve yeni şifrenizi girin.',
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.0),
                      TextFormField(
                        controller: _verificationCodeController,
                        decoration: InputDecoration(
                          labelText: 'Onay Kodu',
                          labelStyle: TextStyle(fontSize: 18.0, color: Colors.blue.shade700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                          prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen onay kodunu girin';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Yeni Şifre',
                          labelStyle: TextStyle(fontSize: 18.0, color: Colors.blue.shade700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                          prefixIcon: Icon(Icons.vpn_key, color: Colors.blue.shade700),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen yeni şifrenizi girin';
                          }
                          if (value.length < 6) {
                            return 'Şifre en az 6 karakter olmalı';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Yeni Şifreyi Onayla',
                          labelStyle: TextStyle(fontSize: 18.0, color: Colors.blue.shade700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                          prefixIcon: Icon(Icons.vpn_key, color: Colors.blue.shade700),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Şifreler eşleşmiyor';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _resetPassword,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: Text(
                            'Şifreyi Yenile',
                            style: TextStyle(fontSize: 18.0, color: Colors.white),
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
