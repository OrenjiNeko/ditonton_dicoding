import 'dart:convert';

import 'package:ditonton/data/models/series_model.dart';
import 'package:ditonton/data/models/series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tSeriesModel = SeriesModel(
      adult: false,
      backdropPath: "/dummy.jpg",
      genreIds: [1, 2, 3],
      id: 1,
      originCountry: ["ID"],
      originalLanguage: "id",
      originalName: "Original Name",
      overview: "This is a dummy overview for testing purposes.",
      popularity: 289.8181,
      posterPath: "/dummy.jpg",
      firstAirDate: "2025-10-26",
      name: "Original Name",
      voteAverage: 7.974,
      voteCount: 438);

  final tSeriesResponseModel =
      SeriesResponse(seriesList: <SeriesModel>[tSeriesModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/series_airing_today.json'));
      // act
      final result = SeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/dummy.jpg",
            "genre_ids": [1, 2, 3],
            "id": 1,
            "origin_country": ["ID"],
            "original_language": "id",
            "original_name": "Original Name",
            "overview": "This is a dummy overview for testing purposes.",
            "popularity": 289.8181,
            "poster_path": "/dummy.jpg",
            "first_air_date": "2025-10-26",
            "name": "Original Name",
            "vote_average": 7.974,
            "vote_count": 438
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
