// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_it_post/domain/models/post_item.dart';
import 'package:post_it_post/ui/post/details/post_datails_page.dart';
import 'package:post_it_post/ui/post/details/post_detail_bloc.dart';

import 'data/base/mock_comment_repository.dart';
import 'data/base/mock_user_repository.dart';
import 'domain/managers/mock_db_manager.dart';

void main() {
  testWidgets('Test detail page start', (WidgetTester tester) async {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(), child: MaterialApp(home: widget));
    }

    final PostItem postItem = PostItem(
        userId: 1,
        isRead: 1,
        isFavorite: 1,
        body: "body",
        title: "tittle",
        id: 1);

    final mockCommentRepository = MockCommentRepository();
    final mockUserRepository = MockUserRepository();
    final mockDBManager = MockDBManager();

    PostDetailBloc bloc = PostDetailBloc(
        userRepository: mockUserRepository,
        dataBaseManager: mockDBManager,
        commentRepository: mockCommentRepository,
        postItem: postItem);

    callback(final PostItem item) {}

    await tester.pumpWidget(
      buildTestableWidget(PostDetailsPage(bloc, callback)),
    );

    await tester.pump();

    expect(bloc.currentState.postItem, isNotNull);
  });

  testWidgets('Test detail page start', (WidgetTester tester) async {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(), child: MaterialApp(home: widget));
    }

    final PostItem postItem = PostItem(
        userId: 1,
        isRead: 1,
        isFavorite: 1,
        body: "body",
        title: "tittle",
        id: 1);

    final mockCommentRepository = MockCommentRepository();
    final mockUserRepository = MockUserRepository();
    final mockDBManager = MockDBManager();

    PostDetailBloc bloc = PostDetailBloc(
        userRepository: mockUserRepository,
        dataBaseManager: mockDBManager,
        commentRepository: mockCommentRepository,
        postItem: postItem);

    callback(final PostItem item) {}

    await tester.pumpWidget(
      buildTestableWidget(PostDetailsPage(bloc, callback)),
    );

    expect(bloc.currentState.postItem, isNotNull);
  });

  testWidgets('Test detail page favorite', (WidgetTester tester) async {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(), child: MaterialApp(home: widget));
    }

    final PostItem postItem = PostItem(
        userId: 1,
        isRead: 1,
        isFavorite: 0,
        body: "body",
        title: "tittle",
        id: 1);

    final mockCommentRepository = MockCommentRepository();
    final mockUserRepository = MockUserRepository();
    final mockDBManager = MockDBManager();

    PostDetailBloc bloc = PostDetailBloc(
        userRepository: mockUserRepository,
        dataBaseManager: mockDBManager,
        commentRepository: mockCommentRepository,
        postItem: postItem);

    callback(final PostItem item) {}

    await tester.pumpWidget(
      buildTestableWidget(PostDetailsPage(bloc, callback)),
    );

    final Finder favoriteButtonFinder = find.byKey(
      Key("favoriteButton"),
    );

    expect(favoriteButtonFinder, findsWidgets);

    await tester.tap(favoriteButtonFinder);

    expect(bloc.currentState.postItem.isFavorite, equals(1));

    await tester.tap(favoriteButtonFinder);

    expect(bloc.currentState.postItem.isFavorite, equals(0));
  });
}
