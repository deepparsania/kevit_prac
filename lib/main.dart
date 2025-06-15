import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kevit_prac/models/comment.dart';
import 'package:kevit_prac/screens/auth/auth_provider.dart';
import 'package:kevit_prac/screens/feed/feed.dart';
import 'package:kevit_prac/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/post.dart';
import 'screens/auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(CommentAdapter());
  await Hive.openBox<Post>('posts');
  await Utils.insertDummyPosts();
  final prefs = await SharedPreferences.getInstance();
  final hasLogin = prefs.getString('login_name')??"";

  runApp(ProviderScope(
      overrides: [
        authProvider.overrideWith((ref) => hasLogin),
      ],
      child:MaterialApp(
    title: 'Kevit prac',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: hasLogin.isNotEmpty?FeedScreen():LoginScreen(),
  )));
}
