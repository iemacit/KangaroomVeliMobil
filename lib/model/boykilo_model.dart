class BoyKiloModel {
  int? id;
  int? ogrenciId;
  String? tarih;
  int? createUserId;
  String? createDate;
  int? boy;
  int? kilo;
  int? okulId;

  BoyKiloModel(
      {this.id,
        this.ogrenciId,
        this.tarih,
        this.createUserId,
        this.createDate,
        this.boy,
        this.kilo,
        this.okulId});

  BoyKiloModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ogrenciId = json['ogrenciId'];
    tarih = json['tarih'];
    createUserId = json['createUserId'];
    createDate = json['createDate'];
    boy = json['boy'];
    kilo = json['kilo'];
    okulId = json['okulId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ogrenciId'] = this.ogrenciId;
    data['tarih'] = this.tarih;
    data['createUserId'] = this.createUserId;
    data['createDate'] = this.createDate;
    data['boy'] = this.boy;
    data['kilo'] = this.kilo;
    data['okulId'] = this.okulId;
    return data;
  }
}
