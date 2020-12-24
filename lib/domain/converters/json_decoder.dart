import 'dart:convert' as converter;

import 'package:post_it_post/domain/converters/base_decoder.dart';

class JsonConverter extends BaseDecoder {
  @override
  convertData(dynamic data) {
    return converter.jsonDecode(data);
  }

  @override
  List<dynamic> convertList(data) {
    List<dynamic> list = converter.jsonDecode(data);
    return list;
  }
}
