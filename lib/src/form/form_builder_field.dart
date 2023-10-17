import 'package:flutter/widgets.dart';
import 'package:general_component/src/form/extensions/autovalidatemode_extension.dart';

import 'form_builder.dart';

enum OptionsOrientation { horizontal, vertical, wrap }

enum ControlAffinity { leading, trailing }

typedef ValueTransformer<T> = dynamic Function(T value);

class FormBuilderField<T> extends FormField<T> {

  final String name;

  final ValueTransformer<T?>? valueTransformer;

  final ValueChanged<T?>? onChanged;

  final VoidCallback? onReset;

  final FocusNode? focusNode;


  const FormBuilderField({
    super.key,
    super.onSaved,
    super.initialValue,
    super.autovalidateMode,
    super.enabled = true,
    super.validator,
    super.restorationId,
    required super.builder,
    required this.name,
    this.valueTransformer,
    this.onChanged,
    this.onReset,
    this.focusNode,
  });

  @override
  FormBuilderFieldState<FormBuilderField<T>, T> createState() =>
      FormBuilderFieldState<FormBuilderField<T>, T>();
}

class FormBuilderFieldState<F extends FormBuilderField<T>, T>
    extends FormFieldState<T> {
  String? _customErrorText;
  FormBuilderState? _formBuilderState;
  bool _touched = false;
  bool _dirty = false;
  late FocusNode effectiveFocusNode;
  FocusAttachment? focusAttachment;

  @override
  F get widget => super.widget as F;

  FormBuilderState? get formState => _formBuilderState;

  T? get initialValue =>
      widget.initialValue ??
      (_formBuilderState?.initialValue ??
          const <String, dynamic>{})[widget.name] as T?;

  dynamic get transformedValue => widget.valueTransformer?.call(value) ?? value;

  @override
  String? get errorText => super.errorText ?? _customErrorText;

  @override
  bool get hasError => super.hasError || errorText != null;

  @override
  bool get isValid => super.isValid && errorText == null;

  bool get enabled => widget.enabled && (_formBuilderState?.enabled ?? true);

  bool get readOnly => !(_formBuilderState?.widget.skipDisabled ?? false);

  bool get _isAlwaysValidate =>
      widget.autovalidateMode.isAlways ||
      (_formBuilderState?.widget.autovalidateMode?.isAlways ?? false);

  bool get isDirty => _dirty;

  bool get isTouched => _touched;

  void registerTransformer(Map<String, Function> map) {
    final fun = widget.valueTransformer;
    if (fun != null) {
      map[widget.name] = fun;
    }
  }

  @override
  void initState() {
    super.initState();

    _formBuilderState = FormBuilder.of(context);

    _formBuilderState?.registerField(widget.name, this);

    effectiveFocusNode = widget.focusNode ?? FocusNode(debugLabel: widget.name);

    effectiveFocusNode.addListener(_touchedHandler);
    focusAttachment = effectiveFocusNode.attach(context);

    if ((enabled || readOnly) && _isAlwaysValidate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        validate();
      });
    }
  }

  @override
  void didUpdateWidget(covariant FormBuilderField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.name != oldWidget.name) {
      _formBuilderState?.unregisterField(oldWidget.name, this);
      _formBuilderState?.registerField(widget.name, this);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      focusAttachment?.detach();
      effectiveFocusNode.removeListener(_touchedHandler);
      effectiveFocusNode = widget.focusNode ?? FocusNode();
      effectiveFocusNode.addListener(_touchedHandler);
      focusAttachment = effectiveFocusNode.attach(context);
    }
  }

  @override
  void dispose() {
    effectiveFocusNode.removeListener(_touchedHandler);

    if (widget.focusNode == null) {
      effectiveFocusNode.dispose();
    }
    _formBuilderState?.unregisterField(widget.name, this);
    super.dispose();
  }

  void _informFormForFieldChange() {
    if (_formBuilderState != null) {
      _dirty = true;
      if (enabled || readOnly) {
        _formBuilderState!.setInternalFieldValue<T>(widget.name, value);
        return;
      }
      _formBuilderState!.removeInternalFieldValue(widget.name);
    }
  }

  void _touchedHandler() {
    if (effectiveFocusNode.hasFocus && _touched == false) {
      setState(() => _touched = true);
    }
  }

  @override
  void setValue(T? value, {bool populateForm = true}) {
    super.setValue(value);
    if (populateForm) {
      _informFormForFieldChange();
    }
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    _informFormForFieldChange();
    widget.onChanged?.call(value);
  }

  @override
  void reset() {
    super.reset();
    didChange(initialValue);
    _dirty = false;
    if (_customErrorText != null) {
      setState(() => _customErrorText = null);
    }
    widget.onReset?.call();
  }

  @override
  bool validate({
    bool clearCustomError = true,
    bool focusOnInvalid = true,
    bool autoScrollWhenFocusOnInvalid = false,
  }) {
    if (clearCustomError) {
      setState(() => _customErrorText = null);
    }
    final isValid = super.validate() && !hasError;

    final fields = _formBuilderState?.fields ??
        <String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>{};

    if (!isValid &&
        focusOnInvalid &&
        (formState?.focusOnInvalid ?? true) &&
        enabled &&
        !fields.values.any((e) => e.effectiveFocusNode.hasFocus)) {
      focus();
      if (autoScrollWhenFocusOnInvalid) ensureScrollableVisibility();
    }

    return isValid;
  }

  void invalidate(
    String errorText, {
    bool shouldFocus = true,
    bool shouldAutoScrollWhenFocus = false,
  }) {
    setState(() => _customErrorText = errorText);

    validate(
      clearCustomError: false,
      autoScrollWhenFocusOnInvalid: shouldAutoScrollWhenFocus,
      focusOnInvalid: shouldFocus,
    );
  }

  void focus() {
    FocusScope.of(context).requestFocus(effectiveFocusNode);
  }

  void ensureScrollableVisibility() {
    Scrollable.ensureVisible(context);
  }
}
