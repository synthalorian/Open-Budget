import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'dart:typed_data';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  // In a real app, this key would be derived from a user password via PBKDF2
  // For this alpha, we'll use a placeholder, but structure it for real use.
  final _key = encrypt.Key.fromUtf8('1984_NEON_GRID_MAINFRAME_KEY_XYZ'); 
  final _iv = encrypt.IV.fromLength(16);

  String encryptData(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decryptData(String encryptedBase64) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt64(encryptedBase64, iv: _iv);
    return decrypted;
  }

  Uint8List encryptBytes(Uint8List data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encryptBytes(data, iv: _iv);
    return encrypted.bytes;
  }

  Uint8List decryptBytes(Uint8List encryptedData) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decryptBytes(encrypt.Encrypted(encryptedData), iv: _iv);
    return Uint8List.fromList(decrypted);
  }
}
