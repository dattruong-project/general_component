import 'package:flutter/material.dart';
import '../form_builder_field_decoration.dart';
import '../form_builder_field_option.dart';

class FormBuilderChoiceChip<T> extends FormBuilderFieldDecoration<T> {
  final List<FormBuilderChipOption<T>> options;

  final double? elevation;

  final double? pressElevation;

  final Color? selectedColor;

  final Color? disabledColor;

  final Color? backgroundColor;

  final Color? selectedShadowColor;

  final Color? shadowColor;

  final OutlinedBorder? shape;

  final MaterialTapTargetSize? materialTapTargetSize;

  final EdgeInsets? labelPadding;

  final TextStyle? labelStyle;

  final EdgeInsets? padding;

  final VisualDensity? visualDensity;

  final Axis direction;

  final WrapAlignment alignment;

  final double spacing;

  final WrapAlignment runAlignment;

  final double runSpacing;

  final WrapCrossAlignment crossAxisAlignment;

  final TextDirection? textDirection;

  final VerticalDirection verticalDirection;

  final ShapeBorder avatarBorder;

  FormBuilderChoiceChip({
    super.autovalidateMode = AutovalidateMode.disabled,
    super.enabled,
    super.focusNode,
    super.onSaved,
    super.validator,
    super.decoration,
    super.key,
    required super.name,
    required this.options,
    super.initialValue,
    super.restorationId,
    super.onChanged,
    super.valueTransformer,
    super.onReset,
    this.alignment = WrapAlignment.start,
    this.avatarBorder = const CircleBorder(),
    this.backgroundColor,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.direction = Axis.horizontal,
    this.disabledColor,
    this.elevation,
    this.labelPadding,
    this.labelStyle,
    this.materialTapTargetSize,
    this.padding,
    this.pressElevation,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.selectedColor,
    this.selectedShadowColor,
    this.shadowColor,
    this.shape,
    this.spacing = 0.0,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.visualDensity,
  }) : super(builder: (FormFieldState<T?> field) {
          final state = field as _FormBuilderChoiceChipState<T>;

          return InputDecorator(
            decoration: state.decoration,
            child: Wrap(
              direction: direction,
              alignment: alignment,
              crossAxisAlignment: crossAxisAlignment,
              runAlignment: runAlignment,
              runSpacing: runSpacing,
              spacing: spacing,
              textDirection: textDirection,
              verticalDirection: verticalDirection,
              children: <Widget>[
                for (FormBuilderChipOption<T> option in options)
                  ChoiceChip(
                    label: option,
                    shape: shape,
                    selected: field.value == option.value,
                    onSelected: state.enabled
                        ? (selected) {
                            final choice = selected ? option.value : null;
                            state.didChange(choice);
                          }
                        : null,
                    avatar: option.avatar,
                    selectedColor: selectedColor,
                    disabledColor: disabledColor,
                    backgroundColor: backgroundColor,
                    shadowColor: shadowColor,
                    selectedShadowColor: selectedShadowColor,
                    elevation: elevation,
                    pressElevation: pressElevation,
                    materialTapTargetSize: materialTapTargetSize,
                    labelStyle: labelStyle,
                    labelPadding: labelPadding,
                    padding: padding,
                    visualDensity: visualDensity,
                    avatarBorder: avatarBorder,
                  ),
              ],
            ),
          );
        });

  @override
  FormBuilderFieldDecorationState<FormBuilderChoiceChip<T>, T> createState() =>
      _FormBuilderChoiceChipState<T>();
}

class _FormBuilderChoiceChipState<T>
    extends FormBuilderFieldDecorationState<FormBuilderChoiceChip<T>, T> {}

class FormBuilderChipOption<T> extends FormBuilderFieldOption<T> {
  final Widget? avatar;

  const FormBuilderChipOption({
    super.key,
    required super.value,
    this.avatar,
    super.child,
  });

  @override
  Widget build(BuildContext context) {
    return child ?? Text(value.toString());
  }
}
