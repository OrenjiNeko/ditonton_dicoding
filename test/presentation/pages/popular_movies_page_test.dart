import 'package:ditonton/bloc/get_popular_movies/get_popular_movies_bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([GetPopularMoviesBloc])
void main() {
  late MockGetPopularMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockGetPopularMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetPopularMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetPopularMoviesLoading());
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(GetPopularMoviesLoading()));
    when(mockBloc.isClosed).thenReturn(false);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetPopularMoviesHasData(<Movie>[]));
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(GetPopularMoviesHasData(<Movie>[])));
    when(mockBloc.isClosed).thenReturn(false);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetPopularMoviesError('Error message'));
    when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(GetPopularMoviesError('Error message')));
    when(mockBloc.isClosed).thenReturn(false);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    final textFinder = find.byKey(Key('error_message'));

    expect(textFinder, findsOneWidget);
  });
}
