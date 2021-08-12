import '../public.dart';
import 'package:bot_toast/bot_toast.dart';

class HWToast {
  static showText({
    required String text,
    Color backgroundColor = Colors.transparent,
    Color contentColor = Colors.black,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(8)),
    TextStyle textStyle = const TextStyle(fontSize: 14, color: Colors.white),
    AlignmentGeometry align = const Alignment(0, 0.45),
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
    Duration duration = const Duration(seconds: 3),
    Duration? animationDuration,
    Duration? animationReverseDuration,
  }) {
    HWToast.hiddenAllToast();
    BotToast.showText(
      text: text,
      contentColor: contentColor,
      align: align,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      textStyle: textStyle,
      contentPadding: contentPadding,
      duration: duration,
      animationDuration: animationDuration,
      animationReverseDuration: animationReverseDuration,
      onlyOne: true,
      enableKeyboardSafeArea: true,
    ); //弹出一个文本框;
  }

  static showLoading({
    VoidCallback? onClose,
    bool clickClose = false,
  }) {
    HWToast.hiddenAllToast();
    BotToast.showLoading(
      enableKeyboardSafeArea: true,
      onClose: onClose,
      clickClose: clickClose,
      backgroundColor: Colors.transparent,
    ); //弹出一个文本框;
  }

  static hiddenAllToast() {
    BotToast.cleanAll();
  }
}
