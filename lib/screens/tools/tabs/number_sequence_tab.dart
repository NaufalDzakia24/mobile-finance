import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class NumberSequenceTab extends StatefulWidget {
  const NumberSequenceTab({super.key});

  @override
  State<NumberSequenceTab> createState() => _NumberSequenceTabState();
}

class _NumberSequenceTabState extends State<NumberSequenceTab> {
  String _selectedType = 'bulat'; // bulat, ganjil, fibonacci, ganjil_pilih
  String _selectedLoopForGanjil =
      'for'; // for, while, do-while (untuk opsi ke-4)
  int _count = 20; // jumlah angka yang di-generate (bisa diubah user)
  List<int> _generatedNumbers = [];
  bool _hasGenerated = false;
  String _algorithmInfo = '';
  String _usedLoop = '';

  void _incrementCount() {
    if (_count < 50) {
      setState(() {
        _count++;
        _hasGenerated = false;
      });
    }
  }

  void _decrementCount() {
    if (_count > 1) {
      setState(() {
        _count--;
        _hasGenerated = false;
      });
    }
  }

  void _resetAll() {
    setState(() {
      _generatedNumbers = [];
      _hasGenerated = false;
      _algorithmInfo = '';
      _usedLoop = '';
      _count = 20;
    });
  }

  void _generateNumbers() {
    List<int> result = [];
    String info = '';
    String loop = '';

    switch (_selectedType) {
      case 'bulat':
        result = _generateBulatWithFor(_count);
        loop = 'FOR';
        info =
            'Menggunakan perulangan FOR untuk menghasilkan $_count bilangan bulat berurutan mulai dari 1.';
        break;
      case 'ganjil':
        result = _generateGanjilWithWhile(_count);
        loop = 'WHILE';
        info =
            'Menggunakan perulangan WHILE untuk menghasilkan $_count bilangan ganjil berurutan.';
        break;
      case 'fibonacci':
        result = _generateFibonacciWithDoWhile(_count);
        loop = 'DO-WHILE';
        info =
            'Menggunakan perulangan DO-WHILE untuk menghasilkan $_count bilangan Fibonacci.';
        break;
      case 'ganjil_pilih':
        // No. 4 - Bilangan Ganjil (pilih salah satu loop)
        switch (_selectedLoopForGanjil) {
          case 'for':
            result = _generateGanjilWithFor(_count);
            loop = 'FOR';
            info =
                'Menggunakan perulangan FOR (pilihan Anda) untuk menghasilkan $_count bilangan ganjil.';
            break;
          case 'while':
            result = _generateGanjilWithWhile(_count);
            loop = 'WHILE';
            info =
                'Menggunakan perulangan WHILE (pilihan Anda) untuk menghasilkan $_count bilangan ganjil.';
            break;
          case 'do-while':
            result = _generateGanjilWithDoWhile(_count);
            loop = 'DO-WHILE';
            info =
                'Menggunakan perulangan DO-WHILE (pilihan Anda) untuk menghasilkan $_count bilangan ganjil.';
            break;
        }
        break;
    }

    setState(() {
      _generatedNumbers = result;
      _hasGenerated = true;
      _algorithmInfo = info;
      _usedLoop = loop;
    });
  }

  // ========================
  // ALGORITMA GENERATOR
  // ========================

  // 1. Bilangan Bulat menggunakan FOR
  List<int> _generateBulatWithFor(int n) {
    List<int> numbers = [];
    for (int i = 1; i <= n; i++) {
      numbers.add(i);
    }
    return numbers;
  }

  // 2. Bilangan Ganjil menggunakan WHILE
  List<int> _generateGanjilWithWhile(int n) {
    List<int> numbers = [];
    int i = 1;
    int count = 0;
    while (count < n) {
      if (i % 2 != 0) {
        numbers.add(i);
        count++;
      }
      i++;
    }
    return numbers;
  }

