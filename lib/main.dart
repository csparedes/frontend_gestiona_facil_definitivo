import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gestionafacil_v3/pages/cliente_nuevo.dart';
import 'package:gestionafacil_v3/pages/clientes.dart';
import 'package:gestionafacil_v3/pages/compras.dart';
import 'package:gestionafacil_v3/pages/compras_comentario.dart';
import 'package:gestionafacil_v3/pages/existencias.dart';
import 'package:gestionafacil_v3/pages/home.dart';
import 'package:gestionafacil_v3/pages/ingresos.dart';
import 'package:gestionafacil_v3/pages/login.dart';
import 'package:gestionafacil_v3/pages/producto_nuevo.dart';
import 'package:gestionafacil_v3/pages/productos.dart';
import 'package:gestionafacil_v3/pages/proveedores.dart';
import 'package:gestionafacil_v3/pages/proveedor_nuevo.dart';
import 'package:gestionafacil_v3/pages/salidas.dart';
import 'package:gestionafacil_v3/pages/usuario_nuevo.dart';
import 'package:gestionafacil_v3/pages/usuarios.dart';
import 'package:gestionafacil_v3/pages/venta_comentario.dart';
import 'package:gestionafacil_v3/pages/ventas.dart';
import 'package:gestionafacil_v3/providers/cliente.dart';
import 'package:gestionafacil_v3/providers/compras.dart';
import 'package:gestionafacil_v3/providers/kardex_existencias.dart';
import 'package:gestionafacil_v3/providers/kardex_ingresos.dart';
import 'package:gestionafacil_v3/providers/kardex_salida.dart';
import 'package:gestionafacil_v3/providers/login.dart';
import 'package:gestionafacil_v3/providers/productos.dart';
import 'package:gestionafacil_v3/providers/proveedor.dart';
import 'package:gestionafacil_v3/providers/usuarios.dart';
import 'package:gestionafacil_v3/providers/ventas.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => UsuariosProvider()),
        ChangeNotifierProvider(create: (_) => ProductosProvider()),
        ChangeNotifierProvider(create: (_) => KardexExistenciasProvider()),
        ChangeNotifierProvider(create: (_) => KardexIngresosProvider()),
        ChangeNotifierProvider(create: (_) => KardexSalidaProvider()),
        ChangeNotifierProvider(create: (_) => ClienteProvider()),
        ChangeNotifierProvider(create: (_) => ProveedorProvider()),
        ChangeNotifierProvider(create: (_) => VentasProvider()),
        ChangeNotifierProvider(create: (_) => ComprasProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': (_) => LoginPage(),
          'home': (_) => HomePage(),
          'usuarios': (_) => UsuariosPage(),
          'usuarioNuevo': (_) => UsuarioNuevoPage(),
          'productos': (_) => ProductosPage(),
          'productoNuevo': (_) => ProductoNuevoPage(),
          'existencias': (_) => ExistenciasPage(),
          'ingresos': (_) => IngresosPage(),
          'salidas': (_) => SalidasPage(),
          'clientes': (_) => ClientesPage(),
          'clienteNuevo': (_) => ClienteNuevoPage(),
          'proveedores': (_) => ProveedoresPage(),
          'proveedorNuevo': (_) => ProveedorNuevoPage(),
          'ventas': (_) => VentasPage(),
          'ventasComentario': (_) => VentaComentarioPage(),
          'compras': (_) => ComprasPage(),
          'comprasComentario': (_) => ComprasComentarioPage(),
        },
        // theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}
