import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_series_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveSeriesWatchList usecase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    usecase = SaveSeriesWatchList(mockSeriesRepository);
  });

  test('should save series to the repository', () async {
    // arrange
    when(mockSeriesRepository.saveTVSeriesWatchlist(testSeriesDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testSeriesDetail);
    // assert
    verify(mockSeriesRepository.saveTVSeriesWatchlist(testSeriesDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
