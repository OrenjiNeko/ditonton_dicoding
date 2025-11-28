import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/bloc/get_now_playing_series/get_now_playing_series_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'airing_today_series_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingSeries])
void main() {
  late GetNowPlayingSeriesBloc getNowPlayingSeriesBloc;
  late MockGetNowPlayingSeries mockGetNowPlayingSeries;

  setUp(() {
    mockGetNowPlayingSeries = MockGetNowPlayingSeries();
    getNowPlayingSeriesBloc = GetNowPlayingSeriesBloc(mockGetNowPlayingSeries);
  });

  test('initial state should be empty', () {
    expect(getNowPlayingSeriesBloc.state, GetNowPlayingSeriesEmpty());
  });

  final tSeries = Series(
      adult: false,
      backdropPath: "backdropPath",
      genreIds: [1, 2, 3],
      id: 1,
      originCountry: ["US"],
      originalLanguage: "us",
      originalName: "originalName",
      overview: "overview",
      popularity: 1,
      posterPath: "posterPath",
      firstAirDate: "firstAirDate",
      name: "name",
      voteAverage: 2.0,
      voteCount: 2);
  final tSeriesList = <Series>[tSeries];

  blocTest<GetNowPlayingSeriesBloc, GetNowPlayingSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return getNowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingSeries()),
    expect: () => [
      GetNowPlayingSeriesLoading(),
      GetNowPlayingSeriesHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingSeries.execute());
    },
  );
  blocTest<GetNowPlayingSeriesBloc, GetNowPlayingSeriesState>(
    'Should emit [Loading, Error] when get now playing series is unsuccessful',
    build: () {
      when(mockGetNowPlayingSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getNowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingSeries()),
    expect: () => [
      GetNowPlayingSeriesLoading(),
      GetNowPlayingSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingSeries.execute());
    },
  );
}
