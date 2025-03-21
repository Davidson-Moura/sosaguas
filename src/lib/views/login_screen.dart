import 'package:flutter/material.dart';
import 'package:sos_aguas/views/register_screen.dart';

import '../controllers/authentication.dart';
import '../models/current_setting.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  late AnimationController _formController;
  late Animation<Offset> _formAnimation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _mostrarMensagem(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: Duration(seconds: 3), // Tempo de exibição
        backgroundColor: Colors.blue, // Cor do fundo
      ),
    );
  }

    Future<void> _login(BuildContext context) async {
      setState(() => _isLoading = true); // 🔥 Ativa o loading

      try {
        var user = await Authentication.login(
            _emailController.text, _passwordController.text);

        var stng = new CurrentSetting();
        stng.id = user.id;
        stng.name = user.name;
        stng.email = user.email;
        stng.password = user.password;

        await stng.Save();

        _replaceRouteToHome();

        _mostrarMensagem(context, "Logado com sucesso!");
      } catch (ex) {
        print(ex);
        _mostrarMensagem(context, ex.toString().replaceAll("Exception: ", ""));
      }

      setState(() => _isLoading = false);
    }
    void _replaceRouteToHome(){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    Future<void> _verifyUser() async{
      print("verificando se está logado.");
      var stng = new CurrentSetting();
      await stng.Fill();

      print(stng.id);
      if(stng.id != null && !stng.id.isEmpty){
        _replaceRouteToHome();
      }
    }

    @override
    void initState() {
      super.initState();

      _verifyUser();

      _logoController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
      );
      _logoAnimation =
          CurvedAnimation(parent: _logoController, curve: Curves.easeIn);
      _logoController.forward();

      _formController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
      );
      _formAnimation = Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset(0, 0),
      ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOut));

      Future.delayed(Duration(milliseconds: 500), () {
        _formController.forward();
      });
    }

    @override
    void dispose() {
      _logoController.dispose();
      _formController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.blue.shade50,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _logoAnimation,
                    child: Image.asset('assets/splash.png', width: 200),
                  ),
                  SizedBox(height: 20),

                  SlideTransition(
                    position: _formAnimation,
                    child: Column(
                      children: [
                        Text(
                            "Bem-vindo ao SOS Águas"
                        ),
                        SizedBox(height: 30),

                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "E-mail",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        SizedBox(height: 20),

                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Senha",
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        SizedBox(height: 20),

                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              _login(context);
                            },
                            child: _isLoading
                                ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                                : Text(
                              "Entrar",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text(
                            "Não tem uma conta? Cadastre-se",
                            style: TextStyle(
                                color: Colors.blue.shade700, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
