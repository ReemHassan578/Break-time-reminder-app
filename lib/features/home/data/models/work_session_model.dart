import 'package:hive/hive.dart';

part 'work_session_model.g.dart'; // Run `flutter pub run build_runner build` to generate this file

@HiveType(typeId: 1)
class WorkSessionModel extends HiveObject {
  @HiveField(0)
  final int workFrom;

  @HiveField(1)
  final int workTo;

  @HiveField(2)
  // In minutes
  final int breakDuration;

  @HiveField(3)
  // In minutes
  final int breakOccurrence;

  @HiveField(4)
  bool isIdle;

  WorkSessionModel(
      {required this.workFrom,
      required this.workTo,
      required this.isIdle,
      required this.breakDuration,
      required this.breakOccurrence});
}
