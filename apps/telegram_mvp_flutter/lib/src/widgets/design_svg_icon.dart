import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DesignSvgIcon extends StatelessWidget {
  const DesignSvgIcon(
    this.assetName, {
    super.key,
    this.size = 24,
    this.color,
    this.semanticLabel,
  });

  final String assetName;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      assetName,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
    );

    if (semanticLabel == null) {
      return icon;
    }

    return Semantics(label: semanticLabel, child: icon);
  }
}
