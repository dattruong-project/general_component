import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../form_builder_field_decoration.dart';
import '../widget/image_source_sheet.dart';

enum ImageSourceOption { camera, gallery }

class FormBuilderImagePicker extends FormBuilderFieldDecoration<List<dynamic>> {
  final bool showDecoration;

  final bool previewAutoSizeWidth;

  final double previewWidth;

  final double previewHeight;

  final EdgeInsetsGeometry? previewMargin;

  final ImageProvider? placeholderImage;

  final Widget? placeholderWidget;

  final IconData? icon;

  final Color? iconColor;

  final Color? backgroundColor;

  final double? maxHeight;

  final double? maxWidth;

  final int? imageQuality;

  final CameraDevice preferredCameraDevice;

  final dynamic Function(dynamic obj)? displayCustomType;

  final void Function(Image)? onImage;

  final int? maxImages;

  final Widget Function(BuildContext context, Widget displayImage)?
      transformImageWidget;

  final Widget cameraIcon;
  final Widget galleryIcon;
  final Widget cameraLabel;
  final Widget galleryLabel;
  final EdgeInsets bottomSheetPadding;
  final bool preventPop;

  final BoxFit fit;

  final List<ImageSourceOption> availableImageSources;

  final ValueChanged<ImageSourceBottomSheet>? onTap;

  final Widget Function(
          FutureVoidCallBack cameraPicker, FutureVoidCallBack galleryPicker)?
      optionsBuilder;

  final WidgetBuilder? loadingWidget;

