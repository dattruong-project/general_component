import 'package:flutter/widgets.dart';

extension AutovalidateModeExtension on AutovalidateMode {
 
  bool get isEnable => isAlways || isOnUserInteraction;
  bool get isAlways => this == AutovalidateMode.always;
  bool get isOnUserInteraction => this == AutovalidateMode.onUserInteraction;
}