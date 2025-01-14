import 'dart:typed_data';

class KeyPair {
  Uint8List privateKey;
  Uint8List publicKey;

  KeyPair({required this.privateKey, required this.publicKey});

  String getPrivateKeyHex() {
    return privateKey
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  String getPublicKeyHex() {
    return publicKey
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
  }
}
