import 'package:hive/hive.dart';
part 'comment.g.dart';

@HiveType(typeId: 1)
class Comment {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final DateTime timestamp;

  Comment({
    required this.username,
    required this.text,
    required this.timestamp,
  });
}
