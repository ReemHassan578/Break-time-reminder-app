import 'package:break_time_reminder_app/features/home/data/models/work_session_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/home/data/models/notification_model.dart';

class HiveHelper {

 static late Box<NotificationModel> notificationBox;
 static late Box<WorkSessionModel> workSessionBox;
 static late Box<bool> isBreakTimeBox;
 static late Box<String> breakEndNotificationTimeBox;


  static Future<void> init() async {

    await Hive.initFlutter();
    Hive.registerAdapter(NotificationModelAdapter());
        Hive.registerAdapter(WorkSessionModelAdapter());

    notificationBox=await Hive.openBox<NotificationModel>('notificationBox');
    workSessionBox=await Hive.openBox<WorkSessionModel>('workSessionBox');
    isBreakTimeBox=await Hive.openBox<bool>('isBreakTimeBox');
    breakEndNotificationTimeBox=await Hive.openBox<String>('breakEndNotificationTimeBox');

  }

static bool  get hasScheduledNotification => notificationBox.isNotEmpty;
}