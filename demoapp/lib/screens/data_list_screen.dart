import 'package:flutter/material.dart';

import '../comm/app_state.dart';
import '../dialogs/new_data_dialog.dart';
import '../models/data_record.dart';
import '../widgets/demo_text.dart';

class DataListScreen extends StatefulWidget {
  const DataListScreen({super.key});

  @override
  State<DataListScreen> createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  List<DemoRecord> _items = AppState.instance!.records;

  void _addData() {
    showDialog(
        context: context,
        builder: (ctx) => DemoNewDataDialog(onCreate: (record) {
              setState(() {
                _items.add(record);
                AppState.instance!.records = _items;
              });
            }));
  }

  Widget _record(DemoRecord record) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DemoText(text: record.id, type: DemoTextType.light),
        Row(children: [
          DemoText(text: record.name, type: DemoTextType.normal),
          DemoText(text: ':', type: DemoTextType.normal),
          const SizedBox(width: 8),
          DemoText(text: record.value, type: DemoTextType.normal)
        ])
      ]),
      IconButton(
          onPressed: () {
            setState(() {
              _items = _items.where((e) => e.id != record.id).toList();
              AppState.instance!.records = _items;
            });
          },
          alignment: Alignment.center,
          iconSize: 24,
          icon: const Icon(Icons.delete, color: Colors.grey))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: DemoText(text: 'My Data', type: DemoTextType.bold),
          actions: [
            IconButton(
                onPressed: _addData,
                icon: const Icon(Icons.add, size: 32, color: Colors.black))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child: Column(children: _items.map(_record).toList())),
        ));
  }
}
