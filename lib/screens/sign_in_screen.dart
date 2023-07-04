import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste/routes/route_paths.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> login() async {
    String email = emailController.text;
    String password = passwordController.text;

    setState(() {
      isLoading = true;
    });

    try {
      final user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Usuário Autenticado"),
        duration: Duration(seconds: 2),
      ));
      emailController.clear();
      passwordController.clear();
      Navigator.of(context).pushNamed(RoutePaths.MOVIELIST);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Usuário não Autenticado. ${e}"),
        duration: Duration(seconds: 2),
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centraliza verticalmente
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centraliza horizontalmente
            children: [
              Image.asset('lib/assets/Bora2.png'),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "E-mail"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Senha"),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => {login()},
                      child: Text("Login"),
                    ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RoutePaths.REGISTER);
                  },
                  child: Text('Cadastre-se'))
            ],
          ),
        ),
      ),
    );
  }
}
