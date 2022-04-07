// ignore_for_file: close_sinks

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/formatters/date_input_formatter.dart';
import '../../../core/utils/loading.dart';
import '../../../entities/user.dart';

class PagePersonalInfoInit extends StatefulWidget {
  final TabController controller;
  PagePersonalInfoInit({Key? key, required this.controller}) : super(key: key);

  @override
  _PagePersonalInfoInitState createState() => _PagePersonalInfoInitState();
}

class _PagePersonalInfoInitState extends State<PagePersonalInfoInit> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _mailController = TextEditingController();

  BehaviorSubject<String> _bhvsname = BehaviorSubject.seeded('');
  BehaviorSubject<String> _bhvslastName = BehaviorSubject.seeded('');
  BehaviorSubject<String> _bhvsbirthDate = BehaviorSubject.seeded('');
  BehaviorSubject<String> _bhvsphone = BehaviorSubject.seeded('');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final key = new GlobalKey();
  final countryController = TextEditingController(text: '+ 33');

  var currentSelectedCountry = CountryWithPhoneCode.us();

  var placeholderHint = '';

  void updatePlaceholderHint() {
    late String newPlaceholder;

    newPlaceholder = currentSelectedCountry.exampleNumberMobileNational;

    setState(() => placeholderHint = newPlaceholder);
  }

  late User consumer;

  @override
  void initState() {
    if (BlocProvider.of<ConsumerBloc>(context).state is ConsumerLoadSuccess) {
      consumer =
          (BlocProvider.of<ConsumerBloc>(context).state as ConsumerLoadSuccess)
              .user;
      _nameController.text = consumer.firstName;
      _lastNameController.text = consumer.lastName;
      if (consumer.birthDate != null)
        _birthDateController.text = formatDate.format(consumer.birthDate!);
      else
        _birthDateController.text = '';
      _phoneController.text = consumer.phoneNumber;

      _mailController.text = consumer.email;
    }
    init();
    _bhvsname.value = _nameController.text;
    _bhvslastName.value = _lastNameController.text;
    _bhvsbirthDate.value = _birthDateController.text;
    _bhvsphone.value = _phoneController.text;

    super.initState();
  }

  init() async {
    await FlutterLibphonenumber().init();
    currentSelectedCountry = CountryManager()
        .countries
        .where((element) => element.countryCode == 'FR')
        .first;
    if (_phoneController.text != '') {
      try {
        final res = await FlutterLibphonenumber().parse(
          _phoneController.text.replaceFirst("+337", "+336"),
          region: currentSelectedCountry.countryCode,
        );
        if (_phoneController.text.contains("+337"))
          _phoneController.text =
              res['national'].toString().replaceFirst("6", "7");
        else
          _phoneController.text = res['national'];
      } catch (e) {}
    }

    currentSelectedCountry = CountryManager()
        .countries
        .where((element) => element.countryCode == 'FR')
        .first;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConsumerBloc, ConsumerState>(
      listener: (context, state) {
        if (state is ConsumerLoadSuccess) widget.controller.animateTo(1);
      },
      child: BlocBuilder<ConsumerBloc, ConsumerState>(
        builder: (context, state) {
          return Scaffold(
              body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage("assets/Pattern.png"),
              ),
            ),
            child: Stack(
              children: [
                Form(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 24.0,
                                left: 24.0,
                                top: 24.0,
                              ),
                              child: NotificationListener<
                                  OverscrollIndicatorNotification>(
                                onNotification: (OverscrollIndicatorNotification
                                    overScroll) {
                                  overScroll.disallowIndicator();
                                  return false;
                                },
                                child: ListView(children: [
                                  /*Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Color.fromRGBO(239, 241, 243, 1)),
                                            height: 40,
                                            width: 40,
                                            child: IconButton(
                                              icon: Icon(Icons.arrow_back),
                                              color: ColorsApp.ContentPrimary,
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),*/
                                  // StreamBuilder<DocumentSnapshot>(
                                  //     stream: FirebaseFirestore.instance
                                  //         .collection('config')
                                  //         .doc('CONFIG')
                                  //         .snapshots(),
                                  //     builder: (context, snapshot) {
                                  //       bool isInPub = true;
                                  //       if (snapshot.hasData) {
                                  //         var data = snapshot.data;
                                  //         print(data!["isInProduction"]);
                                  //         isInPub = data["isInProduction"];
                                  //       }
                                  //       if (isInPub)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return new AlertDialog(
                                                title:
                                                    Text(tr('common.careful')),
                                                content: Text(
                                                    'Est-tu sûr de vouloir ignorer la configuration ?'),
                                                actions: <Widget>[
                                                  new TextButton(
                                                    child:
                                                        Text(tr('common.yes')),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      var prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      await prefs.setString(
                                                          'init', 'true');
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                      widget.controller
                                                          .animateTo(5);
                                                    },
                                                  ),
                                                  new TextButton(
                                                    child:
                                                        Text(tr('common.no')),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Ignorer pour l\'instant',
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              //color: Color(#687787),
                                              color: Color.fromRGBO(
                                                  0, 125, 188, 1),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                  //   else
                                  //     return Container();
                                  // }),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 24, bottom: 16),
                                        child: Text(
                                          tr('configuration.informations.title'),
                                          style: GoogleFonts.roboto(
                                              fontSize: 36,
                                              //color: Color(#687787),
                                              color: ColorsApp.ContentPrimary,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Text(
                                        tr('configuration.informations.subtitle'),
                                        style: GoogleFonts.roboto(
                                            letterSpacing: -0.24,
                                            fontSize: 15,
                                            //color: Color(#687787),
                                            color: Color.fromRGBO(
                                                104, 119, 135, 1),
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 24),
                                        child: TextFormField(
                                          textCapitalization:
                                              TextCapitalization.words,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (value) =>
                                              _bhvsname.value = value,
                                          //autofocus: true,
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
                                                'configuration.informations.forms.firstname.labelText'),
                                            labelStyle: GoogleFonts.roboto(
                                                letterSpacing: -0.32,
                                                fontSize: 16,
                                                //color: Color(#687787),
                                                color: Color.fromRGBO(
                                                    104, 119, 135, 1),
                                                fontWeight: FontWeight.normal),
                                            hintText: tr(
                                                'configuration.informations.forms.firstname.hintText'),
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
                                          controller: _nameController,
                                          onFieldSubmitted: (value) {
                                            _nameController.text = value.trim();
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return tr(
                                                  'configuration.informations.forms.firstname.errorEmpty');
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
                                          textInputAction: TextInputAction.next,
                                          onChanged: (value) =>
                                              _bhvslastName.value = value,
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
                                                'configuration.informations.forms.lastname.labelText'),
                                            labelStyle: GoogleFonts.roboto(
                                                letterSpacing: -0.32,
                                                fontSize: 16,
                                                //color: Color(#687787),
                                                color: Color.fromRGBO(
                                                    104, 119, 135, 1),
                                                fontWeight: FontWeight.normal),
                                            hintText: tr(
                                                'configuration.informations.forms.lastname.hintText'),
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
                                          controller: _lastNameController,
                                          onFieldSubmitted: (value) {
                                            _lastNameController.text = value;
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return tr(
                                                  'configuration.informations.forms.lastname.errorEmpty');
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: TextFormField(
                                                onChanged: (value) =>
                                                    _bhvsbirthDate.value =
                                                        value,
                                                inputFormatters: [
                                                  DateTextFormatter()
                                                ],
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
                                                      _pickDateDebut();
                                                    },
                                                  ),
                                                  focusColor:
                                                      ColorsApp.InputDecoration,
                                                  hoverColor:
                                                      ColorsApp.InputDecoration,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  fillColor: Colors.white,
                                                  labelText: tr(
                                                      'configuration.informations.forms.birthdate.labelText'),
                                                  labelStyle:
                                                      GoogleFonts.roboto(
                                                          letterSpacing: -0.32,
                                                          fontSize: 16,
                                                          color: Color.fromRGBO(
                                                              104, 119, 135, 1),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                  hintText: tr(
                                                      'configuration.informations.forms.birthdate.hintText'),
                                                  hintStyle: GoogleFonts.roboto(
                                                      fontSize: 17,
                                                      color: Color.fromRGBO(
                                                          137, 150, 162, 1),
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                controller:
                                                    _birthDateController,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return tr(
                                                        'configuration.informations.forms.birthdate.errorEmpty');
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
                                                  var now = DateTime.now();
                                                  var date18 = DateTime(
                                                      now.year - 18,
                                                      now.month,
                                                      now.day);
                                                  var date =
                                                      DateFormat("dd/MM/yyyy")
                                                          .parse(value);
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
                                                  if (date.isAfter(date18))
                                                    return 'Vous n\'avez pas 18 ans.';
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    focusColor: ColorsApp
                                                        .InputDecoration,
                                                    hoverColor: ColorsApp
                                                        .InputDecoration,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    fillColor: Colors.white,
                                                    labelText: '',
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
                                                    hintText: '',
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
                                                  controller: countryController,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  onChanged: (v) {
                                                    setState(() {});
                                                  },
                                                  textAlign: TextAlign.center,
                                                  onTap: () async {
                                                    final sortedCountries =
                                                        CountryManager()
                                                            .countries
                                                          ..sort((a, b) =>
                                                              (a.countryName ??
                                                                      '')
                                                                  .compareTo(
                                                                      b.countryName ??
                                                                          ''));
                                                    final res =
                                                        await showModalBottomSheet<
                                                            CountryWithPhoneCode>(
                                                      context: context,
                                                      isScrollControlled: false,
                                                      builder: (context) {
                                                        return ListView.builder(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 16),
                                                          itemBuilder:
                                                              (context, index) {
                                                            final item =
                                                                sortedCountries[
                                                                    index];
                                                            return GestureDetector(
                                                              behavior:
                                                                  HitTestBehavior
                                                                      .opaque,
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(item);
                                                              },
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            24,
                                                                        vertical:
                                                                            16),
                                                                child: Row(
                                                                  children: [
                                                                    /// Phone code
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        '+' +
                                                                            item.phoneCode,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                      ),
                                                                    ),

                                                                    /// Spacer
                                                                    SizedBox(
                                                                        width:
                                                                            16),

                                                                    /// Name
                                                                    Expanded(
                                                                      flex: 8,
                                                                      child: Text(
                                                                          item.countryName ??
                                                                              ''),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          itemCount:
                                                              sortedCountries
                                                                  .length,
                                                        );
                                                      },
                                                    );

                                                    if (res != null) {
                                                      setState(() {
                                                        currentSelectedCountry =
                                                            res;
                                                      });

                                                      updatePlaceholderHint();

                                                      countryController.text =
                                                          '+ ${res.phoneCode}';
                                                    }
                                                  },
                                                  readOnly: true,
                                                  inputFormatters: [],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: TextFormField(
                                                onChanged: (value) =>
                                                    _bhvsphone.value = value,
                                                inputFormatters: [
                                                  LibPhonenumberTextFormatter(
                                                    phoneNumberFormat:
                                                        PhoneNumberFormat
                                                            .national,
                                                    country:
                                                        currentSelectedCountry,
                                                    inputContainsCountryCode:
                                                        true,
                                                  ),
                                                ],
                                                keyboardType:
                                                    TextInputType.phone,
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
                                                      'configuration.informations.forms.phone.labelText'),
                                                  labelStyle:
                                                      GoogleFonts.roboto(
                                                          letterSpacing: -0.32,
                                                          fontSize: 16,
                                                          //color: Color(#687787),
                                                          color: Color.fromRGBO(
                                                              104, 119, 135, 1),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                  hintText: currentSelectedCountry
                                                      .exampleNumberMobileNational,
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
                                                controller: _phoneController,
                                                onFieldSubmitted: (value) {
                                                  _phoneController.text = value;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return tr(
                                                        'configuration.informations.forms.phone.errorEmpty');
                                                  }
                                                  if (value.length != 14) {
                                                    return tr(
                                                        'profile.informations.forms.phone.errorFormat');
                                                  }
                                                  if (!(value
                                                          .startsWith('06') ||
                                                      value.startsWith('07'))) {
                                                    return tr(
                                                        'profile.informations.forms.phone.errorFormat');
                                                  }

                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 5),
                                        child: TextFormField(
                                          readOnly: true,
                                          keyboardType:
                                              TextInputType.emailAddress,
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
                                                'configuration.informations.forms.email.labelText'),
                                            labelStyle: GoogleFonts.roboto(
                                                letterSpacing: -0.32,
                                                fontSize: 16,
                                                //color: Color(#687787),
                                                color: Color.fromRGBO(
                                                    104, 119, 135, 1),
                                                fontWeight: FontWeight.normal),
                                            hintText: tr(
                                                'configuration.informations.forms.email.hintText'),
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
                                          controller: _mailController,
                                          onFieldSubmitted: (value) {
                                            _mailController.text = value;
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return tr(
                                                  'configuration.informations.forms.email.errorEmpty');
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      StreamBuilder<Object>(
                                          stream: Rx.combineLatest4(
                                              _bhvsbirthDate,
                                              _bhvslastName,
                                              _bhvsname,
                                              _bhvsphone, (String birthdate,
                                                  String lastName,
                                                  String name,
                                                  String phone) {
                                            return (name != '' &&
                                                lastName != '' &&
                                                birthdate != '' &&
                                                phone != '');
                                          }),
                                          builder: (context, snapshot) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 24, top: 32),
                                              child: Container(
                                                width: double.infinity,
                                                height: 56,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      primary: (snapshot
                                                                  .data ==
                                                              false)
                                                          ? ColorsApp
                                                              .BackgroundBrandInactive
                                                          : ColorsApp
                                                              .BackgroundBrandPrimary),
                                                  onPressed:
                                                      (snapshot.data == false)
                                                          ? null
                                                          : () async {
                                                              var internationalNumber =
                                                                  _phoneController
                                                                      .text
                                                                      .replaceFirst(
                                                                          '0',
                                                                          '+33')
                                                                      .replaceAll(
                                                                          " ",
                                                                          "");
                                                              setState(() {});
                                                              print(
                                                                  internationalNumber);
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                var date =
                                                                    _birthDateController
                                                                        .text
                                                                        .split(
                                                                            "/");
                                                                if (consumer
                                                                        .firstName ==
                                                                    '') {
                                                                  var body = {
                                                                    "contact": {
                                                                      "first_name": _nameController
                                                                          .text
                                                                          .trim(),
                                                                      "last_name": _lastNameController
                                                                          .text
                                                                          .trim(),
                                                                      "birth_date":
                                                                          '${date[2]}/${date[1]}/${date[0]}',
                                                                      "mobile_phone_number":
                                                                          internationalNumber,
                                                                      "language":
                                                                          "fr",
                                                                      "country_code":
                                                                          "FR",
                                                                      "gender":
                                                                          "male"
                                                                    }
                                                                  };
                                                                  var bodyUpdateForPhoneNumber =
                                                                      {
                                                                    "first_name":
                                                                        _nameController
                                                                            .text
                                                                            .trim(),
                                                                    "last_name":
                                                                        _lastNameController
                                                                            .text
                                                                            .trim(),
                                                                    "birth_date":
                                                                        '${date[2]}/${date[1]}/${date[0]}',
                                                                    "mobile_phone_number":
                                                                        internationalNumber,
                                                                    "language":
                                                                        "fr",
                                                                    "country_code":
                                                                        "FR",
                                                                    "gender":
                                                                        "male"
                                                                  };
                                                                  BlocProvider.of<ConsumerBloc>(context).add(CreateContactEvent(
                                                                      body: jsonEncode(
                                                                          body),
                                                                      bodyPhone:
                                                                          jsonEncode(
                                                                              bodyUpdateForPhoneNumber),
                                                                      userId: consumer
                                                                          .id));
                                                                } else {
                                                                  var body = {
                                                                    "first_name":
                                                                        _nameController
                                                                            .text
                                                                            .trim(),
                                                                    "last_name":
                                                                        _lastNameController
                                                                            .text
                                                                            .trim(),
                                                                    "birth_date":
                                                                        '${date[2]}/${date[1]}/${date[0]}',
                                                                    "mobile_phone_number":
                                                                        internationalNumber,
                                                                    "language":
                                                                        "fr",
                                                                    "country_code":
                                                                        "FR",
                                                                    "gender":
                                                                        "male"
                                                                  };
                                                                  BlocProvider.of<
                                                                              ConsumerBloc>(
                                                                          context)
                                                                      .add(
                                                                          UpdateContactPersonalInfoEvent(
                                                                    body: jsonEncode(
                                                                        body),
                                                                    contactId:
                                                                        consumer
                                                                            .contactId,
                                                                  ));
                                                                }
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        FocusNode());
                                                              }
                                                            },
                                                  child: Text(
                                                    tr('configuration.informations.buttons.button1.label'),
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 15,
                                                        //color: Color(#687787),
                                                        color: ColorsApp
                                                            .ContentPrimaryReversed,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                      Text(
                                        tr('configuration.terms'),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            //color: Color(#687787),
                                            color: Color.fromRGBO(
                                                104, 119, 135, 1),
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: 24,
                                      )
                                    ],
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
                  ),
                ),
                (state is ConsumerLoadInProgress) ? Loading() : Container(),
              ],
            ),
          ));
        },
      ),
    );
  }

  var formatDate = new DateFormat("dd/MM/yyyy");
  _pickDateDebut() async {
    var now = DateTime.now();
    DateTime initialDate = DateTime(2000);
    if (consumer.birthDate != null) initialDate = consumer.birthDate!;
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
        _bhvsbirthDate.value = formatDate.format(date);
      });
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
