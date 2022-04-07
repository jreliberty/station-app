import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/consumer/consumer_bloc.dart';
import '../../blocs/pass/pass_bloc.dart';
import '../../constants/colors.dart';
import '../../entities/contact.dart';
import '../../entities/open_pass_response.dart';
import '../../entities/user.dart';
import '../../entities/violation_error.dart';
import '../formatters/date_input_formatter.dart';
import '../formatters/pass_input_formatter.dart';
import '../functions/functions.dart';
import 'loading.dart';

class PageCreationPass extends StatefulWidget {
  final Contact? contact;
  PageCreationPass({Key? key, required this.contact}) : super(key: key);

  @override
  _PageCreationPassState createState() => _PageCreationPassState();
}

class _PageCreationPassState extends State<PageCreationPass> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  final textFieldBirthFocusNode = FocusNode();
  final textFieldPassFocusNode = FocusNode();

  bool isLoading = false;
  OpenPassResponse? openPassResponse;
  ViolationError? violationError;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late User user;

  @override
  void initState() {
    if (widget.contact != null) {
      _nameController.text = widget.contact!.firstName;
      _lastNameController.text = widget.contact!.lastName;
      _birthDateController.text = formatDate.format(widget.contact!.birthDate);
      _passController.text = widget.contact!.numPass;
    }
    user = (BlocProvider.of<ConsumerBloc>(context).state as ConsumerLoadSuccess)
        .user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsumerBloc, ConsumerState>(
      builder: (context, stateConsumerInit) {
        return MultiBlocListener(
          listeners: [
            BlocListener<PassBloc, PassState>(
              listener: (context, state) async {
                if (state is FindOpenPassSuccess) {
                  openPassResponse = state.openPassResponse;
                  if (_formKey.currentState!.validate()) {
                    if (stateConsumerInit
                        is ConsumerLoadSuccess) if (widget.contact == null) {
                      var date = _birthDateController.text.split("/");
                      var body = {
                        "first_name": _nameController.text.trim(),
                        "last_name": _lastNameController.text.trim(),
                        "birth_date": '${date[2]}/${date[1]}/${date[0]}',
                        "language": "fr",
                        "country_code": "FR",
                        "gender": "male",
                        "payer_id": stateConsumerInit.user.contactId,
                        "middle_name": null
                      };

                      BlocProvider.of<ConsumerBloc>(context).add(
                          CreateSubcontactEvent(
                              body: jsonEncode(body),
                              passId: openPassResponse!.id.toString()));
                    } else {
                      var date = _birthDateController.text.split("/");
                      var body = {
                        "first_name": _nameController.text.trim(),
                        "last_name": _lastNameController.text.trim(),
                        "birth_date": '${date[2]}/${date[1]}/${date[0]}',
                        "language": "fr",
                        "country_code": "FR",
                        "gender": "male",
                        "middle_name": null
                      };
                      BlocProvider.of<ConsumerBloc>(context).add(
                          UpdateContactPersonalInfoEvent(
                              body: jsonEncode(body),
                              contactId: widget.contact!.id));
                      BlocProvider.of<ConsumerBloc>(context).add(
                          AssignPassEvent(
                              passId: openPassResponse!.id.toString(),
                              contactId: widget.contact!.id));
                    }
                  }
                } else if (state is FinOpenPassLoadFailure) {
                  violationError = state.violationError;
                  if (_formKey.currentState!.validate()) {}
                }
              },
            ),
            BlocListener<ConsumerBloc, ConsumerState>(
              listener: (context, state) {
                if (state is ConsumerLoadSuccess) {
                  Navigator.of(context).pop();
                }
                if (state is ConsumerLoadFailure)
                  ScaffoldMessenger.of(context).showSnackBar(
                    personalisedSnackBar(
                        title: 'Vous n\'avez plus de connexion internet',
                        funtion: () {
                          openPassResponse = null;
                          violationError = null;
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<PassBloc>(context).add(
                                FindOpenPassEvent(
                                    passNumber: _passController.text));
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        },
                        label: 'Réessayer'),
                  );
              },
            ),
          ],
          child: BlocBuilder<ConsumerBloc, ConsumerState>(
            builder: (context, stateConsumer) {
              if (stateConsumer is ConsumerLoadInProgress)
                isLoading = true;
              else if (stateConsumer is ConsumerLoadSuccess) isLoading = false;
              return Material(
                type: MaterialType.transparency,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Stack(
                    children: [
                      Column(children: [
                        Container(
                          height: 44,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              topLeft: Radius.circular(16),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 55,
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Color.fromRGBO(
                                                  239, 241, 243, 1),
                                            ),
                                            child: IconButton(
                                              icon: Icon(Icons.clear),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        (widget.contact != null)
                                            ? 'Modifier ce pass '
                                            : 'Ajouter un pass',
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            //color: Color(#687787),
                                            color: ColorsApp.ContentPrimary,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 0,
                                thickness: 1,
                                color: ColorsApp.ContentDivider,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.white,
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 24.0, left: 24, right: 24),
                                child: NotificationListener<
                                    OverscrollIndicatorNotification>(
                                  onNotification:
                                      (OverscrollIndicatorNotification
                                          overScroll) {
                                    overScroll.disallowIndicator();
                                    return false;
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: ListView(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.all(0),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: TextFormField(
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              textInputAction:
                                                  TextInputAction.next,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 17,
                                                  //color: Color(#687787),
                                                  color: Color.fromRGBO(
                                                      0, 16, 24, 1),
                                                  fontWeight:
                                                      FontWeight.normal),
                                              decoration: InputDecoration(
                                                focusColor:
                                                    ColorsApp.InputDecoration,
                                                hoverColor:
                                                    ColorsApp.InputDecoration,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                fillColor: Colors.white,
                                                labelText: tr(
                                                    'configuration.pass.forms.firstname.labelText'),
                                                labelStyle: GoogleFonts.roboto(
                                                    letterSpacing: -0.32,
                                                    fontSize: 16,
                                                    //color: Color(#687787),
                                                    color: Color.fromRGBO(
                                                        104, 119, 135, 1),
                                                    fontWeight:
                                                        FontWeight.normal),
                                                hintText: tr(
                                                    'configuration.pass.forms.firstname.hintText'),
                                                hintStyle: GoogleFonts.roboto(
                                                    fontSize: 17,
                                                    //color: Color(#687787),
                                                    color: Color.fromRGBO(
                                                        137, 150, 162, 1),
                                                    fontWeight:
                                                        FontWeight.normal),
                                                /*border: new OutlineInputBorder(
                                                              borderRadius: new BorderRadius.circular(25.0),
                                                              borderSide: new BorderSide(),
                                                            ),*/
                                              ),
                                              controller: _nameController,
                                              onFieldSubmitted: (value) {
                                                _nameController.text =
                                                    value.trim();
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return tr(
                                                      'configuration.pass.forms.firstname.errorEmpty');
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5, top: 5),
                                            child: TextFormField(
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              textInputAction:
                                                  TextInputAction.next,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 17,
                                                  //color: Color(#687787),
                                                  color: Color.fromRGBO(
                                                      0, 16, 24, 1),
                                                  fontWeight:
                                                      FontWeight.normal),
                                              decoration: InputDecoration(
                                                focusColor:
                                                    ColorsApp.InputDecoration,
                                                hoverColor:
                                                    ColorsApp.InputDecoration,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                fillColor: Colors.white,
                                                labelText: tr(
                                                    'configuration.pass.forms.lastname.labelText'),
                                                labelStyle: GoogleFonts.roboto(
                                                    letterSpacing: -0.32,
                                                    fontSize: 16,
                                                    //color: Color(#687787),
                                                    color: Color.fromRGBO(
                                                        104, 119, 135, 1),
                                                    fontWeight:
                                                        FontWeight.normal),
                                                hintText: tr(
                                                    'configuration.pass.forms.lastname.hintText'),
                                                hintStyle: GoogleFonts.roboto(
                                                    fontSize: 17,
                                                    //color: Color(#687787),
                                                    color: Color.fromRGBO(
                                                        137, 150, 162, 1),
                                                    fontWeight:
                                                        FontWeight.normal),
                                                /*border: new OutlineInputBorder(
                                                              borderRadius: new BorderRadius.circular(25.0),
                                                              borderSide: new BorderSide(),
                                                            ),*/
                                              ),
                                              controller: _lastNameController,
                                              onFieldSubmitted: (value) {
                                                _lastNameController.text =
                                                    value.trim();
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return tr(
                                                      'configuration.pass.forms.lastname.errorEmpty');
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5, top: 5),
                                            child: TextFormField(
                                              inputFormatters: [
                                                DateTextFormatter()
                                              ],
                                              focusNode:
                                                  textFieldBirthFocusNode,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 17,
                                                  //color: Color(#687787),
                                                  color: Color.fromRGBO(
                                                      0, 16, 24, 1),
                                                  fontWeight:
                                                      FontWeight.normal),
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                      Icons.calendar_today),
                                                  onPressed: () {
                                                    // Unfocus all focus nodes
                                                    textFieldBirthFocusNode
                                                        .unfocus();

                                                    // Disable text field's focus node request
                                                    textFieldBirthFocusNode
                                                            .canRequestFocus =
                                                        false;

                                                    // Do your stuff
                                                    _pickDateDebut();

                                                    //Enable the text field's focus node request after some delay
                                                    Future.delayed(
                                                        Duration(
                                                            milliseconds: 100),
                                                        () {
                                                      textFieldBirthFocusNode
                                                              .canRequestFocus =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                focusColor: ColorsApp.InputDecoration,
                                                hoverColor: ColorsApp.InputDecoration,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                fillColor: Colors.white,
                                                labelText: tr(
                                                    'configuration.pass.forms.birthdate.labelText'),
                                                labelStyle: GoogleFonts.roboto(
                                                    letterSpacing: -0.32,
                                                    fontSize: 16,
                                                    //color: Color(#687787),
                                                    color: Color.fromRGBO(
                                                        104, 119, 135, 1),
                                                    fontWeight:
                                                        FontWeight.normal),
                                                hintText: tr(
                                                    'configuration.pass.forms.birthdate.hintText'),
                                                hintStyle: GoogleFonts.roboto(
                                                    fontSize: 17,
                                                    //color: Color(#687787),
                                                    color: Color.fromRGBO(
                                                        137, 150, 162, 1),
                                                    fontWeight:
                                                        FontWeight.normal),
                                                /*border: new OutlineInputBorder(
                                                              borderRadius: new BorderRadius.circular(25.0),
                                                              borderSide: new BorderSide(),
                                                            ),*/
                                              ),
                                              controller: _birthDateController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return tr(
                                                      'configuration.pass.forms.birthdate.errorEmpty');
                                                }
                                                try {
                                                  DateFormat("dd/MM/yyyy")
                                                      .parse(value);
                                                } catch (e) {
                                                  return tr(
                                                      'configuration.informations.forms.birthdate.errorFormat');
                                                }
                                                if (value.length != 10) {
                                                  return tr(
                                                      'configuration.informations.forms.birthdate.errorFormat');
                                                }
                                                var dateSplit =
                                                    value.split('/');
                                                if (int.parse(dateSplit[1]) >
                                                    12) {
                                                  return tr(
                                                      'configuration.informations.forms.birthdate.errorFormat');
                                                }
                                                if (int.parse(dateSplit[0]) >
                                                    31) {
                                                  return tr(
                                                      'configuration.informations.forms.birthdate.errorFormat');
                                                }
                                                return null;
                                              },
                                              onFieldSubmitted: (value) {
                                                _birthDateController.text =
                                                    value;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5, top: 5),
                                            child: Container(
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color.fromRGBO(
                                                    255, 251, 199, 1),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.card_giftcard,
                                                          size: 20,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      tr('configuration.pass.forms.description'),
                                                      style: GoogleFonts.roboto(
                                                          height: 1.5,
                                                          fontSize: 16,
                                                          //color: Color(#687787),
                                                          color: Color.fromRGBO(
                                                              0, 16, 24, 1),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          BlocBuilder<PassBloc, PassState>(
                                            builder: (context, state) {
                                              if (state
                                                  is FindOpenPassInProgress)
                                                isLoading = true;
                                              else {
                                                isLoading = false;
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5, top: 5),
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    PassTextFormatter()
                                                  ],
                                                  focusNode:
                                                      textFieldPassFocusNode,
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 17,
                                                      //color: Color(#687787),
                                                      color: Color.fromRGBO(
                                                          0, 16, 24, 1),
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  decoration: InputDecoration(
                                                    // suffixIcon: IconButton(
                                                    //   icon: Icon(Icons.crop_free),
                                                    //   onPressed: () async {
                                                    //     // Unfocus all focus nodes
                                                    //     textFieldPassFocusNode
                                                    //         .unfocus();

                                                    //     // Disable text field's focus node request
                                                    //     textFieldPassFocusNode
                                                    //             .canRequestFocus =
                                                    //         false;

                                                    //     NfcBloc nfcBloc =
                                                    //         BlocProvider.of<
                                                    //             NfcBloc>(context);
                                                    //     String pass = '';
                                                    //     bool isAvailable =
                                                    //         await NfcManager
                                                    //             .instance
                                                    //             .isAvailable();
                                                    //     if (!isAvailable) {
                                                    //       await showDialog(
                                                    //         context: context,
                                                    //         builder: (BuildContext
                                                    //                 context) =>
                                                    //             AlertDialog(
                                                    //           title: const Text(
                                                    //               'Activer NFC'),
                                                    //           content: const Text(
                                                    //               'Votre NFC n\est pas activé ou votre appareil n\est pas compatible.'),
                                                    //           actions: <Widget>[
                                                    //             new TextButton(
                                                    //               child: const Text(
                                                    //                   'Fermer'),
                                                    //               onPressed: () {
                                                    //                 Navigator.of(
                                                    //                         context)
                                                    //                     .pop();
                                                    //               },
                                                    //             ),
                                                    //             new TextButton(
                                                    //               child: const Text(
                                                    //                   'Paramètres'),
                                                    //               onPressed: () {
                                                    //                 AppSettings
                                                    //                     .openNFCSettings();
                                                    //                 Navigator.of(
                                                    //                         context)
                                                    //                     .pop();
                                                    //               },
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //       );
                                                    //     } else {
                                                    //       NfcBloc nfcBloc =
                                                    //           BlocProvider.of<
                                                    //               NfcBloc>(context);
                                                    //       pass = await showDialog(
                                                    //           context: context,
                                                    //           builder: (BuildContext
                                                    //                   context) =>
                                                    //               PageNFC(
                                                    //                   nfcBloc:
                                                    //                       nfcBloc));
                                                    //       nfcBloc.add(
                                                    //           StopNFCReading());
                                                    //     }
                                                    //     // Do your stuff
                                                    //     // bool mode = await showDialog(
                                                    //     //     context: context,
                                                    //     //     builder: (BuildContext
                                                    //     //             context) =>
                                                    //     //         DialogMethodScan());
                                                    //     // String pass = '';
                                                    //     // if (!mode) {
                                                    //     //   bool isAvailable =
                                                    //     //       await NfcManager
                                                    //     //           .instance
                                                    //     //           .isAvailable();
                                                    //     //   if (!isAvailable)
                                                    //     //     AppSettings
                                                    //     //         .openNFCSettings();
                                                    //     //   else {
                                                    //     //     NfcBloc nfcBloc =
                                                    //     //         BlocProvider.of<
                                                    //     //                 NfcBloc>(
                                                    //     //             context);
                                                    //     //     pass = await showDialog(
                                                    //     //         context: context,
                                                    //     //         builder: (BuildContext
                                                    //     //                 context) =>
                                                    //     //             PageNFC(
                                                    //     //                 nfcBloc:
                                                    //     //                     nfcBloc));
                                                    //     //     nfcBloc.add(
                                                    //     //         StopNFCReading());
                                                    //     //   }
                                                    //     // } else {
                                                    //     //   final status =
                                                    //     //       await Permission
                                                    //     //           .camera
                                                    //     //           .request();
                                                    //     //   if (status ==
                                                    //     //       PermissionStatus
                                                    //     //           .granted) {
                                                    //     //     print(
                                                    //     //         'Permission granted');
                                                    //     //     pass = await showDialog(
                                                    //     //         context: context,
                                                    //     //         builder: (BuildContext
                                                    //     //                 context) =>
                                                    //     //             PageQRCodeReading());
                                                    //     //     return;
                                                    //     //   } else if (status ==
                                                    //     //       PermissionStatus
                                                    //     //           .denied) {
                                                    //     //     print(
                                                    //     //         'Permission denied. Show a dialog and again ask for the permission');
                                                    //     //   } else if (status ==
                                                    //     //       PermissionStatus
                                                    //     //           .permanentlyDenied) {
                                                    //     //     print(
                                                    //     //         'Take the user to the settings page.');
                                                    //     //     await Future.delayed(
                                                    //     //       Duration(
                                                    //     //           milliseconds:
                                                    //     //               100),
                                                    //     //     );
                                                    //     //     await showDialog(
                                                    //     //       context: context,
                                                    //     //       builder: (BuildContext
                                                    //     //               context) =>
                                                    //     //           AlertDialog(
                                                    //     //         title: const Text(
                                                    //     //             'Permission Caméra'),
                                                    //     //         content: const Text(
                                                    //     //             'Cette application a besoin de votre accord pour utiliser la caméra:'),
                                                    //     //         actions: <Widget>[
                                                    //     //           new TextButton(
                                                    //     //             child: const Text(
                                                    //     //                 'Refuser'),
                                                    //     //             onPressed: () {
                                                    //     //               Navigator.of(
                                                    //     //                       context)
                                                    //     //                   .pop();
                                                    //     //             },
                                                    //     //           ),
                                                    //     //           new TextButton(
                                                    //     //             child: const Text(
                                                    //     //                 'Paramètres'),
                                                    //     //             onPressed: () {
                                                    //     //               openAppSettings();
                                                    //     //               Navigator.of(
                                                    //     //                       context)
                                                    //     //                   .pop();
                                                    //     //             },
                                                    //     //           ),
                                                    //     //         ],
                                                    //     //       ),
                                                    //     //     );
                                                    //     //   }
                                                    //     // }
                                                    //     //Enable the text field's focus node request after some delay
                                                    //     Future.delayed(
                                                    //         Duration(
                                                    //             milliseconds: 100),
                                                    //         () {
                                                    //       textFieldPassFocusNode
                                                    //               .canRequestFocus =
                                                    //           true;
                                                    //     });
                                                    //     setState(() {
                                                    //       if (pass != '')
                                                    //         _passController.text =
                                                    //             pass;
                                                    //     });
                                                    //   },
                                                    // ),
                                                    focusColor: ColorsApp.InputDecoration,
                                                    hoverColor: ColorsApp.InputDecoration,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    fillColor: Colors.white,
                                                    labelText: tr(
                                                        'configuration.pass.forms.pass.labelText'),
                                                    labelStyle:
                                                        GoogleFonts.roboto(
                                                            letterSpacing:
                                                                -0.32,
                                                            fontSize: 16,
                                                            //color: Color(#687787),
                                                            color:
                                                                Color.fromRGBO(
                                                                    104,
                                                                    119,
                                                                    135,
                                                                    1),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                    hintText: tr(
                                                        'configuration.pass.forms.pass.hintText'),
                                                    hintStyle:
                                                        GoogleFonts.roboto(
                                                            fontSize: 17,
                                                            //color: Color(#687787),
                                                            color:
                                                                Color.fromRGBO(
                                                                    137,
                                                                    150,
                                                                    162,
                                                                    1),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                    /*border: new OutlineInputBorder(
                                                                                                            borderRadius: new BorderRadius.circular(25.0),
                                                                                                            borderSide: new BorderSide(),
                                                                                                          ),*/
                                                  ),
                                                  controller: _passController,
                                                  validator: (value) {
                                                    print(openPassResponse);
                                                    print(violationError);
                                                    if (value!.isEmpty) {
                                                      return tr(
                                                          'configuration.pass.forms.pass.errorEmpty');
                                                    }
                                                    if (violationError !=
                                                        null) {
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
                                                        if (widget.contact !=
                                                            null) {
                                                          if (widget.contact!
                                                                  .elibertyId !=
                                                              openPassResponse!
                                                                  .contactId)
                                                            return tr(
                                                                'configuration.sync.forms.pass.errorAssigned');
                                                        } else
                                                          return tr(
                                                              'configuration.sync.forms.pass.errorAssigned');
                                                      }
                                                    }
                                                    return null;
                                                  },
                                                  onFieldSubmitted: (value) {
                                                    _passController.text =
                                                        value;
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 24, top: 32),
                                            child: Container(
                                              height: 56,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    openPassResponse = null;
                                                    violationError = null;
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      BlocProvider.of<PassBloc>(
                                                              context)
                                                          .add(FindOpenPassEvent(
                                                              passNumber:
                                                                  _passController
                                                                      .text));
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                    }
                                                  },
                                                  child: Text(
                                                    'Enregistrer',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 15,
                                                        //color: Color(#687787),
                                                        color: ColorsApp.ContentPrimaryReversed,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  )),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                      (stateConsumer is ConsumerLoadInProgress)
                          ? Loading()
                          : Container(),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  var formatDate = new DateFormat("dd/MM/yyyy");
  _pickDateDebut() async {
    var now = DateTime.now();
    DateTime initialDate = DateTime(2000);

    try {
      if (_birthDateController.text != '')
        initialDate = formatDate.parse(_birthDateController.text);
      if (initialDate.isBefore(
        DateTime(DateTime.now().year - 100),
      )) initialDate = DateTime(2000);
    } catch (e) {
      print(e);
    }
    DateTime? date = await showDatePicker(
      context: context,
      locale: const Locale("fr", "FR"),
      lastDate: DateTime.now(),
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 100),
    );
    if (date != null)
      setState(() {
        _birthDateController.text = formatDate.format(date);
      });
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
