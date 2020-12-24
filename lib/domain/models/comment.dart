class Comment {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Comment({this.postId, this.id, this.name, this.email, this.body});

  factory Comment.fromJson(dynamic data) {
    return Comment(
        postId: data['postId'],
        id: data['id'],
        name: data['name'],
        email: data['email'],
        body: data['body']);
  }
}
