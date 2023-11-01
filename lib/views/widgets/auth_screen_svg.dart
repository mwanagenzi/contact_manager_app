import 'package:contacts_manager/views/theme/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreenSvg extends StatelessWidget {
  const AuthScreenSvg({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/curve_top.svg',
      color: Palette.activeCardColor,
      // colorFilter:
      //     const ColorFilter.mode(Palette.activeCardColor, BlendMode.srcIn),
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.fill,
    );
  }
}
