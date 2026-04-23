import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? errorMsg;

  Future<void> _loginWithEmail() async {
    if (!formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    errorMsg = await auth.loginWithEmail(emailCtrl.text, passCtrl.text);
    if (errorMsg != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMsg!)));
    }
  }

  Future<void> _loginWithGoogle() async {
    final auth = context.read<AuthProvider>();
    errorMsg = await auth.loginWithGoogle();
    if (errorMsg != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMsg!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Voice Chat",
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                    validator: (v) =>
                        v!.isEmpty ? 'أدخل البريد الإلكتروني' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'كلمة المرور'),
                    validator: (v) =>
                        v!.isEmpty ? 'أدخل كلمة المرور' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loginWithEmail,
                    icon: const Icon(Icons.email),
                    label: const Text("تسجيل الدخول بالبريد"),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _loginWithGoogle,
                    icon: const Icon(Icons.login),
                    label: const Text("تسجيل الدخول بـ Google"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
