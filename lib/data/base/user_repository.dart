import 'package:post_it_post/domain/models/user.dart';

import 'base_repository.dart';

abstract class UserRepository extends BaseRepository {
  Future<User> getUser(final int id);
}
