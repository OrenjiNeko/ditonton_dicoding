import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/series_table.dart';

abstract class SeriesLocalDataSource {
  Future<String> insertTVSeriesWatchlist(SeriesTable series);
  Future<String> removeTVSeriesWatchlist(SeriesTable series);
  Future<SeriesTable?> getTVSeriesById(int id);
  Future<List<SeriesTable>> getWatchlistTVSeries();
}

class SeriesLocalDataSourceImpl implements SeriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  SeriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertTVSeriesWatchlist(SeriesTable series) async {
    try {
      await databaseHelper.insertTVSeriesWatchlist(series);
      return 'Added Series to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeTVSeriesWatchlist(SeriesTable series) async {
    try {
      await databaseHelper.removeTVSeriesWatchlist(series);
      return 'Removed Series from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<SeriesTable?> getTVSeriesById(int id) async {
    final result = await databaseHelper.getTVSeriesById(id);
    if (result != null) {
      return SeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<SeriesTable>> getWatchlistTVSeries() async {
    final result = await databaseHelper.getWatchlistTVSeries();
    return result.map((data) => SeriesTable.fromMap(data)).toList();
  }
}
