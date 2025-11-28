import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/bloc/get_watchlist_series/get_watchlist_series_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistSeries])
void main() {
  late GetWatchlistSeriesBloc getWatchlistSeriesBloc;
  late MockGetWatchlistSeries mockGetWatchlistSeries;

  setUp(() {
    mockGetWatchlistSeries = MockGetWatchlistSeries();
    getWatchlistSeriesBloc = GetWatchlistSeriesBloc(mockGetWatchlistSeries);
  });

  test('initial state should be empty', () {
    expect(getWatchlistSeriesBloc.state, GetWatchlistSeriesEmpty());
  });

  blocTest<GetWatchlistSeriesBloc, GetWatchlistSeriesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistSeries.execute())
          .thenAnswer((_) async => Right([testWatchListSeries]));
      return getWatchlistSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistSeries()),
    expect: () => [
      GetWatchlistSeriesLoading(),
      GetWatchlistSeriesHasData([testWatchListSeries]),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistSeries.execute()).called(1);
    },
  );

  blocTest<GetWatchlistSeriesBloc, GetWatchlistSeriesState>(
    'should emit [Loading, Error] when get watchlist Series is failed',
    build: () {
      when(mockGetWatchlistSeries.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      return getWatchlistSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistSeries()),
    expect: () => [
      GetWatchlistSeriesLoading(),
      GetWatchlistSeriesError("Can't get data"),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistSeries.execute()).called(1);
    },
  );
}
