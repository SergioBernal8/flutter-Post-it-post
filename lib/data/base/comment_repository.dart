import 'package:post_it_post/data/base/base_repository.dart';
import 'package:post_it_post/domain/models/comment.dart';

abstract class CommentRepository extends BaseRepository {
  Future<List<Comment>> getCommentsForPost(final int postID);
}
