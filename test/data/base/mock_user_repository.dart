import 'package:post_it_post/data/api/api_error.dart';
import 'package:post_it_post/data/base/user_repository.dart';
import 'package:post_it_post/domain/models/user.dart';

class MockUserRepository extends UserRepository {
  @override
  printError(Error error) {}

  @override
  Future<User> getUser(int id) {
    var mockCase = UserRepositoryMockCase.success;

    switch (mockCase) {
      case UserRepositoryMockCase.success:
        final user = User(
            id: 1,
            name: "name",
            email: "email",
            phone: "phone",
            username: "username",
            website: "website");
        return Future.value(user);
      case UserRepositoryMockCase.failure:
        final error = ApiError(404);
        printError(error);
        throw error;
    }
    return Future.value(null);
  }
}

enum UserRepositoryMockCase { success, failure }
