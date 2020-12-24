import 'package:meta/meta.dart';
import 'package:post_it_post/data/base/post_repository.dart';
import 'package:post_it_post/domain/bloc/base_bloc.dart';
import 'package:post_it_post/domain/bloc/base_bloc_state.dart';
import 'package:post_it_post/domain/models/post.dart';
import 'package:rxdart/rxdart.dart';

class PostListState extends BaseBlocState {
  List<Post> postList;

  PostListState._() : postList = [];

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

  @override
  dispose() {
    _subject.close();
  }
}
