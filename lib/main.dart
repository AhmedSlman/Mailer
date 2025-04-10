import 'package:flutter/material.dart';
import 'package:emails_sender/core/di/injection_container.dart';
import 'package:emails_sender/core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Email Sender',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
