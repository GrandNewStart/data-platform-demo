import 'package:flutter/material.dart';

import 'package:uuid/v4.dart';

import '../models/data_record.dart';
import '../widgets/demo_button.dart';
import '../widgets/demo_text.dart';

class DemoNewDataDialog extends StatefulWidget {
  Function(DemoRecord record) onCreate;

  DemoNewDataDialog({required this.onCreate, super.key});

  @override
  State<DemoNewDataDialog> createState() => _DemoNewDataDialogState();
}

class _DemoNewDataDialogState extends State<DemoNewDataDialog> {
  final _dropdownItems = [
    DropdownMenuItem(
        value: 'A', child: DemoText(text: 'A', type: DemoTextType.normal)),
    DropdownMenuItem(
        value: 'B', child: DemoText(text: 'B', type: DemoTextType.normal)),
    DropdownMenuItem(
        value: 'C', child: DemoText(text: 'C', type: DemoTextType.normal))
  ];
  String _selectedDataType = 'A';
  String _input1 = "false", _input2 = "", _input3 = "";

  Widget _textField(Function(String) onChange) {
    return TextField(
        onChanged: onChange,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.black, width: 1))),
        keyboardType: TextInputType.number,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16));
  }

  Widget _checkButton(Function(String) onChange) {
    return Checkbox(
        value: _input1 == "true",
        onChanged: (checked) {
          setState(() {
            _input1 = (checked == true) ? "true" : "false";
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            DemoText(text: 'New Data', type: DemoTextType.bold),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              DemoText(text: 'Data Type', type: DemoTextType.normal),
              DropdownButton(
                  value: _selectedDataType,
                  items: _dropdownItems,
                  onChanged: (item) {
                    setState(() {
                      _selectedDataType = item!;
                    });
                  },
                  menuWidth: 128)
            ]),
            if (_selectedDataType == "A") ...[
              const SizedBox(height: 8),
              _checkButton((text) {
                _input1 = text;
              })
            ],
            if (_selectedDataType == "B") ...[
              const SizedBox(height: 8),
              _textField((text) {
                _input1 = text;
              })
            ],
            if (_selectedDataType == "C") ...[
              _textField((text) {
                _input2 = text;
              }),
              const SizedBox(height: 8),
              _textField((text) {
                _input3 = text;
              })
            ],
            const SizedBox(height: 8),
            DemoButton(
                text: 'Create',
                onPressed: () {
                  Navigator.of(context).pop();
                  String data;
                  if (_selectedDataType == "C") {
                    data = "$_input2,$_input3";
                  } else {
                    data = _input1;
                  }
                  widget.onCreate(DemoRecord(
                      const UuidV4().generate(), _selectedDataType, data));
                }),
            const SizedBox(height: 16)
          ]),
        ),
      ),
    );
  }
}
