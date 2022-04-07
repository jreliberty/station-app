import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';

import '../../blocs/consumer/consumer_bloc.dart';
import '../../constants/colors.dart';
import '../functions/string_extension.dart';

class PageDatePicker extends StatefulWidget {
  final DateTime date;
  final DateTime startDate;
  final DateTime endDate;

  const PageDatePicker(
      {Key? key,
      required this.date,
      required this.startDate,
      required this.endDate})
      : super(key: key);
  @override
  _PageDatePickerState createState() => _PageDatePickerState();
}

class _PageDatePickerState extends State<PageDatePicker> {
  bool isToday = true;
  bool isTomorrow = false;
  DateTime selectedDate = DateTime.now();
  String name = '';
  late DateTime startDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final aDate =
        DateTime(widget.date.year, widget.date.month, widget.date.day);
    startDate = DateTime(
        widget.startDate.year, widget.startDate.month, widget.startDate.day);
    if (aDate == today) {
      isToday = true;
      isTomorrow = false;
    } else if (aDate == tomorrow) {
      isToday = false;
      isTomorrow = true;
    } else {
      isToday = false;
      isTomorrow = false;
    }
    selectedDate = aDate;
    if (BlocProvider.of<ConsumerBloc>(context).state is ConsumerLoadSuccess) {
      var user =
          (BlocProvider.of<ConsumerBloc>(context).state as ConsumerLoadSuccess)
              .user;
      name = user.firstName;
    }
  }

  bool isInZone(DateTime date) {
    if ((startDate.isBefore(date) || startDate.isAtSameMomentAs(date)) &&
        (widget.endDate.isAfter(date) || widget.endDate.isAtSameMomentAs(date)))
      return true;
    else
      return false;
  }

  bool isSelected(DateTime date) {
    final DateTime _selectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    if (_selectedDate == date)
      return true;
    else
      return false;
  }

  void checkDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (selectedDate == today) {
      isToday = true;
      isTomorrow = false;
    } else if (selectedDate == tomorrow) {
      isToday = false;
      isTomorrow = true;
    } else {
      isToday = false;
      isTomorrow = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const Color selectedColorText = Colors.white;
    const Color notSelectedColorText = Color.fromRGBO(0, 125, 188, 1);
    const Color selectedColorBack = Color.fromRGBO(0, 125, 188, 1);
    const Color notSelectedColorBack = ColorsApp.BackgroundBrandSecondary;

    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: [
          Container(
            height: 44,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
          ),
          Container(
            color: Colors.white,
            height: 55,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromRGBO(239, 241, 243, 1),
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
                    tr("orders.map.datepicker.title", args: [name]),
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
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overScroll) {
              overScroll.disallowIndicator();
              return false;
            },
            child: Expanded(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24),
                  child: ListView(children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 11),
                            child: GestureDetector(
                              onTap: () {
                                DateTime today = DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day);
                                if (isInZone(today)) {
                                  selectedDate = today;
                                  checkDate();
                                }
                              },
                              child: Container(
                                height: 81,
                                decoration: BoxDecoration(
                                    color: isToday
                                        ? selectedColorBack
                                        : notSelectedColorBack,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      tr("orders.map.datepicker.buttons.button1.label"),
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          //color: Color(#687787),
                                          color: isToday
                                              ? selectedColorText
                                              : notSelectedColorText,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        tr('orders.map.datepicker.buttons.button1.description',
                                            args: [
                                              DateFormat('dd/MM/yyyy', 'fr')
                                                  .format(DateTime.now())
                                            ]),
                                        style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            //color: Color(#687787),
                                            color: isToday
                                                ? selectedColorText
                                                : notSelectedColorText,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: VerticalDivider(
                            thickness: 0,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 11),
                            child: GestureDetector(
                              onTap: () {
                                DateTime tomorrow = DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day + 1);
                                if (isInZone(tomorrow)) {
                                  selectedDate = tomorrow;
                                  checkDate();
                                }
                              },
                              child: Container(
                                height: 81,
                                decoration: BoxDecoration(
                                    color: isTomorrow
                                        ? selectedColorBack
                                        : notSelectedColorBack,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      tr("orders.map.datepicker.buttons.button2.label"),
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          //color: Color(#687787),
                                          color: isTomorrow
                                              ? selectedColorText
                                              : notSelectedColorText,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        tr('orders.map.datepicker.buttons.button2.description',
                                            args: [
                                              DateFormat('dd/MM/yyyy', 'fr')
                                                  .format(DateTime.now()
                                                      .add(Duration(days: 1)))
                                            ]),
                                        style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            //color: Color(#687787),
                                            color: isTomorrow
                                                ? selectedColorText
                                                : notSelectedColorText,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 80,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 20, bottom: 20),
                            child: Container(
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.access_time,
                                  color: Color.fromRGBO(255, 96, 10, 1),
                                )),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                tr("orders.map.datepicker.description"),
                                style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    //color: Color(#687787),
                                    color: ColorsApp.ContentPrimary,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Container(
                        height: 885,
                        child: PagedVerticalCalendar(
                          startDate:
                              DateTime(startDate.year, startDate.month, 1),
                          endDate: DateTime(2022, 09, 15),
                          addAutomaticKeepAlives: true,
                          monthBuilder: (context, month, year) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 8),
                                child: Text(
                                  (DateFormat('MMMM yyyy', 'fr')
                                          .format(DateTime(year, month)))
                                      .capitalize(),
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      //color: Color(#687787),
                                      color: ColorsApp.ContentPrimary,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            );
                          },
                          dayBuilder: (context, date) {
                            final _isAfterToday = isInZone(date);
                            final _isSelected = isSelected(date);

                            final colorText = (_isAfterToday && !_isSelected)
                                ? Color.fromRGBO(0, 125, 188, 1)
                                : (_isSelected && _isAfterToday)
                                    ? Colors.white
                                    : Color.fromRGBO(137, 150, 162, 1);
                            if (_isSelected && _isAfterToday)
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color.fromRGBO(0, 125, 188, 1),
                                ),
                                child: Center(
                                  child: Text(
                                    DateFormat('d').format(date),
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        //color: Color(#687787),
                                        color: colorText,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              );
                            else
                              return Container(
                                child: Center(
                                  child: Text(
                                    DateFormat('d').format(date),
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        //color: Color(#687787),
                                        color: colorText,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              );
                          },
                          onDayPressed: (date) {
                            if (isInZone(date)) {
                              selectedDate = date;
                              checkDate();
                            }
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(0, 125, 188, 1)),
                    onPressed: () {
                      print(selectedDate);
                      Navigator.of(context).pop(selectedDate);
                    },
                    child: Text(
                      tr('orders.map.datepicker.buttons.button3.label'),
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          //color: Color(#687787),
                          color: ColorsApp.ContentPrimaryReversed,
                          fontWeight: FontWeight.w700),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
