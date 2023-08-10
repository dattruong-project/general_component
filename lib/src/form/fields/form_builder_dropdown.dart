import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../form_builder_field_decoration.dart';

class FormBuilderDropdown<T> extends FormBuilderFieldDecoration<T> {
  final List<DropdownMenuItem<T>> items;

  final DropdownButtonBuilder? selectedItemBuilder;

  final T? value;

  final Widget? hint;

  final Widget? disabledHint;

  final ValueChanged<T?>? onChanged;

  final OnMenuStateChangeFn? onMenuStateChange;

  final TextStyle? style;

  final Widget? underline;

  final bool isDense;

  final bool isExpanded;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool? enableFeedback;

  final AlignmentGeometry alignment;

  final ButtonStyleData? buttonStyleData;

  final IconStyleData iconStyleData;

  final DropdownStyleData dropdownStyleData;

  final MenuItemStyleData menuItemStyleData;

  final DropdownSearchData<T>? dropdownSearchData;

  final Widget? customButton;

  final bool openWithLongPress;

  final bool barrierDismissible;

  final Color? barrierColor;

  final String? barrierLabel;

  FormBuilderDropdown({
    super.key,
    required this.items,
    required super.name,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    this.onChanged,
    this.onMenuStateChange,
    this.style,
    this.underline,
    this.isDense = false,
    this.isExpanded = false,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.buttonStyleData,
    this.iconStyleData = const IconStyleData(),
    this.dropdownStyleData = const DropdownStyleData(),
    this.menuItemStyleData = const MenuItemStyleData(),
    this.dropdownSearchData,
    this.customButton,
    this.openWithLongPress = false,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
  }) : super(
          builder: (FormFieldState<T?> field) {
            final state = field as _FormBuilderDropdownState<T>;

            final hasValue = items.map((e) => e.value).contains(field.value);
            return DropdownButton2<T>(
              isExpanded: isExpanded,
              items: items,
              hint: Text(name),
              dropdownStyleData: dropdownStyleData,
              menuItemStyleData: menuItemStyleData,
              dropdownSearchData: dropdownSearchData,
              barrierColor: barrierColor,
              barrierDismissible: barrierDismissible,
              barrierLabel: barrierLabel,
              customButton: customButton,
              buttonStyleData: buttonStyleData,
              value: hasValue ? field.value : null,
              style: style,
              isDense: isDense,
              disabledHint: hasValue
                  ? items
                      .firstWhere(
                          (dropDownItem) => dropDownItem.value == field.value)
                      .child
                  : disabledHint,
              onChanged:
                  state.enabled ? (T? value) => state.didChange(value) : null,
              focusNode: state.effectiveFocusNode,
              autofocus: autofocus,
              selectedItemBuilder: selectedItemBuilder,
              enableFeedback: enableFeedback,
              alignment: alignment,
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<FormBuilderDropdown<T>, T> createState() =>
      _FormBuilderDropdownState<T>();
}

class _FormBuilderDropdownState<T>
    extends FormBuilderFieldDecorationState<FormBuilderDropdown<T>, T> {}
