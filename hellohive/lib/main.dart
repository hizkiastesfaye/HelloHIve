import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hellohive/feature/auth/presentation/pages/auth_verify_page.dart';
import 'package:hellohive/feature/auth/presentation/pages/forgot_password_page.dart';
import 'package:hellohive/feature/auth/presentation/pages/sign_in_page.dart';
import 'package:hellohive/feature/auth/presentation/pages/sign_up_page.dart';
import 'package:hellohive/home_page.dart';
import 'package:hellohive/feature/settings/presentation/pages/userProfile_pages.dart';
import 'feature/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'feature/settings/presentation/bloc/user_profile_bloc_bloc.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await di.init();
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
        BlocProvider(create:(context) => di.sl<UserProfileBlocBloc>())
      ],
      child: MaterialApp(
        // title: 'Hello Hive',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            scrolledUnderElevation: 0,
            color: Colors.white,
          ),
          primaryColor: Colors.white,
          secondaryHeaderColor: Color(0xFF0A5CAA),
          
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              fontSize: 32,
              color: Color(0xFF3182CE),
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: TextStyle(fontSize: 24, color: Color(0xFF454545)),
            titleLarge: TextStyle(fontSize: 20, color: Color(0xFF454545)),
            titleSmall: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF454545)),
            bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF454545)),
            bodySmall: TextStyle(fontSize: 12, color: Color(0xFF929292)),
            labelLarge: TextStyle(fontSize: 10, color: Color(0xFF929292)),
            labelMedium: TextStyle(fontSize: 8, color: Color(0xFF929292)),
            labelSmall: TextStyle(fontSize: 6, color: Color(0xFF929292)),
          ),
        ),
        initialRoute: '/signin',
        routes: {
          '/': (context) => const HomePage(),
          '/oldLogin': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/signin': (context) => const SignInPage(),
          '/verify':(context){
            final email = ModalRoute.of(context)!.settings.arguments as String;
            return AuthVerifyPage(email:email);
            },
          '/resetPassword' :(context)=> const ForgotPasswordPage(),
          '/userProfile':(context) => UserProfilePage(),
        },
      ),
    );
  }
}
