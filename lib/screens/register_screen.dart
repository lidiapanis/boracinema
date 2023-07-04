import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste/screens/sign_in_screen.dart';

import '../routes/route_paths.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> register() async {
    String email = emailController.text;
    String password = passwordController.text;

    setState(() {
      isLoading = true;
    });

    try {
      auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Usuário Já Cadastrado"),
        duration: Duration(seconds: 5),
      ));
      Navigator.of(context).pushNamed(RoutePaths.SIGNINSCREEN);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Usuário Cadastrado, realize login"),
        duration: Duration(seconds: 10),
      ));
      Navigator.of(context).pushNamed(RoutePaths.SIGNINSCREEN);
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
              Text('Cadastre-se abaixo:'),
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
                      onPressed: () => {register()},
                      child: Text("Cadastrar"),
                    ),
              ElevatedButton(
                onPressed: () => {
                  emailController.clear(),
                  passwordController.clear(),
                  Navigator.pop(context)
                },
                child: Text("Voltar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
