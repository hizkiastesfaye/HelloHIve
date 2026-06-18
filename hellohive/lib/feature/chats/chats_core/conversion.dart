import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeConverter {
  /// DateTime -> String
  static String dateTimeToString(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  /// String -> DateTime
  static DateTime stringToDateTime(String value) {
    return DateTime.parse(value);
  }

  /// Firestore Timestamp -> DateTime
  static DateTime timestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  /// DateTime -> Firestore Timestamp
  static Timestamp dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
}