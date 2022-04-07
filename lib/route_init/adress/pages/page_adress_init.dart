// ignore_for_file: close_sinks

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/utils/loading.dart';
import '../../../entities/adress.dart';
import '../../../entities/user.dart';

class PageAdressInit extends StatefulWidget {
  final TabController controller;
  PageAdressInit({Key? key, required this.controller}) : super(key: key);

  @override
  _PageAdressInitState createState() => _PageAdressInitState();
}

class _PageAdressInitState extends State<PageAdressInit> {
  TextEditingController _streetController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();

  BehaviorSubject<String> _bhvsstreet = BehaviorSubject.seeded('');
  BehaviorSubject<String> _bhvszipCode = BehaviorSubject.seeded('');
  BehaviorSubject<String> _bhvscity = BehaviorSubject.seeded('');
  BehaviorSubject<String> _bhvscountry = BehaviorSubject.seeded('');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final key = new GlobalKey();
  Address? defaultAdress;
  late User user;
  late String contactId;

  @override
  void initState() {
    if (BlocProvider.of<ConsumerBloc>(context).state is ConsumerLoadSuccess) {
      _countryController.text = 'France';
      user =
          (BlocProvider.of<ConsumerBloc>(context).state as ConsumerLoadSuccess)
              .user;
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
    return BlocListener<ConsumerBloc, ConsumerState>(
      listener: (context, state) {
        if (state is ConsumerLoadSuccess) widget.controller.animateTo(2);
      },
      child: BlocBuilder<ConsumerBloc, ConsumerState>(
        builder: (context, state) {
          return Scaffold(
              body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage("assets/Pattern.png"),
                ),
              ),
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
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color:
                                            Color.fromRGBO(239, 241, 243, 1)),
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      color: ColorsApp.ContentPrimary,
                                      onPressed: () {
                                        widget.controller.animateTo(0);
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 0, bottom: 16),
                                  child: Text(
                                    tr('configuration.address.title'),
                                    style: GoogleFonts.roboto(
                                        fontSize: 36,
                                        //color: Color(#687787),
                                        color: ColorsApp.ContentPrimary,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Text(
                                  tr('configuration.address.subtitle'),
                                  style: GoogleFonts.roboto(
                                      letterSpacing: -0.24,
                                      fontSize: 15,
                                      //color: Color(#687787),
                                      color: ColorsApp.ContentTertiary,
                                      fontWeight: FontWeight.w400),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 5, top: 24),
                                  child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.words,
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
                                      labelText: tr(
                                          'configuration.address.forms.road.labelText'),
                                      labelStyle: GoogleFonts.roboto(
                                          letterSpacing: -0.32,
                                          fontSize: 16,
                                          //color: Color(#687787),
                                          color: ColorsApp.ContentTertiary,
                                          fontWeight: FontWeight.normal),
                                      hintText: tr(
                                          'configuration.address.forms.road.hintText'),
                                      hintStyle: GoogleFonts.roboto(
                                          fontSize: 17,
                                          //color: Color(#687787),
                                          color:
                                              Color.fromRGBO(137, 150, 162, 1),
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
                                        return tr(
                                            'configuration.address.forms.road.errorEmpty');
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
                                            focusColor:
                                                ColorsApp.InputDecoration,
                                            hoverColor:
                                                ColorsApp.InputDecoration,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            fillColor: Colors.white,
                                            labelText: tr(
                                                'configuration.address.forms.zipcode.labelText'),
                                            labelStyle: GoogleFonts.roboto(
                                                letterSpacing: -0.32,
                                                fontSize: 16,
                                                //color: Color(#687787),
                                                color: Color.fromRGBO(
                                                    104, 119, 135, 1),
                                                fontWeight: FontWeight.normal),
                                            hintText: tr(
                                                'configuration.address.forms.zipcode.hintText'),
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
                                              return tr(
                                                  'configuration.address.forms.zipcode.errorEmpty');
                                            }
                                            if (int.tryParse(value) == null ||
                                                value.length != 5) {
                                              return tr(
                                                  'configuration.address.forms.zipcode.errorFormat');
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
                                            focusColor:
                                                ColorsApp.InputDecoration,
                                            hoverColor:
                                                ColorsApp.InputDecoration,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            fillColor: Colors.white,
                                            labelText: tr(
                                                'configuration.address.forms.city.labelText'),
                                            labelStyle: GoogleFonts.roboto(
                                                letterSpacing: -0.32,
                                                fontSize: 16,
                                                //color: Color(#687787),
                                                color: Color.fromRGBO(
                                                    104, 119, 135, 1),
                                                fontWeight: FontWeight.normal),
                                            hintText: tr(
                                                'configuration.address.forms.city.hintText'),
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
                                              return tr(
                                                  'configuration.address.forms.city.errorEmpty');
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
                                    textCapitalization:
                                        TextCapitalization.words,
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
                                          color:
                                              Color.fromRGBO(137, 150, 162, 1),
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
                                              onPressed: (snapshot.data ==
                                                      false)
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
                                                            "country_code":
                                                                "FRA",
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
                                                                  body: jsonEncode(
                                                                      body)));
                                                        } else {
                                                          var body = {
                                                            "contact":
                                                                "/api/contacts/$contactId",
                                                            "title":
                                                                _countryController
                                                                    .text,
                                                            "locality":
                                                                _cityController
                                                                    .text,
                                                            "country_code":
                                                                "FRA",
                                                            "street":
                                                                _streetController
                                                                    .text,
                                                            "postal_code":
                                                                _postalCodeController
                                                                    .text,
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
                                                tr('configuration.address.buttons.button1.label'),
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
                                Text(
                                  tr('configuration.terms'),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      //color: Color(#687787),
                                      color: ColorsApp.ContentTertiary,
                                      fontWeight: FontWeight.w400),
                                ),
                                /*Tooltip(
                                            key: key,
                                            message:
                                                'Vous trouverez votre numéro à 12 caractères au recto de votre pass Ski On Demand acheté en magasin.',
                                            child: IconButton(
                                                icon: Icon(Icons.info),
                                                onPressed: () {
                                                  final dynamic tooltip = key.currentState;
                                                  tooltip.ensureTooltipVisible();
                                                }),
                                          )*/
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
          ));
        },
      ),
    );
  }
}
