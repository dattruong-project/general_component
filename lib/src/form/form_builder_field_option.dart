import 'package:flutter/material.dart';

class FormBuilderFieldOption<T> extends StatelessWidget {
  final Widget? child;
  final T value;

  const FormBuilderFieldOption({
    super.key,
    required this.value,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child ?? Text(value.toString());
  }
}
