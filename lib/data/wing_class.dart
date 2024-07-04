class Wing {
  final String id;
  final String name;
  final int floor;
  final int bookedFlats = 2;
  final int blockedFlats = 2;
  final int holdFlats = 2;
  final int availableFlats = 2;

  Wing({required this.id, required this.name, required this.floor});

  factory Wing.fromJson(Map<String, dynamic> json) {
    return Wing(
      id: json['_id'],
      name: json['wingName'],
      floor: json['numberOfFloors'],
    );
  }
}