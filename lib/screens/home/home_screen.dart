import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'widgets/header_section.dart';
import 'widgets/balance_card.dart';
import 'widgets/insight_card.dart';
import 'widgets/goals_section.dart';
import 'widgets/transaction_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HeaderSection(),
              SizedBox(height: 24),
              BalanceCard(),
              SizedBox(height: 20),
              InsightCard(),
              SizedBox(height: 24),
              GoalsSection(),
              SizedBox(height: 24),
              TransactionList(),
            ],
          ),
        ),
      ),
    );
  }
}