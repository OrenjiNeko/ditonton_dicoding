import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/bloc/get_detail_series/get_detail_series_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_series_detail.dart';
import 'package:ditonton/domain/usecases/get_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_series_status.dart';
import 'package:ditonton/domain/usecases/remove_series_watchlist.dart';
import 'package:ditonton/domain/usecases/save_series_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'detail_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetSeriesDetail,
  GetSeriesRecommendations,
  GetWatchlistSeriesStatus,
  SaveSeriesWatchList,
  RemoveSeriesWatchList,
])
void main() {
  late GetDetailSeriesBloc getDetailSeriesBloc;
  late MockGetSeriesDetail mockGetSeriesDetail;
  late MockGetSeriesRecommendations mockGetSeriesRecommendations;
  late MockGetWatchlistSeriesStatus mockGetWatchlistSeriesStatus;
  late MockSaveSeriesWatchList mockSaveSeriesWatchlist;
  late MockRemoveSeriesWatchList mockRemoveSeriesWatchlist;

  setUp(() {
    mockGetSeriesDetail = MockGetSeriesDetail();
    mockGetSeriesRecommendations = MockGetSeriesRecommendations();
    mockGetWatchlistSeriesStatus = MockGetWatchlistSeriesStatus();
    mockSaveSeriesWatchlist = MockSaveSeriesWatchList();
    mockRemoveSeriesWatchlist = MockRemoveSeriesWatchList();
    getDetailSeriesBloc = GetDetailSeriesBloc(
      getSeriesDetail: mockGetSeriesDetail,
      getSeriesRecommendations: mockGetSeriesRecommendations,
      getWatchListStatus: mockGetWatchlistSeriesStatus,
      saveWatchlist: mockSaveSeriesWatchlist,
      removeWatchlist: mockRemoveSeriesWatchlist,
    );
  });

  test('initial state should be empty', () {
    expect(getDetailSeriesBloc.state, GetDetailSeriesInitial());
  });

  const tId = 1;

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
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tSeriesList = <Series>[tSeries];

  blocTest<GetDetailSeriesBloc, GetDetailSeriesState>(
    'should emit [Loading, Has Data] when get series detail and recommendations are successful',
    build: () {
      when(mockGetSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testSeriesDetail));
      when(mockGetSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tSeriesList));
      when(mockGetWatchlistSeriesStatus.execute(tId))
          .thenAnswer((_) async => false);
      return getDetailSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchSeriesDetail(tId)),
    expect: () => [
      GetDetailSeriesLoading(),
      GetDetailSeriesHasData(
        seriesDetail: testSeriesDetail,
        recommendations: tSeriesList,
        isAddedToSeriesWatchlist: false,
      ),
    ],
    verify: (bloc) {
      verify(mockGetSeriesDetail.execute(tId));
      verify(mockGetSeriesRecommendations.execute(tId));
      verify(mockGetWatchlistSeriesStatus.execute(tId));
    },
  );

  group('getDetailSeries', () {
    blocTest<GetDetailSeriesBloc, GetDetailSeriesState>(
      'should emit [Loading, Error] when get series detail is failed',
      build: () {
        when(mockGetSeriesDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return getDetailSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchSeriesDetail(tId)),
      expect: () => [
        GetDetailSeriesLoading(),
        GetDetailSeriesError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetSeriesDetail.execute(tId));
      },
    );
  });

  group(
    'getSeriesRecommendation',
    () {
      blocTest<GetDetailSeriesBloc, GetDetailSeriesState>(
        'should emit [Loading, Error] when get series recommendations is failed',
        build: () {
          when(mockGetSeriesDetail.execute(tId))
              .thenAnswer((_) async => Right(testSeriesDetail));
          when(mockGetSeriesRecommendations.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          when(mockGetWatchlistSeriesStatus.execute(tId))
              .thenAnswer((_) async => false);
          return getDetailSeriesBloc;
        },
        act: (bloc) => bloc.add(FetchSeriesDetail(tId)),
        expect: () => [
          GetDetailSeriesLoading(),
          GetDetailSeriesError('Failed'),
        ],
        verify: (bloc) {
          verify(mockGetSeriesDetail.execute(tId));
          verify(mockGetSeriesRecommendations.execute(tId));
        },
      );
    },
  );

  group('watchlist', () {
    blocTest<GetDetailSeriesBloc, GetDetailSeriesState>(
      'should emit [WatchlistSuccess] when add watchlist is successful',
      build: () {
        when(mockSaveSeriesWatchlist.execute(testSeriesDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistSeriesStatus.execute(testSeriesDetail.id))
            .thenAnswer((_) async => true);
        return getDetailSeriesBloc;
      },
      act: (bloc) => bloc.add(AddToSeriesWatchlist(testSeriesDetail)),
      expect: () => [
        GetDetailSeriesWatchlistSuccess(
          message: 'Added to Watchlist',
          isAddedToSeriesWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockSaveSeriesWatchlist.execute(testSeriesDetail));
      },
    );

    blocTest<GetDetailSeriesBloc, GetDetailSeriesState>(
      'should emit [WatchlistSuccess] with error message when add watchlist is failed',
      build: () {
        when(mockSaveSeriesWatchlist.execute(testSeriesDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistSeriesStatus.execute(testSeriesDetail.id))
            .thenAnswer((_) async => false);
        return getDetailSeriesBloc;
      },
      act: (bloc) => bloc.add(AddToSeriesWatchlist(testSeriesDetail)),
      expect: () => [
        GetDetailSeriesWatchlistSuccess(
          message: 'Failed',
          isAddedToSeriesWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(mockSaveSeriesWatchlist.execute(testSeriesDetail));
      },
    );

    blocTest<GetDetailSeriesBloc, GetDetailSeriesState>(
      'should emit [WatchlistSuccess] when remove watchlist is successful',
      build: () {
        when(mockRemoveSeriesWatchlist.execute(testSeriesDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchlistSeriesStatus.execute(testSeriesDetail.id))
            .thenAnswer((_) async => false);
        return getDetailSeriesBloc;
      },
      act: (bloc) => bloc.add(RemoveFromSeriesWatchlist(testSeriesDetail)),
      expect: () => [
        GetDetailSeriesWatchlistSuccess(
          message: 'Removed from Watchlist',
          isAddedToSeriesWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(mockRemoveSeriesWatchlist.execute(testSeriesDetail));
      },
    );

    blocTest<GetDetailSeriesBloc, GetDetailSeriesState>(
      'should emit [WatchlistSuccess] with error message when remove watchlist is failed',
      build: () {
        when(mockRemoveSeriesWatchlist.execute(testSeriesDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistSeriesStatus.execute(testSeriesDetail.id))
            .thenAnswer((_) async => true);
        return getDetailSeriesBloc;
      },
      act: (bloc) => bloc.add(RemoveFromSeriesWatchlist(testSeriesDetail)),
      expect: () => [
        GetDetailSeriesWatchlistSuccess(
          message: 'Failed',
          isAddedToSeriesWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockRemoveSeriesWatchlist.execute(testSeriesDetail));
      },
    );

    blocTest<GetDetailSeriesBloc, GetDetailSeriesState>(
      'should emit [Loaded] with updated watchlist status when series detail is already loaded',
      build: () {
        when(mockGetWatchlistSeriesStatus.execute(tId))
            .thenAnswer((_) async => true);
        return getDetailSeriesBloc;
      },
      seed: () => GetDetailSeriesHasData(
        seriesDetail: testSeriesDetail,
        recommendations: tSeriesList,
        isAddedToSeriesWatchlist: false,
      ),
      act: (bloc) => bloc.add(LoadSeriesWatchlistStatus(tId)),
      expect: () => [
        GetDetailSeriesHasData(
          seriesDetail: testSeriesDetail,
          recommendations: tSeriesList,
          isAddedToSeriesWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistSeriesStatus.execute(tId));
      },
    );
  });
}
