import 'dart:math';

import 'package:demoapp/comm/utils.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:crypto/crypto.dart';

import '../models/key_pair.dart';

class CryptoUtils {
  static final privateKeyPrefix =
      Utils.hexToUint8List('3031020100300a06082a8648ce3d0301070420');
  static final publicKeyPrefix = Utils.hexToUint8List(
      '3059301306072a8648ce3d020106082a8648ce3d030107034200');

  static ECPrivateKey _getPrivateKey(Uint8List bytes) {
    final rawBytes = bytes.sublist(privateKeyPrefix.length);
    var ecDomainParams = ECDomainParameters('prime256v1');
    return ECPrivateKey(decodeBigInt(rawBytes), ecDomainParams);
  }

  static ECPublicKey _getPublicKey(Uint8List bytes) {
    var rawBytes = bytes.sublist(publicKeyPrefix.length);
    var ecDomainParams = ECDomainParameters('prime256v1');
    var publicKeyPoint = ecDomainParams.curve.decodePoint(rawBytes);
    if (publicKeyPoint == null) {
      throw ArgumentError('Invalid public key bytes');
    }
    return ECPublicKey(publicKeyPoint, ecDomainParams);
  }

  static KeyPair generateKeyPair() {
    final secureRandom = Random.secure();
    final seed =
        Uint8List.fromList(List.generate(32, (_) => secureRandom.nextInt(256)));

    var keyParams = ECKeyGeneratorParameters(ECCurve_prime256v1());

    var random = FortunaRandom();
    random.seed(KeyParameter(seed));

    var generator = ECKeyGenerator();
    generator.init(ParametersWithRandom(keyParams, random));

    final keyPair = generator.generateKeyPair();

    ECPrivateKey privateKey = keyPair.privateKey as ECPrivateKey;
    ECPublicKey publicKey = keyPair.publicKey as ECPublicKey;

    // Encode private key in #PKCS8 format
    final privateKeyBytes =
        Utils.concatenate(privateKeyPrefix, encodeBigInt(privateKey.d!));

    // Encode public key in X.509 SubjectPublicKeyInfo format
    final x = publicKey.Q!.x!.toBigInteger()!;
    final y = publicKey.Q!.y!.toBigInteger()!;
    final publicKeyBytes = Utils.concatenate(publicKeyPrefix,
        Uint8List.fromList([0x04, ...encodeBigInt(x), ...encodeBigInt(y)]));

    return KeyPair(privateKey: privateKeyBytes, publicKey: publicKeyBytes);
  }

  static Uint8List sign(Uint8List message, Uint8List privateKeyBytes) {
    final privateKey = _getPrivateKey(privateKeyBytes);

    // Create the signer
    var signer = ECDSASigner(null, HMac(SHA256Digest(), 64));
    signer.init(true, PrivateKeyParameter<ECPrivateKey>(privateKey));

    // Create signature
    ECSignature signature = signer.generateSignature(message) as ECSignature;

    // Combine r and s into a single Uint8List
    return Uint8List.fromList([
      ...encodeBigInt(signature.r),
      ...encodeBigInt(signature.s),
    ]);
  }

  static bool verify(
      String message, Uint8List signatureBytes, Uint8List publicKeyBytes) {
    // Extract r and s from the signature bytes
    var r = decodeBigInt(signatureBytes.sublist(0, signatureBytes.length ~/ 2));
    var s = decodeBigInt(signatureBytes.sublist(signatureBytes.length ~/ 2));

    final publicKey = _getPublicKey(publicKeyBytes);

    // Create the signer
    var signer = ECDSASigner(null, HMac(SHA256Digest(), 64));
    signer.init(false, PublicKeyParameter<ECPublicKey>(publicKey));

    // Verify signature
    return signer.verifySignature(
        Uint8List.fromList(message.codeUnits), ECSignature(r, s));
  }

  static Uint8List computeSharedSecret(
      Uint8List privateKeyBytes, Uint8List publicKeyBytes) {
    final privateKey = _getPrivateKey(privateKeyBytes);
    final publicKey = _getPublicKey(publicKeyBytes);

    final agreement = ECDHBasicAgreement();
    agreement.key = privateKey;
    final sharedSecret = agreement.calculateAgreement(publicKey);
    return encodeBigInt(sharedSecret);
  }

  static Uint8List generateIV() {
    final secureRandom = Random.secure();
    return Uint8List.fromList(
        List.generate(12, (_) => secureRandom.nextInt(256)));
  }

