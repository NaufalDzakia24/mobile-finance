import 'dart:math';
import 'package:flutter/material.dart';

class QuickSortTab extends StatefulWidget {
  const QuickSortTab({super.key});

  @override
  State<QuickSortTab> createState() => _QuickSortTabState();
}

class _QuickSortTabState extends State<QuickSortTab> {
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

  void quickSort() {
    List<int> numbers =
        controllers.map((e) => int.tryParse(e.text) ?? 0).toList();

    steps.clear();

    _quickSort(numbers, 0, numbers.length - 1);

    setState(() {
      result = numbers;
    });
  }

  void _quickSort(List<int> arr, int low, int high) {
    if (low < high) {
      int pi = _partition(arr, low, high);

      steps.add(arr.join(", "));

      _quickSort(arr, low, pi - 1);
      _quickSort(arr, pi + 1, high);
    }
  }

  int _partition(List<int> arr, int low, int high) {
    int pivot = arr[high];
    int i = low - 1;

    for (int j = low; j < high; j++) {
      bool condition =
          ascending ? arr[j] <= pivot : arr[j] >= pivot;

      if (condition) {
        i++;

        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
      }
    }

    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;

    return i + 1;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Quick Sort",
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
              onPressed: quickSort,
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
                "Visualisasi Quick Sort",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            ...steps.asMap().entries.map(
              (entry) => Card(
                child: ListTile(
                  leading: const Icon(Icons.flash_on),
                  title: Text("Step ${entry.key + 1}"),
                  subtitle: Text(entry.value),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}