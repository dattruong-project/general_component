import 'package:flutter/material.dart';

import 'form_builder_field.dart';

class FormBuilderFieldDecoration<T> extends FormBuilderField<T> {
  const FormBuilderFieldDecoration({
    super.key,
    super.onSaved,
    super.initialValue,
    super.autovalidateMode,
    super.enabled = true,
    super.validator,
    super.restorationId,
    required super.name,
    super.valueTransformer,
    super.onChanged,
    super.onReset,
    super.focusNode,
    required super.builder,
    this.decoration = const InputDecoration(),
  });

  final InputDecoration decoration;


  @override
  FormBuilderFieldDecorationState<FormBuilderFieldDecoration<T>, T>
      createState() =>
          FormBuilderFieldDecorationState<FormBuilderFieldDecoration<T>, T>();
}

class FormBuilderFieldDecorationState<F extends FormBuilderFieldDecoration<T>,
    T> extends FormBuilderFieldState<FormBuilderField<T>, T> {
  @override
  F get widget => super.widget as F;

  InputDecoration get decoration => widget.decoration.copyWith(
        errorText: widget.enabled || readOnly
            ? widget.decoration.errorText ?? errorText
            : null,
        enabled: widget.enabled,
      );

  @override
  bool get hasError => super.hasError || widget.decoration.errorText != null;

  @override
  bool get isValid => super.isValid && widget.decoration.errorText == null;
}
