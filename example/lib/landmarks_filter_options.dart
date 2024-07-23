

import 'package:flutter/material.dart';

class LandmarksFilterOptions extends StatefulWidget {
  final Function(Map<String, bool>) onFilterChange;

  const LandmarksFilterOptions({super.key, required this.onFilterChange});

  @override
  LandmarksFilterOptionsState createState() => LandmarksFilterOptionsState();
}

class LandmarksFilterOptionsState extends State<LandmarksFilterOptions> {
  Map<String, bool> filters = {
    'Face': true,
    'Left Arm': true,
    'Right Arm': true,
    'Torso': true,
    'Left Leg': true,
    'Right Leg': true,
  };

  void _updateFilter(String key, bool value) {
    setState(() {
      filters[key] = value;
    });
    print("SelectedFilter : $key : $value");
    widget.onFilterChange(filters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select filters"),),
      body: Column(
        children: filters.keys.map((filter) {
          return CheckboxListTile(
            title: Text(filter),
            value: filters[filter],
            onChanged: (value) {
              _updateFilter(filter, value!);
            },
          );
        }).toList(),
      ),
    );
  }
}
