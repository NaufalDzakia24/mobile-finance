import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MaxMinTab extends StatefulWidget {
  const MaxMinTab({super.key});

  @override
  State<MaxMinTab> createState() => _MaxMinTabState();
}

class _MaxMinTabState extends State<MaxMinTab> {
  final TextEditingController _inputController = TextEditingController();
  final List<double> _numbers = [];
  double? _maxValue;
  double? _minValue;
  bool _hasCalculated = false;

  void _addNumber() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final number = double.tryParse(text);
    if (number == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Masukkan angka yang valid'),
          backgroundColor: AppColors.expenseRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() {
      _numbers.add(number);
      _inputController.clear();
      _hasCalculated = false;
    });
  }

  void _removeNumber(int index) {
    setState(() {
      _numbers.removeAt(index);
      _hasCalculated = false;
    });
  }

  void _calculateMaxMin() {
    if (_numbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tambahkan minimal 1 angka terlebih dahulu'),
          backgroundColor: AppColors.warningOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    // Algoritma manual mencari Max dan Min
    double max = _numbers[0];
    double min = _numbers[0];

    for (int i = 1; i < _numbers.length; i++) {
      if (_numbers[i] > max) {
        max = _numbers[i];
      }
      if (_numbers[i] < min) {
        min = _numbers[i];
      }
    }

    setState(() {
      _maxValue = max;
      _minValue = min;
      _hasCalculated = true;
    });
  }

  void _clearAll() {
    setState(() {
      _numbers.clear();
      _maxValue = null;
      _minValue = null;
      _hasCalculated = false;
      _inputController.clear();
    });
  }

  String _formatNumber(double value) {
    if (value == value.toInt().toDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input Section
          const Text('Masukkan Angka',
              style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style:
                      const TextStyle(fontSize: 14, color: AppColors.textDark),
                  decoration: InputDecoration(
                    hintText: 'Contoh: 42, 17.5, -8',
                    hintStyle: const TextStyle(
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.normal,
                        fontSize: 13),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: AppColors.primaryGreen),
                    ),
                  ),
                  onSubmitted: (_) => _addNumber(),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _addNumber,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Numbers List
          if (_numbers.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Angka (${_numbers.length})',
                  style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: _clearAll,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.iconBgRed,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Hapus Semua',
                        style: TextStyle(
                            color: AppColors.expenseRed,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_numbers.length, (index) {
                  final isMax =
                      _hasCalculated && _numbers[index] == _maxValue;
                  final isMin =
                      _hasCalculated && _numbers[index] == _minValue;

                  Color chipBg = Colors.grey.shade100;
                  Color chipText = AppColors.textDark;
                  Color chipBorder = Colors.grey.shade200;

                  if (isMax) {
                    chipBg = AppColors.lightGreenBg;
                    chipText = AppColors.primaryGreen;
                    chipBorder = AppColors.primaryGreen.withOpacity(0.3);
                  } else if (isMin) {
                    chipBg = AppColors.iconBgRed;
                    chipText = AppColors.expenseRed;
                    chipBorder = AppColors.expenseRed.withOpacity(0.3);
                  }

                  return GestureDetector(
                    onTap: () => _removeNumber(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: chipBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: chipBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isMax)
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.arrow_upward,
                                  size: 12, color: AppColors.primaryGreen),
                            ),
                          if (isMin)
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.arrow_downward,
                                  size: 12, color: AppColors.expenseRed),
                            ),
                          Text(
                            _formatNumber(_numbers[index]),
                            style: TextStyle(
                                color: chipText,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.close,
                              size: 14, color: chipText.withOpacity(0.5)),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Calculate Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _calculateMaxMin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calculate_outlined,
                      color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Cari Max & Min',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Results
          if (_hasCalculated) ...[
            Row(
              children: [
                Expanded(
                  child: _buildResultCard(
                    icon: Icons.arrow_upward_rounded,
                    label: 'Nilai Maksimum',
                    value: _formatNumber(_maxValue!),
                    color: AppColors.primaryGreen,
                    bgColor: AppColors.lightGreenBg,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildResultCard(
                    icon: Icons.arrow_downward_rounded,
                    label: 'Nilai Minimum',
                    value: _formatNumber(_minValue!),
                    color: AppColors.expenseRed,
                    bgColor: AppColors.iconBgRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Info Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.iconBgBlue,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.progressBlue.withOpacity(0.2)),
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
                    child: const Icon(Icons.info_outline,
                        color: AppColors.progressBlue, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Selisih (Range)',
                            style: TextStyle(
                                color: AppColors.progressBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(
                          'Jarak antara Max dan Min adalah ${_formatNumber(_maxValue! - _minValue!)} dari ${_numbers.length} angka yang dimasukkan.',
                          style: const TextStyle(
                              color: AppColors.textDark,
                              fontSize: 11,
                              height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Empty State
          if (!_hasCalculated && _numbers.isEmpty)
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(vertical: 40),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(Icons.swap_vert_rounded,
                      size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  const Text('Masukkan angka untuk mencari Max & Min',
                      style:
                          TextStyle(color: AppColors.textGrey, fontSize: 13)),
                ],
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
