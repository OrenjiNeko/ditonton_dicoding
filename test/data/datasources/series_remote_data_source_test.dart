import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/series_remote_data_source.dart';
import 'package:ditonton/data/models/series_detail_model.dart';
import 'package:ditonton/data/models/series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late SeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource =
        SeriesRemoteDataSourceImpl(client: mockHttpClient, useSSL: false);
  });

  group(
    "Get Airing Today Series",
    () {
      final tSeriesList = SeriesResponse.fromJson(
              json.decode(readJson('dummy_data/series_airing_today.json')))
          .seriesList;

      test("Should Return List of Series Model When the Response Code is 200",
          () async {
        // arrange
        when(mockHttpClient
                .get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
            .thenAnswer((_) async => http.Response(
                readJson('dummy_data/series_airing_today.json'), 200));
        // act
        final result = await dataSource.getNowPlayingTVSeries();
        // assert
        expect(result, equals(tSeriesList));
      });

      test(
          "Should Throw ServerException When the Response Code is 404 or Other",
          () async {
        // arrange
        when(mockHttpClient
                .get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getNowPlayingTVSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    },
  );

  group(
    "Get Popular Series",
    () {
      final tSeriesList = SeriesResponse.fromJson(
              json.decode(readJson('dummy_data/series_popular.json')))
          .seriesList;

      test("Should Return List of Series Model When the Response Code is 200",
          () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
            .thenAnswer((_) async =>
                http.Response(readJson('dummy_data/series_popular.json'), 200));
        // act
        final result = await dataSource.getPopularTVSeries();
        // assert
        expect(result, equals(tSeriesList));
      });

      test(
          "Should Throw ServerException When the Response Code is 404 or Other",
          () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getPopularTVSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    },
  );

  group(
    "Get Top Rated Series",
    () {
      final tSeriesList = SeriesResponse.fromJson(
              json.decode(readJson('dummy_data/series_top_rated.json')))
          .seriesList;

      test("Should Return List of Series Model When the Response Code is 200",
          () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
            .thenAnswer((_) async => http.Response(
                readJson('dummy_data/series_top_rated.json'), 200));
        // act
        final result = await dataSource.getTopRatedTVSeries();
        // assert
        expect(result, equals(tSeriesList));
      });

      test(
          "Should Throw ServerException When the Response Code is 404 or Other",
          () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTopRatedTVSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    },
  );

  group(
    "Get Series Detail",
    () {
      final tId = 1;
      final tSeriesDetail = SeriesDetailResponse.fromJson(
          json.decode(readJson('dummy_data/series_detail.json')));

      test("Should Return Series Detail When the Response Code is 200",
          () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
            .thenAnswer((_) async =>
                http.Response(readJson('dummy_data/series_detail.json'), 200));
        // act
        final result = await dataSource.getTVSeriesDetail(tId);
        // assert
        expect(result, equals(tSeriesDetail));
      });

      test(
          "Should Throw ServerException When the Response Code is 404 or Other",
          () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTVSeriesDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    },
  );

  group(
    "Get Series Recommendations",
    () {
      final tSeriesList = SeriesResponse.fromJson(
              json.decode(readJson('dummy_data/series_recommendations.json')))
          .seriesList;
      final tId = 1;

      test("Should Return List of Series Model When the Response Code is 200",
          () async {
        // arrange
        when(mockHttpClient
                .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
            .thenAnswer((_) async => http.Response(
                readJson('dummy_data/series_recommendations.json'), 200));
        // act
        final result = await dataSource.getTVSeriesRecommendations(tId);
        // assert
        expect(result, equals(tSeriesList));
      });

      test(
          "Should Throw ServerException When the Response Code is 404 or Other",
          () async {
        // arrange
        when(mockHttpClient
                .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTVSeriesRecommendations(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    },
  );

  group(
    "Get TV Series Search",
    () {
      final tSearchResult = SeriesResponse.fromJson(
              json.decode(readJson('dummy_data/search_series.json')))
          .seriesList;
      final tQuery = 'Spiderman';

      test("Should Return List of Series Model When the Response Code is 200",
          () async {
        // arrange
        when(mockHttpClient
                .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
            .thenAnswer((_) async =>
                http.Response(readJson('dummy_data/search_series.json'), 200));
        // act
        final result = await dataSource.searchTVSeries(tQuery);
        // assert
        expect(result, equals(tSearchResult));
      });

      test(
          "Should Throw ServerException When the Response Code is 404 or Other",
          () async {
        // arrange
        when(mockHttpClient
                .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchTVSeries(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    },
  );
}
