class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(dynamic data) {
    return Post(
        userId: data['userId'],
        id: data['id'],
        title: data['title'],
        body: data['body']);
  }
}
