class KarneModel {
  int? id;
  int? ogrenciId;
  int? gelisimId;
  int? tur;
  String? gelisimAd;
  String? gelisimTurAd;
  int? donem;
  int? puan;

  KarneModel(
      {this.id,
      this.ogrenciId,
      this.gelisimId,
      this.tur,
      this.gelisimAd,
      this.gelisimTurAd,
      this.donem,
      this.puan});

  KarneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ogrenciId = json['ogrenciId'];
    gelisimId = json['gelisimId'];
    tur = json['tur'];
    gelisimAd = json['gelisimAd'];
    gelisimTurAd = json['gelisimTurAd'];
    donem = json['donem'];
    puan = json['puan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ogrenciId'] = this.ogrenciId;
    data['gelisimId'] = this.gelisimId;
    data['tur'] = this.tur;
    data['gelisimAd'] = this.gelisimAd;
    data['gelisimTurAd'] = this.gelisimTurAd;
    data['donem'] = this.donem;
    data['puan'] = this.puan;
    return data;
  }
}