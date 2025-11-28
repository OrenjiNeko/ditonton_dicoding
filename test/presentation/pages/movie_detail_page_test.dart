import 'package:ditonton/bloc/get_detail_movies/get_detail_movies_bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([GetDetailMovieBloc])
void main() {
  late MockGetDetailMovieBloc mockBloc;

  setUp(() {
    mockBloc = MockGetDetailMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetDetailMovieBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    final state = GetDetailMovieHasData(
      movieDetail: testMovieDetail,
      recommendations: <Movie>[],
      isAddedToWatchlist: false,
    );

    when(mockBloc.state).thenReturn(state);
    when(mockBloc.stream).thenAnswer((_) => Stream.value(state));
    when(mockBloc.isClosed).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    final state = GetDetailMovieHasData(
      movieDetail: testMovieDetail,
      recommendations: <Movie>[],
      isAddedToWatchlist: true,
    );

    when(mockBloc.state).thenReturn(state);
    when(mockBloc.stream).thenAnswer((_) => Stream.value(state));
    when(mockBloc.isClosed).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final initialState = GetDetailMovieHasData(
      movieDetail: testMovieDetail,
      recommendations: <Movie>[],
      isAddedToWatchlist: false,
    );

    final successState = GetDetailMovieWatchlistSuccess(
      message: 'Added to Watchlist',
      isAddedToWatchlist: true,
    );

    when(mockBloc.state).thenReturn(initialState);
    when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([
          initialState,
          successState,
        ]));
    when(mockBloc.isClosed).thenReturn(false);

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final initialState = GetDetailMovieHasData(
      movieDetail: testMovieDetail,
      recommendations: <Movie>[],
      isAddedToWatchlist: false,
    );

    final errorState = GetDetailMovieWatchlistSuccess(
      message: 'Failed',
      isAddedToWatchlist: false,
    );

    // Setup initial state
    when(mockBloc.state).thenReturn(initialState);
    when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([
          initialState,
          errorState,
        ]));
    when(mockBloc.isClosed).thenReturn(false);

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
