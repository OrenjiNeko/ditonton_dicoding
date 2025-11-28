import 'package:ditonton/bloc/get_now_playing_series/get_now_playing_series_bloc.dart';
import 'package:ditonton/presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiringTodaySeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/airing-today-series';

  @override
  _AiringTodaySeriesPageState createState() => _AiringTodaySeriesPageState();
}

class _AiringTodaySeriesPageState extends State<AiringTodaySeriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetNowPlayingSeriesBloc>().add(FetchNowPlayingSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airing Today TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetNowPlayingSeriesBloc, GetNowPlayingSeriesState>(
          builder: (context, state) {
            if (state is GetNowPlayingSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetNowPlayingSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final series = state.result[index];
                  return SeriesCard(series);
                },
                itemCount: state.result.length,
              );
            } else if (state is GetNowPlayingSeriesError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                child: Text("No Data"),
              );
            }
          },
        ),
      ),
    );
  }
}
