import 'package:meta/meta.dart';
import 'package:post_it_post/data/base/post_repository.dart';
import 'package:post_it_post/domain/bloc/base_bloc.dart';
import 'package:post_it_post/domain/bloc/base_bloc_state.dart';
import 'package:post_it_post/domain/managers/base_db_manager.dart';
import 'package:post_it_post/domain/models/post_item.dart';
import 'package:rxdart/rxdart.dart';

class PostListState extends BaseBlocState {
  List<PostItem> filteredPostList;
  List<PostItem> postItemList;

  PostListState._()
      : filteredPostList = [],
        postItemList = [];

  factory PostListState.initial() => PostListState._();
}

class PostListBloc extends BaseBloC {
  final BehaviorSubject<PostListState> _subject;
  final ValueStream<PostListState> stream;
  final PostRepository _postRepository;
  final BaseDataBaseManager _dataBaseManager;

  PostListState get currentState => _subject.value;

  factory PostListBloc(
      {@required PostRepository postRepository,
      @required BaseDataBaseManager dataBaseManager}) {
    return PostListBloc._(
        stateSubject:
            BehaviorSubject<PostListState>.seeded(PostListState.initial()),
        dataBaseManager: dataBaseManager,
        postRepository: postRepository);
  }

  PostListBloc._(
      {BehaviorSubject<PostListState> stateSubject,
      PostRepository postRepository,
      BaseDataBaseManager dataBaseManager})
      : _subject = stateSubject,
        stream = stateSubject.stream,
        _postRepository = postRepository,
        _dataBaseManager = dataBaseManager;

  getAllPosts({bool isRefreshing = false}) async {
    currentState.startLoading();
    _subject.add(currentState);

    await _dataBaseManager.startDataBase();

    if (isRefreshing) {
      await _dataBaseManager.deleteAllPostItems();
      _emptyData();
    }

    final allPost = await _getSavedPostFromDataBase();

    if (allPost.isNotEmpty) {
      currentState.postItemList = allPost;
      currentState.stopLoading();
      _subject.add(currentState);
      return;
    }

    final allPostList = await _postRepository.getAllPost().catchError((error) {
      print("Got error: $error");
    });

    var blueDotCount = 20;

    allPostList.forEach((post) {
      final postListItem =
          PostItem.fromPost(post, isRead: blueDotCount <= 0, isFavorite: false);
      blueDotCount--;
      currentState.postItemList.add(postListItem);
    });
    currentState.filteredPostList.addAll(currentState.postItemList);

    await _dataBaseManager.saveAllPostItems(currentState.postItemList);

    currentState.stopLoading();
    _subject.add(currentState);
  }

  Future<List<PostItem>> _getSavedPostFromDataBase() async {
    return await _dataBaseManager.getSavedPostItems();
  }

  readPostItem(PostItem postItem) {
    final readPost = PostItem.readPost(postItem);
    final index = currentState.postItemList
        .indexWhere((element) => element.id == postItem.id);

    if (index != -1) {
      _dataBaseManager.updatePostItem(readPost);
      currentState.postItemList[index] = readPost;

      _subject.add(currentState);
    }
  }

  deletePostItem(int postId) {
    _dataBaseManager.deletePostItem(postId);

    currentState.postItemList.removeWhere((element) => element.id == postId);
    currentState.filteredPostList
        .removeWhere((element) => element.id == postId);

    _subject.add(currentState);
  }

  deleteAllPost() {
    _dataBaseManager.deleteAllPostItems();
    _emptyData();
  }

  _emptyData() {
    currentState.postItemList = [];
    currentState.filteredPostList = [];

    _subject.add(currentState);
  }

  @override
  dispose() {
    _dataBaseManager.closeDataBase();
    _subject.close();
  }
}
