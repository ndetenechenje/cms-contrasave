
class Reminder {
  final String title;
  final DateTime dateTime;

  Reminder({required this.title, required this.dateTime});
  
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'dateTime': dateTime.toIso8601String(), // Convert DateTime to a format that can be stored in the database
    };
  }
}

