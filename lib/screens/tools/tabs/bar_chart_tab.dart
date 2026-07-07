import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BarChartTab extends StatelessWidget {
  const BarChartTab({super.key});

  // ---------- Data Polling (5 mahasiswa) ----------
  static const List<String> _nama = ["Andi", "Budi", "Rina", "Salsa", "Naufal"];
  static const List<double> _tinggi = [170, 165, 180, 175, 168]; // cm
  static const List<double> _berat = [55, 60, 68, 58, 62]; // kg

  // Distribusi nomor sepatu (jumlah mahasiswa per ukuran)
  static const Map<String, double> _sepatu = {
    "39": 1,
    "40": 2,
    "41": 3,
    "42": 3,
    "43": 1,
  };

  // Distribusi ukuran baju
  static const Map<String, double> _baju = {
    "S": 1,
    "M": 2,
    "L": 4,
    "XL": 2,
    "XXL": 1,
  };

  // Distribusi golongan darah
  static const Map<String, double> _golDarah = {
    "A": 3,
    "B": 4,
    "AB": 1,
    "O": 2,
  };

  static const List<Color> _palette = [
    AppColors.primaryGreen,
    Color(0xFF4C9AFF),
    Color(0xFFFFAB4C),
    Color(0xFFFF6B6B),
    Color(0xFF9C6BFF),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dashboard Polling Mahasiswa",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Rekap hasil polling 5 mahasiswa dalam berbagai jenis grafik.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          _buildSectionTitle("1. Tinggi Badan (Bar Chart)"),
          _buildCard(
            height: 320,
            child: _buildBarChart(),
          ),
          const SizedBox(height: 28),

          _buildSectionTitle("2. Berat Badan (Line Chart)"),
          _buildCard(
            height: 320,
            child: _buildLineChart(),
          ),
          const SizedBox(height: 28),

          _buildSectionTitle("3. Nomor Sepatu (Pie Chart)"),
          _buildCard(
            height: 320,
            child: _buildPieChart(_sepatu, donut: false),
          ),
          const SizedBox(height: 28),

          _buildSectionTitle("4. Nomor Baju (Donut Chart)"),
          _buildCard(
            height: 320,
            child: _buildPieChart(_baju, donut: true),
          ),
          const SizedBox(height: 28),

          _buildSectionTitle("5. Golongan Darah (Radar Chart)"),
          _buildCard(
            height: 340,
            child: _buildRadarChart(_golDarah),
          ),
          const SizedBox(height: 25),

          const Text(
            "Data Polling",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),

          ...List.generate(_nama.length, (i) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(_nama[i]),
                subtitle: Text(
                  "Tinggi: ${_tinggi[i].toInt()} cm  •  Berat: ${_berat[i].toInt()} kg",
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ---------- Helper Widgets ----------

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildCard({required double height, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: SizedBox(height: height, child: child),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  // ---------- 1. Bar Chart (Tinggi Badan) ----------
  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        maxY: 200,
        alignment: BarChartAlignment.spaceAround,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 30,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= _nama.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _nama[value.toInt()],
                    style: const TextStyle(fontSize: 11),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(_tinggi.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: _tinggi[i],
                color: AppColors.primaryGreen,
                width: 20,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ---------- 2. Line Chart (Berat Badan) ----------
  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 30,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= _nama.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _nama[value.toInt()],
                    style: const TextStyle(fontSize: 11),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              _berat.length,
              (i) => FlSpot(i.toDouble(), _berat[i]),
            ),
            isCurved: true,
            color: AppColors.primaryGreen,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primaryGreen.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- 3 & 4. Pie / Donut Chart ----------
  Widget _buildPieChart(Map<String, double> data, {required bool donut}) {
    final entries = data.entries.toList();
    final total = data.values.fold<double>(0, (a, b) => a + b);

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: donut ? 45 : 0,
              sections: List.generate(entries.length, (i) {
                final value = entries[i].value;
                final percent = total == 0 ? 0 : (value / total * 100);
                return PieChartSectionData(
                  value: value,
                  color: _palette[i % _palette.length],
                  title: "${percent.toStringAsFixed(0)}%",
                  radius: donut ? 55 : 70,
                  titleStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: List.generate(entries.length, (i) {
            return _legendDot(
              _palette[i % _palette.length],
              "${entries[i].key} (${entries[i].value.toInt()})",
            );
          }),
        ),
      ],
    );
  }

  // ---------- 5. Radar Chart (Golongan Darah) ----------
  Widget _buildRadarChart(Map<String, double> data) {
    final titles = data.keys.toList();
    final values = data.values.toList();

    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        tickCount: 4,
        ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
        radarBorderData: BorderSide(color: Colors.grey.shade300),
        gridBorderData: BorderSide(color: Colors.grey.shade300, width: 1),
        titlePositionPercentageOffset: 0.15,
        getTitle: (index, angle) {
          if (index >= titles.length) {
            return const RadarChartTitle(text: "");
          }
          return RadarChartTitle(text: titles[index]);
        },
        titleTextStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        dataSets: [
          RadarDataSet(
            fillColor: AppColors.primaryGreen.withOpacity(0.25),
            borderColor: AppColors.primaryGreen,
            entryRadius: 3,
            borderWidth: 2,
            dataEntries: List.generate(
              values.length,
              (i) => RadarEntry(value: values[i]),
            ),
          ),
        ],
      ),
    );
  }
}