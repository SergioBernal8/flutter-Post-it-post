import 'package:post_it_post/domain/models/post_item.dart';

abstract class BaseDataBaseManager {
  Future<bool> saveAllPostItems(List<PostItem> allPost);
  Future<List<PostItem>> getSavedPostItems();
  Future<bool> updatePostItem(PostItem item);
  Future<bool> deletePostItem(int postID);
  Future<bool> deleteAllPostItems();
  closeDataBase();
  startDataBase();
}
