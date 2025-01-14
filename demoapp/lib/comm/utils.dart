import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

class Utils {
  static String formatDateFromDateTime(DateTime date) {
    final month = date.month < 10 ? '0${date.month}' : date.month;
    final day = date.day < 10 ? '0${date.day}' : date.day;
    final hour = date.hour < 10 ? '0${date.hour}' : date.hour;
    final minute = date.minute < 10 ? '0${date.minute}' : date.minute;
    final second = date.second < 10 ? '0${date.second}' : date.second;
    return '${date.year}.$month.$day $hour:$minute:$second';
  }

  static String formatDateFromString(String dateStr) {
    final date = DateTime.parse(dateStr);
    return formatDateFromDateTime(date);
  }

  static String decodeHexString(String hex) {
    hex = hex.replaceAll(' ', '').replaceAll('0x', '');

    // Ensure the Hex String length is even (each byte is 2 hex digits).
    if (hex.length % 2 != 0) {
      throw const FormatException("Invalid Hex String. Length must be even.");
    }

    // Convert Hex String to Uint8List (byte array).
    Uint8List bytes = Uint8List.fromList(
      List.generate(hex.length ~/ 2,
          (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16)),
    );

    // Decode the bytes into a UTF-8 String.
    return utf8.decode(bytes);
  }

  static Uint8List hexToUint8List(String hex) {
    final length = hex.length;

    if (length % 2 != 0) {
      throw ArgumentError('Hex string must have an even length');
    }

    final bytes = Uint8List(length ~/ 2);
    for (var i = 0; i < length; i += 2) {
      final byte = hex.substring(i, i + 2);
      bytes[i ~/ 2] = int.parse(byte, radix: 16);
    }
    return bytes;
  }

  static String uint8ListToHex(Uint8List data) {
    return data.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  static Uint8List concatenate(Uint8List prefix, Uint8List suffix) {
    final concatenated = Uint8List(prefix.length + suffix.length);
    concatenated.setRange(0, prefix.length, prefix);
    concatenated.setRange(prefix.length, concatenated.length, suffix);
    return concatenated;
  }
}
