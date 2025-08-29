class RandevuModel {
  int? randevuID;
  String? tarih;
  String? saat;
  int? durum;
  String? veliMesaj;
  int? ogrenciId;
  int? ogretmenId;
  String? icerik;
  String? ogretmenAd;
  String? ogretmenSoyad;
  String? ogrenciAd;
  String? ogrenciSoyad;

  RandevuModel({
    this.randevuID,
    this.tarih,
    this.saat,
    this.durum,
    this.veliMesaj,
    this.ogrenciId,
    this.ogretmenId,
    this.icerik,
    this.ogretmenAd,
    this.ogretmenSoyad,
    this.ogrenciAd,
    this.ogrenciSoyad,
  });

  RandevuModel.fromJson(Map<String, dynamic> json) {
    randevuID = json['randevuID'];
    tarih = json['tarih'] ?? 'Bilinmiyor';
    saat = json['saat'];
    durum = json['durum'];
    veliMesaj = json['veliMesaj'];
    ogrenciId = json['ogrenciId'];
    ogretmenId = json['ogretmenId'];
    icerik = json['icerik'];
    ogretmenAd = json['ogretmenAd'] ?? 'Bilinmiyor';  // Null kontrolü ve varsayılan değer
    ogretmenSoyad = json['ogretmenSoyad'] ?? 'Bilinmiyor';  // Null kontrolü ve varsayılan değer
    ogrenciAd = json['ogrenciAd'] ?? 'Bilinmiyor';  // Null kontrolü ve varsayılan değer
    ogrenciSoyad = json['ogrenciSoyad'] ?? 'Bilinmiyor';  // Null kontrolü ve varsayılan değer
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['randevuID'] = this.randevuID;
    data['tarih'] = this.tarih;
    data['saat'] = this.saat;
    data['durum'] = this.durum;
    data['veliMesaj'] = this.veliMesaj;
    data['ogrenciId'] = this.ogrenciId;
    data['ogretmenId'] = this.ogretmenId;
    data['icerik'] = this.icerik;
    data['ogretmenAd'] = this.ogretmenAd;
    data['ogretmenSoyad'] = this.ogretmenSoyad;
    data['ogrenciAd'] = this.ogrenciAd;
    data['ogrenciSoyad'] = this.ogrenciSoyad;
    return data;
  }
}
