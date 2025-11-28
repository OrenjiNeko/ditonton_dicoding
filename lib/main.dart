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
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/airing_today_series_page.dart';
import 'package:ditonton/presentation/pages/home_series_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/search_series_page.dart';
import 'package:ditonton/presentation/pages/series_detail_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_series_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_series_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //movie bloc
        BlocProvider(
          create: (_) => di.locator<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<GetPopularMoviesBloc>(),
        ),
        BlocProvider(create: (_) => di.locator<GetTopRatedMovieBloc>()),
        BlocProvider(
          create: (_) => di.locator<GetListMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<GetWatchlistMoviesBloc>(),
        ),
        BlocProvider(create: (_) => di.locator<GetDetailMovieBloc>()),

        //series bloc
        BlocProvider(
          create: (_) => di.locator<SearchSeriesBloc>(),
        ),
        BlocProvider(create: (_) => di.locator<GetNowPlayingSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<GetPopularSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<GetTopRatedSeriesBloc>()),
        BlocProvider(
          create: (_) => di.locator<GetWatchlistSeriesBloc>(),
        ),
        BlocProvider(create: (_) => di.locator<GetListSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<GetDetailSeriesBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case '/home_series':
              return MaterialPageRoute(builder: (_) => HomeSeriesPage());
            case SeriesDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => SeriesDetailPage(id: id),
                settings: settings,
              );
            case PopularSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularSeriesPage());
            case TopRatedSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedSeriesPage());
            case AiringTodaySeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => AiringTodaySeriesPage());
            case SearchSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchSeriesPage());
            case WatchlistSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistSeriesPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