  // 3. Bilangan Fibonacci menggunakan DO-WHILE
  List<int> _generateFibonacciWithDoWhile(int n) {
    List<int> numbers = [];
    int a = 0;
    int b = 1;
    int count = 0;

    do {
      numbers.add(a);
      int temp = a + b;
      a = b;
      b = temp;
      count++;
    } while (count < n);

    return numbers;
  }

  // 4a. Bilangan Ganjil menggunakan FOR (pilih salah satu)
  List<int> _generateGanjilWithFor(int n) {
    List<int> numbers = [];
    for (int i = 0; i < n; i++) {
      numbers.add(2 * i + 1); // rumus bilangan ganjil ke-i
    }
    return numbers;
  }

  // 4b. Bilangan Ganjil menggunakan DO-WHILE (pilih salah satu)
  List<int> _generateGanjilWithDoWhile(int n) {
    List<int> numbers = [];
    int i = 1;
    int count = 0;

    do {
      if (i % 2 != 0) {
        numbers.add(i);
        count++;
      }
      i++;
    } while (count < n);

    return numbers;
  }

  // ========================
  // HELPER UI
  // ========================

  String _getTypeLabel(String type) {
    switch (type) {
      case 'bulat':
        return 'Bilangan Bulat';
      case 'ganjil':
        return 'Bilangan Ganjil';
      case 'fibonacci':
        return 'Fibonacci';
      case 'ganjil_pilih':
        return 'Ganjil (Pilih Loop)';
      default:
        return '';
    }
  }

  String _getTypeSubtitle(String type) {
    switch (type) {
      case 'bulat':
        return 'Loop: FOR';
      case 'ganjil':
        return 'Loop: WHILE';
      case 'fibonacci':
        return 'Loop: DO-WHILE';
      case 'ganjil_pilih':
        return 'Pilih salah satu loop';
      default:
        return '';
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'bulat':
        return Icons.looks_one_outlined;
      case 'ganjil':
        return Icons.filter_1_outlined;
      case 'fibonacci':
        return Icons.all_inclusive;
      case 'ganjil_pilih':
        return Icons.tune;
      default:
        return Icons.numbers;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'bulat':
        return AppColors.primaryGreen;
      case 'ganjil':
        return AppColors.warningOrange;
      case 'fibonacci':
        return AppColors.progressBlue;
      case 'ganjil_pilih':
        return const Color(0xFF9B59B6); // ungu - beda dari 3 lainnya
      default:
        return AppColors.primaryGreen;
    }
  }

