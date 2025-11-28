import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/bloc/get_top_rated_series/get_top_rated_series_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedSeries])
void main() {
  late GetTopRatedSeriesBloc getTopRatedSeriesBloc;
  late MockGetTopRatedSeries mockGetTopRatedSeries;

  setUp(() {
    mockGetTopRatedSeries = MockGetTopRatedSeries();
    getTopRatedSeriesBloc = GetTopRatedSeriesBloc(mockGetTopRatedSeries);
  });

  test('initial state should be empty', () {
    expect(getTopRatedSeriesBloc.state, GetTopRatedSeriesEmpty());
  });

  final tSeriesModel = Series(
    adult: false,
    backdropPath: "backdropPath",
    genreIds: [1, 2, 3],
    id: 1,
    originCountry: ["US"],
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    overview: "overview",
    popularity: 1,
    posterPath: "posterPath",
    firstAirDate: "firstAirDate",
    name: "name",
    voteAverage: 1,
    voteCount: 2,
  );
  final tSeriesList = <Series>[tSeriesModel];

  blocTest<GetTopRatedSeriesBloc, GetTopRatedSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return getTopRatedSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedSeries()),
    expect: () => [
      GetTopRatedSeriesLoading(),
      GetTopRatedSeriesHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedSeries.execute());
    },
  );

  blocTest<GetTopRatedSeriesBloc, GetTopRatedSeriesState>(
    'Should emit [Loading, Error] when get Top Rated series is unsuccessful',
    build: () {
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getTopRatedSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedSeries()),
    expect: () => [
      GetTopRatedSeriesLoading(),
      GetTopRatedSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedSeries.execute());
    },
  );
}
