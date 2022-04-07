import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../blocs/pass/pass_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/formatters/pass_input_formatter.dart';
import '../../../core/functions/functions.dart';
import '../../../core/utils/loading.dart';
import '../../../entities/domain.dart';
import '../../../entities/open_pass_response.dart';
import '../../../entities/station.dart';
import '../../../entities/user.dart';
import '../../../entities/violation_error.dart';

class PageFirstPassDomain extends StatefulWidget {
  final User user;
  final Station station;
  final Domain domain;
  final String startDate;

  PageFirstPassDomain(
      {Key? key,
      required this.user,
      required this.station,
      required this.domain,
      required this.startDate})
      : super(key: key);

  @override
  _PageFirstPassDomainState createState() => _PageFirstPassDomainState();
}

class _PageFirstPassDomainState extends State<PageFirstPassDomain> {
  TextEditingController _passController = TextEditingController();
  // ignore: close_sinks
  BehaviorSubject<String> _bhvspass = BehaviorSubject.seeded('');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final key = new GlobalKey();
  bool isLoading = false;
  OpenPassResponse? openPassResponse;
  ViolationError? violationError;
  String contactId = '';
  late User user;
  bool showDial = false;

  final textFieldPassFocusNode = FocusNode();

  @override
  void initState() {
    if (BlocProvider.of<ConsumerBloc>(context).state is ConsumerLoadSuccess) {
      _passController.text =
          (BlocProvider.of<ConsumerBloc>(context).state as ConsumerLoadSuccess)
              .user
              .numPass;
      contactId =
          (BlocProvider.of<ConsumerBloc>(context).state as ConsumerLoadSuccess)
              .user
              .contactId;
      user =
          (BlocProvider.of<ConsumerBloc>(context).state as ConsumerLoadSuccess)
              .user;
    }
    _bhvspass.value = _passController.text;

    super.initState();
  }

