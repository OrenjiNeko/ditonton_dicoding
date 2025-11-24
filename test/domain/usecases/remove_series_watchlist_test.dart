import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/remove_series_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveSeriesWatchList usecase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    usecase = RemoveSeriesWatchList(mockSeriesRepository);
  });

  test('should remove watchlist series from repository', () async {
    // arrange
    when(mockSeriesRepository.removeTVSeriesWatchlist(testSeriesDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testSeriesDetail);
    // assert
    verify(mockSeriesRepository.removeTVSeriesWatchlist(testSeriesDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
