import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kevit_prac/screens/auth/login.dart';
import 'package:kevit_prac/screens/post/add_post.dart';
import 'package:kevit_prac/widget/post_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/post.dart';
import '../../models/comment.dart';
import '../auth/auth_provider.dart';
import 'feed_provider.dart';

class FeedScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        ref.read(feedProvider.notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(feedProvider);
    final username = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    AddPostScreen(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('username');
              ref.read(authProvider.notifier).state = null;
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (_) =>
                    LoginScreen(),
              ), (r) => false);
            },
          )
        ],
      ),
      body: ListView.builder(
        controller: _controller,
        itemCount: posts.length,
        itemBuilder: (_, i) {

          return PostCard(post: posts[i]);
        },
      ),
    );
  }

}
