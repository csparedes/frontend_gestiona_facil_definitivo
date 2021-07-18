import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsProvider {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream =
      new StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    // print('Desde el backgorund: ${message.messageId}');
    _messageStream.add(message.data['texto'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // print('Desde el mensaje: ${message.messageId}');
    _messageStream.add(message.data['texto'] ?? 'No data');
  }

  static Future _onOpenAppMessageHandler(RemoteMessage message) async {
    // print('Desde la App abierta: ${message.messageId}');
    _messageStream.add(message.data['texto'] ?? 'No data');
  }

  static Future initializeApp() async {
    //Push notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    dotenv.env['FIREBASE_TOKEN'] = token.toString();
    print('token firebase: ' + token.toString());
    // final _url = '${dotenv.env['BASE_URL']}/api/notificaciones/agregarToken';
    // final consulta = await http.post(Uri.parse(_url), body: {"token": token});
    // final cons = jsonDecode(consulta.body);
    // print('consulta de backend notificaciones: $cons');

    //handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpenAppMessageHandler);
  }

  static closeStreams() {
    _messageStream.close();
  }
}
