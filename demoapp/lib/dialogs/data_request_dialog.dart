import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../comm/api.dart';
import '../comm/app_state.dart';
import '../models/data_request.dart';
import '../widgets/demo_button.dart';
import '../widgets/demo_text.dart';

class DataRequestDialog extends StatefulWidget {
  DataRequest request;

  DataRequestDialog({required this.request, super.key});

  @override
  State<DataRequestDialog> createState() => _DataRequestDialogState();
}

class _DataRequestDialogState extends State<DataRequestDialog> {
  var hasData = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      hasData = widget.request.hasData();
    });
  }

  void _send() async {
    // TODO: filter only required data
    final response = await Api.sendData(
        widget.request.id, AppState.instance!.records);
    final code = response['code'] as int;
    final message = response['message'] as String;
    _showToast(message);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _delete() {
    var list = AppState.instance!.requests;
    list.removeWhere((e) => e.id == widget.request.id);
    AppState.instance!.requests = list;
    Navigator.of(context).pop(list);
  }

  void _showToast(String message) {
    if (mounted) {
      Toastification().show(
          context: context,
          title: Text(message),
          showIcon: false,
          showProgressBar: false,
          autoCloseDuration: const Duration(seconds: 1),
          dragToClose: false,
          alignment: Alignment.bottomCenter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: IntrinsicHeight(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DemoText(text: 'Data Request', type: DemoTextType.bold),
          const SizedBox(height: 16),
          DemoText(text: 'Sender', type: DemoTextType.normal),
          DemoText(text: widget.request.sender, type: DemoTextType.light),
          const SizedBox(height: 8),
          DemoText(text: 'Queries', type: DemoTextType.normal),
          ...widget.request.queries
              .map((e) => DemoText(text: e, type: DemoTextType.light)),
          const SizedBox(height: 8),
          if (hasData) ...[
            DemoButton(text: 'Send', onPressed: _send),
            const SizedBox(height: 8),
          ],
          DemoButton(text: 'Delete', onPressed: _delete),
          const SizedBox(height: 8),
          DemoButton(
              text: 'Cancel', onPressed: () => {Navigator.of(context).pop()}),
          const SizedBox(height: 16)
        ]),
      )),
    );
  }
}
