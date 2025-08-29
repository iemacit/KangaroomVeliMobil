import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:kangaroom/theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import 'package:kangaroom/generated/l10n.dart';
//S.of(context).aidat

class Yoklama extends StatefulWidget {
  final int ogrenciId;
  Yoklama({super.key, required this.ogrenciId});

  @override
  State<Yoklama> createState() => _YoklamaState();
}

class _YoklamaState extends State<Yoklama> {
  int ay = DateTime.now().month;
  int yil = DateTime.now().year;
  String _errorMessage = "";
  Map<DateTime, String> _attendance = {};
  bool _isLoading = true;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData(widget.ogrenciId, ay, yil);
  }

  Future<void> _fetchAttendanceData(int ogrenciId, int ay, int yil) async {
    try {
      final response = await http.get(Uri.parse(
          'http://37.148.210.227:8001/api/KangaroomYoklama/yoklama?ogrenciId=$ogrenciId&ay=$ay&yil=$yil'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        Map<DateTime, String> newAttendance = {};

        for (var item in data) {
          DateTime date = DateTime.parse(item['tarih']);
          DateTime dateWithoutTime = DateTime(date.year, date.month, date.day);
          newAttendance[dateWithoutTime] =
              item['durum'] == true ? 'devam' : 'devamsız';
        }

        setState(() {
          _attendance = newAttendance;
          _isLoading = false;
        });
      } else {
        throw 'Devam verileri yüklenemedi: ${response.reasonPhrase}';
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Veri getirme hatası: $e';
        _isLoading = false;
      });
    }
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      ay = focusedDay.month;
      yil = focusedDay.year;
      _isLoading = true;
    });
    _fetchAttendanceData(widget.ogrenciId, ay, yil);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(S.of(context).yoklama, style: titleTextStyle),
        centerTitle: true,
      ),
      body: Center(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCircle(
                      color: Theme.of(context).primaryColor,
                      size: 50.0,
                    ),
                    SizedBox(height: 10),
                    Text(
                      S.of(context).verilerYukleniyor,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TableCalendar(
                  locale: Localizations.localeOf(context)
                      .toString(), //'tr_TR', //türkçe
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Ay',
                    CalendarFormat.twoWeeks: '2 Hafta',
                    CalendarFormat.week: 'Hafta'
                  },
                  onPageChanged: _onPageChanged,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    markersAutoAligned: true,
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    formatButtonTextStyle: TextStyle(fontFamily: 'Ubuntu'),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    dowTextFormatter: (date, locale) {
                      return DateFormat.E(locale).format(date).substring(0, 3);
                    },
                    weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
                    weekdayStyle: TextStyle().copyWith(color: Colors.black),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final dateKey = DateTime(day.year, day.month, day.day);
                      final status = _attendance[dateKey];
                      if (status != null) {
                        Color bgColor =
                            status == 'devam' ? Colors.green : Colors.red;
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            day.day.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
