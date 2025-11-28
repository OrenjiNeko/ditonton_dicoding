import 'package:ditonton/bloc/get_now_playing_series/get_now_playing_series_bloc.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/presentation/pages/airing_today_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'airing_today_series_page_test.mocks.dart';

@GenerateMocks([GetNowPlayingSeriesBloc])
void main() {
  late MockGetNowPlayingSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockGetNowPlayingSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetNowPlayingSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    // Perbaikan syntax - hapus arrow function

    when(mockBloc.state).thenReturn(GetNowPlayingSeriesLoading());
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(GetNowPlayingSeriesLoading()));
    when(mockBloc.isClosed).thenReturn(false);

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(AiringTodaySeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetNowPlayingSeriesHasData(<Series>[]));
    when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(GetNowPlayingSeriesHasData(<Series>[])));
    when(mockBloc.isClosed).thenReturn(false);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(AiringTodaySeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetNowPlayingSeriesError('Error message'));
    when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(GetNowPlayingSeriesError('Error message')));
    when(mockBloc.isClosed).thenReturn(false);
    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(AiringTodaySeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
