import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  // ===== KALKULATOR =====
  String? _selectedShape;
  final TextEditingController _input1 = TextEditingController();
  final TextEditingController _input2 = TextEditingController();
  double? _result;

  void _calculate() {
    double a = double.tryParse(_input1.text) ?? 0;
    double b = double.tryParse(_input2.text) ?? 0;

    switch (_selectedShape) {
      case 'Segitiga':
        _result = 0.5 * a * b;
        break;
      case 'Lingkaran':
        _result = 3.14 * a * a;
        break;
      case 'Kotak':
        _result = a * a;
        break;
      case 'Tabung':
        _result = 3.14 * a * a * b;
        break;
    }

    setState(() {});
  }

  // ===== QUIZ PILIHAN TUNGGAL =====
  int? _selectedAnswerSingle;
  bool _checkedSingle = false;

  // ===== QUIZ PILIHAN GANDA =====
  Set<int> _selectedAnswersMultiple = {};
  bool _checkedMultiple = false;
  final Set<int> _correctAnswersMultiple = {0, 2}; // Index jawaban benar

  // ===== POLLING =====
  Map<String, int> _pollingResults = {
    'Badminton': 0,
    'Catur': 0,
    'Padel': 0,
    'Basket': 0,
    'Lari Marathon': 0,
  };
  String? _userVote;

  void _vote(String hobby) {
    setState(() {
      if (_userVote != null) {
        _pollingResults[_userVote!] = _pollingResults[_userVote!]! - 1;
      }
      _userVote = hobby;
      _pollingResults[hobby] = _pollingResults[hobby]! + 1;
    });
  }

  int get _totalVotes => _pollingResults.values.reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kalkulator, Quiz & Polling'),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== KALKULATOR SECTION =====
              _buildSectionTitle("📐 Kalkulator Luas"),
              const SizedBox(height: 16),
              _buildCalculatorSection(),

              const Divider(height: 50, thickness: 2),

              // ===== QUIZ PILIHAN TUNGGAL =====
              _buildSectionTitle("📝 Quiz - Pilihan Tunggal"),
              const SizedBox(height: 16),
              _buildSingleChoiceQuiz(),

              const Divider(height: 50, thickness: 2),

              // ===== QUIZ PILIHAN GANDA =====
              _buildSectionTitle("📝 Quiz - Pilihan Ganda"),
              const SizedBox(height: 16),
              _buildMultipleChoiceQuiz(),

              const Divider(height: 50, thickness: 2),

              // ===== POLLING =====
              _buildSectionTitle("📊 Polling: Hobi Olahraga Favorit"),
              const SizedBox(height: 16),
              _buildPollingSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ===== SECTION TITLE WIDGET =====
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryGreen,
      ),
    );
  }

  // ===== KALKULATOR SECTION =====
  Widget _buildCalculatorSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Bentuk:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2,
              children: [
                _shapeButton("Segitiga", Icons.change_history),
                _shapeButton("Lingkaran", Icons.circle_outlined),
                _shapeButton("Kotak", Icons.crop_square),
                _shapeButton("Tabung", Icons.straighten),
              ],
            ),
            if (_selectedShape != null) ...[
              const SizedBox(height: 20),
              TextField(
                controller: _input1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _selectedShape == "Lingkaran"
                      ? "Jari-jari (r)"
                      : _selectedShape == "Kotak"
                          ? "Sisi"
                          : "Nilai 1",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.calculate),
                ),
              ),
              if (_selectedShape == "Segitiga" || _selectedShape == "Tabung")
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: _input2,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _selectedShape == "Tabung"
                          ? "Tinggi (t)"
                          : "Nilai 2",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.calculate),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _calculate,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Hitung"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              if (_result != null)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 12),
                      Text(
                        "Hasil: ${_result!.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _shapeButton(String title, IconData icon) {
    bool isSelected = _selectedShape == title;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedShape = title;
          _result = null;
          _input1.clear();
          _input2.clear();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade700,
              size: 30,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== QUIZ PILIHAN TUNGGAL =====
  Widget _buildSingleChoiceQuiz() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Soal: 8 × 7 = ?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...["54", "56", "63", "48", "64"].asMap().entries.map((e) {
              bool isCorrect = e.key == 1;
              bool isSelected = _selectedAnswerSingle == e.key;
              Color? tileColor;

              if (_checkedSingle && isSelected) {
                tileColor = isCorrect ? Colors.green.shade50 : Colors.red.shade50;
              }

              return Card(
                color: tileColor,
                child: RadioListTile(
                  value: e.key,
                  groupValue: _selectedAnswerSingle,
                  onChanged: (val) {
                    setState(() {
                      _selectedAnswerSingle = val as int;
                      _checkedSingle = true;
                    });
                  },
                  title: Text(
                    e.value,
                    style: TextStyle(
                      fontWeight: isSelected && _checkedSingle
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  activeColor: isCorrect ? Colors.green : Colors.red,
                ),
              );
            }),
            if (_checkedSingle) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _selectedAnswerSingle == 1
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _selectedAnswerSingle == 1 ? Colors.green : Colors.red,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedAnswerSingle == 1
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: _selectedAnswerSingle == 1
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedAnswerSingle == 1
                            ? "Benar! Jawaban Anda tepat."
                            : "Salah! Jawaban yang benar adalah: 56",
                        style: TextStyle(
                          color: _selectedAnswerSingle == 1
                              ? Colors.green.shade900
                              : Colors.red.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===== QUIZ PILIHAN GANDA =====
  Widget _buildMultipleChoiceQuiz() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Soal: Manakah yang merupakan bilangan prima?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Text(
              "(Pilih semua yang benar)",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ...["2", "4", "7", "9", "15"].asMap().entries.map((e) {
              bool isCorrect = _correctAnswersMultiple.contains(e.key);
              bool isSelected = _selectedAnswersMultiple.contains(e.key);
              Color? tileColor;

              if (_checkedMultiple) {
                if (isSelected && isCorrect) {
                  tileColor = Colors.green.shade50;
                } else if (isSelected && !isCorrect) {
                  tileColor = Colors.red.shade50;
                } else if (!isSelected && isCorrect) {
                  tileColor = Colors.orange.shade50;
                }
              }

              return Card(
                color: tileColor,
                child: CheckboxListTile(
                  value: isSelected,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedAnswersMultiple.add(e.key);
                      } else {
                        _selectedAnswersMultiple.remove(e.key);
                      }
                    });
                  },
                  title: Text(
                    e.value,
                    style: TextStyle(
                      fontWeight: isSelected || (_checkedMultiple && isCorrect)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  activeColor: Colors.blue,
                ),
              );
            }),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _checkedMultiple = true;
                  });
                },
                icon: const Icon(Icons.check),
                label: const Text("Cek Jawaban"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            if (_checkedMultiple) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _selectedAnswersMultiple.difference(_correctAnswersMultiple).isEmpty &&
                          _correctAnswersMultiple.difference(_selectedAnswersMultiple).isEmpty
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _selectedAnswersMultiple.difference(_correctAnswersMultiple).isEmpty &&
                            _correctAnswersMultiple.difference(_selectedAnswersMultiple).isEmpty
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _selectedAnswersMultiple.difference(_correctAnswersMultiple).isEmpty &&
                                  _correctAnswersMultiple.difference(_selectedAnswersMultiple).isEmpty
                              ? Icons.check_circle
                              : Icons.info,
                          color: _selectedAnswersMultiple.difference(_correctAnswersMultiple).isEmpty &&
                                  _correctAnswersMultiple.difference(_selectedAnswersMultiple).isEmpty
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedAnswersMultiple.difference(_correctAnswersMultiple).isEmpty &&
                                    _correctAnswersMultiple.difference(_selectedAnswersMultiple).isEmpty
                                ? "Benar! Semua jawaban Anda tepat."
                                : "Jawaban yang benar adalah: 2 dan 7",
                            style: TextStyle(
                              color: _selectedAnswersMultiple.difference(_correctAnswersMultiple).isEmpty &&
                                      _correctAnswersMultiple.difference(_selectedAnswersMultiple).isEmpty
                                  ? Colors.green.shade900
                                  : Colors.orange.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===== POLLING SECTION =====
  Widget _buildPollingSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih hobi olahraga favorit Anda:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ..._pollingResults.keys.map((hobby) {
              bool isVoted = _userVote == hobby;
              double percentage = _totalVotes > 0
                  ? (_pollingResults[hobby]! / _totalVotes) * 100
                  : 0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _vote(hobby),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isVoted
                          ? AppColors.primaryGreen.withOpacity(0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isVoted ? AppColors.primaryGreen : Colors.grey.shade300,
                        width: isVoted ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isVoted ? Icons.check_circle : Icons.circle_outlined,
                              color: isVoted ? AppColors.primaryGreen : Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                hobby,
                                style: TextStyle(
                                  fontWeight: isVoted
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              "${_pollingResults[hobby]} vote${_pollingResults[hobby]! > 1 ? 's' : ''} (${percentage.toStringAsFixed(1)}%)",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isVoted ? AppColors.primaryGreen : Colors.blue.shade300,
                          ),
                          minHeight: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.how_to_vote, color: Colors.blue),
                  const SizedBox(width: 12),
                  Text(
                    "Total suara: $_totalVotes",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _input1.dispose();
    _input2.dispose();
    super.dispose();
  }
}