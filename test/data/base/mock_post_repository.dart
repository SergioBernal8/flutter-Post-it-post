import 'package:post_it_post/data/api/api_error.dart';
import 'package:post_it_post/data/base/post_repository.dart';
import 'package:post_it_post/domain/models/post.dart';

class MockPostRepository extends PostRepository {
  var mockCase = PostRepositoryMockCase.success;

  @override
  printError(Error error) {}

  @override
  Future<List<Post>> getAllPost() {
    switch (mockCase) {
      case PostRepositoryMockCase.success:
        final list = List.generate(
            3,
            (index) =>
                Post(id: index, body: "body", title: "title", userId: index));
        return Future.value(list);
      case PostRepositoryMockCase.failure:
        final error = ApiError(404);
        printError(error);
        throw error;
      case PostRepositoryMockCase.emptyRepository:
        final List<Post> list = [];
        return Future.value(list);
    }
    return Future.value([]);
  }
}

enum PostRepositoryMockCase { success, failure, emptyRepository }
