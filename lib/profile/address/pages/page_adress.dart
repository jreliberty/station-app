// ignore_for_file: close_sinks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/functions/functions.dart';
import '../../../core/utils/loading.dart';
import '../../../entities/adress.dart';

class PageAdress extends StatefulWidget {
  PageAdress({Key? key}) : super(key: key);

  @override
  _PageAdressState createState() => _PageAdressState();
}

class _PageAdressState extends State<PageAdress> {
  Address? defaultAdress;
  late String contactId;
  TextEditingController _streetController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();

  BehaviorSubject<String> _bhvsstreet = BehaviorSubject.seeded('');
  BehaviorSubject<String> _bhvszipCode = BehaviorSubject.seeded('');
  BehaviorSubject<String> _bhvscity = BehaviorSubject.seeded('');
  BehaviorSubject<String> _bhvscountry = BehaviorSubject.seeded('');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (BlocProvider.of<ConsumerBloc>(context).state is ConsumerLoadSuccess) {
      var user =
          (BlocProvider.of<ConsumerBloc>(context).state as ConsumerLoadSuccess)
              .user;
      if (user.adresses.isNotEmpty)
        user.adresses.forEach((_adress) {
          if (_adress.isPrefered) {
            defaultAdress = _adress;
            _streetController.text = _adress.street;
            _postalCodeController.text = _adress.postalCode;
            _cityController.text = _adress.city;
            _countryController.text = _adress.country;
          }
        });
      contactId = user.contactId;
    }

