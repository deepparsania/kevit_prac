import 'dart:math';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/post.dart';

class Utils {
  static Future<void> insertDummyPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final hasRun = prefs.getBool('dummy_loaded') ?? false;
    if (hasRun) return;

    final box = Hive.box<Post>('posts');
    final random = Random();
    final usernames = ['alice', 'bob', 'carol', 'dave', 'eve'];

    for (int i = 0; i < 8; i++) {
      final username = usernames[random.nextInt(usernames.length)];
     // final imageUrl = 'https://picsum.photos/400/300?random=$i';
      final imageUrl = 'https://picsum.photos/id/$i/400/300';

      final post = Post(
        username: username,
        caption: "Dummy post $i",
        imagePath: imageUrl,
        timestamp: DateTime.now().subtract(Duration(minutes: i * 5)),
      );
      await box.add(post);
    }

    await prefs.setBool('dummy_loaded', true);
  }

  static String formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inSeconds < 60) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    if (diff.inDays > 24) return "${diff.inDays}d ago";
    return DateFormat('dd MMM yyyy').format(timestamp);
  }
}
