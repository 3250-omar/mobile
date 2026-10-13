import 'dart:convert';

import 'redaction.dart';

/// Represents a privacy-compliant local diagnostic event.
class DiagnosticEvent {
  DiagnosticEvent({
    required this.eventCode,
    required this.level,
    DateTime? timestampUtc,
    this.attemptId,
    Map<String, Object>? attributes,
  }) : timestampUtc = (timestampUtc ?? DateTime.now().toUtc())
           .toIso8601String(),
       attributes = attributes != null
           ? Redaction.sanitizeAttributes(attributes)
           : const {};

  final String timestampUtc;
  final String level;
  final String eventCode;
  final String? attemptId;
  final Map<String, Object> attributes;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'timestampUtc': timestampUtc,
    'level': level,
    'eventCode': eventCode,
    if (attemptId != null) 'attemptId': attemptId,
    'attributes': attributes,
  };

  String toJsonLine() => jsonEncode(toJson());

  static DiagnosticEvent fromJson(Map<String, dynamic> json) => DiagnosticEvent(
    eventCode: json['eventCode'] as String,
    level: json['level'] as String,
    timestampUtc: DateTime.parse(json['timestampUtc'] as String),
    attemptId: json['attemptId'] as String?,
    attributes: (json['attributes'] as Map<String, dynamic>?)
        ?.cast<String, Object>(),
  );
}
