import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_series.dart';
import 'package:ditonton/presentation/provider/top_rated_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'series_list_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedSeries])
void main() {
  late MockGetTopRatedSeries mockGetTopRatedSeries;
  late TopRatedSeriesNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedSeries = MockGetTopRatedSeries();
    notifier = TopRatedSeriesNotifier(getTopRatedSeries: mockGetTopRatedSeries)
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
      popularity: 9.0,
      posterPath: "posterPath",
      firstAirDate: "firstAirDate",
      name: "name",
      voteAverage: 12,
      voteCount: 100);

  final tSeriesList = <Series>[tSeries];

  group("Get Top Rated Series", () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      notifier.fetchTopRatedSeries();
      // assert
      expect(notifier.state, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      await notifier.fetchTopRatedSeries();
      // assert
      expect(notifier.state, RequestState.Loaded);
      expect(notifier.series, tSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await notifier.fetchTopRatedSeries();
      // assert
      expect(notifier.state, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
