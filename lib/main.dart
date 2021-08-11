import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gestionafacil_v3/pages/home_kardex.dart';
import 'package:gestionafacil_v3/pages/home_personas.dart';
import 'package:gestionafacil_v3/pages/home_productos.dart';
import 'package:gestionafacil_v3/pages/perchaNueva.dart';
import 'package:gestionafacil_v3/pages/perchar.dart';
import 'package:gestionafacil_v3/pages/producto_codigo_generar.dart';
import 'package:gestionafacil_v3/providers/perchar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:gestionafacil_v3/pages/categoria_nueva.dart';
import 'package:gestionafacil_v3/pages/categorias.dart';
import 'package:gestionafacil_v3/pages/cliente_nuevo.dart';
import 'package:gestionafacil_v3/pages/clientes.dart';
import 'package:gestionafacil_v3/pages/compras.dart';
import 'package:gestionafacil_v3/pages/compras_comentario.dart';
import 'package:gestionafacil_v3/pages/consumos_donaciones.dart';
import 'package:gestionafacil_v3/pages/existencias.dart';
import 'package:gestionafacil_v3/pages/home.dart';
import 'package:gestionafacil_v3/pages/ingresos.dart';
import 'package:gestionafacil_v3/pages/listaPedidos.dart';
import 'package:gestionafacil_v3/pages/listaPedidos_detalle.dart';
import 'package:gestionafacil_v3/pages/login.dart';
import 'package:gestionafacil_v3/pages/producto_nuevo.dart';
import 'package:gestionafacil_v3/pages/productos.dart';
import 'package:gestionafacil_v3/pages/proveedores.dart';
import 'package:gestionafacil_v3/pages/proveedor_nuevo.dart';
import 'package:gestionafacil_v3/pages/realizarPedido.dart';
import 'package:gestionafacil_v3/pages/salidas.dart';
import 'package:gestionafacil_v3/pages/usuario_nuevo.dart';
import 'package:gestionafacil_v3/pages/usuarios.dart';
import 'package:gestionafacil_v3/pages/venta_comentario.dart';
import 'package:gestionafacil_v3/pages/ventas.dart';
import 'package:gestionafacil_v3/providers/categoria.dart';
import 'package:gestionafacil_v3/providers/cliente.dart';
import 'package:gestionafacil_v3/providers/compras.dart';
import 'package:gestionafacil_v3/providers/kardex_existencias.dart';
import 'package:gestionafacil_v3/providers/kardex_ingresos.dart';
import 'package:gestionafacil_v3/providers/kardex_salida.dart';
import 'package:gestionafacil_v3/providers/login.dart';
import 'package:gestionafacil_v3/providers/pedidos.dart';
import 'package:gestionafacil_v3/providers/productos.dart';
import 'package:gestionafacil_v3/providers/proveedor.dart';
import 'package:gestionafacil_v3/providers/push_notifications.dart';
import 'package:gestionafacil_v3/providers/usuarios.dart';
import 'package:gestionafacil_v3/providers/ventas.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationsProvider.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    PushNotificationsProvider.messagesStream.listen((message) {
      final snackBar = SnackBar(
        elevation: 35,
        content: Text(
          '$message',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        duration: Duration(
          milliseconds: 5000,
        ),
      );
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }

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
        ChangeNotifierProvider(create: (_) => CategoriaProvider()),
        ChangeNotifierProvider(create: (_) => PedidosProvider()),
        ChangeNotifierProvider(create: (_) => PercharProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: messengerKey,
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
          'realizarPedido': (_) => RealizarPedidoPage(),
          'consumosDonaciones': (_) => ConsumosDonacionesPage(),
          'categorias': (_) => CategoriasPage(),
          'categoriaNueva': (_) => CategoriaNuevaPage(),
          'listaPedidos': (_) => ListaPedidosPage(),
          'detallePedido': (_) => DetallePedidoPage(),
          'generarCodigo': (_) => GenerarCodigoPage(),
          'perchas': (_) => PercharPage(),
          'percharNueva': (_) => PerchaNuevaPage(),
          'homeKardex': (_) => HomeKardexPage(),
          'homePersonas': (_) => HomePersonasPage(),
          'homeProductos': (_) => HomeProductosPage()
        },
        theme: ThemeData(
          textTheme: GoogleFonts.nanumGothicTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
      ),
    );
  }
}
