import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_it_post/ui/post/list/post_list_bloc.dart';

import 'android/android_list_post_view.dart';
import 'ios/ios_list_post_view.dart';

const GreenColor = Color(0xff00A900);

class PostListPage extends StatefulWidget {
  final PostListBloc bloc;

  PostListPage({@required this.bloc});

  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage>
    with SingleTickerProviderStateMixin {
  _deleteAllPosts() {
    widget.bloc.deleteAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        centerTitle: Platform.isIOS,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
            ),
            onPressed: () => widget.bloc.getAllPosts(isRefreshing: true),
          )
        ],
      ),
      body: Platform.isIOS
          ? IosListPostView(bloc: widget.bloc)
          : AndroidListPostView(bloc: widget.bloc),
      floatingActionButtonLocation: Platform.isIOS
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: Platform.isIOS
          ? Container(
              width: double.infinity,
              height: 40,
              color: Colors.red,
              child: RawMaterialButton(
                onPressed: () => _deleteAllPosts(),
                child: Text(
                  "Delete All",
                  style: TextStyle(color: Colors.white),
                ),
              ))
          : Container(
              width: 50,
              height: 50,
              child: FloatingActionButton(
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {},
                backgroundColor: Colors.red,
              ),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.bloc.dispose();
  }
}
