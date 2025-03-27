import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/hibboo_model.dart';

/// Data source for retrieving Hibboo data
class HibbooDatasource {
  /// Loads and parses the Hibboo data from a JSON asset file
  ///
  /// Returns a Future that completes with a list of [HibbooModel] objects
  Future<List<HibbooModel>> getHibbooList() async {
    final String response = await rootBundle.loadString('assets/hibboo.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => HibbooModel.fromJson(json)).toList();
  }
}
