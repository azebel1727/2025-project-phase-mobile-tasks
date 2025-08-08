import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is Unauthenticated || state is AuthError) {
            Navigator.pushReplacementNamed(context, '/signin');
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset('assets/background.png', fit: BoxFit.cover),

            // Color overlay
            Container(color: const Color.fromARGB(0, 133, 123, 236)),

            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "ECOM",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'CaveatBrush',
                    fontSize: 56,
                    color: Color.fromARGB(255, 34, 4, 109),
                    backgroundColor: Color.fromARGB(0, 197, 206, 210),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "ECOMMERCE App",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
