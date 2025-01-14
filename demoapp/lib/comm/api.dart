import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/data_request.dart';
import '../models/data_record.dart';
import '../models/key_pair.dart';
import 'app_state.dart';

class Api {
  static const host = 'https://552e-221-147-34-162.ngrok-free.app';

  static Future<Map<String, dynamic>> login(String name, KeyPair kp) async {
    final url = Uri.parse('$host/client');
    final body = {
      'publicKey': const Base64Encoder().convert(kp.publicKey),
      'type': 0,
      'name': name
    };
    final bodyStr = jsonEncode(body);
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json;charset=utf-8'},
        body: utf8.encode(bodyStr));
    return jsonDecode(response.body);
  }

  static Future<List<DataRequest>> getRequests(int page) async {
    final url = Uri.parse('$host/order/list?page=$page&size=10');
    final response = await http
        .get(url, headers: {'Content-Type': 'application/json;charset=utf-8'});
    final responseJSON = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = responseJSON['data'] as List<dynamic>;
      return data.map((e) {
        final map = e as Map<String, dynamic>;
        final id = map['id'] as String;
        final sender = map['sender'] as String;
        final queries =
            (map['queries'] as List<dynamic>).map((e) => e as String).toList();
        return DataRequest(id, sender, queries);
      }).toList();
    } else {
      final message = responseJSON['message'] as String;
      throw Exception(message);
    }
  }

  static Future<Map<String, dynamic>> sendData(
      String id, List<DemoRecord> data) async {
    final publicKey = AppState.instance!.kp.publicKey;
    final url = Uri.parse('$host/products');
    final body = {
      'orderId': id,
      'sender': const Base64Encoder().convert(publicKey),
      'data': data.map((e) => e.value).toList().join(",")
    };
    final bodyStr = jsonEncode(body);
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json;charset=utf-8'},
        body: utf8.encode(bodyStr));
    final responseStr = response.body;
    return jsonDecode(responseStr);
  }
}
