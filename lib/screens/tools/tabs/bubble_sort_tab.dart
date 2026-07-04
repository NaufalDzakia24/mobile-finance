import 'dart:math';
import 'package:flutter/material.dart';

class BubbleSortTab extends StatefulWidget {
  const BubbleSortTab({super.key});

  @override
  State<BubbleSortTab> createState() => _BubbleSortTabState();
}

class _BubbleSortTabState extends State<BubbleSortTab> {
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

  void bubbleSort() {
    List<int> numbers =
        controllers.map((e) => int.tryParse(e.text) ?? 0).toList();

    steps.clear();

    for (int i = 0; i < numbers.length - 1; i++) {
      for (int j = 0; j < numbers.length - i - 1; j++) {
        bool swap = ascending
            ? numbers[j] > numbers[j + 1]
            : numbers[j] < numbers[j + 1];

        if (swap) {
          int temp = numbers[j];
          numbers[j] = numbers[j + 1];
          numbers[j + 1] = temp;
        }
      }

      steps.add("Pass ${i + 1} : ${numbers.join(", ")}");
    }

    setState(() {
      result = numbers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Bubble Sort",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
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
                onChanged: (_) {
                  setState(() {
                    ascending = true;
                  });
                },
              ),
              const Text("Ascending"),
              const SizedBox(width: 20),
              Radio<bool>(
                value: false,
                groupValue: ascending,
                onChanged: (_) {
                  setState(() {
                    ascending = false;
                  });
                },
              ),
              const Text("Descending"),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: bubbleSort,
              child: const Text("SORT"),
            ),
          ),

          const SizedBox(height: 25),

          if (result.isNotEmpty) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hasil Sorting",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  result.join(", "),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Visualisasi Bubble Sort",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
