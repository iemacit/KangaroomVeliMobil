/*
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;


class NotificationHelper {
  static final notifications = FlutterLocalNotificationsPlugin();

  // Bildirimlerin başlatılması için statik bir metot
  static Future initialize() async {
    // Android için başlangıç ayarlarını tanımla
    const androidInitialize =
    AndroidInitializationSettings('mipmap/ic_launcher');
    // Başlangıç ayarlarını belirle
    const initializationsSettings =
    InitializationSettings(android: androidInitialize);
    // Bildirimlerin başlatılması
    await notifications.initialize(initializationsSettings);
  }


  static Map<String, Map<String, String>> bildirimler = {
    "Beslenme": {
      "1": "Yarım elma gönül alma, ara öğün yemeyi unutma!",
      "2": "Sağlıksız beslenmenin cezasını ayaklar çekmesin Yemeğine değil hayatına şeker kat",
      "3": "Hayatın tadı şekersiz daha tatlıdır",
      "4": "Daha kontrollü bir şeker için sağlıklı beslenmeyi seçin",
      "5": "Küçük bir hatırlatma! Ara öğününü yedin mi?",
      "6": "Unutmal Öğün atlayarak kan şekerini dengeleyemezsin",
      "7": "Doğru beslen, hareket et şekerini kontrol et",
      "8": "Sağlıklı beslen şekerine yön ver"
    },
    "Fiziksel Aktivite": {
      "1": "Güneş görmeyen doktor görür! Temiz hava almanın tam zamanı. Bugün hava çok güzel biraz yürüyüş yapmaya ne dersin?",
      "2": "Bilmek yetmez uygulamak lazım hadi biraz yürüyelim",
      "3": "Üşenme, erteleme, zamanım yok deme! Hadi yürüyüşe",
      "4": "Hedefine ulaşmak için... adımın kaldı. Başarabilirsin!",
      "5": "Sağlıklı bir sen için bugün harekete geç",
      "6": "Tebrikler günlük adım sayısı hedefinize ulaştınız. Başarını sevdiklerinle paylaşabilirsin",
      "7": "Sağlığa adım at hedefini tamamla",
      "8": "Üşenme erteleme vazgeçme 45 dk yürüyüş yap 23 saat 15 dk seninle Hayatımızda diyabet her gün yürü hareket et",
      "9": "Kendine yatırım yap ve yürüyüş yap",
      "10": "Kendini sevive ona yürüyüş yaparak sağlike hediye et"
    },
    "Tedaviye Uyum": {
      "1": "Bahaneler şekerini normalleştirmez",
      "2": "Seni ayakta tutan iki şey var. Sağ ve sol ayağın onlara iyi bak! Şekerini kontrol et sağlıklı yaşamaya devam et",
      "3": "Sağlıklı yaşamak için kan şekerine kulak ver",
      "4": "Şekerini kontrol et hayatını kontrol et",
      "5": "Huylu huyundan vazgeçer. Sağlıklı yaşamayı seçer",
      "6": "Hadi bugün sağlıklı kalmak için elinden gelenin en iyisini yap",
      "7": "Su içmeyi gülümsemeyi ve şekerini ölçmeyi unutma",
      "8": "Hayallerine sınır koyma kan şekerine sınır koy",
      "9": "Kan şekerinizi dengeleyin hayata gülümseyin",
      "10": "Bu yıl kl göz böbrek ve sinir muayenenizi yaptırmayı unutmayın. Bir dost Alaç/Insulin saatlerinde hatırlatma:",
      "11": "Bugün ayaklanının kontrol ettin mi?",
      "12": "Aman dikkat! Tüm gözler üzerinizde. Yıllık göz muayenenizi aksatmayın"
    }
  };



  static String rastgeleBildirim() {
    // "Beslenme", "Fiziksel Aktivite" ve "Tedaviye Uyum" kategorilerinden rastgele birini seç
    final rastgeleKategori = ["Beslenme", "Fiziksel Aktivite", "Tedaviye Uyum"].elementAt(Random().nextInt(3));

    // Seçilen kategorinin altında bulunan bildirimlerin listesini al
    final bildirimlerListesi = bildirimler[rastgeleKategori]!;

    // Rastgele bir bildirimi seç
    final rastgeleBildirim = bildirimlerListesi.values.elementAt(Random().nextInt(bildirimlerListesi.length));

    return rastgeleBildirim;
  }


  // Bildirim ayrıntılarının oluşturulması için statik bir metot
  static Future notificationDetails() async => const NotificationDetails(
    android: AndroidNotificationDetails(
      "Diyabetes",
      "bildirim",
      importance: Importance.max,
    ),
  );

  // Bildirim gösterme için statik bir metot
  static Future showNotification({
    int id = 0,
    required String title,
    required String body,
    required String payload,
  }) async =>
      notifications.show(
        id,
        title,
        body,
        await notificationDetails(),
        payload: payload,
      );

  // Günlük bildirim planlama için statik bir metot
  static Future scheduleDailyNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required TimeOfDay notificationTime,
  }) async {
    // Şu anki zaman dilimini al
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // Belirtilen saat ve dakika değerleriyle bir tarih ve zaman oluştur
    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      notificationTime.hour,
      notificationTime.minute,
    );
    // Bildirimi günlük olarak zamanla planla
    await notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      await notificationDetails(),
      androidAllowWhileIdle: true, // Cihaz uykuda olsa bile bildirim gönderilmesini sağlar
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  static Future scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDateTime,
  }) async =>
      notifications.zonedSchedule(
          id,
          title,
          body,
          // TimeZone paketiyle DateTime objesini TZDateTime'e dönüştürdük.
          tz.TZDateTime.from(scheduledDateTime, tz.local),
          await notificationDetails(),
          // Bildirim tipini burada alarm olarak belirledik.
          androidScheduleMode: AndroidScheduleMode.exact,
          // Bildirim zamanını absolute (gmt) zaman dilimi olarak belirledik.
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);

  // Tüm bildirimleri iptal etme için statik bir metot
  static Future unScheduleAllNotifications() async =>
      await notifications.cancelAll();

  static Future scheduleDailyTenAMNotification() async {
    await notifications.zonedSchedule(
        0,
        'Diyabet\'ES',
        '${rastgeleBildirim()}',
        nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static tz.TZDateTime nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 12,00);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

}
*/