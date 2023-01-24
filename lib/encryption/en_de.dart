import 'package:encrypt/encrypt.dart';

class en_de {
  static final key = Key.fromUtf8('1d5f39f4737c9a8f9850d7a0306ef563');
  static final iv = IV.fromLength(16);

  static String encrypt(String plainText) {
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}