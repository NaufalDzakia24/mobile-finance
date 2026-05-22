import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class DiscountTab extends StatefulWidget {
  const DiscountTab({super.key});

  @override
  State<DiscountTab> createState() => _DiscountTabState();
}

class _DiscountTabState extends State<DiscountTab> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  double? _originalPrice;
  double? _discountPercent;
  double? _discountAmount;
  double? _finalPrice;
  bool _hasCalculated = false;

  String _formatCurrency(double amount) {
    String amountStr = amount.toInt().toString();
    String result = '';
    int count = 0;
    for (int i = amountStr.length - 1; i >= 0; i--) {
      if (count != 0 && count % 3 == 0) {
        result = '.$result';
      }
      result = amountStr[i] + result;
      count++;
    }
    return 'Rp $result';
  }

  void _calculateDiscount() {
    final priceText = _priceController.text.replaceAll('.', '').replaceAll(',', '').trim();
    final discountText = _discountController.text.trim();

    if (priceText.isEmpty || discountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Isi semua field terlebih dahulu'),
          backgroundColor: AppColors.warningOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final price = double.tryParse(priceText);
    final discount = double.tryParse(discountText);

    if (price == null || discount == null || discount < 0 || discount > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Masukkan angka yang valid (diskon 0-100%)'),
          backgroundColor: AppColors.expenseRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() {
      _originalPrice = price;
      _discountPercent = discount;
      _discountAmount = price * discount / 100;
      _finalPrice = price - _discountAmount!;
      _hasCalculated = true;
    });
  }

  void _clearAll() {
    setState(() {
      _priceController.clear();
      _discountController.clear();
      _originalPrice = null;
      _discountPercent = null;
      _discountAmount = null;
      _finalPrice = null;
      _hasCalculated = false;
    });
  }

  // Preset discount buttons
  void _applyPreset(int percent) {
    setState(() {
      _discountController.text = percent.toString();
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price Input
          const Text('Harga Barang',
              style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _ThousandSeparatorFormatter(),
            ],
            style: const TextStyle(fontSize: 14, color: AppColors.textDark),
            decoration: InputDecoration(
              hintText: 'Contoh: 500.000',
              hintStyle: const TextStyle(
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.normal,
                  fontSize: 13),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 12, right: 8),
                child: const Text('Rp',
                    style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryGreen),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Discount Input
          const Text('Persentase Diskon (%)',
              style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _discountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 14, color: AppColors.textDark),
            decoration: InputDecoration(
              hintText: 'Contoh: 25',
              hintStyle: const TextStyle(
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.normal,
                  fontSize: 13),
              suffixIcon: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Text('%',
                    style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
              suffixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryGreen),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Quick Presets
          const Text('Diskon Populer',
              style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [10, 15, 20, 25, 30, 50].map((percent) {
              final isSelected =
                  _discountController.text == percent.toString();
              return Expanded(
                child: GestureDetector(
                  onTap: () => _applyPreset(percent),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$percent%',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _clearAll,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textGrey,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Reset',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _calculateDiscount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.discount_outlined,
                            color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text('Hitung Diskon',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Results
          if (_hasCalculated) ...[
            // Price breakdown card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildPriceRow(
                    'Harga Asli',
                    _formatCurrency(_originalPrice!),
                    AppColors.textDark,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1),
                  ),
                  _buildPriceRow(
                    'Diskon (${_discountPercent!.toInt()}%)',
                    '- ${_formatCurrency(_discountAmount!)}',
                    AppColors.expenseRed,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreenBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Harga Akhir',
                            style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text(
                          _formatCurrency(_finalPrice!),
                          style: const TextStyle(
                              color: AppColors.primaryGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Savings info card
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
                    child: const Icon(Icons.savings_outlined,
                        color: AppColors.progressBlue, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Anda Hemat!',
                            style: TextStyle(
                                color: AppColors.progressBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(
                          'Anda menghemat ${_formatCurrency(_discountAmount!)} dari harga asli. Dana ini bisa dialokasikan untuk tujuan keuangan Anda!',
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
          if (!_hasCalculated)
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
                  Icon(Icons.receipt_long_outlined,
                      size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  const Text('Masukkan harga & diskon untuk melihat hasil',
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

  Widget _buildPriceRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        Text(value,
            style: TextStyle(
                color: valueColor,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// Formatter untuk otomatis tambahkan titik ribuan saat mengetik
class _ThousandSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Hapus semua titik yang ada
    String text = newValue.text.replaceAll('.', '');

    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Format ulang dengan titik ribuan
    String formatted = '';
    int count = 0;
    for (int i = text.length - 1; i >= 0; i--) {
      if (count != 0 && count % 3 == 0) {
        formatted = '.$formatted';
      }
      formatted = text[i] + formatted;
      count++;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
