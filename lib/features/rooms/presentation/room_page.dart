import 'package:flutter/material.dart';
import '../../../core/services/agora_stub.dart';
import '../data/room_repository.dart';
import '../domain/room.dart';

class RoomPage extends StatefulWidget {
  final Room room;
  const RoomPage({super.key, required this.room});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool isMuted = false;
  late RoomRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = RoomRepository();
    _repo.joinRoom(widget.room.id);
    AgoraStub.joinChannel(
      channelName: widget.room.id,
      uid: '0',
    );
  }

  @override
  void dispose() {
    _repo.leaveRoom(widget.room.id);
    AgoraStub.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.room.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isMuted ? Icons.mic_off : Icons.mic,
              size: 80,
              color: isMuted ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 24),
            Text(isMuted ? "الميكروفون مكتوم" : "أنت تتحدث..."),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () {
                setState(() => isMuted = !isMuted);
                AgoraStub.muteLocalAudio(isMuted);
              },
              icon: Icon(isMuted ? Icons.mic : Icons.mic_off),
              label: Text(isMuted ? "إلغاء الكتم" : "كتم الصوت"),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.exit_to_app),
              label: const Text("مغادرة الغرفة"),
            ),
          ],
        ),
      ),
    );
  }
}
