import 'package:ditonton/bloc/get_detail_series/get_detail_series_bloc.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/presentation/pages/series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'series_detail_page_test.mocks.dart';

@GenerateMocks([GetDetailSeriesBloc])
void main() {
  late MockGetDetailSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockGetDetailSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetDetailSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when series not added to watchlist',
      (WidgetTester tester) async {
    final state = GetDetailSeriesHasData(
      seriesDetail: testSeriesDetail,
      recommendations: <Series>[],
      isAddedToSeriesWatchlist: false,
    );

    when(mockBloc.state).thenReturn(state);
    when(mockBloc.stream).thenAnswer((_) => Stream.value(state));
    when(mockBloc.isClosed).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when series is added to watchlist',
      (WidgetTester tester) async {
    final state = GetDetailSeriesHasData(
      seriesDetail: testSeriesDetail,
      recommendations: <Series>[],
      isAddedToSeriesWatchlist: true,
    );

    when(mockBloc.state).thenReturn(state);
    when(mockBloc.stream).thenAnswer((_) => Stream.value(state));
    when(mockBloc.isClosed).thenReturn(false);
    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final initialState = GetDetailSeriesHasData(
      seriesDetail: testSeriesDetail,
      recommendations: <Series>[],
      isAddedToSeriesWatchlist: false,
    );

    final successState = GetDetailSeriesWatchlistSuccess(
      message: 'Added Series to Watchlist',
      isAddedToSeriesWatchlist: true,
    );

    // Setup initial state
    when(mockBloc.state).thenReturn(initialState);
    when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([
          initialState,
          successState,
        ]));
    when(mockBloc.isClosed).thenReturn(false);

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added Series to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final initialState = GetDetailSeriesHasData(
      seriesDetail: testSeriesDetail,
      recommendations: <Series>[],
      isAddedToSeriesWatchlist: false,
    );

    final errorState = GetDetailSeriesWatchlistSuccess(
      message: 'Failed',
      isAddedToSeriesWatchlist: false,
    );

    when(mockBloc.state).thenReturn(initialState);
    when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([
          initialState,
          errorState,
        ]));
    when(mockBloc.isClosed).thenReturn(false);
    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