  bool canGo = true;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PassBloc, PassState>(
          listener: (context, state) async {
            print(state);
            if (state is FindOpenPassSuccess) {
              print(state.openPassResponse);
              openPassResponse = state.openPassResponse;
              if (_formKey.currentState!.validate()) {
                BlocProvider.of<ConsumerBloc>(context).add(AssignPassEvent(
                    passId: openPassResponse!.id.toString(),
                    contactId: contactId));
              }
            } else if (state is FinOpenPassLoadFailure) {
              print(state.violationError);
              violationError = state.violationError;
              if (_formKey.currentState!.validate()) {}
            }
          },
        ),
        BlocListener<ConsumerBloc, ConsumerState>(
          listener: (context, state) {
            print(state);
            if (state is ConsumerLoadSuccess) {
              BlocProvider.of<CartBloc>(context).add(GetFirstSimulationEvent(
                  user: state.user,
                  domain: widget.domain,
                  station: widget.station,
                  startDate: widget.startDate,
                  selectedContacts: []));
            }
            if (state is ConsumerLoadFailure)
              ScaffoldMessenger.of(context).showSnackBar(
                personalisedSnackBar(
                    title: 'Vous n\'avez plus de connexion internet',
                    funtion: () {
                      BlocProvider.of<ConsumerBloc>(context).add(
                          AssignPassEvent(
                              passId: openPassResponse!.id.toString(),
                              contactId: contactId));
                    },
                    label: 'Réessayer'),
              );
          },
        ),
      ],
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, stateCart) {
          return BlocBuilder<ConsumerBloc, ConsumerState>(
            builder: (context, stateConsumer) {
              return Scaffold(
                  body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorsApp.BackgroundBrandPrimary,
                    image: DecorationImage(
                      image: AssetImage("assets/sync.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification overScroll) {
                          overScroll.disallowIndicator();
                          return false;
                        },
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height / 5 * 3,
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        color: ColorsApp.ContentPrimaryReversed,
                                        onPressed: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, bottom: 16),
                                    child: Text(
                                      tr('configuration.sync.title'),
                                      style: GoogleFonts.roboto(
                                          fontSize: 36,
                                          color:
                                              ColorsApp.ContentPrimaryReversed,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0),
                                    child: Text(
                                      tr('configuration.sync.subtitle'),
                                      style: GoogleFonts.roboto(
                                          letterSpacing: -0.24,
                                          fontSize: 15,
                                          color:
                                              ColorsApp.ContentPrimaryReversed,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/pass.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 2 / 5,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24.0, right: 24),
                                  child: ListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      SizedBox(height: 16),
                                      Text(
                                        tr('configuration.sync.forms.title'),
                                        style: GoogleFonts.roboto(
                                            fontSize: 20,
                                            color: ColorsApp.ContentPrimary,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      BlocBuilder<PassBloc, PassState>(
                                        builder: (context, state) {
                                          if (state is FindOpenPassInProgress)
                                            isLoading = true;
                                          else {
                                            isLoading = false;
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5, top: 5),
                                            child: Form(
                                              key: _formKey,
                                              child: TextFormField(
                                                onChanged: (value) =>
                                                    _bhvspass.value = value,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  PassTextFormatter()
                                                ],
                                                style: GoogleFonts.roboto(
                                                    fontSize: 17,
                                                    color: ColorsApp
                                                        .ContentPrimary,
                                                    fontWeight:
                                                        FontWeight.normal),
                                                decoration: InputDecoration(
                                                  // suffixIcon: isLoading
                                                  //     ? Container(
                                                  //         height: 15,
                                                  //         width: 15,
                                                  //         child:
                                                  //             CircularProgressIndicator())
                                                  //     : IconButton(
                                                  //         icon: Icon(
                                                  //             Icons.crop_free),
                                                  //         onPressed: () async {
                                                  //           // Unfocus all focus nodes
                                                  //           textFieldPassFocusNode
                                                  //               .unfocus();

                                                  //           // Disable text field's focus node request
                                                  //           textFieldPassFocusNode
                                                  //                   .canRequestFocus =
                                                  //               false;

                                                  //           NfcBloc nfcBloc =
                                                  //               BlocProvider.of<
                                                  //                       NfcBloc>(
                                                  //                   context);
                                                  //           String pass = '';
                                                  //           bool isAvailable =
                                                  //               await NfcManager
                                                  //                   .instance
                                                  //                   .isAvailable();
                                                  //           if (!isAvailable) {
                                                  //             await showDialog(
                                                  //               context:
                                                  //                   context,
                                                  //               builder: (BuildContext
                                                  //                       context) =>
                                                  //                   AlertDialog(
                                                  //                 title: const Text(
                                                  //                     'Activer NFC'),
                                                  //                 content:
                                                  //                     const Text(
                                                  //                         'Votre NFC n\est pas activé ou votre appareil n\est pas compatible.'),
                                                  //                 actions: <
                                                  //                     Widget>[
                                                  //                   new TextButton(
                                                  //                     child: const Text(
                                                  //                         'Fermer'),
                                                  //                     onPressed:
                                                  //                         () {
                                                  //                       Navigator.of(context)
                                                  //                           .pop();
                                                  //                     },
                                                  //                   ),
                                                  //                   new TextButton(
                                                  //                     child: const Text(
                                                  //                         'Paramètres'),
                                                  //                     onPressed:
                                                  //                         () {
                                                  //                       AppSettings
                                                  //                           .openNFCSettings();
                                                  //                       Navigator.of(context)
                                                  //                           .pop();
                                                  //                     },
                                                  //                   ),
                                                  //                 ],
                                                  //               ),
                                                  //             );
                                                  //           } else {
                                                  //             NfcBloc nfcBloc =
                                                  //                 BlocProvider.of<
                                                  //                         NfcBloc>(
                                                  //                     context);
                                                  //             pass = await showDialog(
                                                  //                 context:
                                                  //                     context,
                                                  //                 builder: (BuildContext
                                                  //                         context) =>
                                                  //                     PageNFC(
                                                  //                         nfcBloc:
                                                  //                             nfcBloc));
                                                  //             nfcBloc.add(
                                                  //                 StopNFCReading());
                                                  //           }
                                                  //           // Do your stuff
                                                  //           // bool mode = await showDialog(
                                                  //           //     context: context,
                                                  //           //     builder: (BuildContext
                                                  //           //             context) =>
                                                  //           //         DialogMethodScan());
                                                  //           // String pass = '';
                                                  //           // if (!mode) {
                                                  //           //   bool isAvailable =
                                                  //           //       await NfcManager
                                                  //           //           .instance
                                                  //           //           .isAvailable();
                                                  //           //   if (!isAvailable)
                                                  //           //     AppSettings
                                                  //           //         .openNFCSettings();
                                                  //           //   else {
                                                  //           //     NfcBloc nfcBloc =
                                                  //           //         BlocProvider.of<
                                                  //           //                 NfcBloc>(
                                                  //           //             context);
                                                  //           //     pass = await showDialog(
                                                  //           //         context: context,
                                                  //           //         builder: (BuildContext
                                                  //           //                 context) =>
                                                  //           //             PageNFC(
                                                  //           //                 nfcBloc:
                                                  //           //                     nfcBloc));
                                                  //           //     nfcBloc.add(
                                                  //           //         StopNFCReading());
                                                  //           //   }
                                                  //           // } else {
                                                  //           //   final status =
                                                  //           //       await Permission
                                                  //           //           .camera
                                                  //           //           .request();
                                                  //           //   if (status ==
                                                  //           //       PermissionStatus
                                                  //           //           .granted) {
                                                  //           //     print(
                                                  //           //         'Permission granted');
                                                  //           //     pass = await showDialog(
                                                  //           //         context: context,
                                                  //           //         builder: (BuildContext
                                                  //           //                 context) =>
                                                  //           //             PageQRCodeReading());
                                                  //           //     return;
                                                  //           //   } else if (status ==
                                                  //           //       PermissionStatus
                                                  //           //           .denied) {
                                                  //           //     print(
                                                  //           //         'Permission denied. Show a dialog and again ask for the permission');
                                                  //           //   } else if (status ==
                                                  //           //       PermissionStatus
                                                  //           //           .permanentlyDenied) {
                                                  //           //     print(
                                                  //           //         'Take the user to the settings page.');
                                                  //           //     await Future.delayed(
                                                  //           //       Duration(
                                                  //           //           milliseconds:
                                                  //           //               100),
                                                  //           //     );
                                                  //           //     await showDialog(
                                                  //           //       context: context,
                                                  //           //       builder: (BuildContext
                                                  //           //               context) =>
                                                  //           //           AlertDialog(
                                                  //           //         title: const Text(
                                                  //           //             'Permission Caméra'),
                                                  //           //         content: const Text(
                                                  //           //             'Cette application a besoin de votre accord pour utiliser la caméra:'),
                                                  //           //         actions: <Widget>[
                                                  //           //           new TextButton(
                                                  //           //             child: const Text(
                                                  //           //                 'Refuser'),
                                                  //           //             onPressed: () {
                                                  //           //               Navigator.of(
                                                  //           //                       context)
                                                  //           //                   .pop();
                                                  //           //             },
                                                  //           //           ),
                                                  //           //           new TextButton(
                                                  //           //             child: const Text(
                                                  //           //                 'Paramètres'),
                                                  //           //             onPressed: () {
                                                  //           //               openAppSettings();
                                                  //           //               Navigator.of(
                                                  //           //                       context)
                                                  //           //                   .pop();
                                                  //           //             },
                                                  //           //           ),
                                                  //           //         ],
                                                  //           //       ),
                                                  //           //     );
                                                  //           //   }
                                                  //           // }
                                                  //           //Enable the text field's focus node request after some delay
                                                  //           Future.delayed(
                                                  //               Duration(
                                                  //                   milliseconds:
                                                  //                       100),
                                                  //               () {
                                                  //             textFieldPassFocusNode
                                                  //                     .canRequestFocus =
                                                  //                 true;
                                                  //           });
                                                  //           setState(() {
                                                  //             if (pass != '')
                                                  //               _passController
                                                  //                       .text =
                                                  //                   pass;
                                                  //           });
                                                  //         },
                                                  //       ),
                                                  focusColor:
                                                      ColorsApp.InputDecoration,
                                                  hoverColor:
                                                      ColorsApp.InputDecoration,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  fillColor: Colors.white,
                                                  labelText: tr(
                                                      'configuration.sync.forms.pass.labelText'),
                                                  labelStyle:
                                                      GoogleFonts.roboto(
                                                          letterSpacing: -0.32,
                                                          fontSize: 16,
                                                          //color: Color(#687787),
                                                          color: Color.fromRGBO(
                                                              104, 119, 135, 1),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                  hintText: tr(
                                                      'configuration.sync.forms.pass.hintText'),
                                                  hintStyle: GoogleFonts.roboto(
                                                      fontSize: 17,
                                                      //color: Color(#687787),

                                                      color: ColorsApp
                                                          .ContentInactive,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                controller: _passController,
                                                onFieldSubmitted: (value) {
                                                  _passController.text = value;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return tr(
                                                        'configuration.sync.forms.pass.errorEmpty');
                                                  }
                                                  if (violationError != null) {
                                                    return violationError!
                                                        .message;
                                                  }
                                                  if (openPassResponse !=
                                                      null) {
                                                    if (!openPassResponse!
                                                        .active) {
                                                      return tr(
                                                          'configuration.sync.forms.pass.errorActive');
                                                    }
                                                    if (openPassResponse!
                                                        .blocked) {
                                                      return tr(
                                                          'configuration.sync.forms.pass.errorBlocked');
                                                    }
                                                    if (openPassResponse!
                                                            .contactId !=
                                                        null) {
                                                      if (user.elibertyId !=
                                                          openPassResponse!
                                                              .contactId)
                                                        return tr(
                                                            'configuration.sync.forms.pass.errorAssigned');
                                                    }
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      StreamBuilder<Object>(
                                          stream: _bhvspass.stream,
                                          builder: (context, snapshot) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12, top: 12),
                                              child: Container(
                                                height: 56,
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        primary: (snapshot
                                                                    .data ==
                                                                '')
                                                            ? ColorsApp
                                                                .BackgroundBrandInactive
                                                            : ColorsApp
                                                                .BackgroundBrandPrimary),
                                                    onPressed:
                                                        (snapshot.data == '')
                                                            ? null
                                                            : () {
                                                                openPassResponse =
                                                                    null;
                                                                violationError =
                                                                    null;
                                                                if (_formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  BlocProvider.of<
                                                                              PassBloc>(
                                                                          context)
                                                                      .add(FindOpenPassEvent(
                                                                          passNumber:
                                                                              _passController.text));
                                                                  FocusScope.of(
                                                                          context)
                                                                      .requestFocus(
                                                                          FocusNode());

                                                                  //widget.controller.animateTo(3);
                                                                }
                                                              },
                                                    child: Text(
                                                      tr('configuration.sync.buttons.button1.label'),
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 15,
                                                          color: ColorsApp
                                                              .ContentPrimaryReversed,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    )),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      (stateConsumer is ConsumerLoadInProgress)
                          ? Loading()
                          : Container(),
                      (stateCart is CartLoadInProgress)
                          ? Loading()
                          : Container(),
                    ],
                  ),
                ),
              ));
            },
          );
        },
      ),
    );
  }
}
