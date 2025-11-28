import 'package:ditonton/bloc/get_top_rated_movie/get_top_rated_movie_bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([GetTopRatedMovieBloc])
void main() {
  late MockGetTopRatedMovieBloc mockBloc;

  setUp(() {
    mockBloc = MockGetTopRatedMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetTopRatedMovieBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetTopRatedMoviesLoading());
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(GetTopRatedMoviesLoading()));
    when(mockBloc.isClosed).thenReturn(false);

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetTopRatedMoviesHasData(<Movie>[]));
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(GetTopRatedMoviesHasData(<Movie>[])));
    when(mockBloc.isClosed).thenReturn(false);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetTopRatedMoviesError('Error message'));
    when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(GetTopRatedMoviesError('Error message')));
    when(mockBloc.isClosed).thenReturn(false);

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
