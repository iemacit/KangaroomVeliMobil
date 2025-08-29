class Egitimkadromodel {
  String? ad;
  String? soyad;
  String? egitim;
  String? tecrube;

  Egitimkadromodel({this.ad, this.soyad, this.egitim, this.tecrube});

  Egitimkadromodel.fromJson(Map<String, dynamic> json) {
    ad = json['ad'];
    soyad = json['soyad'];
    egitim = json['egitim'];
    tecrube = json['tecrube'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ad'] = this.ad;
    data['soyad'] = this.soyad;
    data['egitim'] = this.egitim;
    data['tecrube'] = this.tecrube;
    return data;
  }
}
