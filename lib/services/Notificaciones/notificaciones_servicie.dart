import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    if (!kIsWeb) {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
      );

      // Inicializar zonas horarias antes de inicializar las notificaciones
      tz.initializeTimeZones();

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
          print('Notificación recibida: ${details.payload}');
        },
      );

      // Crear el canal de notificaciones para Android
      if (Platform.isAndroid) {
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'recordatorios_channel',
          'Recordatorios',
          description: 'Canal para recordatorios',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          enableLights: true,
        );

        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      }
    }
  }

  Future<void> programarNotificacion({
    required int id,
    required String titulo,
    required String cuerpo,
    required DateTime fechaHora,
  }) async {
    if (kIsWeb) {
      _programarNotificacionWeb(titulo: titulo, cuerpo: cuerpo, fechaHora: fechaHora);
    } else {
      await _programarNotificacionNativa(
        id: id,
        titulo: titulo,
        cuerpo: cuerpo,
        fechaHora: fechaHora,
      );
    }
  }

  void _programarNotificacionWeb({
    required String titulo,
    required String cuerpo,
    required DateTime fechaHora,
  }) {
    if (html.Notification.supported) {
      html.Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          // Calcular el delay hasta la notificación
          final delay = fechaHora.difference(DateTime.now());
          Future.delayed(delay, () {
            html.Notification(
              titulo,
              body: cuerpo,
            );
          });
        }
      });
    }
  }

  Future<void> _programarNotificacionNativa({
    required int id,
    required String titulo,
    required String cuerpo,
    required DateTime fechaHora,
  }) async {
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'recordatorios_channel',
        'Recordatorios',
        channelDescription: 'Canal para recordatorios',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    var scheduledDate = tz.TZDateTime.from(fechaHora, tz.local);
    
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        titulo,
        cuerpo,
        scheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      print('Notificación programada para: ${scheduledDate.toString()}');
    } catch (e) {
      print('Error al programar la notificación: $e');
    }
  }

  Future<void> cancelarNotificacion(int id) async {
    if (!kIsWeb) {
      await flutterLocalNotificationsPlugin.cancel(id);
    }
  }
}