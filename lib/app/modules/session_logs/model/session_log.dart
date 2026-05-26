class SessionLog {
  final String id;
  final DateTime startedAt;
  final DateTime endedAt;
  final int durationSec;

  final int? rating;

  final String? trainerNotes;
  final String? memberNotes;

  SessionLog({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.durationSec,
    this.rating,
    this.trainerNotes,
    this.memberNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "startedAt": startedAt.toIso8601String(),
      "endedAt": endedAt.toIso8601String(),
      "durationSec": durationSec,
      "rating": rating,
      "trainerNotes": trainerNotes,
      "memberNotes": memberNotes,
    };
  }

  factory SessionLog.fromMap(Map map) {
    return SessionLog(
      id: map["id"],
      startedAt: DateTime.parse(map["startedAt"]),
      endedAt: DateTime.parse(map["endedAt"]),
      durationSec: map["durationSec"],
      rating: map["rating"],
      trainerNotes: map["trainerNotes"],
      memberNotes: map["memberNotes"],
    );
  }
}
