import 'dart:math';
import 'package:flutter/material.dart';

class SelectionSortTab extends StatefulWidget {
  const SelectionSortTab({super.key});

  @override
  State<SelectionSortTab> createState() => _SelectionSortTabState();
}

class _SelectionSortTabState extends State<SelectionSortTab> {
  final List<TextEditingController> controllers =
      List.generate(10, (_) => TextEditingController());

  List<int> result = [];
  List<String> steps = [];
  bool ascending = true;

  void generateRandom() {
    final random = Random();

    for (var c in controllers) {
      c.text = (random.nextInt(100) + 1).toString();
    }

    setState(() {
      result.clear();
      steps.clear();
    });
  }

  void selectionSort() {
    List<int> arr =
        controllers.map((e) => int.tryParse(e.text) ?? 0).toList();

    steps.clear();

    for (int i = 0; i < arr.length - 1; i++) {
      int selectedIndex = i;

      for (int j = i + 1; j < arr.length; j++) {
        bool condition = ascending
            ? arr[j] < arr[selectedIndex]
            : arr[j] > arr[selectedIndex];

        if (condition) {
          selectedIndex = j;
        }
      }

      int temp = arr[i];
      arr[i] = arr[selectedIndex];
      arr[selectedIndex] = temp;

      steps.add("Step ${i + 1}: ${arr.join(", ")}");
    }

    setState(() {
      result = arr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Selection Sort",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (_, index) {
              return TextField(
                controller: controllers[index],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Angka ${index + 1}",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: generateRandom,
            icon: const Icon(Icons.casino),
            label: const Text("Generate Random"),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<bool>(
                value: true,
                groupValue: ascending,
                onChanged: (_) => setState(() => ascending = true),
              ),
              const Text("Ascending"),
              const SizedBox(width: 20),
              Radio<bool>(
                value: false,
                groupValue: ascending,
                onChanged: (_) => setState(() => ascending = false),
              ),
              const Text("Descending"),
            ],
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: selectionSort,
            child: const Text("SORT"),
          ),

          const SizedBox(height: 20),

          if (result.isNotEmpty) ...[
            const Text(
              "Hasil",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(result.join(", ")),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Step Visualisasi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...steps.map(
              (e) => Card(
                child: ListTile(
                  leading: const Icon(Icons.swap_horiz),
                  title: Text(e),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}