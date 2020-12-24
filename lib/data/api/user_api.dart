import 'package:http/http.dart' as http;
import 'package:post_it_post/data/base/user_repository.dart';
import 'package:post_it_post/domain/converters/json_decoder.dart';
import 'package:post_it_post/domain/models/user.dart';

import 'api_constants.dart';
import 'api_error.dart';

class UserApi extends UserRepository {
  static const TAG = "UserApi";

  @override
  Future<User> getUser(final int id) async {
    final url = ApiConstants.baseUrl + "/$id" + ApiConstants.postPath;

    var response = await http.get(url);
    final jsonConvert = JsonConverter();

    if (response.statusCode == 200) {
      final json = jsonConvert.convertData(response.body);

      return User.fromJson(json);
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
