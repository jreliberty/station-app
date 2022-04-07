import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/utils/page_creation_pass.dart';
import '../../../entities/contact.dart';

class PassCardInit extends StatefulWidget {
  final Contact contact;
  PassCardInit({Key? key, required this.contact}) : super(key: key);

  @override
  _PassCardInitState createState() => _PassCardInitState();
}

class _PassCardInitState extends State<PassCardInit> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 83, 125, 0.1),
                blurRadius: 6,
                offset: Offset(0, 6), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(begin: Alignment.bottomLeft, colors: [
              Color.fromRGBO(1, 84, 160, 1),
              Color.fromRGBO(1, 106, 175, 1),
              Color.fromRGBO(0, 125, 188, 1),
            ])),
        height: 195,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  ClipOval(
                    child: Container(
                      height: 64,
                      width: 64,
                      color: Color.fromRGBO(0, 125, 188, 1),
                      child: Center(
                        child: Text(
                          '${widget.contact.firstName[0].toUpperCase()}${widget.contact.lastName[0].toUpperCase()}',
                          style: GoogleFonts.roboto(
                              fontSize: 24,
                              color: ColorsApp.ContentPrimaryReversed,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.contact.firstName} ${widget.contact.lastName}',
                          style: GoogleFonts.roboto(
                              height: 1.5,
                              fontSize: 16,
                              color: ColorsApp.ContentPrimaryReversed,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          DateFormat('dd MMMM yyyy', 'fr')
                              .format(widget.contact.birthDate),
                          style: GoogleFonts.roboto(
                              height: 1.2,
                              fontSize: 14,
                              letterSpacing: -0.08,
                              color: ColorsApp.ContentPrimaryReversed,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          widget.contact.numPass,
                          style: GoogleFonts.roboto(
                              height: 1.2,
                              fontSize: 14,
                              letterSpacing: -0.08,
                              color: ColorsApp.ContentPrimaryReversed,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                height: 1,
                color: ColorsApp.ContentDivider,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                              ColorsApp.BackgroundBrandSecondary,
                            )),
                            onPressed: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => PageCreationPass(
                                        contact: widget.contact,
                                      ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.pencil,
                                  color: ColorsApp.ContentAction,
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      tr('configuration.pass.card.options.button1'),
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          color: ColorsApp.ContentAction,
                                          fontWeight: FontWeight.w700),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            if (!widget.contact.isPrincipal) {
                              bool? _delete = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return new AlertDialog(
                                    title: Text(
                                      tr('configuration.pass.card.options.careful'),
                                    ),
                                    content: Text(
                                      tr('configuration.pass.card.options.hint'),
                                    ),
                                    actions: <Widget>[
                                      new TextButton(
                                        child: const Text('Oui'),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                      new TextButton(
                                        child: const Text('Non'),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (_delete != null && _delete) {
                                var body = {
                                  "language": "fr",
                                  "country_code": "FR",
                                  "gender": "male",
                                  "middle_name": "deleted"
                                };
                                BlocProvider.of<ConsumerBloc>(context).add(
                                    UpdateContactPersonalInfoEvent(
                                        body: jsonEncode(body),
                                        contactId: widget.contact.id));
                              }
                            } else
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return new AlertDialog(
                                    title: const Text('Attention !'),
                                    content: const Text(
                                        'Vous ne pouvez pas supprimer le contact principal.'),
                                    actions: <Widget>[
                                      new TextButton(
                                        child: const Text('Fermer'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 48,
                            child: Text(
                              tr('configuration.pass.card.options.button2'),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
