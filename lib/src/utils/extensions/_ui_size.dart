import 'package:flutter/material.dart';

class SizeUntil {
  SizeUntil._();
  static SizeUntil instance = SizeUntil._();
  static final view = WidgetsBinding.instance.platformDispatcher.implicitView;
  static final Size pS = view?.physicalSize ?? sizeDefault;
  static final dR = view?.devicePixelRatio ?? 1;
  static final Size _size = pS / dR;
  static Size get size => _size;
}

Size sizeDefault = const Size(375, 812);

final double heightFlex = sizeDefault.height.sf;
final double widthFlex = sizeDefault.width.sf;

extension NumEx on num {
  double get hf => SizeUntil.size.h(sizeDefault) * this;

  double get wf => SizeUntil.size.w(sizeDefault) * this;

  double get sf => SizeUntil.size.f(sizeDefault) * this;

  double get rf => SizeUntil.size.f(sizeDefault) * this;

  double height(num size) => sf / size.sf;

 
  Widget get vSpace => SizedBox(height: sf);
 
  Widget get hSpace => SizedBox(width: sf);
}


extension NumSize on Size {
  double h(Size size) => height / size.height;

  double w(Size size) => width / size.width;

  double f(Size size) =>
      width < height ? width / size.width : height / size.height;
}

class NumContext {
  NumContext(this.numBer, this.numHeight, this.context);
  final double numBer;
  final double numHeight;
  final BuildContext context;
}

extension SizeLayoutContext on BuildContext {
  Size get appSize => MediaQuery.of(this).size;

  EdgeInsets get padding => MediaQuery.of(this).padding;
}
