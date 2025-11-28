import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/bloc/get_list_series/get_list_series_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_series.dart';
import 'package:ditonton/domain/usecases/get_popular_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'list_series_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingSeries, GetPopularSeries, GetTopRatedSeries])
void main() {
  late GetListSeriesBloc getListSeriesBloc;
  late MockGetNowPlayingSeries mockGetNowPlayingSeries;
  late MockGetPopularSeries mockGetPopularSeries;
  late MockGetTopRatedSeries mockGetTopRatedSeries;

  setUp(() {
    mockGetNowPlayingSeries = MockGetNowPlayingSeries();
    mockGetPopularSeries = MockGetPopularSeries();
    mockGetTopRatedSeries = MockGetTopRatedSeries();
    getListSeriesBloc = GetListSeriesBloc(
      getNowPlayingSeries: mockGetNowPlayingSeries,
      getPopularSeries: mockGetPopularSeries,
      getTopRatedSeries: mockGetTopRatedSeries,
    );
  });

  test('initial state should be empty', () {
    expect(getListSeriesBloc.state, GetListSeriesEmpty());
  });

  final tSeries = Series(
    adult: false,
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );
  final tSeriesList = <Series>[tSeries];

  group(
    'get now playing series',
    () {
      blocTest<GetListSeriesBloc, GetListSeriesState>(
        'should emit [loading, hasData] when data is gotten successfully',
        build: () => getListSeriesBloc,
        act: (bloc) {
          when(mockGetNowPlayingSeries.execute())
              .thenAnswer((_) async => Right(tSeriesList));
          bloc.add(FetchNowPlayingSeries());
        },
        expect: () => [
          GetListSeriesLoading(),
          GetListSeriesHasData(nowPlayingSeries: tSeriesList),
        ],
        verify: (bloc) {
          verify(mockGetNowPlayingSeries.execute());
        },
      );

      blocTest<GetListSeriesBloc, GetListSeriesState>(
        'should emit [loading, error] when get now playing Series is unsuccessful',
        build: () => getListSeriesBloc,
        act: (bloc) {
          when(mockGetNowPlayingSeries.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          bloc.add(FetchNowPlayingSeries());
        },
        expect: () => [
          GetListSeriesLoading(),
          GetListSeriesError('Server Failure'),
        ],
        verify: (bloc) {
          verify(mockGetNowPlayingSeries.execute());
        },
      );
    },
  );

  group(
    'get popular series',
    () {
      blocTest<GetListSeriesBloc, GetListSeriesState>(
        'should emit [loading, hasData] when data is gotten successfully',
        build: () => getListSeriesBloc,
        act: (bloc) {
          when(mockGetPopularSeries.execute())
              .thenAnswer((_) async => Right(tSeriesList));
          bloc.add(FetchPopularSeries());
        },
        expect: () => [
          GetListSeriesLoading(),
          GetListSeriesHasData(popularSeries: tSeriesList),
        ],
        verify: (bloc) {
          verify(mockGetPopularSeries.execute());
        },
      );

      blocTest<GetListSeriesBloc, GetListSeriesState>(
        'should emit [loading, error] when get popular series is unsuccessful',
        build: () => getListSeriesBloc,
        act: (bloc) {
          when(mockGetPopularSeries.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          bloc.add(FetchPopularSeries());
        },
        expect: () => [
          GetListSeriesLoading(),
          GetListSeriesError('Server Failure'),
        ],
        verify: (bloc) {
          verify(mockGetPopularSeries.execute());
        },
      );
    },
  );

  group(
    'get top rated series',
    () {
      blocTest<GetListSeriesBloc, GetListSeriesState>(
        'should emit [loading, hasData] when data is gotten successfully',
        build: () => getListSeriesBloc,
        act: (bloc) {
          when(mockGetTopRatedSeries.execute())
              .thenAnswer((_) async => Right(tSeriesList));
          bloc.add(FetchTopRatedSeries());
        },
        expect: () => [
          GetListSeriesLoading(),
          GetListSeriesHasData(topRatedSeries: tSeriesList),
        ],
        verify: (bloc) {
          verify(mockGetTopRatedSeries.execute());
        },
      );

      blocTest<GetListSeriesBloc, GetListSeriesState>(
        'should emit [loading, error] when get top rated series is unsuccessful',
        build: () => getListSeriesBloc,
        act: (bloc) {
          when(mockGetTopRatedSeries.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          bloc.add(FetchTopRatedSeries());
        },
        expect: () => [
          GetListSeriesLoading(),
          GetListSeriesError('Server Failure'),
        ],
        verify: (bloc) {
          verify(mockGetTopRatedSeries.execute());
        },
      );
    },
  );
}
