import 'dart:ui';

import 'package:flutter/material.dart';

class CardTableAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          _SigleCard(
            color: Colors.blueAccent,
            icon: Icons.storefront,
            text: 'Compras',
            onTap: () => Navigator.pushNamed(context, 'compras'),
          ),
          _SigleCard(
            color: Colors.pinkAccent,
            icon: Icons.add_shopping_cart,
            text: 'Ventas',
            onTap: () => Navigator.pushNamed(context, 'ventas'),
          ),
        ]),
        TableRow(children: [
          _SigleCard(
            color: Colors.black,
            icon: Icons.done,
            text: 'Realizar Pedido',
            onTap: () => Navigator.pushNamed(context, 'realizarPedido'),
          ),
          _SigleCard(
            color: Colors.orange,
            icon: Icons.swap_horiz,
            text: 'Consumos\nDonaciones',
            onTap: () => Navigator.pushNamed(context, 'consumosDonaciones'),
          ),
        ]),
        TableRow(children: [
          _SigleCard(
            color: Colors.yellowAccent,
            icon: Icons.drag_indicator_outlined,
            text: 'Lista Productos',
            onTap: () => Navigator.pushNamed(context, 'productos'),
          ),
          _SigleCard(
            color: Colors.green,
            icon: Icons.category_outlined,
            text: 'Categorias',
            onTap: () => Navigator.pushNamed(context, 'categorias'),
          ),
        ]),
        TableRow(children: [
          _SigleCard(
            color: Colors.teal,
            icon: Icons.person_pin_outlined,
            text: 'Proveedores',
            onTap: () => Navigator.pushNamed(context, 'proveedores'),
          ),
          _SigleCard(
            color: Colors.red,
            icon: Icons.group_outlined,
            text: 'Clientes',
            onTap: () => Navigator.pushNamed(context, 'clientes'),
          ),
        ]),
        TableRow(children: [
          _SigleCard(
            color: Colors.orangeAccent,
            icon: Icons.shopping_bag_outlined,
            text: 'Ingresos',
            onTap: () => Navigator.pushNamed(context, 'ingresos'),
          ),
          _SigleCard(
            color: Colors.lightBlue,
            icon: Icons.store_mall_directory,
            text: 'Salidas',
            onTap: () => Navigator.pushNamed(context, 'salidas'),
          ),
        ]),
        TableRow(children: [
          _SigleCard(
            color: Colors.lime,
            icon: Icons.schedule_outlined,
            text: 'Existencias',
            onTap: () => Navigator.pushNamed(context, 'existencias'),
          ),
          _SigleCard(
            color: Colors.black,
            icon: Icons.perm_identity_outlined,
            text: 'Usuarios',
            onTap: () {
              Navigator.pushNamed(context, 'usuarios');
            },
          ),
        ]),
      ],
    );
  }
}

class _SigleCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final onTap;

  const _SigleCard(
      {Key? key,
      required this.icon,
      required this.color,
      required this.text,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _CardBackground(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: this.color,
            child: Icon(
              this.icon,
              size: 35,
              color: Colors.white,
            ),
            radius: 30,
          ),
          SizedBox(height: 10),
          Text(
            this.text,
            style: TextStyle(color: this.color, fontSize: 18),
          )
        ],
      )),
    );
  }
}

class _CardBackground extends StatelessWidget {
  final Widget child;

  const _CardBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
                color: Color.fromRGBO(62, 66, 107, 0.7),
                borderRadius: BorderRadius.circular(20)),
            child: this.child,
          ),
        ),
      ),
    );
  }
}
