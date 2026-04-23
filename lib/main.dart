import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/auth_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCJkTKfYtwfRZK1iMbuRITkyVLte9L0wEk",
      authDomain: "my-chat-app-fd7a5.firebaseapp.com",
      projectId: "my-chat-app-fd7a5",
      storageBucket: "my-chat-app-fd7a5.firebasestorage.app",
      messagingSenderId: "494751576132",
      appId: "1:494751576132:web:5cdfffa3fc726662180c11",
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}
