// To parse this JSON data, do
//
//     final parishRecordsResponseModel = parishRecordsResponseModelFromJson(jsonString);

import 'dart:convert';

// Assuming you place the model in this path, otherwise adjust the import
import 'package:futru_scc_app/models/parish/parish_record_model.dart'; 

ParishRecordsResponseModel parishRecordsResponseModelFromJson(String str) => ParishRecordsResponseModel.fromJson(json.decode(str));

String parishRecordsResponseModelToJson(ParishRecordsResponseModel data) => json.encode(data.toJson());

class ParishRecordsResponseModel {
    bool success;
    String message;
    List<ParishReportModel> parishes;

    ParishRecordsResponseModel({
        required this.success,
        required this.message,
        required this.parishes,
    });

    factory ParishRecordsResponseModel.fromJson(Map<String, dynamic> json) => ParishRecordsResponseModel(
        success: json["success"],
        message: json["message"],
        // FIX: Use the null-aware operator (??) to default to an empty list
        // Note: Backend sends "parishes", not "records"
        parishes: List<ParishReportModel>.from((json["parishes"] ?? []).map((x) => ParishReportModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "parishes": List<dynamic>.from(parishes.map((x) => x.toJson())),
    };
}