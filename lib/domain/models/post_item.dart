import 'package:post_it_post/domain/models/post.dart';

class PostItem {
  final int userId;
  final int id;
  final String title;
  final String body;
  final int isRead;
  final int isFavorite;

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
        isFavorite: isFavorite ? 1 : 0,
        isRead: isRead ? 1 : 0);
  }

  factory PostItem.fromJson(dynamic data) {
    return PostItem(
        userId: data['userId'],
        id: data['id'],
        title: data['title'],
        body: data['body'],
        isFavorite: data["isFavorite"],
        isRead: data["isRead"]);
  }

  factory PostItem.readPost(PostItem postItem) {
    return PostItem(
        body: postItem.body,
        id: postItem.id,
        title: postItem.title,
        userId: postItem.userId,
        isFavorite: postItem.isFavorite,
        isRead: 1);
  }
  factory PostItem.favoritePost(PostItem postItem, int favorite) {
    return PostItem(
        body: postItem.body,
        id: postItem.id,
        title: postItem.title,
        userId: postItem.userId,
        isFavorite: favorite,
        isRead: 1);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "title": title,
        "body": body,
        "isRead": isRead,
        "isFavorite": isFavorite
      };
}
