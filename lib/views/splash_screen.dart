import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../bloc/splash/splash_cubit.dart';
import '../model/decoded_model.dart';
import '../utils/commen.dart';
import '../utils/const.dart';
import '../utils/utils.dart';

class SplashScreen extends StatefulWidget {
  Map<String, dynamic> redirectData = {};
  String? checkSum = "";
  SplashScreen({Key? key, required this.redirectData, this.checkSum})
      : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? message = '';
  String? failedMessage = "waiting for data...";
  int secondsRemaining = autoRedirectSeconds;
  Image? loaderImage;
  AssetImage? myAssetImage;
  Timer? timer;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  checkRedirect() async {
    if (await isConnected()) {
      print("AT SplashScreen : isConnected true");

      print("At check Redirect");
      print(widget.redirectData);
      BlocProvider.of<SplashCubit>(context)
          .checkRedirection(widget.redirectData, widget.checkSum);
      // if (widget.redirectData.isNotEmpty) {

      // } else {
      //   print("No Initial Data Received");
      // }
    } else {
      print("No Initial Data Received");

      log("No Initial Data Received");
    }
  }

  triggerTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        if (mounted) {
          setState(() {
            secondsRemaining--;
          });
        }
      } else {
        // SystemNavigator.pop();
        if (mounted) {
          setState(() {
            timer?.cancel();
          });
        }
        if (Platform.isAndroid) {
          SystemNavigator.pop(animated: true);
        } else {
          platform_channel.invokeMethod("exitBbpsModule", "");
        }
      }
      if (!mounted) {
        timer?.cancel();
      }
    });
  }

  @override
  void initState() {
    checkRedirect();
    // if (widget.redirectData.isNotEmpty) {
    //   BlocProvider.of<SplashCubit>(context).redirect('initData',
    //       initCheckSum: widget.redirectData['checkSum'],
    //       initParams: widget.redirectData['data']);
    // } else {
    //   log("No Initial Data Received");
    // }

    myAssetImage = AssetImage("assets/images/loader.gif");
    // loaderImage = Image(
    //   image: myAssetImage!,
    //   fit: BoxFit.cover,
    //   height: 60,
    //   width: 60,
    // );

    loaderImage = Image(
        image: ResizeImage(
      myAssetImage!,
      width: 40,
      height: 40,
    ));

    super.initState();
  }

  @override
  void dispose() {
    Loader.hide();
    myAssetImage?.evict();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) async {
          if (state is SplashLoading) {
            showLoaderSplash(context, loaderImage);
          } else if (state is SplashSuccess) {
            Loader.hide();

            log(state.redirectModel!.data.toString());
            var id = state.redirectModel!.data
                .toString()
                .split('&')[0]
                .split('=')[1];
            var hash = state.redirectModel!.data
                .toString()
                .split('&')[1]
                .split('=')[1];
            log('At splashScreen : id : $id ');
            log('At splashScreen : hash : $hash');
            print('At splashScreen : id : $id ');
            print('At splashScreen : hash : $hash');
            BlocProvider.of<SplashCubit>(context).login(id, hash);
          } else if (state is SplashFailed) {
            Loader.hide();
            message = state.message;
            triggerTimer();
          } else if (state is SplashError) {
            Loader.hide();
            message = state.error;

            showSnackBar("Please try later", context);
          } else if (state is SplashLoginLoading) {
            showLoaderSplash(context, loaderImage);
            triggerTimer();
          } else if (state is SplashLoginSuccess) {
            Loader.hide();
            // await setSharedValue(ACC, await getDecodedAccounts().toString());
            myAccounts = await getDecodedAccounts();
            DecodedModel? user = await validateJWT();

            // userName = "Hi Test";
            // userName =
            //     "Hi ${user!.emailID != null ? user.emailID!.split('@')[0] : "User"} ";
            if (user!.customerName != null)
              userName = "Hi ${user.customerName ?? user.customerName}";
            goToReplace(context, homeRoute);
          } else if (state is SplashLoginFailed) {
            Loader.hide();
            message = state.message;
          } else if (state is SplashLoginError) {
            Loader.hide();
            message = state.message;
          }
        },
        builder: (context, state) {
          return SplashScreenUI(
            message: message,
            fromParentApp: widget.redirectData.isNotEmpty ? true : false,
            timerValue: secondsRemaining,
          );
        },
      ),
    );
  }
}

