import 'package:bbps/model/account_info_model.dart';
import 'package:bbps/model/add_update_upcoming_due_model.dart';
import 'package:bbps/model/fetch_bill_model.dart';
import 'package:bbps/model/saved_bill_details_model.dart';
import 'package:bbps/model/validate_bill_model.dart';
import 'package:flutter/material.dart';

import '../../../model/bbps_settings_model.dart';
import '../../../model/confirm_fetch_bill_model.dart';
import '../../../model/paymentInformationModel.dart';
import '../../model/auto_schedule_pay_model.dart';

@immutable
abstract class billFlowState {}

class billFlowInitial extends billFlowState {}

class SavedBillDetailsLoading extends billFlowState {}

class SavedBillDetailsSuccess extends billFlowState {
  SavedBillDetailsData? SavedBillDetails;
  SavedBillDetailsSuccess({@required this.SavedBillDetails});
}

class SavedBillDetailsFailed extends billFlowState {
  final String? message;
  SavedBillDetailsFailed({@required this.message});
}

class SavedBillDetailsError extends billFlowState {
  final String? message;
  SavedBillDetailsError({@required this.message});
}

class PaymentInfoLoading extends billFlowState {}

class PaymentInfoSuccess extends billFlowState {
  PaymentInformationModel? PaymentInfoDetail;
  PaymentInfoSuccess({@required this.PaymentInfoDetail});
}

class PaymentInfoFailed extends billFlowState {
  final String? message;
  PaymentInfoFailed({@required this.message});
}

class PaymentInfoError extends billFlowState {
  final String? message;
  PaymentInfoError({@required this.message});
}

class BbpsSettingsLoading extends billFlowState {}

class BbpsSettingsSuccess extends billFlowState {
  bbpsSettingsModel? BbpsSettingsDetail;
  BbpsSettingsSuccess({@required this.BbpsSettingsDetail});
}

class BbpsSettingsFailed extends billFlowState {
  final String? message;
  BbpsSettingsFailed({@required this.message});
}

class BbpsSettingsError extends billFlowState {
  final String? message;
  BbpsSettingsError({@required this.message});
}

class AmountByDateLoading extends billFlowState {}

class AmountByDateSuccess extends billFlowState {
  final String? amountByDate;
  AmountByDateSuccess({@required this.amountByDate});
}

class AmountByDateFailed extends billFlowState {
  final String? message;
  AmountByDateFailed({@required this.message});
}

class AmountByDateError extends billFlowState {
  final String? message;
  AmountByDateError({@required this.message});
}

class FetchBillLoading extends billFlowState {}

class FetchBillSuccess extends billFlowState {
  final billerResponseData? fetchBillResponse;
  FetchBillSuccess({@required this.fetchBillResponse});
}

class FetchBillFailed extends billFlowState {
  final String? message;
  FetchBillFailed({@required this.message});
}

class FetchBillError extends billFlowState {
  final String? message;
  FetchBillError({@required this.message});
}

class ConfirmFetchBillLoading extends billFlowState {}

class ConfirmFetchBillSuccess extends billFlowState {
  final ConfirmFetchBillData? ConfirmFetchBillResponse;
  ConfirmFetchBillSuccess({@required this.ConfirmFetchBillResponse});
}

class ConfirmFetchBillFailed extends billFlowState {
  final String? message;
  ConfirmFetchBillFailed({@required this.message});
}

class ConfirmFetchBillError extends billFlowState {
  final String? message;
  ConfirmFetchBillError({@required this.message});
}

class AccountInfoLoading extends billFlowState {}

class AccountInfoSuccess extends billFlowState {
  final List<AccountsData>? accountInfo;
  AccountInfoSuccess({@required this.accountInfo});
}

class AccountInfoFailed extends billFlowState {
  final String? message;
  AccountInfoFailed({@required this.message});
}

class AccountInfoError extends billFlowState {
  final String? message;
  AccountInfoError({@required this.message});
}

class UpdateUpcomingDueLoading extends billFlowState {}

class UpdateUpcomingDueSuccess extends billFlowState {}

class UpdateUpcomingDueFailed extends billFlowState {}

class UpdateUpcomingDueError extends billFlowState {}

class AddUpdateUpcomingDueLoading extends billFlowState {}

class AddUpdateUpcomingDueSuccess extends billFlowState {
  final AddUpdateUpcomingData? addUpdateUpcomingDueData;
  AddUpdateUpcomingDueSuccess({@required this.addUpdateUpcomingDueData});
}

class AddUpdateUpcomingDueFailed extends billFlowState {
  final String? message;
  AddUpdateUpcomingDueFailed({@required this.message});
}

class AddUpdateUpcomingDueError extends billFlowState {
  final String? message;
  AddUpdateUpcomingDueError({@required this.message});
}

class ValidateBillLoading extends billFlowState {}

class ValidateBillSuccess extends billFlowState {
  final ValidateBillResponseData? validateBillResponseData;
  String? bbpsTranlogId;
  ValidateBillSuccess(
      {@required this.validateBillResponseData, this.bbpsTranlogId});
}

class PrepaidValidateBillSuccess extends billFlowState {
  final String? transactionReferenceKey;
  PrepaidValidateBillSuccess({
    @required this.transactionReferenceKey,
  });
}

class ValidateBillFailed extends billFlowState {
  final String? message;
  ValidateBillFailed({@required this.message});
}

class ValidateBillError extends billFlowState {
  final String? message;
  ValidateBillError({@required this.message});
}

class AllAutopayLoading extends billFlowState {}

class AllAutopaySuccess extends billFlowState {
  AutoSchedulePayModel? autoSchedulePayData;
  AllAutopaySuccess({@required this.autoSchedulePayData});
}

class AllAutopayFailed extends billFlowState {
  final String? message;
  AllAutopayFailed({@required this.message});
}

class AllAutopayError extends billFlowState {
  final String? message;
  AllAutopayError({@required this.message});
}
