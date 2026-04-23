class Room {
  final String id;
  final String name;
  final String creatorId;
  final int participantCount;
  final bool isActive;

  Room({
    required this.id,
    required this.name,
    required this.creatorId,
    required this.participantCount,
    required this.isActive,
  });

  factory Room.fromFirestore(String id, Map<String, dynamic> data) {
    return Room(
      id: id,
      name: data['name'] ?? '',
      creatorId: data['creatorId'] ?? '',
      participantCount: data['participantCount'] ?? 0,
      isActive: data['isActive'] ?? true,
    );
  }
}
