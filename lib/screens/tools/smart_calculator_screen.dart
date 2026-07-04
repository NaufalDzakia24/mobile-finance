import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'tabs/max_min_tab.dart';
import 'tabs/discount_tab.dart';
import 'tabs/number_sequence_tab.dart';
import 'tabs/bubble_sort_tab.dart';
import 'tabs/selection_sort_tab.dart';
import 'tabs/insertion_sort_tab.dart';
import 'tabs/merge_sort_tab.dart';
import 'tabs/quick_sort_tab.dart';
import 'tabs/zodiac_tab.dart';

class SmartCalculatorScreen extends StatefulWidget {
  const SmartCalculatorScreen({super.key});

  @override
  State<SmartCalculatorScreen> createState() => _SmartCalculatorScreenState();
}

class _SmartCalculatorScreenState extends State<SmartCalculatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_TabItem> _tabs = const [
    _TabItem(icon: Icons.swap_vert_rounded, label: 'Max & Min'),
    _TabItem(icon: Icons.discount_outlined, label: 'Diskon'),
    _TabItem(icon: Icons.format_list_numbered_rounded, label: 'Bilangan'),
    _TabItem(icon: Icons.bubble_chart, label: 'Bubble'),
    _TabItem(icon: Icons.select_all, label: 'Selection'),
    _TabItem(icon: Icons.input, label: 'Insertion'),
    _TabItem(icon: Icons.merge_type, label: 'Merge'),
    _TabItem(icon: Icons.flash_on, label: 'Quick'),
    _TabItem(icon: Icons.stars, label: 'Zodiac'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                color: AppColors.textDark, size: 14),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kalkulator Pintar',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- AI Info Card ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.smart_toy_outlined,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tools Keuangan Pintar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                        SizedBox(height: 4),
                        Text(
                          'Cari nilai Max & Min, hitung diskon pembelian, dan generate deret bilangan dengan mudah dalam satu tempat.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Custom Tab Bar (FIXED) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicator: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textGrey,
                labelPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                labelStyle: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w500),
                tabs: _tabs.map((tab) {
                  final isSelected =
                      _tabController.index == _tabs.indexOf(tab);
                  return Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(tab.icon,
                            size: 16,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textGrey),
                        const SizedBox(width: 4),
                        Text(
                          tab.label,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // --- Tab Content ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                MaxMinTab(),
                DiscountTab(),
                NumberSequenceTab(),
                BubbleSortTab(),
                SelectionSortTab(),
                InsertionSortTab(),
                MergeSortTab(),
                QuickSortTab(),
                ZodiacTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;

  const _TabItem({required this.icon, required this.label});
}