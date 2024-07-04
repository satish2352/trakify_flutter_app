class HistoryItem {
  final String oldState;
  final String newState;
  final String updatedBy;
  final String updatedOn;
  final String comment;

  HistoryItem({
    required this.oldState,
    required this.newState,
    required this.updatedBy,
    required this.updatedOn,
    required this.comment,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      oldState: json['oldState'],
      newState: json['newState'],
      updatedBy: json['updatedBy'],
      comment: json['comment'],
      updatedOn: json['updatedOn'],
    );
  }
}
