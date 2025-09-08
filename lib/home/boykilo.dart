import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fl_chart/fl_chart.dart';


import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

import 'package:kangaroom/generated/l10n.dart';

//S.of(context).aidat
class BoyKilo extends StatefulWidget {
  final int ogrenciId;

  BoyKilo({required this.ogrenciId});

  @override
  _BoyKiloState createState() => _BoyKiloState();
}

class _BoyKiloState extends State<BoyKilo> with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;
  List<BoyKiloModel>? _items;
  bool _isLoading = false;

  int _selectedYear = DateTime.now().year;

  @override
void initState() {
  super.initState();
  _motionTabBarController = MotionTabBarController(
    initialIndex: 0,
    length: 3,
    vsync: this,
  );
  _fetchItems(widget.ogrenciId);
  _sendBoyKiloOkundu(widget.ogrenciId); // <-- Bunu ekle
}

Future<void> _sendBoyKiloOkundu(int ogrenciId) async {
  try {
    await Dio().post(
      "http://37.148.210.227:8001/api/KangaroomBoyKilo/boyKiloOkundu/$ogrenciId",
    );
  } catch (e) {
    print("Error sending boyKiloOkundu: $e");
  }
}

  Future<void> _fetchItems(int ogrenciId) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await Dio().get(
          "http://37.148.210.227:8001/api/KangaroomBoyKilo/o/$ogrenciId");
      if (response.statusCode == 200) {
        final _datas = response.data;

        if (_datas is List) {
          setState(() {
            _items = _datas.map((e) => BoyKiloModel.fromJson(e)).toList();
          });
        }
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _changeYear(int change) {
    setState(() {
      _selectedYear += change;
    });
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          S.of(context).boyKilo,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: S.of(context).kilo,
        labels: [S.of(context).kilo, S.of(context).boy, S.of(context).tablo],
        icons: [
          FontAwesomeIcons.weightScale,
          FontAwesomeIcons.rulerVertical,
          Icons.receipt_long,
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Theme.of(context).primaryColor,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Theme.of(context).primaryColor,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int index) {
          setState(() {
            _motionTabBarController.index = index;
          });
        },
      ),
      body: _isLoading
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
          : (_items == null || _items!.isEmpty)
          ? Center(
        child: Text(
          S.of(context).veriBulunamadi,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColor,
          ),
        ),
      )
          : TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: <Widget>[
          Center(
            child: BarChartSample3(
              dataType: 'Kilo',
              pageTitle: S.of(context).kilo,
              data: _items!,
              selectedYear: _selectedYear,
              onYearChanged: _changeYear,
            ),
          ),
          Center(
            child: BarChartSample3(
              dataType: 'Boy',
              pageTitle: S.of(context).boy,
              data: _items!,
              selectedYear: _selectedYear,
              onYearChanged: _changeYear,
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => _changeYear(-1),
                  ),
                  Text(
                    '$_selectedYear',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () => _changeYear(1),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 20,
                        horizontalMargin: 0,
                        dividerThickness: 1,
                        dataRowHeight: 60,
                        headingRowColor:
                        MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                        headingTextStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        columns: <DataColumn>[
                          DataColumn(
                              label: Text("${S.of(context).tarih}")),
                          DataColumn(
                              label: Text("${S.of(context).boy}")),
                          DataColumn(
                              label: Text("${S.of(context).kilo}")),
                        ],
                        rows: getTableRows(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<DataRow> getTableRows() {
    return _items!
        .where((item) => DateTime.parse(item.tarih!).year == _selectedYear)
        .map((item) {
      final String? tarih = item.tarih;
      final String formattedDate = tarih != null ? _formatDate(tarih) : "N/A";

      return DataRow(
        cells: <DataCell>[
          DataCell(Text(formattedDate)),
          DataCell(Text('${item.boy} cm')),
          DataCell(Text('${item.kilo} kg')),
        ],
      );
    }).toList();
  }

  String _formatDate(String tarih) {
    try {
      final DateTime date = DateTime.parse(tarih);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return "Invalid date";
    }
  }
}

class BarChartSample3 extends StatelessWidget {
  final String dataType;
  final String pageTitle;
  final List<BoyKiloModel> data;
  final int selectedYear;
  final Function(int) onYearChanged;

  BarChartSample3({
    required this.dataType,
    required this.pageTitle,
    required this.data,
    required this.selectedYear,
    required this.onYearChanged,
  });

  final List<String> turkishMonths = [
    "Ocak",
    "Şubat",
    "Mart",
    "Nisan",
    "Mayıs",
    "Haziran",
    "Temmuz",
    "Ağustos",
    "Eylül",
    "Ekim",
    "Kasım",
    "Aralık"
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<BoyKiloModel> filteredData = data.where((item) {
      return DateTime.parse(item.tarih!).year == selectedYear;
    }).toList();

    filteredData.sort((a, b) {
      int monthA = DateTime.parse(a.tarih!).month;
      int monthB = DateTime.parse(b.tarih!).month;
      return monthA.compareTo(monthB);
    });

    double barWidth = screenWidth / (filteredData.length * 1.5);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => onYearChanged(-1),
            ),
            Text(
              '$selectedYear',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () => onYearChanged(1),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(
            pageTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                Border.all(color: Theme.of(context).primaryColor, width: 2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: BarChart(
                  BarChartData(
                    barTouchData: _getBarTouchData(),
                    titlesData: _getTitlesData(filteredData),
                    borderData: _getBorderData(context),
                    barGroups: _getBarGroups(barWidth, filteredData),
                    gridData: FlGridData(show: false),
                    alignment: BarChartAlignment.spaceEvenly,
                    maxY: 200,
                    minY: 0,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  BarTouchData _getBarTouchData() {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        tooltipPadding: const EdgeInsets.all(8),
        tooltipMargin: 5,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            rod.toY.round().toString(),
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }

  FlTitlesData _getTitlesData(List<BoyKiloModel> filteredData) {
    filteredData.sort((a, b) {
      int monthA = DateTime.parse(a.tarih!).month;
      int monthB = DateTime.parse(b.tarih!).month;
      return monthA.compareTo(monthB);
    });

    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            final style = TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );

            // Index sınırlarını kontrol et
            if (value.toInt() >= filteredData.length) {
              return Container();
            }

            int month = int.parse(filteredData[value.toInt()].tarih!.substring(5, 7)) - 1;
            String text = turkishMonths[month];

            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: Text(text, style: style),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            final style = TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: Text('${value.toInt()}', style: style),
            );
          },
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  FlBorderData _getBorderData(BuildContext context) {
    return FlBorderData(
      show: true,
      border: Border(
        left: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
        right: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
        bottom: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(
      double barWidth, List<BoyKiloModel> filteredData) {
    return filteredData.asMap().entries.map((entry) {
      int index = entry.key;
      BoyKiloModel item = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: dataType.toLowerCase() == 'kilo'
                ? item.kilo.toDouble()
                : item.boy.toDouble(),
            gradient: _barsGradient(),
            width: barWidth,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 200,
              color: Colors.grey[300],
            ),
          )
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  LinearGradient _barsGradient() {
    return LinearGradient(
      colors: [
        Colors.blue,
        Colors.cyan,
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
  }
}

class BoyKiloModel {
  final int ogrenciId;
  final String? tarih;
  final int boy;
  final int kilo;

  BoyKiloModel({
    required this.ogrenciId,
    required this.tarih,
    required this.boy,
    required this.kilo,
  });

  factory BoyKiloModel.fromJson(Map<String, dynamic> json) {
    return BoyKiloModel(
      ogrenciId: json['ogrenciId'],
      tarih: json['tarih'],
      boy: json['boy'],
      kilo: json['kilo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ogrenciId': ogrenciId,
      'tarih': tarih,
      'boy': boy,
      'kilo': kilo,
    };
  }
}