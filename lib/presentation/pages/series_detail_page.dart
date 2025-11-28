import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/bloc/get_detail_series/get_detail_series_bloc.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/entities/series_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail_series';

  final int id;
  SeriesDetailPage({required this.id});

  @override
  _SeriesDetailPageState createState() => _SeriesDetailPageState();
}

class _SeriesDetailPageState extends State<SeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetDetailSeriesBloc>().add(FetchSeriesDetail(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GetDetailSeriesBloc, GetDetailSeriesState>(
        listener: (context, state) {
          if (state is GetDetailSeriesWatchlistSuccess) {
            final message = state.message;

            if (message == GetDetailSeriesBloc.watchlistAddSuccessMessage ||
                message == GetDetailSeriesBloc.watchlistRemoveSuccessMessage) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(message),
                  );
                },
              );
            }
          }
        },
        builder: (context, state) {
          if (state is GetDetailSeriesLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetDetailSeriesHasData) {
            final series = state.seriesDetail;
            return SafeArea(
              child: DetailContent(
                series,
                state.recommendations,
                state.isAddedToSeriesWatchlist,
              ),
            );
          } else if (state is GetDetailSeriesError) {
            return Text(state.message);
          } else {
            return Center(
              child: Text('No Data'),
            );
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final SeriesDetail series;
  final List<Series> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.series, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${series.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              series.name ?? '-',
                              style: kHeading5,
                            ),
                            FilledButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<GetDetailSeriesBloc>()
                                      .add(AddToSeriesWatchlist(series));
                                } else {
                                  context
                                      .read<GetDetailSeriesBloc>()
                                      .add(RemoveFromSeriesWatchlist(series));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(series.genres ?? []),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: (series.voteAverage ?? 0) / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${series.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              series.overview ?? "-",
                            ),
                            SizedBox(height: 16),
                            ListSeason(
                              seasons: series.seasons ?? [],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            if (recommendations.isEmpty) ...[
                              Container(
                                height: 150,
                                child: Center(
                                  child: Text('No recommendations available'),
                                ),
                              ),
                            ] else ...[
                              Container(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final movie = recommendations[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            SeriesDetailPage.ROUTE_NAME,
                                            arguments: movie.id,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                            placeholder: (context, url) =>
                                                Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: recommendations.length,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}

class ListSeason extends StatelessWidget {
  final List<Season> seasons;
  const ListSeason({
    Key? key,
    required this.seasons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: seasons.length,
        itemBuilder: (context, index) {
          final season = seasons[index];
          return Container(
            width: 200,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CachedNetworkImage(
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${season.posterPath}',
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Container(
                    color: Colors.black54,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Season ${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${season.episodeCount} Episodes',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
