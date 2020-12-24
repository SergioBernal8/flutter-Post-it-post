import 'package:meta/meta.dart';
import 'package:post_it_post/data/base/comment_repository.dart';
import 'package:post_it_post/data/base/user_repository.dart';
import 'package:post_it_post/domain/bloc/base_bloc.dart';
import 'package:post_it_post/domain/bloc/base_bloc_state.dart';
import 'package:post_it_post/domain/models/comment.dart';
import 'package:post_it_post/domain/models/post_item.dart';
import 'package:post_it_post/domain/models/user.dart';
import 'package:rxdart/rxdart.dart';

class PostDetailState extends BaseBlocState {
  PostItem postItem;
  User user;
  List<Comment> commentList;

  PostDetailState._(PostItem postItem)
      : postItem = postItem,
        commentList = [];

  factory PostDetailState.initial(PostItem postItem) =>
      PostDetailState._(postItem);
}

class PostDetailBloc extends BaseBloC {
  final BehaviorSubject<PostDetailState> _subject;
  final ValueStream<PostDetailState> stream;
  final UserRepository _userRepository;
  final CommentRepository _commentRepository;

  PostDetailState get currentState => _subject.value;

  factory PostDetailBloc(
      {@required UserRepository userRepository,
      @required CommentRepository commentRepository,
      @required PostItem postItem}) {
    return PostDetailBloc._(
        stateSubject: BehaviorSubject<PostDetailState>.seeded(
            PostDetailState.initial(postItem)),
        commentRepository: commentRepository,
        userRepository: userRepository);
  }

  PostDetailBloc._(
      {BehaviorSubject<PostDetailState> stateSubject,
      CommentRepository commentRepository,
      UserRepository userRepository})
      : _subject = stateSubject,
        stream = stateSubject.stream,
        _commentRepository = commentRepository,
        _userRepository = userRepository;

  getUser() async {
    currentState.startLoading();
    _subject.add(currentState);

    currentState.user = await _userRepository
        .getUser(currentState.postItem.userId)
        .catchError((error) {
      print("Got error: $error");
    });
    _getComments();
    currentState.stopLoading();
    _subject.add(currentState);
  }

  _getComments() async {
    currentState.startLoading();
    _subject.add(currentState);

    currentState.commentList = await _commentRepository
        .getCommentsForPost(currentState.postItem.id)
        .catchError((error) {
      print("Got error: $error");
    });
    currentState.stopLoading();
    _subject.add(currentState);
  }

  @override
  dispose() {
    _subject.close();
  }
}
