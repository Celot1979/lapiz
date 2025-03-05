import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    if (!kIsWeb) {
      // Configuración para plataformas nativas
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      final LinuxInitializationSettings initializationSettingsLinux =
          LinuxInitializationSettings(
        defaultActionName: 'Abrir notificación',
      );

      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
          print('Notificación recibida: ${details.payload}');
        },
      );
    }
    tz.initializeTimeZones();
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
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      linux: LinuxNotificationDetails(
        urgency: LinuxNotificationUrgency.normal,
      ),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      titulo,
      cuerpo,
      tz.TZDateTime.from(fechaHora, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelarNotificacion(int id) async {
    if (!kIsWeb) {
      await flutterLocalNotificationsPlugin.cancel(id);
    }
  }
}