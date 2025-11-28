import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/bloc/get_popular_series/get_popular_series_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_popular_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularSeries])
void main() {
  late MockGetPopularSeries mockGetPopularSeries;
  late GetPopularSeriesBloc popularSeriesBloc;
  setUp(() {
    mockGetPopularSeries = MockGetPopularSeries();
    popularSeriesBloc = GetPopularSeriesBloc(mockGetPopularSeries);
  });
  test('initial state should be empty', () {
    expect(popularSeriesBloc.state, GetPopularSeriesEmpty());
  });

  final tSeriesModel = Series(
    originCountry: ['US'],
    originalLanguage: 'en',
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    firstAirDate: '2021-09-17',
    genreIds: [14, 28],
    id: 557,
    name: 'demon',
    originalName: 'demon',
    overview: 'overview',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tSeriesList = <Series>[tSeriesModel];

  blocTest<GetPopularSeriesBloc, GetPopularSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularSeries()),
    expect: () => [
      GetPopularSeriesLoading(),
      GetPopularSeriesHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetPopularSeries.execute());
    },
  );
  blocTest<GetPopularSeriesBloc, GetPopularSeriesState>(
    'Should emit [Loading, Error] when get popular series is unsuccessful',
    build: () {
      when(mockGetPopularSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularSeries()),
    expect: () => [
      GetPopularSeriesLoading(),
      GetPopularSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularSeries.execute());
    },
  );
}
