import 'package:post_it_post/domain/models/post.dart';

import 'base_repository.dart';

abstract class PostRepository extends BaseRepository {
  Future<List<Post>> getAllPost();
}
