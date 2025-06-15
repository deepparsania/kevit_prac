import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kevit_prac/screens/feed/feed_provider.dart';
import 'package:kevit_prac/utils/file_utils.dart';
import 'package:kevit_prac/utils/utils.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../screens/auth/auth_provider.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(authProvider) ?? 'user';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            leading: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blueAccent,
              child: Text(
                post.username[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              post.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              Utils.formatTime(post.timestamp),
              style: TextStyle(fontSize: 12),
            ),
          ),

          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                post.imagePath.contains("http")
                    ? Image.network(
                      post.imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                    : Image.file(
                      File(post.imagePath),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
          ),

          /// CAPTION
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(post.caption, style: TextStyle(fontSize: 15)),
            ),

          /// ACTION BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                /// Like
                IconButton(
                  icon: Icon(
                    post.likedByUser ? Icons.favorite : Icons.favorite_border,
                    color: post.likedByUser ? Colors.red : Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    post.likedByUser = !post.likedByUser;
                    post.likes += post.likedByUser ? 1 : -1;
                    post.save();
                    ref.read(feedProvider.notifier).updatePost(post);
                  },
                ),
                Text(
                  '${post.likes}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),

                /// Comment
                IconButton(
                  icon: Icon(Icons.comment_outlined, color: Colors.grey[700]),
                  onPressed:
                      () => _showCommentDialog(context, ref, post, username),
                ),
                Text(
                  '${post.comments.length}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),

                Spacer(),

                /// Download
                IconButton(
                  icon: Icon(Icons.download_rounded, color: Colors.grey[700]),
                  onPressed: () async {
                    await FileUtils.saveImageToGallery(post.imagePath);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Image downloaded!')),
                    );
                  },
                ),
              ],
            ),
          ),

          /// COMMENTS
          if (post.comments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...post.comments.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: c.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: '  '),
                                TextSpan(text: c.text),
                              ],
                            ),
                          ),
                          Text(Utils.formatTime(c.timestamp),style: Theme.of(context).textTheme.labelSmall,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _showCommentDialog(
    BuildContext context,
    WidgetRef ref,
    Post post,
    String username,
  ) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Add Comment"),
            content: TextField(
              controller: ctrl,
              decoration: InputDecoration(
                hintText: "Write your comment...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
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
                child: const Text("Post"),
              ),
            ],
          ),
    );
  }
}
