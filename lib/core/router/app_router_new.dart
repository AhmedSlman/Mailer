import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emails_sender/features/auth/presentation/screens/login_screen.dart';
import 'package:emails_sender/features/email_input/presentation/view/email_input_screen.dart';
import 'package:emails_sender/features/template_management/presentation/view/template_screen.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';
import 'package:emails_sender/features/email_input/presentation/cubit/email_input_cubit.dart';
import 'package:emails_sender/features/mailer/presentation/screens/send_emails_screen.dart';
import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:emails_sender/core/di/injection_container.dart';
import 'package:emails_sender/features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String home = '/';
  static const String templates = '/templates';
  static const String login = '/login';
  static const String sendEmails = '/send-emails';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    redirect: (context, state) {
      final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final bool isLoginRoute = state.uri.path == login;
      final bool isSplashRoute = state.uri.path == splash;

      // If on splash screen, let it handle the navigation
      if (isSplashRoute) {
        return null;
      }

      // If not logged in and trying to access protected routes, redirect to login
      if (!isLoggedIn && !isLoginRoute) {
        return login;
      }

      // If logged in and on login route, redirect to home
      if (isLoggedIn && isLoginRoute) {
        return home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => LoginScreen(),
      ),
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
          GoRoute(
            path: sendEmails,
            name: 'send-emails',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              return SendEmailsScreen(
                selectedEmails: extra['selectedEmails'] as List<String>,
                templates: extra['templates'] as List<Template>,
              );
            },
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