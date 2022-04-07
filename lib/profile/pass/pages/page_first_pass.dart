// ignore_for_file: close_sinks

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../blocs/pass/pass_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/formatters/pass_input_formatter.dart';
import '../../../core/functions/functions.dart';
import '../../../core/utils/loading.dart';
import '../../../entities/open_pass_response.dart';
import '../../../entities/user.dart';
import '../../../entities/violation_error.dart';

class PageFirstPass extends StatefulWidget {
  final TabController controller;
  PageFirstPass({Key? key, required this.controller}) : super(key: key);

  @override
  _PageFirstPassState createState() => _PageFirstPassState();
}

class _PageFirstPassState extends State<PageFirstPass> {
  TextEditingController _passController = TextEditingController();
  BehaviorSubject<String> _bhvspass = BehaviorSubject.seeded('');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final key = new GlobalKey();
  bool isLoading = false;
  OpenPassResponse? openPassResponse;
  ViolationError? violationError;
  String contactId = '';
  late User user;

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
    if (user.firstName == '' || user.lastName == '' || user.birthDate == null)
      init();
    super.initState();
  }

  void init() async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text(tr('common.careful')),
          content: Text(
              'Tu dois d\'abbord compléter tes informations personnelles !'),
          actions: <Widget>[
            new TextButton(
              child: Text('J\'ai compris'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PassBloc, PassState>(
          listener: (context, state) async {
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
            if (state is ConsumerLoadSuccess) {
              widget.controller.animateTo(1);
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
      child: BlocBuilder<ConsumerBloc, ConsumerState>(
        builder: (context, stateConsumer) {
          return Scaffold(
              body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 125, 188, 1),
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
                          height: MediaQuery.of(context).size.height * 3 / 5,
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
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, bottom: 16),
                                child: Text(
                                  tr('configuration.sync.title'),
                                  style: GoogleFonts.roboto(
                                      fontSize: 36,
                                      color: ColorsApp.ContentPrimaryReversed,
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
                                      color: ColorsApp.ContentPrimaryReversed,
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
                          height: MediaQuery.of(context).size.height * 2 / 5,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 24.0, right: 24),
                              child: ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  SizedBox(height: 16),
                                  Text(
                                    tr('configuration.sync.forms.title'),
                                    style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        //color: Color(#687787),
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
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              PassTextFormatter()
                                            ],
                                            style: GoogleFonts.roboto(
                                                fontSize: 17,
                                                //color: Color(#687787),
                                                color: Color.fromRGBO(
                                                    0, 16, 24, 1),
                                                fontWeight: FontWeight.normal),
                                            decoration: InputDecoration(
                                              focusColor:
                                                  ColorsApp.InputDecoration,
                                              hoverColor:
                                                  ColorsApp.InputDecoration,
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              fillColor: Colors.white,
                                              labelText: tr(
                                                  'configuration.sync.forms.pass.labelText'),
                                              labelStyle: GoogleFonts.roboto(
                                                  letterSpacing: -0.32,
                                                  fontSize: 16,
                                                  //color: Color(#687787),
                                                  color: Color.fromRGBO(
                                                      104, 119, 135, 1),
                                                  fontWeight:
                                                      FontWeight.normal),
                                              hintText: tr(
                                                  'configuration.sync.forms.pass.hintText'),
                                              hintStyle: GoogleFonts.roboto(
                                                  fontSize: 17,
                                                  //color: Color(#687787),
                                                  color: Color.fromRGBO(
                                                      137, 150, 162, 1),
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
                                                return violationError!.message;
                                              }
                                              // bool isUsed = false;
                                              // if (user.contacts.isNotEmpty) {
                                              //   user.contacts
                                              //       .forEach((element) {
                                              //     if (value == element.numPass)
                                              //       isUsed = true;
                                              //   });
                                              // }
                                              // if (isUsed)
                                              //   return 'Tu as déjà attribué ce Pass dans ce compte.';
                                              if (openPassResponse != null) {
                                                if (!openPassResponse!.active) {
                                                  return tr(
                                                      'configuration.sync.forms.pass.errorActive');
                                                }
                                                if (openPassResponse!.blocked) {
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
                                                    primary: (snapshot.data ==
                                                            '')
                                                        ? ColorsApp
                                                            .BackgroundBrandInactive
                                                        : ColorsApp
                                                            .BackgroundBrandPrimary),
                                                onPressed: (snapshot.data == '')
                                                    ? null
                                                    : () {
                                                        openPassResponse = null;
                                                        violationError = null;
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          BlocProvider.of<
                                                                      PassBloc>(
                                                                  context)
                                                              .add(FindOpenPassEvent(
                                                                  passNumber:
                                                                      _passController
                                                                          .text));
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  FocusNode());

                                                          //widget.controller.animateTo(3);
                                                        }
                                                      },
                                                child: Text(
                                                  tr('configuration.sync.buttons.button1.label'),
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 15,
                                                      //color: Color(#687787),
                                                      color: ColorsApp
                                                          .ContentPrimaryReversed,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )),
                                          ),
                                        );
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 24,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: 56,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              side: BorderSide(
                                                  color: Color.fromRGBO(
                                                      217, 221, 225, 1),
                                                  width: 2)),
                                          elevation: 0,
                                          primary:
                                              ColorsApp.ContentPrimaryReversed,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Ignorer pour l\'instant',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 15,
                                                  color: Color.fromRGBO(
                                                      0, 104, 157, 1),
                                                  fontWeight: FontWeight.w700),
                                            )),
                                      ),
                                    ),
                                  ),
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
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}
