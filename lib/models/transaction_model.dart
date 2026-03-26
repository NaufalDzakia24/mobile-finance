import 'package:flutter/material.dart';

class TransactionModel {
  final int? id; // Tambahkan ID untuk primary key SQLite
  final String title;
  final String category; // Tambahkan kategori untuk menentukan Icon di UI
  final String date;
  final double amount; // Gunakan double agar bisa dihitung (tambah/kurang)
  final bool isExpense;

  TransactionModel({
    this.id,
    required this.title, 
    required this.category,
    required this.date, 
    required this.amount, 
    required this.isExpense,
  });

  // Helper untuk mengubah Kategori menjadi Icon di UI secara otomatis
  IconData get icon {
    switch (category.toLowerCase()) {
      // Pemasukan
      case 'gaji': return Icons.account_balance_wallet;
      case 'bonus': return Icons.card_giftcard;
      // Pengeluaran
      case 'makanan': return Icons.fastfood;
      case 'transportasi': return Icons.directions_car;
      case 'hiburan': return Icons.movie;
      case 'belanja': return Icons.shopping_bag;
      case 'kesehatan': return Icons.medical_services;
      default: return isExpense ? Icons.outbox : Icons.move_to_inbox;
    }
  }

  // Konversi ke Map untuk masuk ke SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'date': date,
      'amount': amount,
      'isExpense': isExpense ? 1 : 0, // SQLite simpan bool sebagai 1/0
    };
  }

  // Konversi dari Map SQLite kembali ke Object
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      date: map['date'],
      amount: map['amount'],
      isExpense: map['isExpense'] == 1,
    );
  }
}