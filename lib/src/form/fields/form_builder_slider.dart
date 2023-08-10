import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_builder_field_decoration.dart';

enum DisplayValues { all, current, minMax, none }

class FormBuilderSlider extends FormBuilderFieldDecoration<double> {
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final MouseCursor? mouseCursor;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final bool autofocus;
  final Widget Function(String min)? minValueWidget;
  final Widget Function(String value)? valueWidget;
  final Widget Function(String max)? maxValueWidget;
  final NumberFormat? numberFormat;
  final DisplayValues displayValues;

  FormBuilderSlider({
    super.key,
    required super.name,
    super.validator,
    required double super.initialValue,
    super.decoration,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    super.restorationId,
    required this.min,
    required this.max,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.onChangeStart,
    this.onChangeEnd,
    this.label,
    this.semanticFormatterCallback,
    this.numberFormat,
    this.displayValues = DisplayValues.all,
    this.autofocus = false,
    this.mouseCursor,
    this.maxValueWidget,
    this.minValueWidget,
    this.valueWidget,
  }) : super(
          builder: (FormFieldState<double?> field) {
            final state = field as _FormBuilderSliderState;
            final effectiveNumberFormat =
                numberFormat ?? NumberFormat.compact();

            return InputDecorator(
              decoration: state.decoration,
              child: Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Slider(
                      value: field.value!,
                      min: min,
                      max: max,
                      divisions: divisions,
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      onChangeEnd: onChangeEnd,
                      onChangeStart: onChangeStart,
                      label: label,
                      semanticFormatterCallback: semanticFormatterCallback,
                      onChanged: state.enabled
                          ? (value) {
                              field.didChange(value);
                            }
                          : null,
                      autofocus: autofocus,
                      mouseCursor: mouseCursor,
                      focusNode: state.effectiveFocusNode,
                    ),
                    Row(
                      children: <Widget>[
                        if (displayValues != DisplayValues.none &&
                            displayValues != DisplayValues.current)
                          minValueWidget
                                  ?.call(effectiveNumberFormat.format(min)) ??
                              Text(effectiveNumberFormat.format(min)),
                        const Spacer(),
                        if (displayValues != DisplayValues.none &&
                            displayValues != DisplayValues.minMax)
                          valueWidget?.call(
                                  effectiveNumberFormat.format(field.value)) ??
                              Text(effectiveNumberFormat.format(field.value)),
                        const Spacer(),
                        if (displayValues != DisplayValues.none &&
                            displayValues != DisplayValues.current)
                          maxValueWidget
                                  ?.call(effectiveNumberFormat.format(max)) ??
                              Text(effectiveNumberFormat.format(max)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<FormBuilderSlider, double> createState() =>
      _FormBuilderSliderState();
}

class _FormBuilderSliderState
    extends FormBuilderFieldDecorationState<FormBuilderSlider, double> {}
