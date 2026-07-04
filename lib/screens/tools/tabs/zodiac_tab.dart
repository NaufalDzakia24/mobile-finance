import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ZodiacTab extends StatefulWidget {
  const ZodiacTab({super.key});

  @override
  State<ZodiacTab> createState() => _ZodiacTabState();
}

class _ZodiacTabState extends State<ZodiacTab> {
  DateTime? selectedDate;
  String zodiac = "-";
  String range = "-";
  String emoji = "✨";

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void checkZodiac() {
    if (selectedDate == null) return;

    int day = selectedDate!.day;
    int month = selectedDate!.month;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      zodiac = "Aries";
      range = "21 Maret - 19 April";
      emoji = "♈";
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      zodiac = "Taurus";
      range = "20 April - 20 Mei";
      emoji = "♉";
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      zodiac = "Gemini";
      range = "21 Mei - 20 Juni";
      emoji = "♊";
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      zodiac = "Cancer";
      range = "21 Juni - 22 Juli";
      emoji = "♋";
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      zodiac = "Leo";
      range = "23 Juli - 22 Agustus";
      emoji = "♌";
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      zodiac = "Virgo";
      range = "23 Agustus - 22 September";
      emoji = "♍";
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      zodiac = "Libra";
      range = "23 September - 22 Oktober";
      emoji = "♎";
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      zodiac = "Scorpio";
      range = "23 Oktober - 21 November";
      emoji = "♏";
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      zodiac = "Sagittarius";
      range = "22 November - 21 Desember";
      emoji = "♐";
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      zodiac = "Capricorn";
      range = "22 Desember - 19 Januari";
      emoji = "♑";
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      zodiac = "Aquarius";
      range = "20 Januari - 18 Februari";
      emoji = "♒";
    } else {
      zodiac = "Pisces";
      range = "19 Februari - 20 Maret";
      emoji = "♓";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Cek Zodiac",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          ElevatedButton.icon(
            onPressed: pickDate,
            icon: const Icon(Icons.calendar_today),
            label: const Text("Pilih Tanggal Lahir"),
          ),

          const SizedBox(height: 15),

          Text(
            selectedDate == null
                ? "Belum memilih tanggal"
                : DateFormat("dd MMMM yyyy").format(selectedDate!),
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: checkZodiac,
              child: const Text("CEK ZODIAC"),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 55),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    zodiac,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    range,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}