class BultenModel {
  int? id;
  int? yil;
  String? dosyaAdi;
  String? tarih;
  String? aylik;
  int? hafta;

  BultenModel(
      {this.id, this.yil, this.dosyaAdi, this.tarih, this.aylik, this.hafta});

  BultenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yil = json['yil'];
    dosyaAdi = json['dosyaAdi'];
    tarih = json['tarih'];
    aylik = json['aylik'];
    hafta = json['hafta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yil'] = this.yil;
    data['dosyaAdi'] = this.dosyaAdi;
    data['tarih'] = this.tarih;
    data['aylik'] = this.aylik;
    data['hafta'] = this.hafta;
    return data;
  }
}
