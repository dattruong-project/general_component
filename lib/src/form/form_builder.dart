import 'package:flutter/widgets.dart';

import 'form_builder_field.dart';

class FormBuilder extends StatefulWidget {
  final VoidCallback? onChanged;

  final WillPopCallback? onWillPop;

  final Widget child;

  final AutovalidateMode? autovalidateMode;

  final Map<String, dynamic> initialValue;

  final bool skipDisabled;

  final bool enabled;

  final bool clearValueOnUnregister;

  const FormBuilder({
    super.key,
    required this.child,
    this.onChanged,
    this.autovalidateMode,
    this.onWillPop,
    this.initialValue = const <String, dynamic>{},
    this.skipDisabled = false,
    this.enabled = true,
    this.clearValueOnUnregister = false,
  });

  static FormBuilderState? of(BuildContext context) =>
      context.findAncestorStateOfType<FormBuilderState>();

  @override
  FormBuilderState createState() => FormBuilderState();
}

typedef FormBuilderFields
    = Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>;

class FormBuilderState extends State<FormBuilder> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FormBuilderFields _fields = {};
  final Map<String, dynamic> _instantValue = {};
  final Map<String, dynamic> _savedValue = {};

  final Map<String, Function> _transformers = {};
  bool _focusOnInvalid = true;

  bool get focusOnInvalid => _focusOnInvalid;

  bool get enabled => widget.enabled;

  bool get isValid => fields.values.every((field) => field.isValid);

  bool get isDirty => fields.values.any((field) => field.isDirty);

  bool get isTouched => fields.values.any((field) => field.isTouched);

  Map<String, String> get errors => {
        for (var element
            in fields.entries.where((element) => element.value.hasError))
          element.key.toString(): element.value.errorText ?? ''
      };

  Map<String, dynamic> get initialValue => widget.initialValue;

  FormBuilderFields get fields => _fields;

  Map<String, dynamic> get instantValue =>
      Map<String, dynamic>.unmodifiable(_instantValue.map((key, value) =>
          MapEntry(key, _transformers[key]?.call(value) ?? value)));

  Map<String, dynamic> get value =>
      Map<String, dynamic>.unmodifiable(_savedValue.map((key, value) =>
          MapEntry(key, _transformers[key]?.call(value) ?? value)));

  dynamic transformValue<T>(String name, T? v) {
    final t = _transformers[name];
    return t != null ? t.call(v) : v;
  }

  dynamic getTransformedValue<T>(String name, {bool fromSaved = false}) {
    return transformValue<T>(name, getRawValue(name));
  }

  T? getRawValue<T>(String name, {bool fromSaved = false}) {
    return (fromSaved ? _savedValue[name] : _instantValue[name]) ??
        initialValue[name];
  }

  void setInternalFieldValue<T>(String name, T? value) {
    _instantValue[name] = value;
    widget.onChanged?.call();
  }

  void removeInternalFieldValue(String name) {
    _instantValue.remove(name);
  }

  void registerField(String name, FormBuilderFieldState field) {
    final oldField = _fields[name];
    assert(() {
      if (oldField != null) {
        debugPrint('Warning! Replacing duplicate Field for $name'
            ' -- this is OK to ignore as long as the field was intentionally replaced');
      }
      return true;
    }());

    _fields[name] = field;
    field.registerTransformer(_transformers);

    field.setValue(
      oldField?.value ?? (_instantValue[name] ??= field.initialValue),
      populateForm: false,
    );
  }

  void unregisterField(String name, FormBuilderFieldState field) {
    assert(_fields.containsKey(name));

    if (field == _fields[name]) {
      _fields.remove(name);
      _transformers.remove(name);
      if (widget.clearValueOnUnregister) {
        _instantValue.remove(name);
        _savedValue.remove(name);
      }
    } else {
      assert(() {
        debugPrint('Warning! Ignoring Field unregistration for $name'
            ' -- this is OK to ignore as long as the field was intentionally replaced');
        return true;
      }());
    }
  }

  void save() {
    _formKey.currentState!.save();

    _savedValue.clear();
    _savedValue.addAll(_instantValue);
  }

  @Deprecated(
      'Will be remove to avoid redundancy. Use fields[name]?.invalidate(errorText) instead')
  void invalidateField({required String name, String? errorText}) =>
      fields[name]?.invalidate(errorText ?? '');

  @Deprecated(
      'Will be remove to avoid redundancy. Use fields.first.invalidate(errorText) instead')
  void invalidateFirstField({required String errorText}) =>
      fields.values.first.invalidate(errorText);

  bool validate({
    bool focusOnInvalid = true,
    bool autoScrollWhenFocusOnInvalid = false,
  }) {
    _focusOnInvalid = focusOnInvalid;
    final hasError = !_formKey.currentState!.validate();
    if (hasError) {
      final wrongFields =
          fields.values.where((element) => element.hasError).toList();
      if (wrongFields.isNotEmpty) {
        if (focusOnInvalid) {
          wrongFields.first.focus();
        }
        if (autoScrollWhenFocusOnInvalid) {
          wrongFields.first.ensureScrollableVisibility();
        }
      }
    }
    return !hasError;
  }

  bool saveAndValidate({
    bool focusOnInvalid = true,
    bool autoScrollWhenFocusOnInvalid = false,
  }) {
    save();
    return validate(
      focusOnInvalid: focusOnInvalid,
      autoScrollWhenFocusOnInvalid: autoScrollWhenFocusOnInvalid,
    );
  }

  void reset() {
    _formKey.currentState?.reset();
  }

  void patchValue(Map<String, dynamic> val) {
    val.forEach((key, dynamic value) {
      _fields[key]?.didChange(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: widget.autovalidateMode,
      onWillPop: widget.onWillPop,
      child: _FormBuilderScope(
        formState: this,
        child: FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: widget.child,
        ),
      ),
    );
  }
}

class _FormBuilderScope extends InheritedWidget {
  const _FormBuilderScope({
    required super.child,
    required FormBuilderState formState,
  }) : _formState = formState;

  final FormBuilderState _formState;

  FormBuilder get form => _formState.widget;

  @override
  bool updateShouldNotify(_FormBuilderScope oldWidget) =>
      oldWidget._formState != _formState;
}
