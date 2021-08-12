import 'package:flutter/services.dart';
import 'package:flutter_coinid/public.dart';

class RegExInputFormatter implements TextInputFormatter {
  final RegExp _regExp;

  RegExInputFormatter._(this._regExp);

  factory RegExInputFormatter.withRegex(String regexString) {
    try {
      final regex = RegExp(regexString);
      return RegExInputFormatter._(regex);
    } catch (e) {
      assert(false, e.toString());
      return RegExInputFormatter._(RegExp(""));
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = _isValid(oldValue.text);
    final newValueValid = _isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }

  bool _isValid(String value) {
    try {
      final matches = _regExp.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    this.padding,
    this.maxLines = 1,
    this.obscureText = false,
    this.onSubmitted,
    required this.controller,
    this.decoration,
    this.style,
    this.maxLength,
    this.onChange,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  }) : super(key: key);

  final EdgeInsetsGeometry? padding;
  final TextEditingController? controller;
  int maxLines;
  final bool obscureText;
  final ValueChanged<String>? onSubmitted;
  InputDecoration? decoration;
  final TextStyle? style;
  final int? maxLength;
  final ValueChanged<String>? onChange;
  final bool enabled;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  static TextInputFormatter decimalInputFormatter(int? decimals) {
    String amount = '^[0-9]{0,}(\\.[0-9]{0,$decimals})?\$';
    return RegExInputFormatter.withRegex(amount);
  }

  static InputDecoration getUnderLineDecoration({
    String? hintText,
    TextStyle? hintStyle,
    String? helperText,
    TextStyle? helperStyle,
    Widget? prefixIcon,
    Widget? suffixIcon,
    BoxConstraints suffixIconConstraints =
        const BoxConstraints(maxWidth: 100, maxHeight: double.infinity),
    BoxConstraints prefixIconConstraints =
        const BoxConstraints(minWidth: 80, maxHeight: double.infinity),
    int underLineColor = Constant.textfield_border_color,
    double underLineWidth = 1,
    Color fillColor = const Color(Constant.main_color),
    EdgeInsetsGeometry contentPadding = EdgeInsets.zero,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      suffixIconConstraints: suffixIconConstraints,
      prefixIconConstraints: prefixIconConstraints,
      enabledBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(width: underLineWidth, color: Color(underLineColor)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(width: underLineWidth, color: Color(underLineColor)),
      ),
      counterText: "",
      hintText: hintText,
      hintStyle: hintStyle,
      helperText: helperText,
      helperStyle: helperStyle,
      helperMaxLines: 5,
      fillColor: fillColor,
      filled: true,
      contentPadding: contentPadding,
    );
  }

  static InputDecoration getBorderLineDecoration({
    Color borderColor: const Color(Constant.textfield_border_color),
    String? hintText,
    TextStyle? hintStyle,
    String? helperText,
    TextStyle? helperStyle,
    Color fillColor = const Color(Constant.main_color),
    EdgeInsetsGeometry contentPadding = const EdgeInsets.fromLTRB(18, 0, 18, 0),
    double borderRadius = 8,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? counterText,
    TextStyle? counterStyle,
    BoxConstraints suffixIconConstraints =
        const BoxConstraints(maxWidth: 100, maxHeight: double.infinity),
    BoxConstraints prefixIconConstraints =
        const BoxConstraints(minWidth: 80, maxHeight: double.infinity),
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      suffixIconConstraints: suffixIconConstraints,
      prefixIconConstraints: prefixIconConstraints,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      hintText: hintText,
      hintStyle: TextStyle(
          color: ColorUtils.fromHex('#585858'),
          fontWeight: FontWightHelper.regular,
          fontSize: OffsetWidget.setSp(16)),
      helperText: helperText,
      helperStyle: TextStyle(
        color: ColorUtils.rgba(153, 153, 153, 1),
        fontWeight: FontWightHelper.regular,
        fontSize: OffsetWidget.setSp(14),
      ),
      helperMaxLines: 5,
      fillColor: fillColor,
      filled: true,
      contentPadding: contentPadding,
      counterText: counterText,
      counterStyle: counterStyle,
    );
  }

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry? padding = widget.padding;
    final TextEditingController? controller = widget.controller;
    int maxLines = widget.maxLines;
    final obscureText = widget.obscureText;
    final onSubmitted = widget.onSubmitted;
    return Container(
      padding: padding,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        obscureText: obscureText,
        onSubmitted: onSubmitted,
        style: TextStyle(
          color: Color(Constant.valueTextColor),
          fontSize: OffsetWidget.setSp(16),
          fontWeight: FontWightHelper.regular,
        ),
        maxLength: widget.maxLength,
        onChanged: widget.onChange,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        decoration: widget.decoration != null ? widget.decoration : null,
      ),
    );
  }
}
