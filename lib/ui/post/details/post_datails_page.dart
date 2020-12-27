import 'dart:io';

import 'package:flutter/material.dart';
import 'package:post_it_post/ui/common/loading_indicator.dart';
import 'package:post_it_post/ui/post/details/post_detail_bloc.dart';

class PostDetailsPage extends StatefulWidget {
  final PostDetailBloc bloc;

  PostDetailsPage(this.bloc);

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  @override
  void initState() {
    super.initState();

    widget.bloc.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        centerTitle: Platform.isIOS,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Text(
                "Description",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: Container(
                width: double.infinity,
                child: Text(
                  widget.bloc.currentState.postItem.body,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Text(
                "User",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<PostDetailState>(
              stream: widget.bloc.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LoadingIndicator();
                }
                if (snapshot.data.user != null) {
                  final user = snapshot.data.user;
                  return Container(
                    height: 100,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            "${user.name}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            "${user.email}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            "${user.phone}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Text(
                          "${user.website}",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  );
                }
                return LoadingIndicator();
              },
            ),
            Container(
              width: double.infinity,
              child: Container(
                color: Colors.grey[200],
                child: Text(
                  "Comments",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<PostDetailState>(
                stream: widget.bloc.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoadingIndicator();
                  }
                  if (snapshot.data.isLoading) {
                    return LoadingIndicator();
                  } else {
                    final data = snapshot.data.commentList;
                    return ListView.separated(
                        separatorBuilder: (_, __) => Divider(
                              color: Colors.grey,
                              height: 1,
                            ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return ListTile(
                            dense: true,
                            title: Text(item.body),
                          );
                        });
                  }
                },
              ),
            )
          ],
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
