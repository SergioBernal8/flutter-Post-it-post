import 'package:meta/meta.dart';
import 'package:post_it_post/data/base/post_repository.dart';
import 'package:post_it_post/domain/bloc/base_bloc.dart';
import 'package:post_it_post/domain/bloc/base_bloc_state.dart';
import 'package:post_it_post/domain/models/post.dart';
import 'package:post_it_post/domain/models/post_item.dart';
import 'package:rxdart/rxdart.dart';

class PostListState extends BaseBlocState {
  List<Post> postList;
  List<PostItem> postItemList;

  PostListState._()
      : postList = [],
        postItemList = [];

  factory PostListState.initial() => PostListState._();
}

class PostListBloc extends BaseBloC {
  final BehaviorSubject<PostListState> _subject;
  final ValueStream<PostListState> stream;
  final PostRepository _postRepository;

  PostListState get currentState => _subject.value;

  factory PostListBloc({@required PostRepository postRepository}) {
    return PostListBloc._(
        stateSubject:
            BehaviorSubject<PostListState>.seeded(PostListState.initial()),
        postRepository: postRepository);
  }

  PostListBloc._(
      {BehaviorSubject<PostListState> stateSubject,
      PostRepository postRepository})
      : _subject = stateSubject,
        stream = stateSubject.stream,
        _postRepository = postRepository;

  getAllPosts() async {
    currentState.startLoading();
    _subject.add(currentState);

    currentState.postList = await _postRepository.getAllPost();

    int blueDotCount = 20;

    currentState.postList.forEach((post) {
      final postListItem =
          PostItem.fromPost(post, isRead: blueDotCount <= 0, isFavorite: false);
      blueDotCount--;
      currentState.postItemList.add(postListItem);
    });

    currentState.stopLoading();
    _subject.add(currentState);
  }

  deletePostItem(int postId) {
    currentState.postItemList.removeWhere((element) => element.id == postId);
    currentState.postList.removeWhere((element) => element.id == postId);
    _subject.add(currentState);
  }

  @override
  dispose() {
    _subject.close();
  }
}
