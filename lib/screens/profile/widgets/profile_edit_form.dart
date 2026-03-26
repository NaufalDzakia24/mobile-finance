import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ProfileEditForm extends StatefulWidget {
  const ProfileEditForm({super.key});

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  // Controller untuk input teks agar bisa diedit
  final TextEditingController _nameController = TextEditingController(text: 'Budi Santoso');
  final TextEditingController _emailController = TextEditingController(text: 'budi.santoso@email.com');
  final TextEditingController _phoneController = TextEditingController(text: '+62 812 3456 7890');
  final TextEditingController _birthDateController = TextEditingController(text: '15 Agustus 1990');
  
  String? _selectedGender = 'Laki-laki'; // Nilai awal dropdown

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputLabel('Nama Lengkap'),
          _buildTextField(
            controller: _nameController,
            suffixIcon: Icons.close, // Ikon 'X' untuk menghapus teks
            onSuffixIconTap: () => _nameController.clear(),
          ),
          const SizedBox(height: 20),

          _buildInputLabel('Email'),
          _buildTextField(controller: _emailController, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 20),

          _buildInputLabel('Nomor Telepon'),
          _buildTextField(controller: _phoneController, keyboardType: TextInputType.phone),
          const SizedBox(height: 20),

          _buildInputLabel('Tanggal Lahir'),
          _buildTextField(
            controller: _birthDateController,
            suffixIcon: Icons.calendar_today_outlined,
            readOnly: true, // Tidak bisa diketik manual, harus pakai picker
            onTap: () {
              // TODO: Tampilkan DatePicker di sini
            },
          ),
          const SizedBox(height: 20),

          _buildInputLabel('Jenis Kelamin'),
          _buildDropdownField(),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: const TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
    IconData? suffixIcon,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    VoidCallback? onSuffixIconTap,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.normal),
        suffixIcon: suffixIcon != null
            ? GestureDetector(onTap: onSuffixIconTap, child: Icon(suffixIcon, color: AppColors.textGrey, size: 20))
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryGreen)),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey),
          style: const TextStyle(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
          items: <String>['Laki-laki', 'Perempuan']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }
}