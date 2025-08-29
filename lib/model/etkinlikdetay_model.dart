class EtkinlikDetay_model {
  int? id;
  String? ad;
  String? tarih;
  String? sinif;
  int? durum;
  String? aciklama;
  String? tutar;
  String? saat;
  String? resimBinary;
  String? resimPath;
  String? iban;

  EtkinlikDetay_model(
      {this.id,
      this.ad,
      this.tarih,
      this.sinif,
      this.durum,
      this.aciklama,
      this.tutar,
      this.saat,
      this.resimBinary,
      this.resimPath,
      this.iban});

  EtkinlikDetay_model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ad = json['ad'];
    tarih = json['tarih'];
    sinif = json['sinif'];
    durum = json['durum'];
    aciklama = json['aciklama'];
    tutar = json['tutar'];
    saat = json['saat'];
    resimBinary = json['resimBinary'];
    resimPath = json['resimPath'];
    iban = json['iban'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ad'] = this.ad;
    data['tarih'] = this.tarih;
    data['sinif'] = this.sinif;
    data['durum'] = this.durum;
    data['aciklama'] = this.aciklama;
    data['tutar'] = this.tutar;
    data['saat'] = this.saat;
    data['resimBinary'] = this.resimBinary;
    data['resimPath'] = this.resimPath;
    data['iban'] = this.iban;
    return data;
  }
}