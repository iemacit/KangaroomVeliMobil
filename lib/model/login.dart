class Login {
  final int Id;
  final String Ad;
  final String Soyad;
  final String Telefon;
  final String Sifre;
  final int OkulId;


  Login({
    required this.Id,
    required this.Ad,
    required this.Soyad,
    required this.Sifre,
    required this.Telefon,
    required this.OkulId,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
        Id: json['id'],
        Ad: json['ad'],
        Soyad: json['soyad'],
        Telefon: json['telefon'],
        Sifre: json['sifre'],
        OkulId:json['okulId']
    );
  }
}
