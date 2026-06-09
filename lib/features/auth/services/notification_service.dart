import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mi_tension/core/enums/diasSemana.dart';
import 'package:mi_tension/features/auth/models/recordatorio_dto.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static FlutterLocalNotificationsPlugin? _plugin;
  static bool _inicializado = false;

  static Future<void> inicializar() async {
    if (_inicializado) return;
    _plugin = FlutterLocalNotificationsPlugin();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Madrid'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin!.initialize(settings);

    _inicializado = true;
  }

  static Future<void> programarRecordatorio(
    RecordatorioDto recordatorio,
  ) async {
    if (_plugin == null) return;
    await cancelarRecordatorio(recordatorio.id);
    for (final dia in recordatorio.dias) {
      final id = _generarId(recordatorio.id, dia);
      final hora = _parsearHora(recordatorio.hora);
      await _plugin!.zonedSchedule(
        id,
        'Recordatorio de medicación',
        '${recordatorio.nombreMedicina} - ${recordatorio.dosis}',
        _proximaFecha(dia, hora),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'recordatorios_canal',
            'Recordatorios de medicación',
            channelDescription:
                'Notificaciones para recordar tomar la medicación',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  static Future<void> cancelarRecordatorio(String id) async {
    if (_plugin == null) return;
    for (final dia in DiasSemana.values) {
      await _plugin!.cancel(_generarId(id, dia));
    }
  }

  static Future<void> cancelarTodas() async {
    if (_plugin == null) return;
    await _plugin!.cancelAll();
  }

  static int _generarId(String recordatorioId, DiasSemana dia) {
    final base = recordatorioId.hashCode.abs() % 10000;
    return base * 10 + dia.index;
  }

  static TimeOfDay _parsearHora(String hora) {
    final partes = hora.split(':');
    return TimeOfDay(hour: int.parse(partes[0]), minute: int.parse(partes[1]));
  }

  static tz.TZDateTime _proximaFecha(DiasSemana dia, TimeOfDay hora) {
    final ahora = tz.TZDateTime.now(tz.local);
    final diasSemana = {
      DiasSemana.lunes: DateTime.monday,
      DiasSemana.martes: DateTime.tuesday,
      DiasSemana.miercoles: DateTime.wednesday,
      DiasSemana.jueves: DateTime.thursday,
      DiasSemana.viernes: DateTime.friday,
      DiasSemana.sabado: DateTime.saturday,
      DiasSemana.domingo: DateTime.sunday,
    };
    var fecha = tz.TZDateTime(
      tz.local,
      ahora.year,
      ahora.month,
      ahora.day,
      hora.hour,
      hora.minute,
    );
    while (fecha.weekday != diasSemana[dia]) {
      fecha = fecha.add(const Duration(days: 1));
    }
    if (fecha.isBefore(ahora)) {
      fecha = fecha.add(const Duration(days: 7));
    }
    return fecha;
  }
}