  FormBuilderImagePicker({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.decoration = const InputDecoration(),
    super.onChanged,
    super.valueTransformer,
    super.enabled = true,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    this.loadingWidget,
    this.transformImageWidget,
    this.showDecoration = true,
    this.placeholderWidget,
    this.previewAutoSizeWidth = true,
    this.fit = BoxFit.cover,
    this.preventPop = false,
    this.displayCustomType,
    this.previewWidth = 130,
    this.previewHeight = 130,
    this.previewMargin,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.maxHeight,
    this.maxWidth,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
    this.onImage,
    this.maxImages,
    this.cameraIcon = const Icon(Icons.camera_enhance),
    this.galleryIcon = const Icon(Icons.image),
    this.cameraLabel = const Text('Camera'),
    this.galleryLabel = const Text('Gallery'),
    this.bottomSheetPadding = EdgeInsets.zero,
    this.placeholderImage,
    this.onTap,
    this.optionsBuilder,
    this.availableImageSources = const [
      ImageSourceOption.camera,
      ImageSourceOption.gallery,
    ],
  })  : assert(maxImages == null || maxImages >= 0),
        super(
          builder: (FormFieldState<List<dynamic>?> field) {
            final state = field as FormBuilderImagePickerState;
            final theme = Theme.of(state.context);
            final disabledColor = theme.disabledColor;
            final primaryColor = theme.primaryColor;
            final value = state.effectiveValue;
            final canUpload = state.enabled && !state.hasMaxImages;

            final itemCount = value.length + (canUpload ? 1 : 0);

            Widget addButtonBuilder(
              BuildContext context,
            ) =>
                GestureDetector(
                  key: UniqueKey(),
                  child: placeholderWidget ??
                      SizedBox(
                        width: previewWidth,
                        child: placeholderImage != null
                            ? Image(
                                image: placeholderImage,
                              )
                            : Container(
                                color: (state.enabled
                                    ? backgroundColor ??
                                        primaryColor.withAlpha(50)
                                    : disabledColor),
                                child: Icon(
                                  icon ?? Icons.camera_enhance,
                                  color: state.enabled
                                      ? iconColor ?? primaryColor
                                      : disabledColor,
                                ),
                              ),
                      ),
                  onTap: () async {
                    final remainingImages =
                        maxImages == null ? null : maxImages - value.length;

                    final imageSourceSheet = ImageSourceBottomSheet(
                      maxHeight: maxHeight,
                      maxWidth: maxWidth,
                      preventPop: preventPop,
                      remainingImages: remainingImages,
                      imageQuality: imageQuality,
                      preferredCameraDevice: preferredCameraDevice,
                      bottomSheetPadding: bottomSheetPadding,
                      cameraIcon: cameraIcon,
                      cameraLabel: cameraLabel,
                      galleryIcon: galleryIcon,
                      galleryLabel: galleryLabel,
                      optionsBuilder: optionsBuilder,
                      availableImageSources: availableImageSources,
                      onImageSelected: (image) {
                        state.focus();
                        field.didChange([...value, ...image]);
                        Navigator.pop(state.context);
                      },
                    );
                    onTap != null
                        ? onTap(imageSourceSheet)
                        : await showModalBottomSheet<void>(
                            context: state.context,
                            builder: (_) {
                              return imageSourceSheet;
                            },
                          );
                  },
                );

            Widget itemBuilder(
              BuildContext context,
              dynamic item,
              int index,
            ) {
              bool checkIfItemIsCustomType(dynamic e) => !(e is XFile ||
                  e is String ||
                  e is Uint8List ||
                  e is ImageProvider ||
                  e is Widget);

              final itemCustomType = checkIfItemIsCustomType(item);
              var displayItem = item;
              if (itemCustomType && displayCustomType != null) {
                displayItem = displayCustomType(item);
              }
              assert(
                !checkIfItemIsCustomType(displayItem),
                'Display item must be of type [Uint8List], [XFile], [String] (url), [ImageProvider] or [Widget]. '
                'Consider using displayCustomType to handle the type: ${displayItem.runtimeType}',
              );

              final displayWidget = displayItem is Widget
                  ? displayItem
                  : displayItem is ImageProvider
                      ? Image(image: displayItem, fit: fit)
                      : displayItem is Uint8List
                          ? Image.memory(displayItem, fit: fit)
                          : displayItem is String
                              ? Image.network(
                                  displayItem,
                                  fit: fit,
                                )
                              : XFileImage(
                                  file: displayItem,
                                  fit: fit,
                                  loadingWidget: loadingWidget,
                                );
              return Stack(
                key: ObjectKey(item),
                children: <Widget>[
                  transformImageWidget?.call(context, displayWidget) ??
                      displayWidget,
                  if (state.enabled)
                    PositionedDirectional(
                      top: 0,
                      end: 0,
                      child: InkWell(
                        onTap: () {
                          state.focus();
                          field.didChange(
                            value.toList()..removeAt(index),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.7),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          height: 22,
                          width: 22,
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }

            final child = SizedBox(
              height: previewHeight,
              child: itemCount == 0
                  ? null
                  : itemCount == 1
                      ? canUpload
                          ? addButtonBuilder(state.context)
                          : SizedBox(
                              width: previewAutoSizeWidth ? null : previewWidth,
                              child: itemBuilder(state.context, value.first, 0),
                            )
                      : ListView.builder(
                          itemExtent:
                              previewAutoSizeWidth ? null : previewWidth,
                          scrollDirection: Axis.horizontal,
                          itemCount: itemCount,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: previewMargin,
                              child: Builder(
                                builder: (context) {
                                  if (index < value.length) {
                                    final item = value[index];
                                    return itemBuilder(context, item, index);
                                  }
                                  return addButtonBuilder(context);
                                },
                              ),
                            );
                          },
                        ),
            );
            return showDecoration
                ? InputDecorator(
                    decoration: state.decoration,
                    child: child,
                  )
                : child;
          },
        );

  @override
  FormBuilderImagePickerState createState() => FormBuilderImagePickerState();
}

class FormBuilderImagePickerState extends FormBuilderFieldDecorationState<
    FormBuilderImagePicker, List<dynamic>> {
  List<dynamic> get effectiveValue =>
      value?.where((element) => element != null).toList() ?? [];

  bool get hasMaxImages {
    final ev = effectiveValue;
    return widget.maxImages != null && ev.length >= widget.maxImages!;
  }
}

class XFileImage extends StatefulWidget {
  const XFileImage({
    super.key,
    required this.file,
    this.fit,
    this.loadingWidget,
  });

  final XFile file;
  final BoxFit? fit;
  final WidgetBuilder? loadingWidget;

  @override
  State<XFileImage> createState() => _XFileImageState();
}

class _XFileImageState extends State<XFileImage> {
  final _memoizer = AsyncMemoizer<Uint8List>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _memoizer.runOnce(widget.file.readAsBytes),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return widget.loadingWidget?.call(context) ??
              const Center(child: CircularProgressIndicator());
        }
        return Image.memory(data, fit: widget.fit);
      },
    );
  }
}
