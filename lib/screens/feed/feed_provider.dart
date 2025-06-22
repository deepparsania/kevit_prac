import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../models/post.dart';

final feedProvider = StateNotifierProvider<FeedNotifier, List<Post>>((ref) {
  return FeedNotifier();
});

class FeedNotifier extends StateNotifier<List<Post>> {
  static const int pageSize = 5;
  int _page = 0;

  FeedNotifier() : super([]) {
    Hive.box<Post>('posts').listenable().addListener(_onBoxChanged);
    loadMore(); // Initial load
  }

  void _onBoxChanged() {
    final allPosts = Hive.box<Post>('posts').values.toList().reversed.toList();
    final total = (_page + 1) * pageSize;
    state = allPosts.take(total).toList();
  }

  void loadMore() {
    _page++;
    print(_page);
    _onBoxChanged(); // reapply pagination
  }

  void updatePost(Post updatedPost) {
    final index = state.indexWhere((p) => p.key == updatedPost.key);
    if (index != -1) {
      final newList = [...state];
      newList[index] = updatedPost;
      state = newList;
    }
  }

  void resetFeed() {
    _page = 0;
    state = [];
    loadMore();
  }

  @override
  void dispose() {
    Hive.box<Post>('posts').listenable().removeListener(_onBoxChanged);
    super.dispose();
  }
}
