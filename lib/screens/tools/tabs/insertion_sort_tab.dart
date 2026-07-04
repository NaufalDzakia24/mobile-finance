import 'dart:math';
import 'package:flutter/material.dart';

class InsertionSortTab extends StatefulWidget {
  const InsertionSortTab({super.key});

  @override
  State<InsertionSortTab> createState() => _InsertionSortTabState();
}

class _InsertionSortTabState extends State<InsertionSortTab> {
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

  void insertionSort() {
    List<int> arr =
        controllers.map((e) => int.tryParse(e.text) ?? 0).toList();

    steps.clear();

    for (int i = 1; i < arr.length; i++) {
      int key = arr[i];
      int j = i - 1;

      while (j >= 0 &&
          (ascending ? arr[j] > key : arr[j] < key)) {
        arr[j + 1] = arr[j];
        j--;
      }

      arr[j + 1] = key;

      steps.add("Step $i: ${arr.join(", ")}");
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
            "Insertion Sort",
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
            onPressed: insertionSort,
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
              "Steps",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...steps.map(
              (e) => Card(
                child: ListTile(
                  leading: const Icon(Icons.timeline),
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