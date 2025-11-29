import 'package:ditonton/bloc/get_detail_movies/get_detail_movies_bloc.dart';
import 'package:ditonton/bloc/get_detail_series/get_detail_series_bloc.dart';
import 'package:ditonton/bloc/get_list_movies/get_list_movies_bloc.dart';
import 'package:ditonton/bloc/get_list_series/get_list_series_bloc.dart';
import 'package:ditonton/bloc/get_now_playing_series/get_now_playing_series_bloc.dart';
import 'package:ditonton/bloc/get_popular_movies/get_popular_movies_bloc.dart';
import 'package:ditonton/bloc/get_popular_series/get_popular_series_bloc.dart';
import 'package:ditonton/bloc/get_top_rated_movie/get_top_rated_movie_bloc.dart';
import 'package:ditonton/bloc/get_top_rated_series/get_top_rated_series_bloc.dart';
import 'package:ditonton/bloc/get_watchlist_movies/get_watchlist_movies_bloc.dart';
import 'package:ditonton/bloc/get_watchlist_series/get_watchlist_series_bloc.dart';
import 'package:ditonton/bloc/search/search_bloc.dart';
import 'package:ditonton/bloc/search_series/search_series_bloc.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/series_local_data_source.dart';
import 'package:ditonton/data/datasources/series_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/series_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/series_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_now_playing_series.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_series.dart';
import 'package:ditonton/domain/usecases/get_series_detail.dart';
import 'package:ditonton/domain/usecases/get_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_series_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_series_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_series_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_series.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  //movie bloc
  locator.registerFactory(
    () => SearchBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => GetPopularMoviesBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => GetTopRatedMovieBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => GetWatchlistMoviesBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => GetDetailMovieBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

  locator.registerFactory(
    () => GetListMovieBloc(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );

  //series bloc
  locator.registerFactory(
    () => SearchSeriesBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => GetNowPlayingSeriesBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => GetPopularSeriesBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => GetTopRatedSeriesBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => GetWatchlistSeriesBloc(
      locator(),
    ),
  );

  locator.registerFactory(() => GetListSeriesBloc(
        getNowPlayingSeries: locator(),
        getPopularSeries: locator(),
        getTopRatedSeries: locator(),
      ));

  locator.registerFactory(() => GetDetailSeriesBloc(
        getSeriesDetail: locator(),
        getSeriesRecommendations: locator(),
        getWatchListStatus: locator(),
        saveWatchlist: locator(),
        removeWatchlist: locator(),
      ));

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetNowPlayingSeries(locator()));
  locator.registerLazySingleton(() => GetPopularSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedSeries(locator()));
  locator.registerLazySingleton(() => GetSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistSeriesStatus(locator()));
  locator.registerLazySingleton(() => SaveSeriesWatchList(locator()));
  locator.registerLazySingleton(() => RemoveSeriesWatchList(locator()));
  locator.registerLazySingleton(() => GetWatchlistSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<SeriesRepository>(
    () => SeriesRepositoryImpl(
        remoteDataSource: locator(), localDataSource: locator()),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator(), useSSL: true));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<SeriesRemoteDataSource>(
      () => SeriesRemoteDataSourceImpl(client: locator(), useSSL: true));
  locator.registerLazySingleton<SeriesLocalDataSource>(
      () => SeriesLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
