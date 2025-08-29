class Soru {
  final int soruId; // ekledim
  final String soruAd;
  final String cevap1;
  final String cevap2;
  final String cevap3;
  final String cevap4;
  final String cevap5;
  final String verilenCevap; // ekledim

  Soru({
    required this.soruId,
    required this.soruAd,
    required this.cevap1,
    required this.cevap2,
    required this.cevap3,
    required this.cevap4,
    required this.cevap5,
    this.verilenCevap = '',
  });

  factory Soru.fromJson(Map<String, dynamic> json) {
    return Soru(
      soruId: json['soruId'] ?? 0,
      soruAd: json['soruAd'] ?? '',
      cevap1: json['cevap1'] ?? '',
      cevap2: json['cevap2'] ?? '',
      cevap3: json['cevap3'] ?? '',
      cevap4: json['cevap4'] ?? '',
      cevap5: json['cevap5'] ?? '',
      verilenCevap: json['verilenCevap'] ?? '',
    );
  }
}

class Anket {
  final int id;
  final String anketAd;
  final String aciklama;
  final List<Soru> sorular;

  Anket({
    required this.id,
    required this.anketAd,
    required this.aciklama,
    required this.sorular,
  });

  factory Anket.fromJson(Map<String, dynamic> json, List<Soru> sorular) {
    return Anket(
      id: json['id'],
      anketAd: json['anketAd'],
      aciklama: json['aciklama'],
      sorular: sorular,
    );
  }
}

class AnketCevap {
  final int soruId;
  final String cevap;
  final int anketId;
  final int cevaplayanId;
  final bool durum;

  AnketCevap({
    required this.soruId,
    required this.cevap,
    required this.anketId,
    required this.cevaplayanId,
    required this.durum,
  });

  Map<String, dynamic> toJson() {
    return {
      'soruId': soruId,
      'cevap': cevap,
      'anketId': anketId,
      'cevaplayanId': cevaplayanId,
      'durum': durum,
    };
  }
}