  static Map<String, Uint8List> encrypt(
      Uint8List key, Uint8List iv, Uint8List plaintext) {
    if (iv.length != 12) {
      throw ArgumentError('IV must be exactly 12 bytes for AES-GCM');
    }
    if (key.length != 32) {
      throw ArgumentError('Key must be exactly 32 bytes for AES-256');
    }

    final gcm = GCMBlockCipher(AESEngine())
      ..init(
        true, // true for encryption
        AEADParameters(
          KeyParameter(key),
          128, // Authentication tag length in bits
          iv,
          Uint8List(0), // Associated data (AAD), optional
        ),
      );

    final ciphertextAndTag =
        Uint8List(plaintext.length + gcm.macSize); // Allocate space
    try {
      final processedLength =
          gcm.processBytes(plaintext, 0, plaintext.length, ciphertextAndTag, 0);
      gcm.doFinal(ciphertextAndTag, processedLength);
    } catch (e) {
      throw StateError('Encryption failed: $e');
    }
    return {
      'cipherText':
          ciphertextAndTag.sublist(0, ciphertextAndTag.length - gcm.macSize),
      'tag': ciphertextAndTag.sublist(ciphertextAndTag.length - gcm.macSize),
      'iv': iv,
    };
  }

  static Uint8List decrypt(
      Uint8List key, Uint8List tag, Uint8List iv, Uint8List ciphertext) {
    if (iv.length != 12) {
      throw ArgumentError('IV must be exactly 12 bytes for AES-GCM');
    }
    if (key.length != 32) {
      throw ArgumentError('Key must be exactly 32 bytes for AES-256');
    }

    final gcm = GCMBlockCipher(AESEngine())
      ..init(
        false, // false for decryption
        AEADParameters(
          KeyParameter(key),
          128, // Authentication tag length in bits
          iv, // IV used during encryption
          Uint8List(0), // Associated data (AAD), optional
        ),
      );

    // Combine ciphertext and tag
    final ciphertextAndTag = Uint8List.fromList([...ciphertext, ...tag]);

    final plaintext = Uint8List(ciphertext.length); // Allocate space
    final processedLength = gcm.processBytes(
        ciphertextAndTag, 0, ciphertextAndTag.length, plaintext, 0);
    gcm.doFinal(plaintext, processedLength);

    return plaintext;
  }

  static Uint8List hmac(Uint8List key, Uint8List message) {
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(message);
    return Uint8List.fromList(digest.bytes);
  }

  static Uint8List encodeBigInt(BigInt number) {
    var hexString = number.toRadixString(16);

    if (hexString.length % 2 != 0) {
      hexString = '0$hexString';
    }

    return Uint8List.fromList(List.generate(hexString.length ~/ 2,
        (i) => int.parse(hexString.substring(i * 2, i * 2 + 2), radix: 16)));
  }

  static BigInt decodeBigInt(Uint8List bytes) {
    return BigInt.parse(
        bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
        radix: 16);
  }

  static void test() {
    try {
      final kp1 = CryptoUtils.generateKeyPair();
      final kp2 = CryptoUtils.generateKeyPair();
      print("KP1: $kp1");
      print("KP2: $kp2");

      const msg = 'Hello, World!';

      final signature =
          CryptoUtils.sign(Uint8List.fromList(msg.codeUnits), kp1.privateKey);
      print("SIGNATURE: ${Utils.uint8ListToHex(signature)}");

      final verified = CryptoUtils.verify(msg, signature, kp1.publicKey);
      print("VERFIED $verified");

      final sec1 =
          CryptoUtils.computeSharedSecret(kp1.privateKey, kp2.publicKey);
      final sec2 =
          CryptoUtils.computeSharedSecret(kp2.privateKey, kp1.publicKey);
      print("SEC 1: ${Utils.uint8ListToHex(sec1)}");
      print("SEC 2: ${Utils.uint8ListToHex(sec2)}");

      final iv = CryptoUtils.generateIV();
      print('IV: ${Utils.uint8ListToHex(iv)}');
      final enc =
          CryptoUtils.encrypt(sec1, iv, Uint8List.fromList(msg.codeUnits));
      print("ENC:");
      print("   CIPHER TEXT: ${Utils.uint8ListToHex(enc['ciphertext']!)}");
      print("   TAG: ${Utils.uint8ListToHex(enc['tag']!)}");
      print("   IV: ${Utils.uint8ListToHex(enc['iv']!)}");

      final dec = CryptoUtils.decrypt(
          sec2, enc['tag']!, enc['iv']!, enc['ciphertext']!);
      print("DEC: ${String.fromCharCodes(dec)}");
    } on InvalidCipherTextException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }
}
