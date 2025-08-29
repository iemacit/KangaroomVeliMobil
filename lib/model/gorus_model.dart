class Gorus {
  final int id;
  final int tur;
  final String baslik;
  final String icerik;
  final int createUserId;
  final String createDate;
  final int okulId;
  final String cevap;

  Gorus({
    required this.id,
    required this.tur,
    required this.baslik,
    required this.icerik,
    required this.createUserId,
    required this.createDate,
    required this.okulId,
    required this.cevap,
  });

  factory Gorus.fromJson(Map<String, dynamic> json) {
    return Gorus(
      id: json['id'] as int,
      tur: json['tur'] as int,
      baslik: json['baslik'] as String,
      icerik: json['icerik'] as String,
      createUserId: json['createUserId'] as int,
      createDate: json['createDate'] as String,
      okulId: json['okulId'] as int,
      cevap: json['cevap'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tur': tur,
      'baslik': baslik,
      'icerik': icerik,
      'createUserId': createUserId,
      'createDate': createDate,
      'okulId': okulId,
      'cevap': cevap,
    };
  }
}
