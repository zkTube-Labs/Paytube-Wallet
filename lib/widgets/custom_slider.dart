import '../public.dart';
class CustomSlider extends StatelessWidget {
  CustomSlider(
      {Key? key,
      this.width = 0,
      this.height = 0,
      this.borderRadius = 0,
      this.percentage,
      this.max,
      this.activeColor,
      this.backgroundColor,
      })
      : super(key: key);

  double width;
  double? percentage = 0;
  double? max = 100;
  double height;

  double borderRadius;
  Color? backgroundColor;
  Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      child: Container(
          color: backgroundColor,
          width: OffsetWidget.setSc(width) ,
          height: OffsetWidget.setSc(height) ,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  color: activeColor,
                  width: (percentage!/max!)*OffsetWidget.setSc(width),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
