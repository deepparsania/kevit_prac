import 'package:flutter/material.dart';

import '../utils/my_color.dart';

class CustomBottomSheet{

  final Widget child;
  Color backgroundColor;
  bool isNeedMargin;
  bool isDismissible;
  final VoidCallback? dismissibleCallback;

  CustomBottomSheet({
    required this.child,
    this.isNeedMargin = false,
    this.isDismissible = false,
    this.dismissibleCallback,
    Color? backgroundColor,
  }):backgroundColor = MyColor.colorWhite;

  void customBottomSheet(BuildContext context){

    showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: MyColor.transparentColor,
      context: context,
      builder: (BuildContext context) =>
      StatefulBuilder(builder:
        (BuildContext context,
        StateSetter setState) {
      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child:
        AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Container(
            margin: isNeedMargin ? const EdgeInsets.only(
                left: 15, right: 15, bottom: 15) : EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: isNeedMargin ? BorderRadius.circular(15) : const BorderRadius.vertical(top: Radius.circular(15))
            ),
            child: child,
          ),
        ),
      );})
    ).then((value){
      // voidCallback;
      // Invoke the dismiss callback if provided
      if (dismissibleCallback != null) {
        dismissibleCallback!();
      }
    });
  }
}