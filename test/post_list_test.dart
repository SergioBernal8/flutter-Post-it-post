// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_it_post/ui/post/list/post_list_bloc.dart';
import 'package:post_it_post/ui/post/list/post_list_page.dart';

import 'data/base/mock_post_repository.dart';
import 'domain/managers/mock_db_manager.dart';

void main() {
  testWidgets('Test main page list', (WidgetTester tester) async {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(), child: MaterialApp(home: widget));
    }

    final mockPostRepository = MockPostRepository();
    final mockDBManager = MockDBManager();

    PostListBloc bloc = PostListBloc(
        postRepository: mockPostRepository, dataBaseManager: mockDBManager);

    await tester.pumpWidget(
      buildTestableWidget(PostListPage(bloc: bloc)),
    );

    await tester.pump();

    expect(bloc.currentState.postItemList.length, greaterThanOrEqualTo(0));
  });

  testWidgets('Test main page list empty', (WidgetTester tester) async {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(), child: MaterialApp(home: widget));
    }

    final mockPostRepository = MockPostRepository();
    mockPostRepository.mockCase = PostRepositoryMockCase.emptyRepository;

    final mockDBManager = MockDBManager();
    mockDBManager.mockCase = MockDBManagerCase.emptyData;

    PostListBloc bloc = PostListBloc(
        postRepository: mockPostRepository, dataBaseManager: mockDBManager);

    await tester.pumpWidget(
      buildTestableWidget(PostListPage(bloc: bloc)),
    );

    await tester.pump();

    expect(bloc.currentState.postItemList.length, equals(0));
  });

  testWidgets('Test main list delete tap', (WidgetTester tester) async {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(), child: MaterialApp(home: widget));
    }

    final mockPostRepository = MockPostRepository();
    final mockDBManager = MockDBManager();

    PostListBloc bloc = PostListBloc(
        postRepository: mockPostRepository, dataBaseManager: mockDBManager);

    await tester.pumpWidget(
      buildTestableWidget(PostListPage(bloc: bloc)),
    );

    final Finder deleteButtonFinder = find.byKey(Key("FABDeleteButton"));

    expect(deleteButtonFinder, findsWidgets);

    await tester.tap(deleteButtonFinder);

    expect(bloc.currentState.postItemList.length, equals(0));
  });

  testWidgets('Test main list refresh tap', (WidgetTester tester) async {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(), child: MaterialApp(home: widget));
    }

    final mockPostRepository = MockPostRepository();
    final mockDBManager = MockDBManager();

    PostListBloc bloc = PostListBloc(
        postRepository: mockPostRepository, dataBaseManager: mockDBManager);

    await tester.pumpWidget(
      buildTestableWidget(PostListPage(bloc: bloc)),
    );

    final Finder refreshButtonFinder = find.byKey(Key("refreshButton"));

    expect(refreshButtonFinder, findsWidgets);

    await tester.tap(refreshButtonFinder);

    await tester.pump();

    expect(bloc.currentState.postItemList.length, greaterThanOrEqualTo(0));
  });
}
