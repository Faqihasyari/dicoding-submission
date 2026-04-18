class MeetingModel {
  final String? id;
  final String title;
  final DateTime date;
  final String rawTranscript;
  final String summary;

  MeetingModel(this.id, this.title, this.date, this.rawTranscript, this.summary);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'rawTranscipt': rawTranscript,
      'summary': summary
    };
  }
}

