class FlatItem {
  final String id;
  final String flatNumber;
  final String flatStatus;
  final String floorId;
  final int floorNumber;

  FlatItem({
    required this.id,
    required this.flatNumber,
    required this.flatStatus,
    required this.floorId,
    required this.floorNumber,
  });
}

class FloorData {
  final String id;
  final int floorNumber;
  final List<FlatItem> createdFlats;

  FloorData({
    required this.id,
    required this.floorNumber,
    required this.createdFlats,
  });
}