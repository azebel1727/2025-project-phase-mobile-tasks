import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void _signUp() {
    context.read<AuthBloc>().add(
      SignUpRequested(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      ),
    );
    print("name: {$nameController.text}");
    print("email: {$emailController.text}");
    print("name: {$passwordController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
        // Navigate or show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up successful!')),
        );
        Navigator.pushReplacementNamed(context, '/chat');
          } else if (state is AuthError) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.blue,
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              "ECOM",
              style: TextStyle(
            fontSize: 32,
            fontFamily: 'CaveatBrush',
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 4, 101, 181),
            backgroundColor: Colors.white,
              ),
            ),
          ],
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),
            const Text(
          "Create your account",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Name
            const Text(
          'Name',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'ex: Jon Smith',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
          ),
            ),
            const SizedBox(height: 20),

            // Email
            const Text(
          'Email',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'ex: jon.smith@email.com',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
          ),
            ),
            const SizedBox(height: 20),

            // Password
            const Text(
          'Password',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '********',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
          ),
            ),
            const SizedBox(height: 20),

            // Confirm Password
            const Text(
          'Confirm Password',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '********',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
          ),
            ),
            const SizedBox(height: 20),

            // Terms and Conditions
            Row(
          children: const [
            Icon(Icons.check_box_outline_blank),
            SizedBox(width: 8),
            Expanded(
              child: Text(
            "I understand the terms and policy",
            style: TextStyle(fontSize: 16),
              ),
            ),
          ],
            ),
            const SizedBox(height: 20),

            // Sign Up Button
            SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state is AuthLoading ? null : _signUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 11, 86, 147),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state is AuthLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : const Text(
                'Sign Up',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
          ),
            ),
            const SizedBox(height: 40),

            // Go to Sign In
            Center(
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, '/signin'),
            child: const Text("Have an account? Sign In"),
          ),
            ),
          ],
        ),
          );
        },
      ),
    );
    
  }
}
