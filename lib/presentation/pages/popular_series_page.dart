import 'package:ditonton/bloc/get_popular_series/get_popular_series_bloc.dart';
import 'package:ditonton/presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-series';

  @override
  _PopularSeriesPageState createState() => _PopularSeriesPageState();
}

class _PopularSeriesPageState extends State<PopularSeriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetPopularSeriesBloc>().add(FetchPopularSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetPopularSeriesBloc, GetPopularSeriesState>(
          builder: (context, state) {
            if (state is GetPopularSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetPopularSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final series = state.result[index];
                  return SeriesCard(series);
                },
                itemCount: state.result.length,
              );
            } else if (state is GetPopularSeriesError) {
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