    _bhvsstreet.value = _streetController.text;
    _bhvszipCode.value = _postalCodeController.text;
    _bhvscity.value = _cityController.text;
    _bhvscountry.value = _countryController.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<ConsumerBloc, ConsumerState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: BlocListener<ConsumerBloc, ConsumerState>(
            listener: (context, state) {
              if (state is ConsumerLoadSuccess) Navigator.of(context).pop();

              if (state is ConsumerLoadFailure)
                ScaffoldMessenger.of(context).showSnackBar(
                  personalisedSnackBar(
                      title: 'Vous n\'avez plus de connexion internet',
                      funtion: () {
                        BlocProvider.of<ConsumerBloc>(context)
                            .add(InitConsumerEvent());
                      },
                      label: 'Réessayer'),
                );
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                            onNotification:
                                (OverscrollIndicatorNotification overScroll) {
                              overScroll.disallowIndicator();
                              return false;
                            },
                            child: ListView(children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(FlutterRemix.arrow_left_line),
                                    color: ColorsApp.ContentPrimary,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      'Mon adresse',
                                      style: GoogleFonts.roboto(
                                          height: 1.2,
                                          fontSize: 20,
                                          color: ColorsApp.ContentPrimary,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5, top: 24),
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) =>
                                      _bhvsstreet.value = value,
                                  style: GoogleFonts.roboto(
                                      fontSize: 17,
                                      //color: Color(#687787),
                                      color: ColorsApp.ContentPrimary,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                    focusColor: ColorsApp.InputDecoration,
                                    hoverColor: ColorsApp.InputDecoration,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    fillColor: Colors.white,
                                    labelText: 'N° et nom de la rue',
                                    labelStyle: GoogleFonts.roboto(
                                        letterSpacing: -0.32,
                                        fontSize: 16,
                                        //color: Color(#687787),
                                        color: ColorsApp.ContentTertiary,
                                        fontWeight: FontWeight.normal),
                                    hintText: "1 rue de la République",
                                    hintStyle: GoogleFonts.roboto(
                                        fontSize: 17,
                                        //color: Color(#687787),
                                        color: Color.fromRGBO(137, 150, 162, 1),
                                        fontWeight: FontWeight.normal),
                                    /*border: new OutlineInputBorder(
                                                                          borderRadius: new BorderRadius.circular(25.0),
                                                                          borderSide: new BorderSide(),
                                                                        ),*/
                                  ),
                                  controller: _streetController,
                                  onFieldSubmitted: (value) {
                                    _streetController.text = value.trim();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Saisissez votre rue.';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, top: 5, right: 12),
                                      child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (value) =>
                                            _bhvszipCode.value = value,
                                        style: GoogleFonts.roboto(
                                            fontSize: 17,
                                            //color: Color(#687787),
                                            color: ColorsApp.ContentPrimary,
                                            fontWeight: FontWeight.normal),
                                        decoration: InputDecoration(
                                          focusColor: ColorsApp.InputDecoration,
                                          hoverColor: ColorsApp.InputDecoration,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          fillColor: Colors.white,
                                          labelText: 'Code postal',
                                          labelStyle: GoogleFonts.roboto(
                                              letterSpacing: -0.32,
                                              fontSize: 16,
                                              //color: Color(#687787),
                                              color: Color.fromRGBO(
                                                  104, 119, 135, 1),
                                              fontWeight: FontWeight.normal),
                                          hintText: "38000",
                                          hintStyle: GoogleFonts.roboto(
                                              fontSize: 17,
                                              //color: Color(#687787),
                                              color: Color.fromRGBO(
                                                  137, 150, 162, 1),
                                              fontWeight: FontWeight.normal),
                                          /*border: new OutlineInputBorder(
                                                                                borderRadius: new BorderRadius.circular(25.0),
                                                                                borderSide: new BorderSide(),
                                                                              ),*/
                                        ),
                                        controller: _postalCodeController,
                                        onFieldSubmitted: (value) {
                                          _postalCodeController.text =
                                              value.trim();
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Saisissez votre code postal.';
                                          }
                                          if (int.tryParse(value) == null ||
                                              value.length != 5) {
                                            return 'Format invalide.';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, top: 5),
                                      child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (value) =>
                                            _bhvscity.value = value,
                                        style: GoogleFonts.roboto(
                                            fontSize: 17,
                                            //color: Color(#687787),
                                            color: ColorsApp.ContentPrimary,
                                            fontWeight: FontWeight.normal),
                                        decoration: InputDecoration(
                                          focusColor: ColorsApp.InputDecoration,
                                          hoverColor: ColorsApp.InputDecoration,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          fillColor: Colors.white,
                                          labelText: 'Ville',
                                          labelStyle: GoogleFonts.roboto(
                                              letterSpacing: -0.32,
                                              fontSize: 16,
                                              //color: Color(#687787),
                                              color: Color.fromRGBO(
                                                  104, 119, 135, 1),
                                              fontWeight: FontWeight.normal),
                                          hintText: "Grenoble",
                                          hintStyle: GoogleFonts.roboto(
                                              fontSize: 17,
                                              //color: Color(#687787),
                                              color: Color.fromRGBO(
                                                  137, 150, 162, 1),
                                              fontWeight: FontWeight.normal),
                                          /*border: new OutlineInputBorder(
                                                                            borderRadius: new BorderRadius.circular(25.0),
                                                                            borderSide: new BorderSide(),
                                                                          ),*/
                                        ),
                                        controller: _cityController,
                                        onFieldSubmitted: (value) {
                                          _cityController.text = value.trim();
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Saisissez votre ville.';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5, top: 5),
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (value) =>
                                      _bhvscountry.value = value,
                                  style: GoogleFonts.roboto(
                                      fontSize: 17,
                                      //color: Color(#687787),
                                      color: ColorsApp.ContentPrimary,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                    focusColor: ColorsApp.InputDecoration,
                                    hoverColor: ColorsApp.InputDecoration,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    fillColor: Colors.white,
                                    labelText: 'Pays',
                                    labelStyle: GoogleFonts.roboto(
                                        letterSpacing: -0.32,
                                        fontSize: 16,
                                        //color: Color(#687787),
                                        color: ColorsApp.ContentTertiary,
                                        fontWeight: FontWeight.normal),
                                    hintText: "France",
                                    hintStyle: GoogleFonts.roboto(
                                        fontSize: 17,
                                        //color: Color(#687787),
                                        color: Color.fromRGBO(137, 150, 162, 1),
                                        fontWeight: FontWeight.normal),
                                    /*border: new OutlineInputBorder(
                                                                          borderRadius: new BorderRadius.circular(25.0),
                                                                          borderSide: new BorderSide(),
                                                                        ),*/
                                  ),
                                  controller: _countryController,
                                  onFieldSubmitted: (value) {
                                    _countryController.text = value.trim();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Saisissez votre pays.';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              StreamBuilder<Object>(
                                  stream: Rx.combineLatest4(
                                      _bhvscity,
                                      _bhvszipCode,
                                      _bhvsstreet,
                                      _bhvscountry, (String city,
                                          String zipCode,
                                          String street,
                                          String country) {
                                    return (street != '' &&
                                        zipCode != '' &&
                                        city != '' &&
                                        country != '');
                                  }),
                                  builder: (context, snapshot) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 24, top: 32),
                                      child: Container(
                                        height: 56,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: (snapshot.data ==
                                                        false)
                                                    ? ColorsApp
                                                        .BackgroundBrandInactive
                                                    : ColorsApp
                                                        .BackgroundBrandPrimary),
                                            onPressed: (snapshot.data == false)
                                                ? null
                                                : () async {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      if (defaultAdress ==
                                                          null) {
                                                        var body = {
                                                          "contact":
                                                              "/api/contacts/$contactId",
                                                          "title":
                                                              _countryController
                                                                  .text
                                                                  .trim(),
                                                          "locality":
                                                              _cityController
                                                                  .text
                                                                  .trim(),
                                                          "country_code": "FRA",
                                                          "street":
                                                              _streetController
                                                                  .text
                                                                  .trim(),
                                                          "postal_code":
                                                              _postalCodeController
                                                                  .text
                                                                  .trim(),
                                                          "favorite": true,
                                                          "address_type": 1
                                                        };
                                                        BlocProvider.of<
                                                                    ConsumerBloc>(
                                                                context)
                                                            .add(CreateContactAdressEvent(
                                                                body:
                                                                    jsonEncode(
                                                                        body)));
                                                      } else {
                                                        var body = {
                                                          "title":
                                                              _countryController
                                                                  .text
                                                                  .trim(),
                                                          "locality":
                                                              _cityController
                                                                  .text
                                                                  .trim(),
                                                          "country_code": "FRA",
                                                          "street":
                                                              _streetController
                                                                  .text
                                                                  .trim(),
                                                          "postal_code":
                                                              _postalCodeController
                                                                  .text
                                                                  .trim(),
                                                          "favorite": true,
                                                          "address_type": 1
                                                        };
                                                        BlocProvider.of<
                                                                    ConsumerBloc>(
                                                                context)
                                                            .add(UpdateContactAdressEvent(
                                                                body:
                                                                    jsonEncode(
                                                                        body),
                                                                adressId:
                                                                    defaultAdress!
                                                                        .id));
                                                      }

                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                    }
                                                  },
                                            child: Text(
                                              'Enregistrer mes modifications',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 15,
                                                  //color: Color(#687787),
                                                  color: ColorsApp
                                                      .ContentPrimaryReversed,
                                                  fontWeight: FontWeight.w700),
                                            )),
                                      ),
                                    );
                                  }),
                              Text(
                                'Decathlon s’engage à ne pas communiquer vos coordonnées à des tiers, conformément au Règlement Général sur la Protection des Données.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    //color: Color(#687787),
                                    color: ColorsApp.ContentTertiary,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                (state is ConsumerLoadInProgress) ? Loading() : Container(),
              ],
            ),
          ),
        );
      },
    ));
  }
}
