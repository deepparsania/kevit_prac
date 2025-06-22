import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kevit_prac/screens/feed/feed_provider.dart';
import 'package:kevit_prac/utils/file_utils.dart';
import 'package:kevit_prac/utils/utils.dart';
import 'package:kevit_prac/widget/comment_screen.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../screens/auth/auth_provider.dart';
import '../utils/dimensions.dart';
import '../utils/my_color.dart';
import '../utils/style.dart';
import 'custom_bottom_sheet.dart';
import 'default_text.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(authProvider) ?? 'user';
    final isLiked = post.likedBy.contains(username);
    bool isReadMore = false;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: MyColor.grayColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: MyColor.primaryColor,
                  child: DefaultText(
                    text: post.username[0].toUpperCase(),
                    textStyle: outfitifBoldText,
                    fontSize: Dimensions.fontDefault,
                    textColor: MyColor.colorWhite,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DefaultText(
                        text: post.username ?? "",
                        textStyle: outfitifMediumText,
                        fontSize: Dimensions.fontLarge,
                        textColor: MyColor.iconColor,
                      ),
                      const SizedBox(width: 12),
                      DefaultText(
                        text: Utils.formatTime(post.timestamp),
                        textStyle: outfitifMediumText,
                        fontSize: Dimensions.fontSmall,
                        textColor: MyColor.uniqueColor,
                      ),
                    ],
                  ),
                ),

                popMenu(context, MyColor.iconColor),
              ],
            ),
          ),

          SizedBox(height: post.caption.isEmpty ? 0 : 10),
          // Caption
          post.caption.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          isReadMore = !isReadMore;
                        });
                      },
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: " ${post.caption ?? ""}",
                              style: outfitifRegularText.copyWith(
                                fontSize: Dimensions.fontDefault,
                                color: MyColor.iconColor,
                              ),
                            ),
                          ],
                        ),
                        maxLines: isReadMore ? 100 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              )
              : SizedBox.shrink(),

          // Post Image
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (_) => Scaffold(
                      backgroundColor: MyColor.colorBlack,
                      body: Container(
                        padding: const EdgeInsets.all(10),
                        child: Stack(
                          children: [
                            InteractiveViewer(
                              boundaryMargin: const EdgeInsets.all(20.0),
                              minScale: 0.1,
                              maxScale: 2.0,
                              child: Center(
                                child:
                                    post.imagePath.contains("http")
                                        ? CachedNetworkImage(
                                          imageUrl: post.imagePath,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => Container(
                                                color: Colors.grey[300],
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  Container(
                                                    color: Colors.grey[300],
                                                  ),
                                        )
                                        : Image.file(
                                          File(post.imagePath),
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  popMenu(context, MyColor.colorWhite),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: MyColor.colorWhite,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child:
                      post.imagePath.contains("http")
                          ? CachedNetworkImage(
                            imageUrl: post.imagePath,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) =>
                                    Container(color: Colors.grey[300]),
                            errorWidget:
                                (context, url, error) =>
                                    Container(color: Colors.grey[300]),
                          )
                          : Image.file(
                            File(post.imagePath),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                ),
              ),
            ),
          ),

          // Like & Comment Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isLiked) {
                      post.likedBy.remove(username);
                      post.likes -= 1;
                    } else {
                      post.likedBy.add(username);
                      post.likes += 1;
                    }
                    post.save();
                    ref.read(feedProvider.notifier).updatePost(post);
                  },
                  child: Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                        child: SvgPicture.asset(
                          isLiked
                              ? "assets/icons/ic_like.svg"
                              : "assets/icons/ic_unlike.svg",
                          key: ValueKey(isLiked),
                          width: 24,
                          height: 24,
                        ),
                      ),

                      const SizedBox(width: 4),
                      DefaultText(
                        text: "${post.likes} Likes",
                        textStyle: outfitifSemiBoldText,
                        fontSize: Dimensions.fontSmall,
                        textColor: MyColor.iconColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    CustomBottomSheet(
                      backgroundColor: MyColor.colorWhite,
                      isNeedMargin: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 4,
                            width: 40,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: MyColor.primaryColor.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: CommentScreen(
                              post: post,
                              comments: post.comments,
                              totalComment: post.comments.length.toString(),
                            ),
                          ),
                        ],
                      ),
                    ).customBottomSheet(context);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/ic_comment.svg",
                        width: 22,
                        height: 22,
                      ),
                      const SizedBox(width: 4),
                      DefaultText(
                        text: "${post.comments.length} Comments",
                        textStyle: outfitifSemiBoldText,
                        fontSize: Dimensions.fontSmall,
                        textColor: MyColor.iconColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  popMenu(BuildContext context, Color color) {
    return PopupMenuButton<int>(
      color: MyColor.colorWhite,
      child: Icon(Icons.more_horiz, color: color),
      padding: EdgeInsets.all(0),
      onSelected: (int item) async {
        if (item == 1) {
          bool result = await FileUtils.saveImageToGallery(
            post.imagePath,
            context,
          );
          if (result) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Image downloaded!')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image not downloaded! please try again later'),
              ),
            );
          }
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<int>>[
            PopupMenuItem<int>(
              value: 1,
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/ic_download.svg",
                    color: MyColor.iconColor,
                  ),
                  SizedBox(width: 5),
                  DefaultText(
                    text: "Download Image",
                    textColor: MyColor.iconColor,
                    fontSize: Dimensions.fontLarge,
                    textStyle: outfitifMediumText,
                  ),
                ],
              ),
            ),
          ],
    );
  }
}
