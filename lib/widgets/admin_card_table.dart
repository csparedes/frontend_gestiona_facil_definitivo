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
            color: Colors.green,
            icon: Icons.inventory_2_outlined,
            text: 'Productos',
            onTap: () => Navigator.pushNamed(context, 'homeProductos'),
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
            color: Colors.red,
            icon: Icons.verified_outlined,
            text: 'Kardex',
            onTap: () => Navigator.pushNamed(context, 'homeKardex'),
          ),
          _SigleCard(
            color: Colors.black,
            icon: Icons.perm_identity_outlined,
            text: 'Usuarios\nClientes',
            onTap: () {
              Navigator.pushNamed(context, 'homePersonas');
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
  final Color colorText;
  final String text;
  final onTap;

  const _SigleCard({
    Key? key,
    required this.icon,
    required this.color,
    this.colorText = Colors.white,
    required this.text,
    required this.onTap,
  }) : super(key: key);

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
            style: TextStyle(
              color: this.colorText,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
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

class CardTableKardex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          _SigleCard(
            color: Colors.teal,
            icon: Icons.precision_manufacturing_outlined,
            text: 'Perchar',
            onTap: () => Navigator.pushNamed(context, 'perchas'),
          ),
        ]),
        TableRow(children: [
          _SigleCard(
            color: Colors.lime,
            icon: Icons.schedule_outlined,
            text: 'Existencias',
            onTap: () => Navigator.pushNamed(context, 'existencias'),
          ),
        ]),
        TableRow(children: [
          _SigleCard(
            color: Colors.orangeAccent,
            icon: Icons.shopping_bag_outlined,
            text: 'Ingresos',
            onTap: () => Navigator.pushNamed(context, 'ingresos'),
          ),
        ]),
        TableRow(children: [
          _SigleCard(
            color: Colors.lightBlue,
            icon: Icons.store_mall_directory,
            text: 'Salidas',
            onTap: () => Navigator.pushNamed(context, 'salidas'),
          ),
        ])
      ],
    );
  }
}

class CardTablePersonas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          _SigleCard(
            color: Colors.teal,
            icon: Icons.person_pin_outlined,
            text: 'Proveedores',
            onTap: () => Navigator.pushNamed(context, 'proveedores'),
          ),
        ]),
        TableRow(children: [
          _SigleCard(
            color: Colors.red,
            icon: Icons.group_outlined,
            text: 'Clientes',
            onTap: () => Navigator.pushNamed(context, 'clientes'),
          ),
        ]),
        TableRow(children: [
          _SigleCard(
            color: Colors.black,
            icon: Icons.perm_identity_outlined,
            text: 'Usuarios',
            onTap: () {
              Navigator.pushNamed(context, 'usuarios');
            },
          ),
        ])
      ],
    );
  }
}

class CardTableProductos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          _SigleCard(
            color: Colors.black,
            icon: Icons.done,
            text: 'Realizar Pedido',
            onTap: () => Navigator.pushNamed(context, 'realizarPedido'),
          ),
        ]),
        TableRow(children: [
          _SigleCard(
            color: Colors.indigoAccent,
            icon: Icons.drag_indicator_outlined,
            text: 'Lista Productos',
            onTap: () => Navigator.pushNamed(context, 'productos'),
          ),
        ]),
        TableRow(children: [
          _SigleCard(
            color: Colors.green,
            icon: Icons.category_outlined,
            text: 'Categorias',
            onTap: () => Navigator.pushNamed(context, 'categorias'),
          ),
        ])
      ],
    );
  }
}
