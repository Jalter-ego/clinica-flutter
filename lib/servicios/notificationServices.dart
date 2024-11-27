import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings darwinInitializationSettings =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  if (await Permission.notification.isDenied) {
    final status = await Permission.notification.request();
    if (status.isDenied) {
      print('Permiso para notificaciones denegado');
      return;
    }
  }
}

Future<void> mostrarNotificacion({
  required String titulo,
  required String cuerpo,
}) async {
  print("Intentando mostrar la notificación...");

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'channelId',
    'channelName',
    channelDescription: 'Descripción del canal',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    icon: '@mipmap/ic_launcher', // Ícono de la notificación
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  try {
    await flutterLocalNotificationsPlugin.show(
      0,
      titulo,
      cuerpo,
      notificationDetails,
    );
    print("Notificación mostrada correctamente");
  } catch (e) {
    print("Error al mostrar la notificación: $e");
  }
}
