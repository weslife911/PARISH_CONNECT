// To parse this JSON data, do
//
//     final recordsResponseModel = recordsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:parish_connect/models/scc/scc_record_model.dart';

RecordsResponseModel recordsResponseModelFromJson(String str) => RecordsResponseModel.fromJson(json.decode(str));

String recordsResponseModelToJson(RecordsResponseModel data) => json.encode(data.toJson());

class RecordsResponseModel {
    bool success;
    String message;
    List<SccReportModel> records;

    RecordsResponseModel({
        required this.success,
        required this.message,
        required this.records,
    });

    factory RecordsResponseModel.fromJson(Map<String, dynamic> json) => RecordsResponseModel(
        success: json["success"],
        message: json["message"],
        // FIX: Use the null-aware operator (??) to default to an empty list []
        // if json["records"] is null, preventing a NoSuchMethodError.
        records: List<SccReportModel>.from((json["records"] ?? []).map((x) => SccReportModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
    };
}
