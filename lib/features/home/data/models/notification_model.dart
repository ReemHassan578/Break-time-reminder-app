import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 0)
class NotificationModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String scheduledTime;
 

  NotificationModel(
      {
      required this.id,
      required this.scheduledTime});

      
}