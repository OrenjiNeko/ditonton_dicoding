import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/entities/series_detail.dart';

abstract class SeriesRepository {
  Future<Either<Failure, List<Series>>> getNowPlayingTVSeries();
  Future<Either<Failure, List<Series>>> getPopularTVSeries();
  Future<Either<Failure, List<Series>>> getTopRatedTVSeries();
  Future<Either<Failure, SeriesDetail>> getTVSeriesDetail(int id);
  Future<Either<Failure, List<Series>>> getTVSeriesRecommendations(int id);
  Future<Either<Failure, List<Series>>> searchTVSeries(String query);
  Future<Either<Failure, String>> saveTVSeriesWatchlist(
      SeriesDetail SeriesDetail);
  Future<Either<Failure, String>> removeTVSeriesWatchlist(
      SeriesDetail SeriesDetail);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Series>>> getWatchlistTVSeries();
}
