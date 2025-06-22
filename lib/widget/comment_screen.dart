import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kevit_prac/models/comment.dart';
import 'package:kevit_prac/models/post.dart';
import 'package:kevit_prac/utils/utils.dart';

import '../screens/auth/auth_provider.dart';
import '../screens/feed/feed_provider.dart';
import '../utils/dimensions.dart';
import '../utils/my_color.dart';
import '../utils/style.dart';
import 'default_text.dart';

class CommentScreen extends ConsumerWidget {
  List<Comment> comments;
  Post post;
  String totalComment;

  CommentScreen({
    Key? key,
    required this.post,
    required this.comments,
    required this.totalComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(authProvider) ?? 'user';
    final ctrl = TextEditingController();

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/icons/ic_comment.svg"),
              const SizedBox(width: 4),
              DefaultText(
                text: totalComment,
                textStyle: outfitifSemiBoldText,
                fontSize: Dimensions.fontSmall,
                textColor: MyColor.iconColor,
              ),
            ],
          ),
          SizedBox(height: 5),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child:
                (comments.length ?? 0) > 0
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...comments.map(
                          (c) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.blueAccent,
                                  child: Text(
                                    c.username[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                DefaultText(
                                                  text: c.username ?? "",
                                                  textStyle:
                                                      outfitifSemiBoldText,
                                                  fontSize:
                                                      Dimensions.fontLarge,
                                                  maxLines: 1,
                                                  textColor: MyColor.iconColor,
                                                ),
                                                const SizedBox(width: 4),
                                                DefaultText(
                                                  text: Utils.formatTime(
                                                    c.timestamp,
                                                  ),
                                                  textStyle:
                                                      outfitifRegularText,
                                                  fontSize:
                                                      Dimensions.fontDefault,
                                                  textColor:
                                                      MyColor.uniqueColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      DefaultText(
                                        text: c.text ?? "",
                                        textStyle: outfitifRegularText,
                                        fontSize: Dimensions.fontDefault,
                                        maxLines: 10,
                                        textColor: MyColor.iconColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                    : Center(
                      child: DefaultText(
                        text: "No Comments found",
                        textStyle: outfitifSemiBoldText,
                        fontSize: Dimensions.fontExtraLarge,
                        textColor: MyColor.iconColor,
                      ),
                    ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  maxLines: 2,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  controller: ctrl,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) {
                    ctrl.text = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    hintText: "Type a comment",
                    hintStyle: outfitifRegularText.copyWith(
                      color: MyColor.uniqueColor,
                      fontSize: Dimensions.fontLarge,
                    ),
                    fillColor: MyColor.iconBgColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColor.iconBgColor),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColor.iconBgColor),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColor.iconBgColor),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColor.iconBgColor),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onChanged: (data) {},
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  final text = ctrl.text.trim();
                  if (text.isNotEmpty) {
                    post.comments.add(
                      Comment(
                        username: username,
                        text: text,
                        timestamp: DateTime.now(),
                      ),
                    );
                    post.save();
                    ref.read(feedProvider.notifier).updatePost(post);
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MyColor.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/ic_send.svg",
                    fit: BoxFit.cover,
                    width: 24,
                    height: 24,
                    color: MyColor.colorWhite,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    // ),
    // );
  }
}
