// import 'package:emails_sender/firebase_options.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

// import 'package:emails_sender/core/di/injection_container.dart';
// import 'package:emails_sender/core/router/app_router.dart';
// import 'package:emails_sender/core/theme/app_theme.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await init();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Emails Sender',
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       themeMode: ThemeMode.dark,
//       routerConfig: AppRouter.router,
//     );
//   }
// }

import 'package:emails_sender/features/auth/data/remote/auth_remote_ds.dart';
import 'package:emails_sender/features/auth/data/remote/email_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyEmailApp());
}

class MyEmailApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gmail Sender',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthServiceImpl();
  final EmailService _emailService = EmailService();
  String? _userEmail;
  String? _accessToken;
  bool _isLoggedIn = false;
  bool _isSending = false;

  final TextEditingController _toController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  Future<void> _signIn() async {
    try {
      final result = await _authService.signIn();
      setState(() {
        _userEmail = result['email'];
        _accessToken = result['accessToken'];
        _isLoggedIn = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signed in as $_userEmail')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      setState(() {
        _userEmail = null;
        _accessToken = null;
        _isLoggedIn = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signed out')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _sendEmail() async {
    if (_accessToken == null || _userEmail == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please sign in first')));
      return;
    }

    final to = _toController.text.trim();
    if (!_isValidEmail(to)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    setState(() => _isSending = true);
    try {
      await _emailService.sendEmail(
        accessToken: _accessToken!,
        from: _userEmail!,
        to: to,
        subject: _subjectController.text.trim(),
        body: _bodyController.text.trim(),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email sent successfully')));
      _toController.clear();
      _subjectController.clear();
      _bodyController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      setState(() => _isSending = false);
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Email'),
        actions: [
          if (_isLoggedIn)
            IconButton(icon: Icon(Icons.logout), onPressed: _signOut),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:
            _isLoggedIn
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Signed in as: $_userEmail',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _toController,
                      decoration: InputDecoration(
                        labelText: 'To',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _bodyController,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _isSending ? null : _sendEmail,
                        child:
                            _isSending
                                ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text('Send Email'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : Center(
                  child: ElevatedButton(
                    onPressed: _signIn,
                    child: Text('Sign in with Google'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
      ),
    );
  }

  @override
  void dispose() {
    _toController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
