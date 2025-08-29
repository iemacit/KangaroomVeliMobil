import 'dart:convert';

class KangaroomMesaj {
  int id;
  String icerik;
  int kime;
  int createUserId;
  int gondericiTur;
  DateTime createDate;
  int statu;

  KangaroomMesaj({
    required this.id,
    required this.icerik,
    required this.kime,
    required this.createUserId,
    required this.gondericiTur,
    required this.createDate,
    required this.statu,

  });

  factory KangaroomMesaj.fromJson(Map<String, dynamic> json) {
    return KangaroomMesaj(
      id: json['id'],
      icerik: json['icerik'],
      createUserId: json['createUserId'],
      createDate: DateTime.parse(json['createDate']),
      kime: json['kime'],
      gondericiTur: json['gondericiTur'],
      statu:json['statu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icerik': icerik,
      'kime': kime,
      'createUserId': createUserId,
      'gondericiTur': gondericiTur,
      'createDate': createDate.toIso8601String(),
      'statu':statu
    };
  }

  static List<KangaroomMesaj> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => KangaroomMesaj.fromJson(json)).toList();
  }

  static String toJsonList(List<KangaroomMesaj> list) {
    return jsonEncode(list.map((item) => item.toJson()).toList());
  }
}