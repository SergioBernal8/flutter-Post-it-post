import 'package:flutter/material.dart';
import 'package:post_it_post/data/api/post_api.dart';
import 'package:post_it_post/ui/post/list/post_list_bloc.dart';

class PostListPage extends StatefulWidget {
  final PostListBloc bloc;

  PostListPage({@required this.bloc});

  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  _getPost() async {
    final repo = PostApi();
    final post = await repo.getAllPost();
  }

  @override
  Widget build(BuildContext context) {
    _getPost();
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        backgroundColor: Color(0xff79B900),
      ),
    );
  }
}
