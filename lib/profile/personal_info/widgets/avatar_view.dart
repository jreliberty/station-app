import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../../../entities/user.dart';

class AvatarView extends StatefulWidget {
  final String image;
  final User consumer;
  const AvatarView({
    Key? key,
    required this.image,
    required this.consumer,
  }) : super(key: key);

  @override
  _AvatarViewState createState() => _AvatarViewState();
}

class _AvatarViewState extends State<AvatarView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: (widget.consumer.firstName != '' && widget.consumer.lastName != '')
          ? ClipOval(
              child: Container(
                height: 96,
                width: 96,
                color: (widget.image == '')
                    ? Color.fromRGBO(0, 125, 188, 1)
                    : ColorsApp.BackgroundBrandSecondary,
                child: Padding(
                  padding: EdgeInsets.all(4.6),
                  child: ClipOval(
                      child: widget.image == ''
                          ? Center(
                              child: Text(
                                (widget.consumer.firstName != '' &&
                                        widget.consumer.lastName != '')
                                    ? '${widget.consumer.firstName[0].toUpperCase()}${widget.consumer.lastName[0].toUpperCase()}'
                                    : '😁',
                                style: GoogleFonts.roboto(
                                    fontSize: 34,
                                    color: ColorsApp.ContentPrimaryReversed,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          : Image.network(
                              widget.image,
                              fit: BoxFit.cover,
                            )),
                ),
              ),
            )
          : Container(),
    );
  }
}
