import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recent_emi.dart';

class RecentEmiStorage {
  static const _key = "recent_emis";

  static Future<List<RecentEmi>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data
        .map((e) => RecentEmi.fromJson(jsonDecode(e)))
        .toList();
  }

static Future<void> save(RecentEmi emi) async {
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList(_key) ?? [];

  print("Before save: ${list.length}");

  // 🔥 REMOVE EXACT DUPLICATES FIRST
  list.removeWhere((e) {
    final json = jsonDecode(e);
    return json["amount"] == emi.amount &&
        json["rate"] == emi.rate &&
        json["tenure"] == emi.tenure &&
        json["isMyWay"] == emi.isMyWay &&
        json["loanDate"] == emi.loanDate.toIso8601String();
  });

  // 🔥 ADD NEW ENTRY TO TOP
  list.insert(0, jsonEncode(emi.toJson()));

  // 🔥 KEEP ONLY LAST 5
  if (list.length > 5) {
    list.removeRange(5, list.length);
  }

  await prefs.setStringList(_key, list);

  final verify = prefs.getStringList(_key);
  print("After save: ${verify?.length}");
}


}
