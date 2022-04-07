import 'dart:math';

import 'package:flutter/material.dart';

import '../../entities/consumer_category.dart';
import '../../entities/push_notification.dart';
import '../../entities/station.dart';

int getAge(DateTime date) {
  var today = DateTime.now();
  int difference = today.difference(date).inDays;
  int year = (difference / 365).floor();
  return year;
}

ConsumerCategory getConsumerCategory(
    List<ConsumerCategory> categories, int age) {
  ConsumerCategory result = categories.first;
  categories.forEach((element) {
    if (age >= element.ageMin && age <= element.ageMax) result = element;
  });
  return result;
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

List getHigherPriceStation(Station station) {
  Map<int, String> listPrices = {};
  if (station.domains.isNotEmpty) {
    station.domains.forEach((element) {
      if (element.validities.isNotEmpty) {
        listPrices[element.validities[0].pricesInfo.bestPrice!] = element.label;
      } else
        listPrices[element.priceFrom] = element.label;
    });
  }
  List<int> listKeys = listPrices.keys.toList();
  return [listKeys.reduce(max), listPrices[listKeys.reduce(max)]];
}

int getMaxIndexNotifications(List<PushNotification> notifs) {
  int index = 0;
  if (notifs.isNotEmpty)
    notifs.forEach((element) {
      index = max(index, element.index);
    });
  return index;
}

SnackBar personalisedSnackBar(
    {required String title,
    required Function() funtion,
    required String label}) {
  return SnackBar(
    content: Text(title),
    action: SnackBarAction(
      label: label,
      onPressed: funtion,
    ),
  );
}
