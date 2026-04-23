import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/room.dart';

class RoomRepository {
  final _roomsRef = FirebaseFirestore.instance.collection('rooms');

  Stream<List<Room>> getRoomsStream() {
    return _roomsRef
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Room.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  Future<DocumentReference> createRoom(String name, String creatorId) {
    return _roomsRef.add({
      'name': name,
      'creatorId': creatorId,
      'participantCount': 0,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> joinRoom(String roomId) async {
    // زيادة عداد المشاركين
    await _roomsRef.doc(roomId).update({
      'participantCount': FieldValue.increment(1),
    });
  }

  Future<void> leaveRoom(String roomId) async {
    await _roomsRef.doc(roomId).update({
      'participantCount': FieldValue.increment(-1),
    });
  }
}
