import 'package:ditonton/bloc/get_popular_series/get_popular_series_bloc.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/presentation/pages/popular_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_series_page_test.mocks.dart';

@GenerateMocks([GetPopularSeriesBloc])
void main() {
  late MockGetPopularSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockGetPopularSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetPopularSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetPopularSeriesLoading());
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(GetPopularSeriesLoading()));
    when(mockBloc.isClosed).thenReturn(false);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetPopularSeriesHasData(<Series>[]));
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(GetPopularSeriesHasData(<Series>[])));
    when(mockBloc.isClosed).thenReturn(false);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularSeriesPage()));
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetPopularSeriesError('Error message'));
    when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(GetPopularSeriesError('Error message')));
    when(mockBloc.isClosed).thenReturn(false);

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
