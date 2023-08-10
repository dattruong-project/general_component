import 'package:flutter/material.dart';

import '../form_builder_field.dart';
import '../form_builder_field_option.dart';

class GroupedCheckbox<T> extends StatelessWidget {
  final List<FormBuilderFieldOption<T>> options;

  final List<T>? value;

  final List<T>? disabled;

  final OptionsOrientation orientation;

  final ValueChanged<List<T>> onChanged;

  final Color? activeColor;

  final Color? checkColor;

  final bool tristate;

  final MaterialTapTargetSize? materialTapTargetSize;

  final Color? focusColor;

  final Color? hoverColor;

  final Axis wrapDirection;

  final WrapAlignment wrapAlignment;

  final double wrapSpacing;

  final WrapAlignment wrapRunAlignment;

  final double wrapRunSpacing;

  final WrapCrossAlignment wrapCrossAxisAlignment;

  final TextDirection? wrapTextDirection;

  final VerticalDirection wrapVerticalDirection;

  final Widget? separator;

  final ControlAffinity controlAffinity;

  const GroupedCheckbox({
    super.key,
    required this.options,
    required this.orientation,
    required this.onChanged,
    this.value,
    this.disabled,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.materialTapTargetSize,
    this.tristate = false,
    this.wrapDirection = Axis.horizontal,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapSpacing = 0.0,
    this.wrapRunAlignment = WrapAlignment.start,
    this.wrapRunSpacing = 0.0,
    this.wrapCrossAxisAlignment = WrapCrossAlignment.start,
    this.wrapTextDirection,
    this.wrapVerticalDirection = VerticalDirection.down,
    this.separator,
    this.controlAffinity = ControlAffinity.leading,
  });

  @override
  Widget build(BuildContext context) {
    final widgetList = <Widget>[];
    for (var i = 0; i < options.length; i++) {
      widgetList.add(item(i));
    }
    Widget finalWidget;
    if (orientation == OptionsOrientation.vertical) {
      finalWidget = SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgetList,
        ),
      );
    } else if (orientation == OptionsOrientation.horizontal) {
      finalWidget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widgetList.map((item) {
            return Column(children: <Widget>[item]);
          }).toList(),
        ),
      );
    } else {
      finalWidget = SingleChildScrollView(
        child: Wrap(
          spacing: wrapSpacing,
          runSpacing: wrapRunSpacing,
          textDirection: wrapTextDirection,
          crossAxisAlignment: wrapCrossAxisAlignment,
          verticalDirection: wrapVerticalDirection,
          alignment: wrapAlignment,
          direction: Axis.horizontal,
          runAlignment: wrapRunAlignment,
          children: widgetList,
        ),
      );
    }
    return finalWidget;
  }

  Widget item(int index) {
    final option = options[index];
    final optionValue = option.value;
    final isOptionDisabled = true == disabled?.contains(optionValue);
    final control = Checkbox(
      activeColor: activeColor,
      checkColor: checkColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      materialTapTargetSize: materialTapTargetSize,
      value: tristate
          ? value?.contains(optionValue)
          : true == value?.contains(optionValue),
      tristate: tristate,
      onChanged: isOptionDisabled
          ? null
          : (selected) {
              List<T> selectedListItems = value == null ? [] : List.of(value!);
              selected!
                  ? selectedListItems.add(optionValue)
                  : selectedListItems.remove(optionValue);
              onChanged(selectedListItems);
            },
    );
    final label = GestureDetector(
      onTap: isOptionDisabled
          ? null
          : () {
              List<T> selectedListItems = value == null ? [] : List.of(value!);
              selectedListItems.contains(optionValue)
                  ? selectedListItems.remove(optionValue)
                  : selectedListItems.add(optionValue);
              onChanged(selectedListItems);
            },
      child: option,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (controlAffinity == ControlAffinity.leading) control,
        Flexible(flex: 1, child: label),
        if (controlAffinity == ControlAffinity.trailing) control,
        if (separator != null && index != options.length - 1) separator!,
      ],
    );
  }
}
