import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/widgets/admin_card_table.dart';

class HomeKardexPage extends StatelessWidget {
  const HomeKardexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return kardexView(context);
  }

  Scaffold kardexView(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(CupertinoIcons.arrow_left)),
        middle: Text('Kardex'),
        border: Border(bottom: BorderSide(width: 1)),
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
            CardTableKardex(),
          ],
        ),
      ),
    );
  }
}
