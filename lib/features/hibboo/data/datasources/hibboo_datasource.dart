import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/hibboo_model.dart';

class HibbooDatasource {
  Future<List<HibbooModel>> getHibbooList() async {
    final String response = await rootBundle.loadString('assets/hibboo.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => HibbooModel.fromJson(json)).toList();
  }
}