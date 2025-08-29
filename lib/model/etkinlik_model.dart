class Etkinlik_Model {
  int? id;
  String? ad;
  String? tarih;
  int? durum;

  Etkinlik_Model({this.id, this.ad, this.tarih, this.durum});

  Etkinlik_Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ad = json['ad'];
    tarih = json['tarih'];
    durum = json['durum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ad'] = this.ad;
    data['tarih'] = this.tarih;
    data['durum'] = this.durum;
    return data;
  }
}