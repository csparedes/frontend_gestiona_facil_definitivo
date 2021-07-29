import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gestionafacil_v3/widgets/admin_card_table.dart';
import 'package:gestionafacil_v3/widgets/worker_card_table.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rol = dotenv.env["USER_ROL"];
    if (rol == '1') {
      //Admin
      return adminView(context);
    } else {
      //Worker
      return workerView(context);
    }
  }

  Scaffold adminView(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Admin Dashboard'),
        border: Border(bottom: BorderSide(width: 1)),
        trailing: CupertinoButton(
            child: Text(
              'Salir',
              style: TextStyle(
                fontSize: 13,
                color: Colors.deepPurple,
              ),
            ),
            onPressed: () {
              dotenv.env['USER_ROL'] = "";
              dotenv.env['TOKEN'] = "";
              Navigator.popAndPushNamed(context, 'login');
            }),
      ),
      body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: bodyAdmin(context)),
    );
  }

  Widget bodyAdmin(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.all(5),
      color: Colors.deepPurple[200],
      child: SingleChildScrollView(
        child: Column(
          children: [
            CardTableAdmin(),
          ],
        ),
      ),
    );
  }

  Scaffold workerView(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Worker Dashboard'),
        border: Border(bottom: BorderSide(width: 1)),
        trailing: CupertinoButton(
            child: Text(
              'Salir',
              style: TextStyle(
                fontSize: 13,
                color: Colors.deepPurple,
              ),
            ),
            onPressed: () {
              dotenv.env['USER_ROL'] = "";
              dotenv.env['TOKEN'] = "";
              Navigator.popAndPushNamed(context, 'login');
            }),
      ),
      body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: bodyWorker(context)),
    );
  }

  Widget bodyWorker(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.all(5),
      color: Colors.deepPurple[200],
      child: SingleChildScrollView(
        child: Column(
          children: [
            WorkerTableAdmin(),
          ],
        ),
      ),
    );
  }
}
