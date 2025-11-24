import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/series_detail_model.dart';
import 'package:ditonton/data/models/series_model.dart';
import 'package:ditonton/data/repositories/series_repository_impl.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SeriesRepositoryImpl repository;
  late MockSeriesRemoteDataSource mockRemoteDataSource;
  late MockSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockSeriesRemoteDataSource();
    mockLocalDataSource = MockSeriesLocalDataSource();
    repository = SeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tSeriesModel = SeriesModel(
    adult: true,
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    name: "name",
    originCountry: ['ID'],
    originalLanguage: 'id',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'dummy.jpg',
    voteAverage: 1,
    voteCount: 1,
  );

  final tSeries = Series(
    adult: true,
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    name: "name",
    originCountry: ['ID'],
    originalLanguage: 'id',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'dummy.jpg',
    voteAverage: 1,
    voteCount: 1,
  );

  final tSeriesModelList = <SeriesModel>[tSeriesModel];
  final tSeriesList = <Series>[tSeries];

  group(
    "Airing Today Series",
    () {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getNowPlayingTVSeries())
            .thenAnswer((_) async => tSeriesModelList);
        // act
        final result = await repository.getNowPlayingTVSeries();
        // assert
        verify(mockRemoteDataSource.getNowPlayingTVSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tSeriesList);
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getNowPlayingTVSeries())
            .thenThrow(ServerException());
        // act
        final result = await repository.getNowPlayingTVSeries();
        // assert
        verify(mockRemoteDataSource.getNowPlayingTVSeries());
        expect(result, equals(Left(ServerFailure(''))));
      });

      test(
        'should return connection failure when the device is not connected to internet',
        () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingTVSeries())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getNowPlayingTVSeries();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTVSeries());
          expect(
              result,
              equals(
                  Left(ConnectionFailure('Failed to connect to the network'))));
        },
      );
    },
  );

  group(
    "Popular Series",
    () {
      test(
        "should return series list when call to data source is successful",
        () async {
          // arrange
          when(mockRemoteDataSource.getPopularTVSeries())
              .thenAnswer((_) async => tSeriesModelList);
          // act
          final result = await repository.getPopularTVSeries();
          // assert
          final resultList = result.getOrElse(() => []);
          expect(resultList, tSeriesList);
        },
      );

      test(
        "should return server failure when call to data source is unsuccessful",
        () async {
          // arrange
          when(mockRemoteDataSource.getPopularTVSeries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getPopularTVSeries();
          // assert
          expect(result, Left(ServerFailure('')));
        },
      );

      test(
        'should return connection failure when the device is not connected to internet',
        () async {
          // arrange
          when(mockRemoteDataSource.getPopularTVSeries())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getPopularTVSeries();
          // assert
          expect(
              result,
              equals(
                  Left(ConnectionFailure('Failed to connect to the network'))));
        },
      );
    },
  );

  group(
    "Top Rated Series",
    () {
      test(
        "should return series list when call to data source is successful",
        () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTVSeries())
              .thenAnswer((_) async => tSeriesModelList);
          // act
          final result = await repository.getTopRatedTVSeries();
          // assert
          final resultList = result.getOrElse(() => []);
          expect(resultList, tSeriesList);
        },
      );

      test(
        "should return server failure when call to data source is unsuccessful",
        () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTVSeries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getTopRatedTVSeries();
          // assert
          expect(result, Left(ServerFailure('')));
        },
      );

      test(
        'should return connection failure when the device is not connected to internet',
        () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTVSeries())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTopRatedTVSeries();
          // assert
          expect(
              result,
              equals(
                  Left(ConnectionFailure('Failed to connect to the network'))));
        },
      );
    },
  );

  group(
    "Get Movie Detail",
    () {
      final tId = 1;
      final tSeriesResponse = SeriesDetailResponse(
        adult: true,
        backdropPath: 'backdropPath',
        firstAirDate: "2020-01-01",
        genres: [GenreModel(id: 1, name: 'name')],
        homepage: 'homepage',
        id: 1,
        inProduction: true,
        languages: ['en'],
        lastAirDate: "2020-12-12",
        name: 'name',
        numberOfEpisodes: 10,
        numberOfSeasons: 2,
        originCountry: ['US'],
        originalLanguage: 'en',
        originalName: 'originalName',
        overview: 'overview',
        popularity: 1.0,
        posterPath: 'posterPath',
        seasons: [
          SeasonModel(
              airDate: "2020-01-01",
              episodeCount: 10,
              id: 1,
              name: "name",
              overview: "overview",
              posterPath: "posterPath",
              seasonNumber: 2,
              voteAverage: 1.0)
        ],
        status: 'status',
        tagline: 'tagline',
        type: 'type',
        voteAverage: 1.0,
        voteCount: 1,
      );

      test(
          'should return Movie data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTVSeriesDetail(tId))
            .thenAnswer((_) async => tSeriesResponse);
        // act
        final result = await repository.getTVSeriesDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTVSeriesDetail(tId));
        expect(result, equals(Right(testSeriesDetail)));
      });

      test(
          'should return Server Failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTVSeriesDetail(tId))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTVSeriesDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTVSeriesDetail(tId));
        expect(result, equals(Left(ServerFailure(''))));
      });

      test(
          'should return connection failure when the device is not connected to internet',
          () async {
        // arrange
        when(mockRemoteDataSource.getTVSeriesDetail(tId))
            .thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTVSeriesDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTVSeriesDetail(tId));
        expect(
            result,
            equals(
                Left(ConnectionFailure('Failed to connect to the network'))));
      });
    },
  );

  group(
    "Get TV Series Recommendations",
    () {
      final tSeriesList = <SeriesModel>[];
      final tId = 1;

      test(
        'should return TV Series list when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getTVSeriesRecommendations(tId))
              .thenAnswer((_) async => tSeriesList);
          // act
          final result = await repository.getTVSeriesRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTVSeriesRecommendations(tId));
          final resultList = result.getOrElse(() => []);
          expect(resultList, equals([]));
        },
      );

      test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getTVSeriesRecommendations(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTVSeriesRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTVSeriesRecommendations(tId));
          expect(result, equals(Left(ServerFailure(''))));
        },
      );

      test(
        'should return connection failure when the device is not connected to internet',
        () async {
          // arrange
          when(mockRemoteDataSource.getTVSeriesRecommendations(tId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTVSeriesRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTVSeriesRecommendations(tId));
          expect(
              result,
              equals(
                  Left(ConnectionFailure('Failed to connect to the network'))));
        },
      );
    },
  );

  group(
    "Search TV Series",
    () {
      final tQuery = 'demon';

      test(
        'should return TV Series list when call to data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.searchTVSeries(tQuery))
              .thenAnswer((_) async => tSeriesModelList);
          // act
          final result = await repository.searchTVSeries(tQuery);
          // assert
          final resultList = result.getOrElse(() => []);
          expect(resultList, tSeriesList);
        },
      );

      test(
        'should return server failure when call to data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.searchTVSeries(tQuery))
              .thenThrow(ServerException());
          // act
          final result = await repository.searchTVSeries(tQuery);
          // assert
          expect(result, Left(ServerFailure('')));
        },
      );

      test(
        'should return connection failure when the device is not connected to internet',
        () async {
          // arrange
          when(mockRemoteDataSource.searchTVSeries(tQuery))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.searchTVSeries(tQuery);
          // assert
          expect(
              result,
              equals(
                  Left(ConnectionFailure('Failed to connect to the network'))));
        },
      );
    },
  );

  group(
    "Save TV Series Watchlist",
    () {
      test(
        'should return success message when saving successful',
        () async {
          // arrange
          when(mockLocalDataSource.insertTVSeriesWatchlist(testSeriesTable))
              .thenAnswer((_) async => 'Added to Watchlist');
          // act
          final result =
              await repository.saveTVSeriesWatchlist(testSeriesDetail);
          // assert
          expect(result, Right('Added to Watchlist'));
        },
      );

      test(
        'should return database failure when saving unsuccessful',
        () async {
          // arrange
          when(mockLocalDataSource.insertTVSeriesWatchlist(testSeriesTable))
              .thenThrow(DatabaseException('Failed to add watchlist'));
          // act
          final result =
              await repository.saveTVSeriesWatchlist(testSeriesDetail);
          // assert
          expect(result, Left(DatabaseFailure('Failed to add watchlist')));
        },
      );
    },
  );

  group(
    "Remove TV Series Watchlist",
    () {
      test(
        'should return success message when remove successful',
        () async {
          // arrange
          when(mockLocalDataSource.removeTVSeriesWatchlist(testSeriesTable))
              .thenAnswer((_) async => 'Removed from Watchlist');
          // act
          final result =
              await repository.removeTVSeriesWatchlist(testSeriesDetail);
          // assert
          expect(result, Right('Removed from Watchlist'));
        },
      );

      test(
        'should return database failure when remove unsuccessful',
        () async {
          // arrange
          when(mockLocalDataSource.removeTVSeriesWatchlist(testSeriesTable))
              .thenThrow(DatabaseException('Failed to remove watchlist'));
          // act
          final result =
              await repository.removeTVSeriesWatchlist(testSeriesDetail);
          // assert
          expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
        },
      );
    },
  );

  group(
    "Get TV Series Watchlist status",
    () {
      test('should return TV Series Watchlist status', () async {
        // arrange
        final tId = 1;
        when(mockLocalDataSource.getTVSeriesById(tId))
            .thenAnswer((_) async => null);
        // act
        final result = await repository.isAddedToWatchlist(tId);
        // assert
        expect(result, false);
      });
    },
  );

  group(
    "Get Watchlist TV Series",
    () {
      test('should return list of TV Series from database', () async {
        // arrange
        when(mockLocalDataSource.getWatchlistTVSeries())
            .thenAnswer((_) async => [testSeriesTable]);
        // act
        final result = await repository.getWatchlistTVSeries();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testWatchListSeries]);
      });
    },
  );
}
