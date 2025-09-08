class OgrenciBilgileri {
  int? id;
  String? tc;
  String? ad;
  String? soyad;
  String? dogumTarihi;
  int? sinif;
  String? sinifAd;
  String? hastalik;
  String? alerji;
  int? okulId;
  int? anneId;
  int? babaId;
  int? ogretmenId;
  int? duygu;
  int? uyku;
  int? ilac;
  int? tuvalet;
  int? sabah;
  int? ogle;
  int? ikindi;
  int? odemeGun;
  String? ilacAdi;
  String? ogretmen;
  String? ilacSaati;
  String? kahvaltiBas;
  String? kahvaltiBit;
  String? ogleBas;
  String? oglebit;
  String? ikindibas;
  String? ikindibit;
  int? mudur;
  int? duyuru;
  int? bulten;
  int? muhasebeci;
  int? boykilo;
  int? beslenme;
  int? etkinlik;
  int? anket;
  int? dersSaat;
  int? mufredat;
  int? randevu;

  OgrenciBilgileri({
    this.id,
    this.tc,
    this.ad,
    this.soyad,
    this.dogumTarihi,
    this.sinif,
    this.sinifAd,
    this.hastalik,
    this.alerji,
    this.okulId,
    this.anneId,
    this.babaId,
    this.ogretmenId,
    this.ogretmen,
    this.duygu,
    this.uyku,
    this.ilac,
    this.tuvalet,
    this.sabah,
    this.ogle,
    this.ikindi,
    this.odemeGun,
    this.ilacAdi,
    this.ilacSaati,
    this.kahvaltiBas,
    this.kahvaltiBit,
    this.ogleBas,
    this.oglebit,
    this.ikindibas,
    this.ikindibit,
    this.mudur,
    this.muhasebeci,
    this.duyuru,
    this.bulten,
    this.boykilo,
    this.beslenme,
    this.etkinlik,
    this.anket,
    this.dersSaat,
    this.mufredat,
    this.randevu,
  });

  OgrenciBilgileri.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tc = json['tc'];
    ad = json['ad'];
    soyad = json['soyad'];
    dogumTarihi = json['dogumTarihi'];
    sinif = json['sinif'];
    sinifAd = json['sinifAd'];
    hastalik = json['hastalik'];
    alerji = json['alerji'];
    okulId = json['okulId'];
    anneId = json['anneId'];
    babaId = json['babaId'];
    ogretmenId = json['ogretmenId'];
    ogretmen = json['ogretmen'];
    duygu = json['duygu'];
    uyku = json['uyku'];
    ilac = json['ilac'];
    tuvalet = json['tuvalet'];
    sabah = json['sabah'];
    ogle = json['ogle'];
    ikindi = json['ikindi'];
    ilacSaati = json['ilacSaati'];
    odemeGun = json['odemeGun'];
    ilacAdi = json['ilacAdi'];
    kahvaltiBas = json['kahvaltiBas'];
    kahvaltiBit = json['kahvaltiBit'];
    ogleBas = json['ogleBas'];
    oglebit = json['oglebit'];
    ikindibas = json['ikindibas'];
    ikindibit = json['ikindibit'];
    mudur = json['mudur'];
    muhasebeci = json['muhasebeci'];
    duyuru = json['duyuru'];
    bulten = json['bulten'];
    boykilo = json['boyKilo'];
    beslenme = json['beslenme'];
    etkinlik = json['etkinlik'];
    anket = json['anket'];
    dersSaat = json['dersSaat'];
    mufredat = json['mufredat'];
    randevu = json['randevu'];
  }
}
