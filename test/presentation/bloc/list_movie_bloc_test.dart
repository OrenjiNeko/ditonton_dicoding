import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/bloc/get_list_movies/get_list_movies_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'list_movie_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late GetListMovieBloc getListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    getListBloc = GetListMovieBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  test('initial state should be empty', () {
    expect(getListBloc.state, GetListMoviesEmpty());
  });

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
  final tMovieList = <Movie>[tMovie];

  group(
    'get now playing movies',
    () {
      blocTest<GetListMovieBloc, GetListMoviesState>(
        'should emit [loading, hasData] when data is gotten successfully',
        build: () => getListBloc,
        act: (bloc) {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));
          bloc.add(FetchNowPlayingMovies());
        },
        expect: () => [
          GetListMoviesLoading(),
          GetListMoviesHasData(nowPlayingMovies: tMovieList),
        ],
        verify: (bloc) {
          verify(mockGetNowPlayingMovies.execute());
        },
      );

      blocTest<GetListMovieBloc, GetListMoviesState>(
        'should emit [loading, error] when get now playing movies is unsuccessful',
        build: () => getListBloc,
        act: (bloc) {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          bloc.add(FetchNowPlayingMovies());
        },
        expect: () => [
          GetListMoviesLoading(),
          GetListMoviesError('Server Failure'),
        ],
        verify: (bloc) {
          verify(mockGetNowPlayingMovies.execute());
        },
      );
    },
  );

  group(
    'get popular movies',
    () {
      blocTest<GetListMovieBloc, GetListMoviesState>(
        'should emit [loading, hasData] when data is gotten successfully',
        build: () => getListBloc,
        act: (bloc) {
          when(mockGetPopularMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));
          bloc.add(FetchPopularMovies());
        },
        expect: () => [
          GetListMoviesLoading(),
          GetListMoviesHasData(popularMovies: tMovieList),
        ],
        verify: (bloc) {
          verify(mockGetPopularMovies.execute());
        },
      );

      blocTest<GetListMovieBloc, GetListMoviesState>(
        'should emit [loading, error] when get popular movies is unsuccessful',
        build: () => getListBloc,
        act: (bloc) {
          when(mockGetPopularMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          bloc.add(FetchPopularMovies());
        },
        expect: () => [
          GetListMoviesLoading(),
          GetListMoviesError('Server Failure'),
        ],
        verify: (bloc) {
          verify(mockGetPopularMovies.execute());
        },
      );
    },
  );

  group(
    'get top rated movies',
    () {
      blocTest<GetListMovieBloc, GetListMoviesState>(
        'should emit [loading, hasData] when data is gotten successfully',
        build: () => getListBloc,
        act: (bloc) {
          when(mockGetTopRatedMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));
          bloc.add(FetchTopRatedMovies());
        },
        expect: () => [
          GetListMoviesLoading(),
          GetListMoviesHasData(topRatedMovies: tMovieList),
        ],
        verify: (bloc) {
          verify(mockGetTopRatedMovies.execute());
        },
      );

      blocTest<GetListMovieBloc, GetListMoviesState>(
        'should emit [loading, error] when get top rated movies is unsuccessful',
        build: () => getListBloc,
        act: (bloc) {
          when(mockGetTopRatedMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          bloc.add(FetchTopRatedMovies());
        },
        expect: () => [
          GetListMoviesLoading(),
          GetListMoviesError('Server Failure'),
        ],
        verify: (bloc) {
          verify(mockGetTopRatedMovies.execute());
        },
      );
    },
  );
}
