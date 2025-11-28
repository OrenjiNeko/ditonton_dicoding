import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/bloc/get_detail_movies/get_detail_movies_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'detail_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late GetDetailMovieBloc getDetailMovieBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    getDetailMovieBloc = GetDetailMovieBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  test('initial state should be empty', () {
    expect(getDetailMovieBloc.state, GetDetailMovieInitial());
  });

  const tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  blocTest<GetDetailMovieBloc, GetDetailMovieState>(
    'should emit [Loading, Has Data] when get movie detail and recommendations are successful',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
      return getDetailMovieBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(tId)),
    expect: () => [
      GetDetailMovieLoading(),
      GetDetailMovieHasData(
        movieDetail: testMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: false,
      ),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
      verify(mockGetWatchlistStatus.execute(tId));
    },
  );

  group('getDetailMovies', () {
    blocTest<GetDetailMovieBloc, GetDetailMovieState>(
      'should emit [Loading, Error] when get movie detail is failed',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return getDetailMovieBloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        GetDetailMovieLoading(),
        GetDetailMovieError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );
  });

  group(
    'getMovieRecommendation',
    () {
      blocTest<GetDetailMovieBloc, GetDetailMovieState>(
        'should emit [Loading, Error] when get movie recommendations is failed',
        build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => Right(testMovieDetail));
          when(mockGetMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          when(mockGetWatchlistStatus.execute(tId))
              .thenAnswer((_) async => false);
          return getDetailMovieBloc;
        },
        act: (bloc) => bloc.add(FetchMovieDetail(tId)),
        expect: () => [
          GetDetailMovieLoading(),
          GetDetailMovieError('Failed'),
        ],
        verify: (bloc) {
          verify(mockGetMovieDetail.execute(tId));
          verify(mockGetMovieRecommendations.execute(tId));
        },
      );
    },
  );

  group('watchlist', () {
    blocTest<GetDetailMovieBloc, GetDetailMovieState>(
      'should emit [WatchlistSuccess] when add watchlist is successful',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return getDetailMovieBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testMovieDetail)),
      expect: () => [
        GetDetailMovieWatchlistSuccess(
          message: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<GetDetailMovieBloc, GetDetailMovieState>(
      'should emit [WatchlistSuccess] with error message when add watchlist is failed',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return getDetailMovieBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testMovieDetail)),
      expect: () => [
        GetDetailMovieWatchlistSuccess(
          message: 'Failed',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<GetDetailMovieBloc, GetDetailMovieState>(
      'should emit [WatchlistSuccess] when remove watchlist is successful',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return getDetailMovieBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
      expect: () => [
        GetDetailMovieWatchlistSuccess(
          message: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<GetDetailMovieBloc, GetDetailMovieState>(
      'should emit [WatchlistSuccess] with error message when remove watchlist is failed',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return getDetailMovieBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
      expect: () => [
        GetDetailMovieWatchlistSuccess(
          message: 'Failed',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<GetDetailMovieBloc, GetDetailMovieState>(
      'should emit [Loaded] with updated watchlist status when movie detail is already loaded',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return getDetailMovieBloc;
      },
      seed: () => GetDetailMovieHasData(
        movieDetail: testMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: false,
      ),
      act: (bloc) => bloc.add(LoadWatchlistStatus(tId)),
      expect: () => [
        GetDetailMovieHasData(
          movieDetail: testMovieDetail,
          recommendations: tMovies,
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );
  });
}
