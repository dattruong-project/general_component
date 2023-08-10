import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_builder_field_decoration.dart';
import 'form_builder_slider.dart';

class FormBuilderRangeSlider extends FormBuilderFieldDecoration<RangeValues> {
  final ValueChanged<RangeValues>? onChangeStart;

  final ValueChanged<RangeValues>? onChangeEnd;

  final double min;

  final double max;

  final int? divisions;

  final RangeLabels? labels;

  final Color? activeColor;

  final Color? inactiveColor;

  final SemanticFormatterCallback? semanticFormatterCallback;

  final Widget Function(String min)? minValueWidget;

  final Widget Function(String value)? valueWidget;

  final Widget Function(String max)? maxValueWidget;

  final NumberFormat? numberFormat;

  final DisplayValues displayValues;

  FormBuilderRangeSlider({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.decoration,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    required this.min,
    required this.max,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.onChangeStart,
    this.onChangeEnd,
    this.labels,
    this.semanticFormatterCallback,
    this.displayValues = DisplayValues.all,
    this.minValueWidget,
    this.valueWidget,
    this.maxValueWidget,
    this.numberFormat,
  }) : super(builder: (FormFieldState<RangeValues?> field) {
          final state = field as _FormBuilderRangeSliderState;
          final effectiveNumberFormat = numberFormat ?? NumberFormat.compact();
          if (initialValue == null) {
            field.setValue(RangeValues(min, min));
          }
          return InputDecorator(
            decoration: state.decoration,
            child: Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RangeSlider(
                    values: field.value!,
                    min: min,
                    max: max,
                    divisions: divisions,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    onChangeEnd: onChangeEnd,
                    onChangeStart: onChangeStart,
                    labels: labels,
                    semanticFormatterCallback: semanticFormatterCallback,
                    onChanged: state.enabled
                        ? (values) {
                            field.didChange(values);
                          }
                        : null,
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
                                '${effectiveNumberFormat.format(field.value!.start)} - ${effectiveNumberFormat.format(field.value!.end)}') ??
                            Text(
                                '${effectiveNumberFormat.format(field.value!.start)} - ${effectiveNumberFormat.format(field.value!.end)}'),
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
        });

  @override
  FormBuilderFieldDecorationState<FormBuilderRangeSlider, RangeValues>
      createState() => _FormBuilderRangeSliderState();
}

class _FormBuilderRangeSliderState extends FormBuilderFieldDecorationState<
    FormBuilderRangeSlider, RangeValues> {}
