import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/bloc/get_watchlist_movies/get_watchlist_movies_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late GetWatchlistMoviesBloc getWatchlistMoviesBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    getWatchlistMoviesBloc = GetWatchlistMoviesBloc(mockGetWatchlistMovies);
  });

  test('initial state should be empty', () {
    expect(getWatchlistMoviesBloc.state, GetWatchlistMoviesEmpty());
  });

  blocTest<GetWatchlistMoviesBloc, GetWatchlistMoviesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right([testWatchlistMovie]));
      return getWatchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      GetWatchlistMoviesLoading(),
      GetWatchlistMoviesHasData([testWatchlistMovie]),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute()).called(1);
    },
  );

  blocTest<GetWatchlistMoviesBloc, GetWatchlistMoviesState>(
    'should emit [Loading, Error] when get watchlist movies is failed',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      return getWatchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      GetWatchlistMoviesLoading(),
      GetWatchlistMoviesError("Can't get data"),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute()).called(1);
    },
  );
}
