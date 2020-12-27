import 'package:flutter/material.dart';
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
  bool filterPosts = false;

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
  var currentFilter = PostFilter.all;

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
      currentState.filterPosts = true;
      await _dataBaseManager.deleteAllPostItems();
      _emptyData();
    }

    final allPost = await _getSavedPostFromDataBase();

    if (allPost.isNotEmpty) {
      currentState.postItemList = allPost;
      currentState.filteredPostList.addAll(allPost);
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

    if (currentState.filterPosts) {
      filterPost(currentFilter);
      currentState.filterPosts = false;
    } else {
      currentState.stopLoading();
      _subject.add(currentState);
    }
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

      final filterIndex = currentState.filteredPostList
          .indexWhere((element) => element.id == postItem.id);
      if (filterIndex != -1) {
        currentState.filteredPostList[filterIndex] = readPost;
      }

      _subject.add(currentState);
    }
  }

  deletePostItem(int postId) {
    _dataBaseManager.deletePostItem(postId);

    currentState.postItemList.removeWhere((element) => element.id == postId);
    currentState.filteredPostList
        .removeWhere((element) => element.id == postId);
  }

  deleteAllPost() {
    _dataBaseManager.deleteAllPostItems();
    _emptyData();
  }

  filterPost(PostFilter filter) {
    currentFilter = filter;
    switch (filter) {
      case PostFilter.all:
        currentState.filteredPostList = currentState.postItemList;
        break;
      case PostFilter.favorites:
        currentState.filteredPostList = currentState.postItemList
            .where((element) => element.isFavorite == 1)
            .toList();
        break;
    }
    currentState.stopLoading();
    _subject.add(currentState);
  }

  reloadPostData(PostItem postItem) {
    final index = currentState.postItemList
        .indexWhere((element) => element.id == postItem.id);
    if (index != -1) {
      currentState.postItemList[index] = postItem;
    }

    if (currentFilter == PostFilter.favorites) {
      final filteredIndex = currentState.filteredPostList
          .indexWhere((element) => element.id == postItem.id);
      if (filteredIndex != -1) {
        if (postItem.isFavorite == 0) {
          currentState.filteredPostList.removeAt(filteredIndex);
        } else {
          currentState.filteredPostList[filteredIndex] = postItem;
        }
      }
    }

    _subject.add(currentState);
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

enum PostFilter { all, favorites }
