import 'dart:convert';
import 'dart:math' as Math;

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class StringUtil {
  static String toMD5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static String removeHtmlLabel(String data) {
    return data?.replaceAll(RegExp('<[^>]+>'), '');
  }

  static bool isEmpty(String str) {
    if (null == str || "" == str || 'null' == str) {
      return true;
    }
    return false;
  }


  /*
  * 获取网络请求密钥生成的字符串
  * /* 'X-Signature: 1603183802434;91966229;le8rN/NiKJOPOlIZKc6sv7LNEZpoMYT1Uf2rwrbcCeY='*/
  * */
  static String getSignature() {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    int bigNub =
        Math.Random().nextInt(90000000) + 10000000; //10000000 - 99999999之间
    // timeStamp = 1603183802434;
    // bigNub = 91966229;
    String message = '${timeStamp};${bigNub}';
    String base64Key = 'oconn1020';
    final keyBytes = Utf8Encoder().convert(base64Key);
    final dataBytes = Utf8Encoder().convert(message);
    final hmacBytes = Hmac(sha256, keyBytes).convert(dataBytes).bytes;
    final signStr = base64Encode(hmacBytes);
    return message + ';' + signStr;
  }

}
