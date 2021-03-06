import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:invmovieconcept1/native/Cache.dart';

import 'package:invmovieconcept1/models/MovieTicket.dart';

class ReservationProvider extends ChangeNotifier {
  static ReservationProvider state(
    BuildContext context, [
    bool listen = false,
  ]) =>
      Provider.of<ReservationProvider>(context, listen: listen);

  List<MovieTicket> list = [];
  bool init = false;
  bool loading = true;

  ReservationProvider() {
    this.initAsync();
  }

  initAsync() async {
    if (this.init) {
      return;
    }
    this.init = true;
    final rawReservations = Cache.ins.getStringList("reservations");
    if (rawReservations != null && rawReservations.isNotEmpty) {
      final newList = rawReservations
          .map(
            (e) => MovieTicket.fromJson(e),
          )
          .toList();
      this.list = newList;
    }
    this.loading = false;
    this.notifyListeners();
  }

  add(MovieTicket ticket) async {
    final newList = [...list, ticket];
    final listJson = newList.map((t) => t.toJson()).toList();

    await Cache.ins.setStringList("reservations", listJson);
    this.list = newList;
    this.notifyListeners();
  }

  clear() async {
    await Cache.ins.remove("reservations");
    this.list = [];
    notifyListeners();
  }
}
