import 'dart:core';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gestionafacil_v3/providers/login.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();
    return Scaffold(
      body: Center(
        child: _pagina(context, email, password),
      ),
    );
  }
}

Stack _pagina(BuildContext context, TextEditingController email,
    TextEditingController password) {
  return Stack(
    children: [
      _crearFondo(context),
      _loginForm(context, email, password),
    ],
  );
}

Widget _crearFondo(BuildContext context) {
  final size = MediaQuery.of(context).size;

  final fondoModaro = Container(
    height: size.height * 0.4,
    width: double.infinity,
    decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
      Color.fromRGBO(63, 63, 156, 1.0),
      Color.fromRGBO(90, 70, 178, 1.0)
    ])),
  );

  final circulo = Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)),
  );

  return Stack(
    children: <Widget>[
      fondoModaro,
      Positioned(top: 90.0, left: 30.0, child: circulo),
      Positioned(top: -40.0, right: -30.0, child: circulo),
      Positioned(bottom: -50.0, right: -10.0, child: circulo),
      Positioned(bottom: 120.0, right: 20.0, child: circulo),
      Positioned(bottom: -50.0, left: -20.0, child: circulo),
      Container(
        padding: EdgeInsets.only(top: 80.0),
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage('assets/logo-blanco.png'),
              height: 110,
            ),
            SizedBox(height: 28.0, width: double.infinity),
            DefaultTextStyle(
              style: TextStyle(color: Colors.white, fontSize: 25),
              child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText('Gestiona Fácil'),
                ],
                repeatForever: true,
              ),
            ),
            // Text('Gestiona Fácil',
            //     style: TextStyle(color: Colors.white, fontSize: 25.0))
          ],
        ),
      )
    ],
  );
}

Widget _loginForm(BuildContext context, TextEditingController email,
    TextEditingController password) {
  final size = MediaQuery.of(context).size;
  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        SafeArea(
          child: Container(
            height: 200.0,
          ),
        ),
        Container(
          width: size.width * 0.85,
          margin: EdgeInsets.symmetric(vertical: 30.0),
          padding: EdgeInsets.symmetric(vertical: 50.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0)
              ]),
          child: Column(
            children: <Widget>[
              Text('Ingreso', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 60.0),
              _crearEmail(email),
              SizedBox(height: 30.0),
              _crearPassword(password),
              SizedBox(height: 30.0),
              _crearBoton(context, email, password)
            ],
          ),
        ),
        TextButton(
          child: Text('Contacto con la administración',
              style: TextStyle(
                color: Colors.deepPurple,
              )),
          onPressed: () =>
              AlertDialogContactoAdministracionWidget.showAlertDialog(context),
        ),
        SizedBox(height: 100.0)
      ],
    ),
  );
}

Widget _crearEmail(TextEditingController email) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    child: TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        icon: Icon(
          Icons.alternate_email,
          color: Colors.deepPurple,
        ),
        hintText: 'ejemplo@correo.com',
        labelText: 'Correo electrónico',
        labelStyle: TextStyle(color: Colors.deepPurple),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      cursorColor: Colors.deepPurple,
      controller: email,
    ),
  );
}

Widget _crearPassword(TextEditingController password) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    child: TextField(
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
        labelText: 'Contraseña',
        labelStyle: TextStyle(color: Colors.deepPurple),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      cursorColor: Colors.deepPurple,
      controller: password,
    ),
  );
}

Widget _crearBoton(BuildContext context, TextEditingController email,
    TextEditingController password) {
  return CupertinoButton(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
      child: Text(
        'Ingresar',
        // style: TextStyle(color: Colors.deepPurple, fontSize: 20),
      ),
      // color: Colors.deepPurple,
    ),
    onPressed: () => _login(context, email, password),
    color: Colors.deepPurple,
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
  );
}

_login(BuildContext context, TextEditingController email,
    TextEditingController password) async {
  //Aqui se envía los datos
  // final loginProvider = Provider.of<LoginProvider>(context, listen: false);
  final loginProvider = new LoginProvider();
  Map<String, String> data = {
    'email': email.text,
    'password': password.text,
  };
  final Map<String, dynamic> respuesta = await loginProvider.login(data);
  if (respuesta['ok']) {
    dotenv.env['USER_ROL'] = respuesta['usuario']['roleId'].toString();
    dotenv.env['TOKEN'] = respuesta['token'];

    Navigator.popAndPushNamed(context, 'home');
  } else {
    email.clear();
    password.clear();
    AlertDialogLoginWidget.showAlertDialog(context);
  }
}
