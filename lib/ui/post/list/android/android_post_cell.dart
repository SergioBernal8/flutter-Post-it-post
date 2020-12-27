import 'package:flutter/material.dart';
import 'package:post_it_post/domain/models/post_item.dart';

class AndroidPostCell extends StatelessWidget {
  final PostItem _postItem;

  AndroidPostCell(this._postItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 10),
      width: double.infinity,
      child: Row(
        children: [
          _postItem.isRead == 1
              ? Container()
              : Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
          Container(width: 10),
          Expanded(
            child: Text(
              _postItem.body,
              textAlign: TextAlign.justify,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(width: 5),
          _postItem.isFavorite == 1
              ? Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 20,
                )
              : Container(),
          Container(width: 5),
        ],
      ),
    );
  }
}
