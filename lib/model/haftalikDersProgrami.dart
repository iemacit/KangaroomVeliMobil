class DersModel2 {
  int? id;
  int? okulId;
  String? zaman;
  String? dosyaAdi;

  DersModel2(
      {this.id,
        this.okulId,
        this.zaman,
        this.dosyaAdi,

      });

  DersModel2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    okulId = json['okulId'];
    zaman = json['zaman'];
    dosyaAdi = json['dosyaAdi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['okulId'] = this.okulId;
    data['zaman'] = this.zaman;
    data['dosyaAdi'] = this.dosyaAdi;
    return data;
  }
}
