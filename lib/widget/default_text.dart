import 'package:flutter/material.dart';

import '../utils/dimensions.dart';
import '../utils/my_color.dart';
import '../utils/style.dart';

class DefaultText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextStyle textStyle;
  final int maxLines;
  final Color? textColor;
  final double fontSize;

  DefaultText(
      {Key? key,
      required this.text,
      this.textAlign,
      this.textStyle = outfitifRegularText,
      this.maxLines = 1,
      Color? textColor,
      this.fontSize = Dimensions.fontDefault})
      : textColor = textColor ?? MyColor.primaryColor,super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: textStyle.copyWith(
          fontSize: fontSize,
          color: textColor,
          overflow: TextOverflow.ellipsis),
      maxLines: maxLines,
      softWrap: false,
    );
  }
}
