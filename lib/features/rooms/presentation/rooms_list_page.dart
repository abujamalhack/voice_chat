import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../auth/presentation/auth_provider.dart';
import '../data/room_repository.dart';
import 'room_page.dart';

class RoomsListPage extends StatelessWidget {
  const RoomsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = RoomRepository();
    return Scaffold(
      appBar: AppBar(
        title: const Text("الغرف المباشرة"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, repo),
        icon: const Icon(Icons.add),
        label: const Text("إنشاء غرفة"),
      ),
      body: StreamBuilder<List<Room>>(
        stream: repo.getRoomsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("لا توجد غرف نشطة"));
          }
          final rooms = snapshot.data!;
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(room.name),
                  subtitle: Text("المشاركون: ${room.participantCount}"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoomPage(room: room),
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms).slideX();
            },
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, RoomRepository repo) {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("غرفة جديدة"),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(hintText: "اسم الغرفة"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () {
              final user = context.read<AuthProvider>().user!;
              repo.createRoom(nameCtrl.text, user.id);
              Navigator.pop(ctx);
            },
            child: const Text("إنشاء"),
          ),
        ],
      ),
    );
  }
}
