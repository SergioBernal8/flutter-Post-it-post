import 'package:flutter/material.dart';
import 'package:post_it_post/domain/models/post_item.dart';

class IosPostCell extends StatelessWidget {
  final PostItem _postItem;

  IosPostCell(this._postItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 10),
      width: double.infinity,
      child: Row(
        children: [
          _postItem.isFavorite == 1
              ? Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 20,
                )
              : _postItem.isRead == 1
                  ? Container()
                  : Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Text(
              _postItem.body,
              textAlign: TextAlign.justify,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.chevron_right_outlined,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
