import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kevit_prac/screens/auth/login.dart';
import 'package:kevit_prac/screens/post/add_post.dart';
import 'package:kevit_prac/utils/my_color.dart';
import 'package:kevit_prac/utils/style.dart';
import 'package:kevit_prac/widget/post_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/post.dart';
import '../../models/comment.dart';
import '../../utils/dimensions.dart';
import '../../widget/default_text.dart';
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
    final posts = ref.watch(feedProvider)??[];
    final username = ref.watch(authProvider)??"";

    return Scaffold(
      backgroundColor: MyColor.secondryColor,
      appBar: AppBar(
        backgroundColor: MyColor.secondryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width * 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: MyColor.primaryColor,
                child: DefaultText(
                  text: username.isNotEmpty?username[0].toUpperCase():"",
                  textStyle: outfitifBoldText,
                  fontSize: Dimensions.fontDefault,
                  textColor: MyColor.colorWhite,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultText(
                    text: "Hello",
                    textStyle: outfitifMediumText,
                    fontSize: Dimensions.fontSmall,
                    textColor: MyColor.uniqueColor,
                  ),
                  DefaultText(
                    text: username ?? "",
                    textStyle: outfitifMediumText,
                    fontSize: Dimensions.fontLarge,
                    textColor: MyColor.iconColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: MyColor.primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddPostScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: MyColor.primaryColor),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('login_name');
              ref.read(authProvider.notifier).state = null;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
          ),
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
