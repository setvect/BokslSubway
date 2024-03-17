import 'dart:ui';

String getChosung(String input) {
  String result = '';
  for (int i = 0; i < input.length; i++) {
    int unicode = input.codeUnitAt(i);
    if (unicode >= 0xAC00 && unicode <= 0xD7A3) {
      int chosung = ((unicode - 0xAC00) / (21 * 28)).floor();
      result += ['ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'][chosung];
    } else {
      result += input[i];
    }
  }
  return result;
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
