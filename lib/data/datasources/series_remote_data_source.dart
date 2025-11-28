import 'dart:convert';
import 'dart:io';

import 'package:ditonton/data/models/series_detail_model.dart';
import 'package:ditonton/data/models/series_model.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/series_response.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

abstract class SeriesRemoteDataSource {
  Future<List<SeriesModel>> getNowPlayingTVSeries();
  Future<List<SeriesModel>> getPopularTVSeries();
  Future<List<SeriesModel>> getTopRatedTVSeries();
  Future<SeriesDetailResponse> getTVSeriesDetail(int id);
  Future<List<SeriesModel>> getTVSeriesRecommendations(int id);
  Future<List<SeriesModel>> searchTVSeries(String query);
}

class SeriesRemoteDataSourceImpl implements SeriesRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;
  final bool useSSL;

  SeriesRemoteDataSourceImpl({required this.client, this.useSSL = true});

  @override
  Future<List<SeriesModel>> getNowPlayingTVSeries() async {
    final secureClient = await _getClient();
    final response =
        await secureClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY'));

    if (response.statusCode == 200) {
      return SeriesResponse.fromJson(json.decode(response.body)).seriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SeriesDetailResponse> getTVSeriesDetail(int id) async {
    final secureClient = await _getClient();
    final response =
        await secureClient.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return SeriesDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SeriesModel>> getTVSeriesRecommendations(int id) async {
    final secureClient = await _getClient();
    final response = await secureClient
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return SeriesResponse.fromJson(json.decode(response.body)).seriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SeriesModel>> getPopularTVSeries() async {
    final secureClient = await _getClient();
    final response =
        await secureClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return SeriesResponse.fromJson(json.decode(response.body)).seriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SeriesModel>> getTopRatedTVSeries() async {
    final secureClient = await _getClient();
    final response =
        await secureClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return SeriesResponse.fromJson(json.decode(response.body)).seriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SeriesModel>> searchTVSeries(String query) async {
    final secureClient = await _getClient();
    final response = await secureClient
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return SeriesResponse.fromJson(json.decode(response.body)).seriesList;
    } else {
      throw ServerException();
    }
  }

  Future<http.Client> _getClient() async {
    if (!useSSL) {
      return client;
    }

    try {
      final secureClient = await createSecureClient();
      return secureClient;
    } catch (e) {
      return client;
    }
  }

  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('certificates/tes2.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  Future<http.Client> createSecureClient() async {
    HttpClient httpClient = HttpClient(context: await globalContext);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return IOClient(httpClient);
  }
}
