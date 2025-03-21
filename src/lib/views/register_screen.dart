import 'package:flutter/material.dart';
import 'package:sos_aguas/models/user.dart';
import 'package:sos_aguas/storages/user_storage.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _registerUser() {
    if (_formKey.currentState!.validate()) {

      var user = new User(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      var storage = UserStorage();
      storage.add(user);

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cadastrado com sucesso!'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Usuário")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) => value!.isEmpty ? "Informe o nome" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty ? "Informe o email" : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Senha"),
                obscureText: true,
                validator: (value) => value!.length < 6 ? "Senha deve ter pelo menos 6 caracteres" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text("Registrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
