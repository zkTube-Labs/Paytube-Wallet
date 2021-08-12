import '../public.dart';
import 'package:flutter/material.dart';

//加载网络图片
class LoadNetworkImage extends StatelessWidget {
  LoadNetworkImage(this.name,
      {Key? key,
      this.width,
      this.height,
      this.fit = BoxFit.contain,
      this.color,
      this.scale,
      this.placeholder})
      : super(key: key);

  final String? name;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final double? scale;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      image: name == null ? "" : name!,
      placeholder: placeholder!,
      height: height,
      width: width,
      fit: fit,
      imageScale: scale!,
    );
  }
}
