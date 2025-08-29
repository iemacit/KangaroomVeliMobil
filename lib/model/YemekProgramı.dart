class YemekModel {
  int? id;
  String? fileName;
  String? dosyaYolu;
  String? fileDate;
  int? okulId;
  String? zaman;
  String? hafta;

  YemekModel({
    this.id,
    this.fileName,
    this.dosyaYolu,
    this.fileDate,
    this.okulId,
    this.zaman,
    this.hafta,
  });

  YemekModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['fileName'];
    dosyaYolu = json['dosyaYolu'];
    fileDate = json['fileDate'];
    okulId = json['okulId'];
    zaman = json['zaman'];
    hafta = json['hafta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fileName'] = this.fileName;
    data['dosyaYolu'] = this.dosyaYolu;
    data['fileDate'] = this.fileDate;
    data['okulId'] = this.okulId;
    data['zaman'] = this.zaman;
    data['hafta'] = this.hafta;
    return data;
  }
}
