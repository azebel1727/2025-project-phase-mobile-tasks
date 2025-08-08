import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/sign_up_page.dart'; // <-- added this import
import 'features/auth/presentation/pages/splash_page.dart';
import 'injection_container.dart' as di;
import 'package:flutter_web_plugins/url_strategy.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //debugDefaultTargetPlatformOverride = null;
  await di.init(); // Setup dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(AppStarted()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashPage(), // Start with Splash Screen
        routes: {
          '/home': (_) => const HomePage(),
          '/signin': (_) => const SignInPage(),
          '/signup': (_) => const SignUpPage(), // <-- added signup route
        },
      ),
    );
  }
}
