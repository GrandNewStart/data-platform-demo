
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../comm/api.dart';
import '../comm/app_state.dart';
import '../dialogs/data_request_dialog.dart';
import '../models/data_request.dart';
import '../models/key_pair.dart';
import '../widgets/demo_button.dart';
import '../widgets/demo_text.dart';
import 'data_list_screen.dart';

class MainScreen extends StatefulWidget {
  String name;
  KeyPair kp;

  MainScreen({required this.name, required this.kp, super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _page = 0;
  var _requests = AppState.instance!.requests;

  void _getRequests() async {
    try {
      final list = await Api.getRequests(_page);
      // final newList = [...Demo2State.instance!.requests, ...list];
      AppState.instance!.requests = list;
      setState(() {
        _requests = list;
      });
    } catch (e) {
      _showToast(e.toString());
    }
  }

  void _showToast(String message) {
    if (mounted) {
      Toastification().show(
          context: context,
          title: Text(message),
          showIcon: false,
          showProgressBar: false,
          autoCloseDuration: const Duration(seconds: 2),
          dragToClose: false,
          alignment: Alignment.bottomCenter);
    }
  }

  Widget _request(DataRequest request) {
    TextStyle style;
    if (request.hasData()) {
      style = const TextStyle(
          color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16);
    } else {
      style = const TextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16);
    }
    return InkWell(
        onTap: () {
          _showRequest(request);
        },
        splashColor: Colors.grey,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(request.id, style: style)));
  }

  void _showData() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const DataListScreen()));
  }

  void _showRequest(DataRequest request) async {
    final updatedList = await showDialog(
        context: context,
        builder: (ctx) => DataRequestDialog(request: request));
    if (updatedList is List<DataRequest>) {
      setState(() {
        _requests = updatedList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.grey, actions: [
          IconButton(
              onPressed: _getRequests,
              icon: const Icon(Icons.refresh, color: Colors.black, size: 32))
        ]),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.person_rounded, size: 32),
                  DemoText(text: widget.name, type: DemoTextType.normal)
                ]),
                const SizedBox(height: 16),
                SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      DemoText(text: 'Data Requests', type: DemoTextType.bold),
                      ..._requests.map(_request)
                    ])),
                const Spacer(),
                DemoButton(text: 'My Data', onPressed: _showData)
              ]),
        ));
  }
}
