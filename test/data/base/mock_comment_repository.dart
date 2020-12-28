import 'package:post_it_post/data/api/api_error.dart';
import 'package:post_it_post/data/base/comment_repository.dart';
import 'package:post_it_post/domain/models/comment.dart';

class MockCommentRepository extends CommentRepository {
  var mockCase = CommentRepositoryMockCase.success;

  @override
  Future<List<Comment>> getCommentsForPost(int postID) {
    switch (mockCase) {
      case CommentRepositoryMockCase.success:
        final list = List.generate(
            3,
            (index) => Comment(
                id: index,
                body: "body",
                email: "email",
                name: "name",
                postId: 1));
        return Future.value(list);
      case CommentRepositoryMockCase.failure:
        final error = ApiError(404);
        printError(error);
        throw error;
      case CommentRepositoryMockCase.emptyRepository:
        final List<Comment> list = [];
        return Future.value(list);
    }
    return Future.value([]);
  }

  @override
  printError(Error error) {}
}

enum CommentRepositoryMockCase { success, failure, emptyRepository }
