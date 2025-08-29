class HakkimizdaModel {
  int? id;
  String? firmaAdi;
  String? mudurAdi;
  String? mudurYardimcisiAdi;
  String? misyon;
  String? vizyon;
  String? hakkimizda;
  String? telNo1;
  String? telNo2;
  String? email;
  String? website;
  String? konum;
  String? adres;
  String? il;
  String? ilce;
  String? instagram;
  String? facebook;
  String? youtube;
  String? linkedin;
  String? renk1;
  String? renk2;
  String? renk3;
  String? resimBinary;

  HakkimizdaModel(
      {this.id,
        this.firmaAdi,
        this.mudurAdi,
        this.mudurYardimcisiAdi,
        this.misyon,
        this.vizyon,
        this.hakkimizda,
        this.telNo1,
        this.telNo2,
        this.email,
        this.website,
        this.konum,
        this.adres,
        this.il,
        this.ilce,
        this.instagram,
        this.facebook,
        this.youtube,
        this.linkedin,
        this.renk1,
        this.renk2,
        this.renk3,
        this.resimBinary});

  HakkimizdaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmaAdi = json['firmaAdi'];
    mudurAdi = json['mudurAdi'];
    mudurYardimcisiAdi = json['mudurYardimcisiAdi'];
    misyon = json['misyon'];
    vizyon = json['vizyon'];
    hakkimizda = json['hakkimizda'];
    telNo1 = json['telNo1'];
    telNo2 = json['telNo2'];
    email = json['email'];
    website = json['website'];
    konum = json['konum'];
    adres = json['adres'];
    il = json['il'];
    ilce = json['ilce'];
    instagram = json['instagram'];
    facebook = json['facebook'];
    youtube = json['youtube'];
    linkedin = json['linkedin'];
    renk1 = json['renk1'];
    renk2 = json['renk2'];
    renk3 = json['renk3'];
    resimBinary = json['resimBinary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firmaAdi'] = this.firmaAdi;
    data['mudurAdi'] = this.mudurAdi;
    data['mudurYardimcisiAdi'] = this.mudurYardimcisiAdi;
    data['misyon'] = this.misyon;
    data['vizyon'] = this.vizyon;
    data['hakkimizda'] = this.hakkimizda;
    data['telNo1'] = this.telNo1;
    data['telNo2'] = this.telNo2;
    data['email'] = this.email;
    data['website'] = this.website;
    data['konum'] = this.konum;
    data['adres'] = this.adres;
    data['il'] = this.il;
    data['ilce'] = this.ilce;
    data['instagram'] = this.instagram;
    data['facebook'] = this.facebook;
    data['youtube'] = this.youtube;
    data['linkedin'] = this.linkedin;
    data['renk1'] = this.renk1;
    data['renk2'] = this.renk2;
    data['renk3'] = this.renk3;
    data['resimBinary'] = this.resimBinary;
    return data;
  }
}
