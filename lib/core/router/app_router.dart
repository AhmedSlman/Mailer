import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emails_sender/features/email_input/presentation/view/email_input_screen.dart';
import 'package:emails_sender/features/template_management/presentation/view/template_screen.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';
import 'package:emails_sender/features/email_input/presentation/cubit/email_input_cubit.dart';
import 'package:emails_sender/core/di/injection_container.dart';

class AppRouter {
  static const String home = '/';
  static const String templates = '/templates';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<TemplateCubit>()..loadTemplates(),
            ),
            BlocProvider(
              create: (context) => sl<EmailInputCubit>(),
            ),
          ],
          child: Scaffold(
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _calculateSelectedIndex(state.uri.path),
              onTap: (index) => _onItemTapped(index, context),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.email),
                  label: 'Emails',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.description),
                  label: 'Templates',
                ),
              ],
            ),
          ),
        ),
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            builder: (context, state) => const EmailInputScreen(),
          ),
          GoRoute(
            path: templates,
            name: 'templates',
            builder: (context, state) => const TemplateScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );

  static int _calculateSelectedIndex(String path) {
    if (path.startsWith(templates)) {
      return 1;
    }
    return 0;
  }

  static void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(home);
        break;
      case 1:
        context.go(templates);
        break;
    }
  }
}
 