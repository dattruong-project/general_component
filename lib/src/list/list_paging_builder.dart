import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListPagingBuilder<T> extends StatefulWidget {
  const ListPagingBuilder({
    Key? key,
    required this.pagingController,
    required this.itemBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
    this.animateTransitions,
    this.transitionDuration,
    this.displacement,
    this.edgeOffset,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth,
    this.triggerMode,
  }) : super(key: key);

  final PagingController<int, T> pagingController;
  final ItemWidgetBuilder<T> itemBuilder;
  final WidgetBuilder? firstPageErrorIndicatorBuilder;
  final WidgetBuilder? newPageErrorIndicatorBuilder;
  final WidgetBuilder? firstPageProgressIndicatorBuilder;
  final WidgetBuilder? newPageProgressIndicatorBuilder;
  final WidgetBuilder? noItemsFoundIndicatorBuilder;
  final WidgetBuilder? noMoreItemsIndicatorBuilder;
  final bool? animateTransitions;
  final Duration? transitionDuration;
  final double? displacement;
  final double? edgeOffset;
  final RefreshCallback onRefresh;
  final Color? color;
  final Color? backgroundColor;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double? strokeWidth;
  final RefreshIndicatorTriggerMode? triggerMode;

  @override
  State<ListPagingBuilder<T>> createState() => _ListPagingBuilderState<T>();
}

class _ListPagingBuilderState<T> extends State<ListPagingBuilder<T>> {
  late final PagingController<int, T> _pagedController;

  @override
  void initState() {
    super.initState();
    _pagedController = widget.pagingController;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: widget.onRefresh,
        backgroundColor: widget.backgroundColor,
        color: widget.color,
        displacement: widget.displacement ?? 40.0,
        strokeWidth: RefreshProgressIndicator.defaultStrokeWidth,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: PagedListView<int, T>(
          builderDelegate: PagedChildBuilderDelegate<T>(
            firstPageErrorIndicatorBuilder:
            widget.firstPageErrorIndicatorBuilder,
            newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder,
            firstPageProgressIndicatorBuilder:
            widget.firstPageProgressIndicatorBuilder,
            newPageProgressIndicatorBuilder:
            widget.newPageProgressIndicatorBuilder,
            noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder,
            noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder,
            animateTransitions: widget.animateTransitions ?? false,
            transitionDuration:
            widget.transitionDuration ?? const Duration(milliseconds: 250),
            itemBuilder: widget.itemBuilder,
          ),
          pagingController: _pagedController,
        )
    );
  }

  @override
  void dispose() {
    _pagedController.dispose();
    super.dispose();
  }
}
