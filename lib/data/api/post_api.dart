import 'package:http/http.dart' as http;
import 'package:post_it_post/data/base/post_repository.dart';
import 'package:post_it_post/domain/converters/json_decoder.dart';
import 'package:post_it_post/domain/models/post.dart';

import 'api_constants.dart';
import 'api_error.dart';

class PostApi extends PostRepository {
  static const TAG = "PostApi";

  @override
  Future<List<Post>> getAllPost() async {
    final url = ApiConstants.baseUrl + ApiConstants.postPath;

    var response = await http.get(url);
    final jsonConvert = JsonConverter();

    if (response.statusCode == 200) {
      final jsonList = jsonConvert.convertList(response.body);

      List<Post> postList = [];

      jsonList.forEach((elementData) {
        postList.add(Post.fromJson(elementData));
      });
      return postList;
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
