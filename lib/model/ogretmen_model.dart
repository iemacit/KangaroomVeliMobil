class OgretmenModel {
  int? id;
  String? ad;
  String? soyad;
  String? iletisim;
  String? token;

  OgretmenModel({this.id, this.ad, this.soyad, this.iletisim});

  OgretmenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ad = json['ad'];
    soyad = json['soyad'];
    iletisim = json['iletisim'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ad'] = this.ad;
    data['soyad'] = this.soyad;
    data['iletisim'] = this.iletisim;
    data['token'] = this.token;
    return data;
  }
}