class SplashScreenUI extends StatefulWidget {
  String? message;
  bool fromParentApp;
  int? timerValue;

  SplashScreenUI(
      {Key? key,
      @required this.message,
      required this.fromParentApp,
      this.timerValue})
      : super(key: key);

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  @override
  Widget build(BuildContext context) {
    return widget.fromParentApp!
        ? SafeArea(
            child: Scaffold(
              backgroundColor: primaryBodyColor,
              body: widget.message!.isEmpty
                  ? SizedBox(
                      child: Column(children: []),
                    )
                  : SizedBox(
                      width: width(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          verticalSpacer(12.0),
                          Container(
                            decoration: BoxDecoration(
                              color: primaryBodyColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(7.0),
                              ),
                            ),
                            width: width(context) / 1.2,
                            height: height(context) / 2.5,
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // SvgPicture.asset(alertSvg),
                                  Text(
                                    widget.message!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: txtRejectColor,
                                        fontSize: width(context) * 0.05),
                                  ),
                                  verticalSpacer(height(context) * 0.20),
                                  RichText(
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    text: TextSpan(
                                      text: " Automatically redirecting in ",
                                      style: TextStyle(
                                          color: txtPrimaryColor,
                                          fontSize: width(context) * 0.06),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                '\n ${widget.timerValue.toString()} ',
                                            style: TextStyle(
                                              color: alertWaitingColor,
                                              fontSize: width(context) * 0.07,
                                            )),
                                        TextSpan(
                                            text: 'seconds',
                                            style: TextStyle(
                                              color: txtPrimaryColor,
                                              fontSize: width(context) * 0.06,
                                            )),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                equitaspngLogo,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          )
        : Container(
            height: height(context),
            width: width(context),
            color: primaryBodyColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      verticalSpacer(12.0),
                      Container(
                        decoration: BoxDecoration(
                          color: primaryBodyColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(7.0),
                          ),
                        ),
                        width: width(context) / 1.2,
                        height: height(context) / 2.5,
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // SvgPicture.asset(alertSvg),
                              Text(
                                widget.message!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: txtRejectColor,
                                    fontSize: width(context) * 0.05),
                              ),
                              verticalSpacer(height(context) * 0.20),

                              RichText(
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                text: TextSpan(
                                  text: " Automatically redirecting in ",
                                  style: TextStyle(
                                      color: txtPrimaryColor,
                                      fontSize: width(context) * 0.06),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            '\n ${widget.timerValue.toString()} ',
                                        style: TextStyle(
                                          color: alertWaitingColor,
                                          fontSize: width(context) * 0.07,
                                        )),
                                    TextSpan(
                                        text: 'seconds',
                                        style: TextStyle(
                                          color: txtPrimaryColor,
                                          fontSize: width(context) * 0.06,
                                        )),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            equitaspngLogo,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //       SizedBox(
                //   height: height(context),
                //   width: width(context),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       ElevatedButton(
                //           onPressed: () {
                //             BlocProvider.of<SplashCubit>(context).redirect('one');
                //           },
                //           child: Text('One')),
                //       ElevatedButton(
                //           onPressed: () {
                //             BlocProvider.of<SplashCubit>(context).redirect('two');
                //           },
                //           child: Text('Two')),
                //       ElevatedButton(
                //           onPressed: () {
                //             BlocProvider.of<SplashCubit>(context).redirect('three');
                //           },
                //           child: Text('Three')),
                //       ElevatedButton(
                //           onPressed: () {
                //             BlocProvider.of<SplashCubit>(context).redirect('four');
                //           },
                //           child: Text('Four')),
                //       ElevatedButton(
                //           onPressed: () {
                //             BlocProvider.of<SplashCubit>(context).redirect('five');
                //           },
                //           child: Text('Five')),
                //       ElevatedButton(
                //           onPressed: () {
                //             BlocProvider.of<SplashCubit>(context).redirect('six');
                //           },
                //           child: Text('Six')),
                //       ElevatedButton(
                //           onPressed: () {
                //             BlocProvider.of<SplashCubit>(context).redirect('seven');
                //           },
                //           child: Text('Seven')),
                //       verticalSpacer(32.0),
                //       Text(
                //         widget.message!,
                //         style: TextStyle(fontSize: 18.0),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          );
  }
}
