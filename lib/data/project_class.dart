class Project {
  final String id;
  final String name;
  final String type;
  final String area;
  final String state;
  final String city;
  final String description;
  final int totalFlats;
  final int bookedFlats;
  final int availableFlats;
  final int blockedFlats;
  final int heldFlats;

  Project({
    required this.id,
    required this.name,
    required this.type,
    required this.area,
    required this.state,
    required this.city,
    required this.description,
    required this.totalFlats,
    required this.bookedFlats,
    required this.availableFlats,
    required this.blockedFlats,
    required this.heldFlats,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      area: json['address'],
      city: json['city'],
      state: json['state'],
      description: json['description'],
      totalFlats: json['totalFlats'],
      bookedFlats: json['bookedFlats'],
      availableFlats: json['availableFlats'],
      blockedFlats: json['blockedFlats'],
      heldFlats: json['holdFlats'],
    );
  }
}
