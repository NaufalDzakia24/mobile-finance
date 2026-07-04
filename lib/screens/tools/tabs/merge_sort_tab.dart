import 'dart:math';
import 'package:flutter/material.dart';

class MergeSortTab extends StatefulWidget {
  const MergeSortTab({super.key});

  @override
  State<MergeSortTab> createState() => _MergeSortTabState();
}

class _MergeSortTabState extends State<MergeSortTab> {
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

  List<int> mergeSort(List<int> arr) {
    if (arr.length <= 1) return arr;

    int mid = arr.length ~/ 2;
    List<int> left = mergeSort(arr.sublist(0, mid));
    List<int> right = mergeSort(arr.sublist(mid));

    return merge(left, right);
  }

  List<int> merge(List<int> left, List<int> right) {
    List<int> result = [];
    int i = 0, j = 0;

    while (i < left.length && j < right.length) {
      bool condition = ascending
          ? left[i] <= right[j]
          : left[i] >= right[j];

      if (condition) {
        result.add(left[i]);
        i++;
      } else {
        result.add(right[j]);
        j++;
      }
    }

    while (i < left.length) {
      result.add(left[i]);
      i++;
    }

    while (j < right.length) {
      result.add(right[j]);
      j++;
    }

    steps.add("Merge: ${result.join(", ")}");
    return result;
  }

  void startSort() {
    List<int> arr =
        controllers.map((e) => int.tryParse(e.text) ?? 0).toList();

    steps.clear();

    setState(() {
      result = mergeSort(arr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Merge Sort",
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
            onPressed: startSort,
            child: const Text("SORT"),
          ),

          const SizedBox(height: 20),

          if (result.isNotEmpty) ...[
            const Text(
              "Hasil Merge Sort",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              "Proses Merge",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...steps.map(
              (e) => Card(
                child: ListTile(
                  leading: const Icon(Icons.merge_type),
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