class DersModel {
  int? id;
  String? fileName;
  String? fileDate;
  int? okulId;
  String? createDate;

  DersModel(
      {this.id,
        this.fileName,
        this.fileDate,
        this.okulId,
        this.createDate,

      });

  DersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['fileName'];
    fileDate = json['fileDate'];
    okulId = json['okulId'];
    createDate=json['createDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fileName'] = this.fileName;
    data['fileDate'] = this.fileDate;
    data['okulId'] = this.okulId;
    data['createDate'] = this.createDate;
    return data;
  }
}
