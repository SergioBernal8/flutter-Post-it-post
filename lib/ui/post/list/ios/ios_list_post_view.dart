import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_it_post/ui/common/loading_indicator.dart';

import '../post_list_bloc.dart';
import '../post_list_page.dart';
import 'ios_post_cell.dart';

class IosListPostView extends StatefulWidget {
  final PostListBloc bloc;

  IosListPostView({@required this.bloc});
  @override
  _IosListPostViewState createState() => _IosListPostViewState();
}

class _IosListPostViewState extends State<IosListPostView>
    with SingleTickerProviderStateMixin {
  var _segmentedControlValue = 0;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        _segmentedControlValue = _tabController.index;
        setState(() {});
      });
    widget.bloc.getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * .8,
                child: CupertinoSegmentedControl(
                  padding: EdgeInsets.only(top: 10),
                  groupValue: _segmentedControlValue,
                  selectedColor: GreenColor,
                  unselectedColor: Colors.white,
                  borderColor: GreenColor,
                  children: {
                    0: Text(
                      "All",
                      style: TextStyle(
                          fontSize: 10, decoration: TextDecoration.none),
                    ),
                    1: Text(
                      "Favorites",
                      style: TextStyle(
                          fontSize: 10, decoration: TextDecoration.none),
                    )
                  },
                  onValueChanged: (value) {
                    _segmentedControlValue = value;
                    _tabController.index = value;
                    setState(() {});
                  },
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  StreamBuilder<PostListState>(
                    stream: widget.bloc.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.isLoading) {
                          return LoadingIndicator();
                        } else {
                          final data = snapshot.data.postItemList;
                          return ListView.separated(
                              separatorBuilder: (_, __) => Divider(
                                    color: Colors.grey,
                                    height: 1,
                                  ),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final item = data[index];
                                return Dismissible(
                                  background: Container(color: Colors.red),
                                  key: ObjectKey(item.id),
                                  onDismissed: (direction) {
                                    widget.bloc.deletePostItem(item.id);
                                  },
                                  child: IosPostCell(item),
                                );
                              });
                        }
                      }
                      return LoadingIndicator();
                    },
                  ),
                  Icon(Icons.directions_transit),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
