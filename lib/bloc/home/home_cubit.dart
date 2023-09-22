import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/api_repository.dart';
// import '../../model/auto_schedule_pay_model copy.dart';
import '../../model/auto_schedule_pay_model.dart';
import '../../model/auto_schedule_pay_model.dart';
import '../../model/bbps_settings_model.dart';
import '../../model/biller_model.dart';
import '../../model/categories_model.dart';
import '../../model/chart_model.dart';
import '../../model/delete_upcoming_due_model.dart';
import '../../model/edit_bill_modal.dart';
import '../../model/input_signatures_model.dart';
import '../../model/location_model.dart';
import '../../model/paymentInformationModel.dart';
import '../../model/prepaid_fetch_plans_model.dart';
import '../../model/saved_billers_model.dart';
import '../../model/states_data_model.dart';
import '../../model/upcoming_dues_model.dart';
import '../../model/update_bill_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  Repository? repository;
  HomeCubit({@required this.repository}) : super(HomeInitial());
  int pageNumber = 1;

  void getCharts() async {
    if (!isClosed) {
      emit(MybillChartLoading());
    }
    try {
      repository!.getChartData().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              ChartModel chartModel = ChartModel.fromJson(value);
              if (!isClosed) {
                emit(MybillChartSuccess(chartModel: chartModel));
              }
            } else {
              if (!isClosed) {
                emit(MybillChartFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(MybillChartError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(MybillChartFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::getCharts:::");
    }
  }

  void fetchPrepaidFetchPlans(dynamic id) {
    if (!isClosed) {
      emit(PrepaidFetchPlansLoading());
    }

    try {
      repository!.fetchPrepaidFetchPlans(id).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              PrepaidFetchPlansModel? prepaidFetchPlansModel =
                  PrepaidFetchPlansModel.fromJson(value);
              //  success emit
              if (!isClosed) {
                emit(PrepaidFetchPlansSuccess(
                    prepaidPlansData: prepaidFetchPlansModel.data!.data));
              }
            } else {
              //  failed emit
              if (!isClosed) {
                emit(PrepaidFetchPlansFailed(message: value['message']));
              }
            }
          } else {
            //  error emit
            if (!isClosed) {
              emit(PrepaidFetchPlansError(message: value['message']));
            }
          }
        } else {
          //  failed emit

          if (!isClosed) {
            emit(PrepaidFetchPlansFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT:::fetchPrepaidFetchPlans:::");
    }
  }

  void deleteUpcomingDue(dynamic customerBillID) {
    if (!isClosed) {
      emit(DeleteUpcomingDueLoading());
    }

    try {
      repository!.deleteUpcomingDue(customerBillID).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              DeleteUpcomingDueModel? deleteUpcomingDueModel =
                  DeleteUpcomingDueModel.fromJson(value);
              //  success emit
              if (!isClosed) {
                emit(DeleteUpcomingDueSuccess(
                    message: deleteUpcomingDueModel.message));
              }
            } else {
              //  failed emit
              if (!isClosed) {
                emit(DeleteUpcomingDueFailed(message: value['message']));
              }
            }
          } else {
            //  error emit
            if (!isClosed) {
              emit(DeleteUpcomingDueError(message: value['message']));
            }
          }
        } else {
          //  failed emit

          if (!isClosed) {
            emit(DeleteUpcomingDueFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT:::deleteUpcomingDue:::");
    }
  }

  void searchBiller(queryString, Category, Loaction) {
    log(queryString, name: "SEARCH IN HOME CUBIT");

    if (!isClosed) {
      emit(BillersSearchLoading());
    }

    Map<String, dynamic> testPayload = {
      "searchString": queryString,
      "category": Category,
      "location": Loaction,
      "pageNumber": 1
    };
    //{"searchString":"test","category":"All","location":"All","pageNumber":1}

    try {
      repository!
          .getSearchedBillers(
              testPayload['searchString'],
              testPayload['category'],
              testPayload['location'],
              testPayload['pageNumber'])
          .then((value) {
        log(value['status'].toString(), name: "home cubit : searchBiller");

        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              BillerModel? billersSearchModel = BillerModel.fromJson(value);
              //  success emit
              if (!isClosed) {
                emit(BillersSearchSuccess(
                    searchResultsData: billersSearchModel.billData));
              }
            } else {
              //  failed emit
              if (!isClosed) {
                emit(BillersSearchFailed(message: value['message']));
              }
            }
          } else {
            //  error emit
            if (!isClosed) {
              emit(BillersSearchError(message: value['message']));
            }
          }
        } else {
          //  failed emit

          if (!isClosed) {
            emit(BillersSearchFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::getSearchedBillers :::");
    }
  }

  void getSavedBillers() {
    if (!isClosed) {
      emit(SavedBillersLoading());
    }
    try {
      repository!.getSavedBillers().then((value) {
        log(value['status'].toString());

        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              SavedBillersModel? savedBillersModel =
                  SavedBillersModel.fromJson(value);
              //  success emit
              if (!isClosed) {
                emit(SavedBillersSuccess(
                    savedBillersData: savedBillersModel.data));
              }
            } else {
              //  failed emit
              if (!isClosed) {
                emit(SavedBillersFailed(message: value['message']));
              }
            }
          } else {
            //  error emit
            if (!isClosed) {
              emit(SavedBillersError(message: value['message']));
            }
          }
        } else {
          //  failed emit

          if (!isClosed) {
            emit(SavedBillersFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::getSavedBillers :::");
    }
  }

  void getAllUpcomingDues() {
    if (!isClosed) {
      emit(UpcomingDuesLoading());
    }
    try {
      repository!.getAllUpcomingDues().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              // log(jsonEncode(value).toString());

              UpcomingDuesModel? upcomingDuesModel =
                  UpcomingDuesModel.fromJson(value);
              //  success emit
              if (!isClosed) {
                log(upcomingDuesModel.data.toString(),
                    name: "at getAllUpcomingDues() ::::");
                emit(UpcomingDuesSuccess(
                    upcomingDuesData: upcomingDuesModel.data));
              }
            } else {
              //  failed emit
              if (!isClosed) {
                emit(UpcomingDuesFailed(message: value['message']));
              }
            }
          } else {
            //  error emit
            if (!isClosed) {
              emit(UpcomingDuesError(message: value['message']));
            }
          }
        } else {
          //  failed emit
          if (!isClosed) {
            emit(UpcomingDuesFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::getAllUpcomingDues :::");
    }
  }

  void getAutopay() async {
    if (!isClosed) {
      emit(AutoPayLoading());
    }
    try {
      repository!.getAllScheduledAutoPay().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              AutoSchedulePayModel? autoSchedulePayModel =
                  AutoSchedulePayModel.fromJson(value);
              if (!isClosed) {
                log(jsonEncode(autoSchedulePayModel.data),
                    name: "AT getAutopay");

                emit(AutopaySuccess(
                    autoScheduleData: autoSchedulePayModel.data));
              }
            } else {
              if (!isClosed) {
                emit(AutopayFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(AutopayError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(AutopayFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::getAutopay :::");
    }
  }

  void getAllCategories() {
    if (!isClosed) {
      emit(CategoriesLoading());
    }
    try {
      repository!.getCategories().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              CategoriesModel? categoriesModel =
                  CategoriesModel.fromJson(value);
              if (!isClosed) {
                emit(CategoriesSuccess(CategoriesList: categoriesModel.data));
              }
            } else {
              if (!isClosed) {
                emit(CategoriesFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(CategoriesError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(CategoriesFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::getAllCategories:::");
    }
  }

  void getStateAndCities() {
    if (!isClosed) {
      emit(LocationLoading());
    }
    try {
      repository!.getLocation().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              locationModel? locationModels = locationModel.fromJson(value);
              if (!isClosed) {
                emit(LocationSuccess(LocationList: locationModels.data));
              }
            } else {
              if (!isClosed) {
                emit(LocationFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(LocationError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(LocationFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::getStateAndCities:::");
    }
  }

  void fetchStatesData() {
    if (!isClosed) {
      emit(StatesDataLoading());
    }

    try {
      repository!.getStatesData().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              StatesDataModel? statesDataModel =
                  StatesDataModel.fromJson(value);

              if (!isClosed) {
                emit(StatesDataSuccess(statesData: statesDataModel.data));
              }
            } else {
              if (!isClosed) {
                emit(StatesDataFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(StatesDataError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(StatesDataFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::fetchStatesData:::");
    }
  }

  void getAllBiller(cid) {
    if (state is AllbillerLoading) return;

    final currentState = state;
    List<BillersData>? prevBillerData = <BillersData>[];

    if (currentState is AllbillerSuccess) {
      prevBillerData = currentState.allbillerList;
    }

    emit(AllbillerLoading(prevBillerData!, isFirstFetch: pageNumber == 1));
    // log(cid.toString() + pageNumber.toString());

    try {
      repository!.getBillers(cid, pageNumber).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              BillerModel? all_biller = BillerModel.fromJson(value);
              pageNumber++;
              // final List<BillerData> billdata =
              //     (state as AllbillerLoading).prevData;
              prevBillerData!
                  .addAll(all_biller.billData as Iterable<BillersData>);
              if (!isClosed) {
                emit(AllbillerSuccess(allbillerList: prevBillerData));
              }
            } else {
              if (!isClosed) {
                emit(AllbillerFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(AllbillerError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(AllbillerFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::getAllBiller:::");
    }
  }

  void getInputSingnature(billID) {
    if (!isClosed) {
      emit(InputSignatureLoading());
    }
    try {
      repository!.getInputSignature(billID).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              InputSignaturesModel? InputDetails =
                  InputSignaturesModel.fromJson(value);
              if (!isClosed) {
                emit(InputSignatureSuccess(
                    InputSignatureList: InputDetails.data));
              }
            } else {
              if (!isClosed) {
                emit(InputSignatureFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(InputSignatureError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(InputSignatureFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::getInputSingnature:::");
    }
  }

  void getEditBill(billID) {
    if (!isClosed) {
      emit(EditBillLoading());
    }
    try {
      repository!.getSavedBillDetails(billID).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              EditbillModel InputDetails = EditbillModel.fromJson(value);
              if (!isClosed) {
                emit(EditBillSuccess(EditBillList: InputDetails.data));
              }
            } else {
              if (!isClosed) {
                emit(EditBillFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(EditBillError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(EditBillFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::getEditBill:::");
    }
  }

  void updateBill(payload) {
    if (!isClosed) {
      emit(UpdateBillLoading());
    }
    log(payload.toString(), name: "payload for updateBill");
    try {
      repository!.updateBillDetails(payload).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              UpdateBillModel UpdateBillDetails =
                  UpdateBillModel.fromJson(value);
              if (!isClosed) {
                emit(UpdateBillSuccess(UpdateBillDetails: UpdateBillDetails));
              }
            } else {
              if (!isClosed) {
                emit(UpdateBillFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(UpdateBillError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(UpdateBillFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::updateBill:::");
    }
  }

  void getBbpsSettings() {
    if (!isClosed) {
      emit(BbpsSettingsLoading());
    }
    try {
      repository!.getBbpsSettings().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              bbpsSettingsModel? BbpsSettingsDetails =
                  bbpsSettingsModel.fromJson(value);
              if (!isClosed) {
                emit(BbpsSettingsSuccess(
                    BbpsSettingsDetails: BbpsSettingsDetails));
              }
            } else {
              if (!isClosed) {
                emit(BbpsSettingsFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(BbpsSettingsError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(BbpsSettingsFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::getBbpsSettings:::");
    }
  }
}
