import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension SB on num {
  Widget get vertical => SizedBox(
        height: toDouble(),
      );

  Widget get horizontal => SizedBox(
        width: toDouble(),
      );

  double textHeight(num size) => this / size;
}

extension CustomizeString on String? {
  bool isNullOrEmpty() => this == null || (this!.isEmpty == true);

  String get hidePhone {
    if (this == null) return '0000xxx000';
    final start = this!.length > 4 ? this!.substring(0, 4) : '0000';
    final end = this!.length > 4
        ? this!.substring(this!.length - 4, this!.length - 1)
        : '000';
    return '${start}xxx$end';
  }
}

extension BX on bool? {
  bool get isNF => this ?? false;

  bool get isNT => this ?? true;
}

extension VGlobalKey on GlobalKey {
  Offset get position {
    final RenderBox? renderBox =
        currentContext?.findRenderObject() as RenderBox?;
    final NavigatorState? state =
        currentContext?.findAncestorStateOfType<NavigatorState>();
    if (state != null) {
      return renderBox?.localToGlobal(
            Offset.zero,
            ancestor: state.context.findRenderObject(),
          ) ??
          Offset.zero;
    }
    return renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
  }

  Size get size {
    final RenderBox? renderBox =
        currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size ?? Size.zero;
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

extension DateUtil on DateTime {
  DateTime onlyYear() => DateTime(year);

  DateTime onlyMonthYear() => DateTime(year, month);

  DateTime onlyDayMonthYear() => DateTime(year, month, day);

  String getYearMonthDay() {
    return DateFormat.yMd().format(this);
  }

  String getDayMonthYear() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String get dmy {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String getCurrentMonthDay() {
    return DateFormat.Md().format(this);
  }

  String getFormattedDateTime() {
    return DateFormat('dd/MM/yyyy - HH:mm').format(this);
  }

  String getFormattedDateForServer() => DateFormat('yyyy-MM-dd').format(this);

  String getFormattedDateTimeForServer() =>
      DateFormat('yyyy-MM-dd HH:mm').format(this);

  String getHourMinute() {
    return DateFormat('HH:mm').format(this);
  }

  String getDayMonthDateTime() {
    return DateFormat('dd/MM').format(this);
  }

  bool isBetween(DateTime from, DateTime to) {
    from = from.add(const Duration(seconds: 1));
    return compareTo(from) == 0 ||
        compareTo(to) == 0 ||
        (isAfter(from) && isBefore(to));
  }

  List<DateTime> getAllDateInWeek() {
    final DateTime dateNow = this;
    final DateTime startFrom =
        dateNow.subtract(Duration(days: dateNow.weekday - 1));
    final List<DateTime> dateTimes = [];

    for (int i = 0; i < 7; i++) {
      final int day = startFrom.add(Duration(days: i)).day;
      final int month = startFrom.add(Duration(days: i)).month;
      dateTimes.add(DateTime(dateNow.year, month, day));
    }

    return dateTimes;
  }

  bool leapYear(int year) {
    bool leapYear = false;
    final bool leap = (year % 100 == 0) && (year % 400 != 0);
    if (leap == true) {
      leapYear = false;
    } else if (year % 4 == 0) {
      leapYear = true;
    }
    return leapYear;
  }
}

extension StringT on String {
  String get hardcode => this;

  String get fixedCode => this;

  bool get isNumber => double.tryParse(this) != null;

  String getOnlyFirstLettersOfSentence() {
    final firstLetters = <String>[];
    if (isEmpty) return '';
    final words = split(' ');
    for (final String word in words) {
      if (word.isNotEmpty) {
        firstLetters.add(word.substring(0, 1));
      }
    }

    return firstLetters.join().toUpperCase();
  }
}
