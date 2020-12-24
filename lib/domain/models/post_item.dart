import 'package:post_it_post/domain/models/post.dart';

class PostItem {
  final int userId;
  final int id;
  final String title;
  final String body;
  final bool isRead;
  final bool isFavorite;

  PostItem(
      {this.userId,
      this.id,
      this.title,
      this.body,
      this.isFavorite,
      this.isRead});

  factory PostItem.fromPost(Post post,
      {bool isFavorite = false, bool isRead = false}) {
    return PostItem(
        body: post.body,
        id: post.id,
        title: post.title,
        userId: post.userId,
        isFavorite: isFavorite,
        isRead: isRead);
  }
}
