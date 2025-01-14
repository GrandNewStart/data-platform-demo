import '../models/data_request.dart';
import '../models/data_record.dart';
import '../models/key_pair.dart';

class AppState {
  String _name;
  KeyPair _kp;
  List<DemoRecord> _records = [];
  List<DataRequest> _requests = [];

  static AppState? _instance;

  static AppState? get instance => _instance;

  static void initialize(String name, KeyPair kp) {
    _instance = AppState._(name, kp);
  }

  AppState._(this._name, this._kp);

  String get name => _name;

  KeyPair get kp => _kp;

  List<DataRequest> get requests => _requests;

  List<DemoRecord> get records => _records;

  set requests(List<DataRequest> value) {
    _requests = value;
  }

  set records(List<DemoRecord> value) {
    _records = value;
  }
}
