import 'package:flutter_coinid/public.dart';

class FontWightHelper {
  // FontWeight.w100: 'Thin',
  // FontWeight.w200: 'ExtraLight',
  // FontWeight.w300: 'Light',
  // FontWeight.w400: 'Regular',
  // FontWeight.w500: 'Medium',
  // FontWeight.w600: 'SemiBold',
  // FontWeight.w700: 'Bold',
  // FontWeight.w800: 'ExtraBold',
  // FontWeight.w900: 'Black',
//   苹方-简 常规体
// font-family: PingFangSC-Regular, sans-serif;
// 苹方-简 极细体
// font-family: PingFangSC-Ultralight, sans-serif;
// 苹方-简 细体
// font-family: PingFangSC-Light, sans-serif;
// 苹方-简 纤细体
// font-family: PingFangSC-Thin, sans-serif;
// 苹方-简 中黑体
// font-family: PingFangSC-Medium, sans-serif;
// 苹方-简 中粗体
// font-family: PingFangSC-Semibold, sans-serif;

  ///400
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight semiBold = FontWeight.w600;

  @override
  // TODO: implement index
  int get index => throw UnimplementedError();
}

class ColorUtils {
  static Color rgba(int r, int g, int b, double a) {
    return Color.fromARGB((a * 255).toInt(), r, g, b);
  }
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
