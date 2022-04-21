import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:station/constants/colors.dart';

import '../../../blocs/connexion/connexion_bloc.dart';
import '../../loading/loading.dart';

class PageLogin extends StatefulWidget {
  PageLogin({Key? key}) : super(key: key);

  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  List<Locale> languages = [Locale('fr', 'FR'), Locale('en', 'US')];
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  BehaviorSubject<String> _bhvsemail = BehaviorSubject.seeded('');
  BehaviorSubject<String> _bhvspassword = BehaviorSubject.seeded('');
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ConnexionBloc>(context).add(GetCredentialsEvent());
  }

  bool keepLogin = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnexionBloc, ConnexionState>(
      listener: (context, state) {
        if (state is GettingJwtInProgress) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => LoadingConnection()));
        }
        // TODO: implement listener
      },
      child: Scaffold(
        body: BlocBuilder<ConnexionBloc, ConnexionState>(
          builder: (context, state) {
            if (state is GettingCredentialsDone) {
                _emailController.text = state.credentials.email;
                _passwordController.text = state.credentials.password;
                _bhvsemail.value = state.credentials.email;
                _bhvspassword.value = state.credentials.password;
              }
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                width: double.infinity,
                color: Color.fromARGB(255, 233, 231, 231),
                // decoration: BoxDecoration(
                //   color: Color.fromRGBO(0, 125, 188, 1),
                //   image: DecorationImage(
                //     image: AssetImage("assets/login_fond.jpeg"),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: 40,
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: SvgPicture.asset('assets/logo_npy.svg'),
                      ),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: 8,
                      ),
                      Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 125, 188, 1),
                          image: DecorationImage(
                            image: AssetImage("assets/en_tete.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            NotificationListener<
                                OverscrollIndicatorNotification>(
                              onNotification:
                                  (OverscrollIndicatorNotification overScroll) {
                                overScroll.disallowIndicator();
                                return false;
                              },
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "S'identifier",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              fontSize: 25,
                                              color: ColorsApp.ContentPrimary,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8, top: 16),
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textCapitalization:
                                                TextCapitalization.none,
                                            textInputAction:
                                                TextInputAction.next,
                                            onChanged: (value) =>
                                                _bhvsemail.value = value,
                                            style: GoogleFonts.roboto(
                                                fontSize: 17,
                                                //color: Color(#687787),
                                                color: const Color.fromRGBO(
                                                    0, 16, 24, 1),
                                                fontWeight: FontWeight.normal),
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(
                                                FlutterRemix.asterisk,
                                                size: 10,
                                              ),
                                              focusColor: const Color.fromRGBO(
                                                  45, 18, 40, 1),
                                              hoverColor: const Color.fromRGBO(
                                                  45, 18, 40, 1),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              fillColor: Colors.white,
                                              //labelText: 'Email',
                                              labelStyle: GoogleFonts.roboto(
                                                  letterSpacing: -0.32,
                                                  fontSize: 16,
                                                  //color: Color(#687787),
                                                  color: const Color.fromRGBO(
                                                      104, 119, 135, 1),
                                                  fontWeight:
                                                      FontWeight.normal),
                                              hintText: "Email",
                                              hintStyle: GoogleFonts.roboto(
                                                  fontSize: 17,
                                                  //color: Color(#687787),
                                                  color: const Color.fromRGBO(
                                                      137, 150, 162, 1),
                                                  fontWeight:
                                                      FontWeight.normal),
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(
                                                    color: Color.fromRGBO(
                                                        0, 56, 118, 1)),
                                              ),
                                            ),
                                            controller: _emailController,
                                            onFieldSubmitted: (value) {
                                              _emailController.text = value;
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Saisissez votre email.';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8, top: 8),
                                          child: TextFormField(
                                            textCapitalization:
                                                TextCapitalization.none,
                                            textInputAction:
                                                TextInputAction.done,
                                            obscureText: true,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            onChanged: (value) =>
                                                _bhvspassword.value = value,
                                            style: GoogleFonts.roboto(
                                                fontSize: 17,
                                                //color: Color(#687787),
                                                color: const Color.fromRGBO(
                                                    0, 16, 24, 1),
                                                fontWeight: FontWeight.normal),
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(
                                                FlutterRemix.asterisk,
                                                size: 10,
                                              ),
                                              focusColor: const Color.fromRGBO(
                                                  45, 18, 40, 1),
                                              hoverColor: const Color.fromRGBO(
                                                  45, 18, 40, 1),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              fillColor: Colors.white,
                                              labelStyle: GoogleFonts.roboto(
                                                  letterSpacing: -0.32,
                                                  fontSize: 16,
                                                  //color: Color(#687787),
                                                  color: const Color.fromRGBO(
                                                      104, 119, 135, 1),
                                                  fontWeight:
                                                      FontWeight.normal),
                                              hintText: "Mot de passe",
                                              hintStyle: GoogleFonts.roboto(
                                                  fontSize: 17,
                                                  //color: Color(#687787),
                                                  color: const Color.fromRGBO(
                                                      137, 150, 162, 1),
                                                  fontWeight:
                                                      FontWeight.normal),
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(
                                                    color: Color.fromRGBO(
                                                        0, 56, 118, 1)),
                                              ),
                                            ),
                                            controller: _passwordController,
                                            onFieldSubmitted: (value) {
                                              _passwordController.text = value;
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Saisissez votre mot de passe.';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => setState(() {
                                            keepLogin = !keepLogin;
                                          }),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 0),
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                    value: keepLogin,
                                                    onChanged: (value) =>
                                                        setState(() {
                                                          keepLogin =
                                                              !keepLogin;
                                                        })),
                                                Text(
                                                  'Se souvenir de moi',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.roboto(
                                                      letterSpacing: -0.2,
                                                      fontSize: 15,
                                                      color: ColorsApp
                                                          .ContentPrimary,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        StreamBuilder<Object>(
                                            stream: Rx.combineLatest2(
                                                _bhvsemail, _bhvspassword, (
                                              String email,
                                              String password,
                                            ) {
                                              return (email != '' &&
                                                  password != '');
                                            }),
                                            builder: (context, snapshot) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 16, top: 8),
                                                child: SizedBox(
                                                  height: 40,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: ColorsApp
                                                            .ContentActive,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                        ),
                                                      ),
                                                      onPressed:
                                                          (snapshot.data ==
                                                                  false)
                                                              ? null
                                                              : () async {
                                                                  var prefs =
                                                                      await SharedPreferences
                                                                          .getInstance();
                                                                  await prefs.setString(
                                                                      'email',
                                                                      _emailController
                                                                          .text);
                                                                  await prefs.setString(
                                                                      'password',
                                                                      _passwordController
                                                                          .text);
                                                                  BlocProvider.of<
                                                                              ConnexionBloc>(
                                                                          context)
                                                                      .add(GetJWTEvent(
                                                                          email: _emailController
                                                                              .text,
                                                                          password:
                                                                              _passwordController.text));
                                                                },
                                                      child: Text(
                                                        'Connexion',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 15,
                                                                //color: Color(#687787),
                                                                color: const Color
                                                                        .fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      )),
                                                ),
                                              );
                                            }),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
