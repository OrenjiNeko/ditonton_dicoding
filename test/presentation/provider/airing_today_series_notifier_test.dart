import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_series.dart';
import 'package:ditonton/presentation/provider/airing_today_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'airing_today_series_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingSeries])
void main() {
  late MockGetNowPlayingSeries mockGetNowPlayingSeries;
  late AiringTodaySeriesNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingSeries = MockGetNowPlayingSeries();
    notifier = AiringTodaySeriesNotifier(mockGetNowPlayingSeries)
      ..addListener(() {
        listenerCallCount++;
      });
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

  group(
    "Get Popular Series",
    () {
      test('should change state to loading when usecase is called', () async {
        // arrange
        when(mockGetNowPlayingSeries.execute())
            .thenAnswer((_) async => Right(tSeriesList));
        // act
        notifier.fetchNowPlayingSeries();
        // assert
        expect(notifier.state, RequestState.Loading);
        expect(listenerCallCount, 1);
      });

      test('should change series data when data is gotten successfully',
          () async {
        // arrange
        when(mockGetNowPlayingSeries.execute())
            .thenAnswer((_) async => Right(tSeriesList));
        // act
        await notifier.fetchNowPlayingSeries();
        // assert
        expect(notifier.state, RequestState.Loaded);
        expect(notifier.series, tSeriesList);
        expect(listenerCallCount, 2);
      });

      test('should return error when data is unsuccessful', () async {
        // arrange
        when(mockGetNowPlayingSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        // act
        await notifier.fetchNowPlayingSeries();
        // assert
        expect(notifier.state, RequestState.Error);
        expect(notifier.message, 'Server Failure');
        expect(listenerCallCount, 2);
      });
    },
  );
}
