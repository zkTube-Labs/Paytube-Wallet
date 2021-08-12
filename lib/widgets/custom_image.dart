import '../public.dart';
import 'package:flutter/material.dart';

//加载本地图片
class LoadAssetsImage extends StatelessWidget {
  LoadAssetsImage(this.name,
      {Key? key,
      this.width,
      this.height,
      this.fit = BoxFit.contain,
      this.color,
      this.scale,
      this.errorBuilder})
      : super(key: key);

  final String name;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final double? scale;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      name,
      height: height,
      width: width,
      fit: fit,
      color: color,
      scale: scale,
      errorBuilder: errorBuilder,
    );
  }
}
