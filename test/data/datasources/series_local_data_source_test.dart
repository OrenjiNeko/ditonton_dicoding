import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/series_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = SeriesLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group("Save TV Series Watchlist", () {
    test('should return success message when insert to database is successful',
        () async {
      // arrange
      when(mockDatabaseHelper.insertTVSeriesWatchlist(testSeriesTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertTVSeriesWatchlist(testSeriesTable);
      // assert
      expect(result, 'Added Series to Watchlist');
    });

    test('should throw DatabaseException when insert to database fails',
        () async {
      // arrange
      when(mockDatabaseHelper.insertTVSeriesWatchlist(testSeriesTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertTVSeriesWatchlist(testSeriesTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group("Remove TV Series Watchlist", () {
    test(
        'should return success message when remove from database is successful',
        () async {
      // arrange
      when(mockDatabaseHelper.removeTVSeriesWatchlist(testSeriesTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeTVSeriesWatchlist(testSeriesTable);
      // assert
      expect(result, 'Removed Series from Watchlist');
    });

    test('should throw DatabaseException when remove from database fails',
        () async {
      // arrange
      when(mockDatabaseHelper.removeTVSeriesWatchlist(testSeriesTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeTVSeriesWatchlist(testSeriesTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get TV Series Detail By Id', () {
    final tId = 1;

    test('should return TV Series Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTVSeriesById(tId))
          .thenAnswer((_) async => testSeriesMap);
      // act
      final result = await dataSource.getTVSeriesById(tId);
      // assert
      expect(result, equals(testSeriesTable));
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTVSeriesById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTVSeriesById(tId);
      // assert
      expect(result, equals(null));
    });
  });

  group('Get Watchlist TV Series', () {
    test('should return list of TV Series Table from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTVSeries())
          .thenAnswer((_) async => [testSeriesMap]);
      // act
      final result = await dataSource.getWatchlistTVSeries();
      // assert
      expect(result, equals([testSeriesTable]));
    });
  });
}
