import 'package:flutter/material.dart';
import 'package:post_it_post/data/api/post_api.dart';
import 'package:post_it_post/ui/post/list/post_list_bloc.dart';

import 'post/list/post_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post it Post',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PostListPage(
        bloc: PostListBloc(postRepository: PostApi()),
      ),
    );
  }
}