  Color _getTypeBgColor(String type) {
    switch (type) {
      case 'bulat':
        return AppColors.lightGreenBg;
      case 'ganjil':
        return AppColors.iconBgOrange;
      case 'fibonacci':
        return AppColors.iconBgBlue;
      case 'ganjil_pilih':
        return const Color(0xFFF3E8FF); // light purple
      default:
        return AppColors.lightGreenBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _getTypeColor(_selectedType);
    final activeBgColor = _getTypeBgColor(_selectedType);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===========================
          // SECTION 1: Pilih Jenis Bilangan
          // ===========================
          const Text(
            'Pilih Jenis Bilangan',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),

          ...['bulat', 'ganjil', 'fibonacci', 'ganjil_pilih'].map((type) {
            final isSelected = _selectedType == type;
            final color = _getTypeColor(type);
            final bgColor = _getTypeBgColor(type);

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = type;
                  _hasGenerated = false;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? bgColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? color.withOpacity(0.4)
                        : Colors.grey.shade200,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withOpacity(0.15)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getTypeIcon(type),
                        color: isSelected ? color : AppColors.textGrey,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _getTypeLabel(type),
                                style: TextStyle(
                                  color: isSelected
                                      ? color
                                      : AppColors.textDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (type == 'ganjil_pilih') ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? color.withOpacity(0.15)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getTypeSubtitle(type),
                            style: TextStyle(
                              color: isSelected
                                  ? color.withOpacity(0.7)
                                  : AppColors.textGrey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? color : Colors.grey.shade300,
                          width: isSelected ? 5 : 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          // ===========================
          // SECTION 1.5: Pilih Loop (hanya untuk No.4)
          // ===========================
          if (_selectedType == 'ganjil_pilih') ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF9B59B6).withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Metode Loop:',
                    style: TextStyle(
                      color: Color(0xFF9B59B6),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildLoopOption('for', 'FOR'),
                      const SizedBox(width: 8),
                      _buildLoopOption('while', 'WHILE'),
                      const SizedBox(width: 8),
                      _buildLoopOption('do-while', 'DO-WHILE'),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ===========================
          // SECTION 2: Jumlah Angka (Stepper)
          // ===========================
          const Text(
            'Jumlah Angka',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Minus Button
                GestureDetector(
                  onTap: _decrementCount,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _count > 1
                          ? activeColor.withOpacity(0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.remove,
                      color: _count > 1 ? activeColor : Colors.grey.shade400,
                      size: 20,
                    ),
                  ),
                ),
                // Count Display
                Column(
                  children: [
                    Text(
                      '$_count',
                      style: TextStyle(
                        color: activeColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'angka',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 11),
                    ),
                  ],
                ),
                // Plus Button
                GestureDetector(
                  onTap: _incrementCount,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _count < 50
                          ? activeColor.withOpacity(0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.add,
                      color: _count < 50 ? activeColor : Colors.grey.shade400,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Min: 1 | Max: 50',
              style: TextStyle(color: AppColors.textGrey, fontSize: 10),
            ),
          ),
          const SizedBox(height: 16),

          // ===========================
          // SECTION 3: Action Buttons
          // ===========================
          Row(
            children: [
              // Reset Button
               Expanded(
                child: GestureDetector(
                  onTap: _resetAll,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, size: 18, color: AppColors.textGrey),
                        const SizedBox(width: 4),
                        Text(
                          'Reset',
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Generate Button
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _generateNumbers,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _hasGenerated
                              ? Icons.replay_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _hasGenerated ? 'Generate Ulang' : 'Generate',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ===========================
          // SECTION 4: Results
          // ===========================
          if (_hasGenerated) ...[
            // Algorithm Info Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: activeBgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: activeColor.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.code, color: activeColor, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Algoritma: $_usedLoop',
                          style: TextStyle(
                            color: activeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _algorithmInfo,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Number Grid
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getTypeIcon(_selectedType),
                        color: activeColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_getTypeLabel(_selectedType)} (${_generatedNumbers.length} angka)',
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_generatedNumbers.length, (index) {
                      return Container(
                        constraints: const BoxConstraints(minWidth: 48),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: activeBgColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: activeColor.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: activeColor.withOpacity(0.5),
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${_generatedNumbers[index]}',
                              style: TextStyle(
                                color: activeColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Summary
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Jenis', _getTypeLabel(_selectedType)),
                  const Divider(height: 20),
                  _buildSummaryRow('Loop yang Dipakai', _usedLoop),
                  const Divider(height: 20),
                  _buildSummaryRow(
                    'Jumlah Elemen',
                    '${_generatedNumbers.length}',
                  ),
                  const Divider(height: 20),
                  _buildSummaryRow(
                    'Nilai Pertama',
                    '${_generatedNumbers.first}',
                  ),
                  const Divider(height: 20),
                  _buildSummaryRow(
                    'Nilai Terakhir',
                    '${_generatedNumbers.last}',
                  ),
                  const Divider(height: 20),
                  _buildSummaryRow(
                    'Total Jumlah',
                    '${_generatedNumbers.reduce((a, b) => a + b)}',
                  ),
                ],
              ),
            ),
          ],

          // Empty State
          if (!_hasGenerated)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(vertical: 36),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.format_list_numbered_rounded,
                    size: 48,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Pilih jenis, atur jumlah, lalu tekan Generate',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget untuk pilihan loop pada No.4
  Widget _buildLoopOption(String value, String label) {
    final isSelected = _selectedLoopForGanjil == value;
    const color = Color(0xFF9B59B6);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLoopForGanjil = value;
            _hasGenerated = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textGrey,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
