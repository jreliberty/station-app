import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogMethodScan extends StatelessWidget {
  const DialogMethodScan({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        elevation: 10,
        title: Text('Sélectionnez la méthode'),
        content: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  /* color: Colors
                                      .blueAccent,*/
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                        'assets/icons8_nfc_tag_64.png',
                                        fit: BoxFit.fill)),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 8, top: 10),
                                    child: Text(
                                      '',
                                      // textAlign: TextAlign.center,
                                      style: GoogleFonts.dosis(
                                          color: Colors.white,
                                          fontSize: 20,
                                          letterSpacing: 0.7

                                          // fontWeight: FontWeight.bold
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  /*color: Colors
                                      .blueAccent,*/
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                        'assets/icons8_qr_code_64.png',
                                        fit: BoxFit.fill)),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.withOpacity(0.3)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 8, top: 10),
                                    child: Text(
                                      '',
                                      // textAlign: TextAlign.center,
                                      style: GoogleFonts.dosis(
                                          color: Colors.white,
                                          fontSize: 20,
                                          letterSpacing: 0.7

                                          // fontWeight: FontWeight.bold
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
