import 'dart:convert';

class ParishReportModel {
  // --- Header Fields ---
  final String commissionName;
  final DateTime periodCovered; // Changed to DateTime to match backend

  // --- Table Data (All non-nullable integers) ---
  final int totalMembers;
  final int missionsRepresented;
  final int generalMeetings;
  final int activeMembers;
  final int excoMeetings;

  // --- Report Sections (All modeled as List<String>) ---
  final List<String> activities;
  final List<String> problemsAndSolutions;
  final List<String> issuesForCouncil;
  final List<String> futurePlans;

  ParishReportModel({
    required this.commissionName,
    required this.periodCovered,
    required this.totalMembers,
    required this.missionsRepresented,
    required this.generalMeetings,
    required this.activeMembers,
    required this.excoMeetings,
    required this.activities,
    required this.problemsAndSolutions,
    required this.issuesForCouncil,
    required this.futurePlans,
  });

  // --- JSON Serialization ---

  factory ParishReportModel.fromRawJson(String str) => ParishReportModel.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory ParishReportModel.fromJson(Map<String, dynamic> json) => ParishReportModel(
        commissionName: json["commissionName"],
        // Parse ISO 8601 date string from backend
        periodCovered: DateTime.parse(json["periodCovered"]),
        
        totalMembers: json["totalMembers"],
        missionsRepresented: json["missionsRepresented"],
        generalMeetings: json["generalMeetings"],
        activeMembers: json["activeMembers"],
        excoMeetings: json["excoMeetings"],

        // List Parsing with explicit casting
        activities: List<String>.from(json["activities"].map((x) => x)),
        problemsAndSolutions: List<String>.from(json["problemsAndSolutions"].map((x) => x)),
        issuesForCouncil: List<String>.from(json["issuesForCouncil"].map((x) => x)),
        futurePlans: List<String>.from(json["futurePlans"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "commissionName": commissionName,
        "periodCovered": periodCovered.toIso8601String(),
        "totalMembers": totalMembers,
        "missionsRepresented": missionsRepresented,
        "generalMeetings": generalMeetings,
        "activeMembers": activeMembers,
        "excoMeetings": excoMeetings,
        
        // Lists to JSON
        "activities": List<dynamic>.from(activities.map((x) => x)),
        "problemsAndSolutions": List<dynamic>.from(problemsAndSolutions.map((x) => x)),
        "issuesForCouncil": List<dynamic>.from(issuesForCouncil.map((x) => x)),
        "futurePlans": List<dynamic>.from(futurePlans.map((x) => x)),
      };
}