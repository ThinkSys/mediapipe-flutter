import 'package:flutter/material.dart';

class LandmarksFilterOptions extends StatefulWidget {
  final Map<String, bool> defaultFilters;
  final Function(String key, bool value) onFilterChange;

  const LandmarksFilterOptions(
      {super.key, required this.onFilterChange, required this.defaultFilters});

  @override
  LandmarksFilterOptionsState createState() => LandmarksFilterOptionsState();
}

class LandmarksFilterOptionsState extends State<LandmarksFilterOptions> {
  void _updateFilter(String key, bool value) {
    setState(() {
      widget.defaultFilters[key] = value;
    });
    print("SelectedFilter : $key : $value");
    widget.onFilterChange(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select filters"),
      ),
      body: Column(
        children: widget.defaultFilters.keys.map((filter) {
          return CheckboxListTile(
            title: Text(filter),
            value: widget.defaultFilters[filter],
            onChanged: (value) {
              _updateFilter(filter, value!);
            },
          );
        }).toList(),
      ),
    );
  }
}
