import 'package:flutter/material.dart';
import 'package:post_it_post/data/api/comment_api.dart';
import 'package:post_it_post/data/api/user_api.dart';
import 'package:post_it_post/domain/managers/sq_db_manager.dart';
import 'package:post_it_post/domain/models/post_item.dart';
import 'package:post_it_post/ui/common/loading_indicator.dart';
import 'package:post_it_post/ui/post/details/post_datails_page.dart';
import 'package:post_it_post/ui/post/details/post_detail_bloc.dart';
import 'package:post_it_post/ui/post/list/android/android_post_cell.dart';

import '../post_list_bloc.dart';
import '../post_list_page.dart';

class AndroidListPostView extends StatefulWidget {
  final PostListBloc bloc;

  AndroidListPostView({@required this.bloc});

  @override
  _AndroidListPostViewState createState() => _AndroidListPostViewState();
}

class _AndroidListPostViewState extends State<AndroidListPostView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        _filterPost();
      });
    widget.bloc.getAllPosts();
  }

  _filterPost() {
    final filter =
        _tabController.index == 0 ? PostFilter.all : PostFilter.favorites;
    widget.bloc.filterPost(filter);
  }

  _updateCallback(PostItem item) {
    widget.bloc.reloadPostData(item);
  }

  _goToDetails(PostItem item) {
    widget.bloc.readPostItem(item);
    final PostDetailBloc bloc = PostDetailBloc(
        userRepository: UserApi(),
        commentRepository: CommentApi(),
        dataBaseManager: SQDBManager(),
        postItem: item);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostDetailsPage(bloc, _updateCallback)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GreenColor,
      appBar: TabBar(
        unselectedLabelColor: Colors.white,
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        tabs: [
          Tab(text: "All".toUpperCase()),
          Tab(text: "Favorites".toUpperCase()),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            color: Colors.white,
            child: StreamBuilder<PostListState>(
              stream: widget.bloc.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isLoading) {
                    return LoadingIndicator();
                  } else {
                    final data = snapshot.data.filteredPostList;
                    return ListView.separated(
                        separatorBuilder: (_, __) => Divider(
                              color: Colors.grey,
                              height: 1,
                            ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return GestureDetector(
                            onTap: () => _goToDetails(item),
                            child: Dismissible(
                              background: Container(color: Colors.red),
                              key: ObjectKey(item.id),
                              onDismissed: (direction) {
                                widget.bloc.deletePostItem(item.id);
                              },
                              child: AndroidPostCell(item),
                            ),
                          );
                        });
                  }
                }
                return LoadingIndicator();
              },
            ),
          ),
          Container(
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
