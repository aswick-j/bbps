part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class CategoriesLoading extends HomeState {}

class CategoriesSuccess extends HomeState {
  List<CategorieData>? CategoriesList;
  CategoriesSuccess({@required this.CategoriesList});
}

class CategoriesFailed extends HomeState {
  final String? message;
  CategoriesFailed({@required this.message});
}

class CategoriesError extends HomeState {
  final String? message;
  CategoriesError({@required this.message});
}

class LocationLoading extends HomeState {}

class LocationSuccess extends HomeState {
  List<String>? LocationList;
  LocationSuccess({@required this.LocationList});
}

class LocationFailed extends HomeState {
  final String? message;
  LocationFailed({@required this.message});
}

class LocationError extends HomeState {
  final String? message;
  LocationError({@required this.message});
}

// savedbillers
class SavedBillerLoading extends HomeState {}

class SavedBillersLoading extends HomeState {}

class SavedBillersSuccess extends HomeState {
  List<SavedBillersData>? savedBillersData;
  SavedBillersSuccess({@required this.savedBillersData});
}

class SavedBillersFailed extends HomeState {
  final String? message;
  SavedBillersFailed({@required this.message});
}

class SavedBillersError extends HomeState {
  final String? message;
  SavedBillersError({@required this.message});
}

// upcomingDues
class UpcomingDuesLoading extends HomeState {}

class UpcomingDuesSuccess extends HomeState {
  List<UpcomingDuesData>? upcomingDuesData;
  UpcomingDuesSuccess({@required this.upcomingDuesData});
}

class UpcomingDuesFailed extends HomeState {
  final String? message;
  UpcomingDuesFailed({@required this.message});
}

class UpcomingDuesError extends HomeState {
  final String? message;
  UpcomingDuesError({@required this.message});
}

//autoPay
class AutoPayLoading extends HomeState {}

class AutopaySuccess extends HomeState {
  AutoSchedulePayData? autoScheduleData;

  AutopaySuccess({@required this.autoScheduleData});
}

class AutopayFailed extends HomeState {
  final String? message;
  AutopayFailed({@required this.message});
}

class AutopayError extends HomeState {
  final String? message;
  AutopayError({@required this.message});
}

// slider loading
class SliderLoading extends HomeState {
  final bool? isTrue;
  SliderLoading({@required this.isTrue});
}

class SliderData extends HomeState {
  List<dynamic>? sliderData;
  SliderData({@required this.sliderData});
}

// Allbiller
class AllbillerLoading extends HomeState {
  List<BillersData> prevData;
  bool isFirstFetch;

  AllbillerLoading(this.prevData, {this.isFirstFetch = false});
}

class AllbillerSuccess extends HomeState {
  List<BillersData>? allbillerList;
  AllbillerSuccess({this.allbillerList});
}

class AllbillerFailed extends HomeState {
  final String? message;
  AllbillerFailed({@required this.message});
}

class AllbillerError extends HomeState {
  final String? message;
  AllbillerError({@required this.message});
}

// InputSignature
class InputSignatureLoading extends HomeState {}

class InputSignatureSuccess extends HomeState {
  List<InputSignaturesData>? InputSignatureList;
  InputSignatureSuccess({@required this.InputSignatureList});
}

class InputSignatureFailed extends HomeState {
  final String? message;
  InputSignatureFailed({@required this.message});
}

class InputSignatureError extends HomeState {
  final String? message;
  InputSignatureError({@required this.message});
}

// InputSignature
class EditBillLoading extends HomeState {}

class EditBillSuccess extends HomeState {
  EditbillData? EditBillList;
  EditBillSuccess({@required this.EditBillList});
}

class EditBillFailed extends HomeState {
  final String? message;
  EditBillFailed({@required this.message});
}

class EditBillError extends HomeState {
  final String? message;
  EditBillError({@required this.message});
}

class UpdateBillLoading extends HomeState {}

class UpdateBillSuccess extends HomeState {
  UpdateBillModel? UpdateBillDetails;
  UpdateBillSuccess({@required this.UpdateBillDetails});
}

class UpdateBillFailed extends HomeState {
  final String? message;
  UpdateBillFailed({@required this.message});
}

class UpdateBillError extends HomeState {
  final String? message;
  UpdateBillError({@required this.message});
}

class BbpsSettingsLoading extends HomeState {}

class BbpsSettingsSuccess extends HomeState {
  bbpsSettingsModel? BbpsSettingsDetails;
  BbpsSettingsSuccess({@required this.BbpsSettingsDetails});
}

class BbpsSettingsFailed extends HomeState {
  final String? message;
  BbpsSettingsFailed({@required this.message});
}

class BbpsSettingsError extends HomeState {
  final String? message;
  BbpsSettingsError({@required this.message});
}

class BillersSearchLoading extends HomeState {}

class BillersSearchSuccess extends HomeState {
  List<BillersData>? searchResultsData;
  BillersSearchSuccess({@required this.searchResultsData});
}

class BillersSearchError extends HomeState {
  String? message;
  BillersSearchError({@required this.message});
}

class BillersSearchFailed extends HomeState {
  String? message;
  BillersSearchFailed({@required this.message});
}

class DeleteUpcomingDueLoading extends HomeState {}

class DeleteUpcomingDueSuccess extends HomeState {
  String? message;
  DeleteUpcomingDueSuccess({@required this.message});
}

class DeleteUpcomingDueError extends HomeState {
  String? message;
  DeleteUpcomingDueError({@required this.message});
}

class DeleteUpcomingDueFailed extends HomeState {
  String? message;
  DeleteUpcomingDueFailed({@required this.message});
}

// states-data

class StatesDataLoading extends HomeState {}

class StatesDataSuccess extends HomeState {
  List<StatesData>? statesData;
  StatesDataSuccess({this.statesData});
}

class StatesDataFailed extends HomeState {
  final String? message;
  StatesDataFailed({@required this.message});
}

class StatesDataError extends HomeState {
  final String? message;
  StatesDataError({@required this.message});
}

//fetchPrepaidFetchPlans
class PrepaidFetchPlansLoading extends HomeState {}

class PrepaidFetchPlansSuccess extends HomeState {
  List<PrepaidPlansData>? prepaidPlansData;
  PrepaidFetchPlansSuccess({this.prepaidPlansData});
}

class PrepaidFetchPlansFailed extends HomeState {
  final String? message;
  PrepaidFetchPlansFailed({@required this.message});
}

class PrepaidFetchPlansError extends HomeState {
  final String? message;
  PrepaidFetchPlansError({@required this.message});
}

class MybillChartLoading extends HomeState {}

class MybillChartSuccess extends HomeState {
  ChartModel? chartModel;
  MybillChartSuccess({@required this.chartModel});
}

class MybillChartFailed extends HomeState {
  final String? message;
  MybillChartFailed({@required this.message});
}

class MybillChartError extends HomeState {
  final String? message;
  MybillChartError({@required this.message});
}
