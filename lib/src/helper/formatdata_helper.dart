import 'package:cloud_firestore/cloud_firestore.dart';

String formatDayMonthYear(Timestamp timestamp) {
  //get DD/MM/YYYY
  DateTime dateTime = timestamp.toDate();

  //get DD
  String day = "";
  dateTime.day < 10 ? day = '0${dateTime.day}' : day = dateTime.day.toString();

  //get MM
  String month = "";
  dateTime.month < 10
      ? month = '0${dateTime.month}'
      : month = dateTime.month.toString();

  //get YYYY
  String year = dateTime.year.toString();

  //formatDayMonthYear
  String formatted = '$day/$month/$year';

  return formatted;
}
