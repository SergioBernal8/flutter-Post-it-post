import 'package:http/http.dart' as http;
import 'package:post_it_post/data/api/api_constants.dart';
import 'package:post_it_post/data/api/api_error.dart';
import 'package:post_it_post/data/base/comment_repository.dart';
import 'package:post_it_post/domain/converters/json_decoder.dart';
import 'package:post_it_post/domain/models/comment.dart';

class CommentApi extends CommentRepository {
  static const TAG = "CommentApi";

  @override
  Future<List<Comment>> getCommentsForPost(final int postID) async {
    final url = ApiConstants.baseUrl +
        ApiConstants.postPath +
        "/$postID" +
        ApiConstants.commentsPath;
    var response = await http.get(url);
    final jsonConvert = JsonConverter();

    if (response.statusCode == 200) {
      final jsonList = jsonConvert.convertList(response.body);

      List<Comment> commentList = [];

      jsonList.forEach((elementData) {
        commentList.add(Comment.fromJson(elementData));
      });
      return commentList;
    } else {
      final error = ApiError(response.statusCode);
      printError(error);
      throw error;
    }
  }

  @override
  printError(Error error) {
    final apiError = error as ApiError;
    print(
        "$TAG -> Got error : ${apiError.errorCode} ::  ${apiError.errorType.toString()}");
  }
}
