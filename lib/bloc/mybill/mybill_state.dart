part of 'mybill_cubit.dart';

@immutable
abstract class MybillState {}

class MybillInitial extends MybillState {}

class MybillChartLoading extends MybillState {}

class MybillChartSuccess extends MybillState {
  ChartModel? chartModel;
  MybillChartSuccess({@required this.chartModel});
}

class MybillChartFailed extends MybillState {
  final String? message;
  MybillChartFailed({@required this.message});
}

class MybillChartError extends MybillState {
  final String? message;
  MybillChartError({@required this.message});
}

// upcomingDues
class UpcomingDueLoading extends MybillState {}

class UpcomingDueSuccess extends MybillState {
  List<UpcomingDuesData>? upcomingDuesData;
  UpcomingDueSuccess({@required this.upcomingDuesData});
}

class UpcomingDueFailed extends MybillState {
  final String? message;
  UpcomingDueFailed({@required this.message});
}

class UpcomingDueError extends MybillState {
  final String? message;
  UpcomingDueError({@required this.message});
}
