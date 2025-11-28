import 'package:ditonton/bloc/get_top_rated_series/get_top_rated_series_bloc.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/presentation/pages/top_rated_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_series_page_test.mocks.dart';

@GenerateMocks([GetTopRatedSeriesBloc])
void main() {
  late MockGetTopRatedSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockGetTopRatedSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetTopRatedSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetTopRatedSeriesLoading());
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(GetTopRatedSeriesLoading()));
    when(mockBloc.isClosed).thenReturn(false);

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetTopRatedSeriesHasData(<Series>[]));
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(GetTopRatedSeriesHasData(<Series>[])));
    when(mockBloc.isClosed).thenReturn(false);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(GetTopRatedSeriesError('Error message'));
    when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(GetTopRatedSeriesError('Error message')));
    when(mockBloc.isClosed).thenReturn(false);

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
