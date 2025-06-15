import 'package:hive/hive.dart';
import 'comment.dart';
part 'post.g.dart';

@HiveType(typeId: 0)
class Post extends HiveObject {
  @HiveField(0) String username;
  @HiveField(1) String imagePath;
  @HiveField(2) String caption;
  @HiveField(3) DateTime timestamp;
  @HiveField(4) int likes;
  @HiveField(5) bool likedByUser;
  @HiveField(6) List<Comment> comments;

  Post({
    required this.username,
    required this.imagePath,
    required this.caption,
    required this.timestamp,
    this.likes = 0,
    this.likedByUser = false,
    List<Comment>? comments,
  }) : comments = comments ?? [];
}
