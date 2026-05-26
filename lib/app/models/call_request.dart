import 'package:hive/hive.dart';

@HiveType(typeId: 30)
class CallRequest extends HiveObject {
  @HiveField(0)
  late String id; // UUID generated at creation
  @HiveField(1)
  late String memberId; // UID from local Auth (anonymous)
  @HiveField(2)
  late String trainerId; // UID of assigned trainer (Aarav)
  @HiveField(3)
  late DateTime slot; // Start of the 30‑min block
  @HiveField(4)
  late String? note; // Optional note (≤140 chars)
  @HiveField(5)
  late String status; // 'pending' | 'approved' | 'declined'
  @HiveField(6)
  String? reason; // Decline reason (optional)
  @HiveField(7)
  String? roomId; // 100ms roomId (filled on approval)
  @HiveField(8)
  late DateTime createdAt;
  @HiveField(9)
  String? roomCode; // 100ms roomCode (filled on approval)

  CallRequest({
    required this.id,
    required this.memberId,
    required this.trainerId,
    required this.slot,
    this.note,
    required this.status,
    this.reason,
    this.roomId,
    this.roomCode,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'trainerId': trainerId,
      'slot': slot.toIso8601String(),
      'note': note,
      'status': status,
      'reason': reason,
      'roomId': roomId,
      'roomCode': roomCode,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CallRequest.fromMap(Map<dynamic, dynamic> map) {
    return CallRequest(
      id: map['id'] as String,
      memberId: map['memberId'] as String,
      trainerId: map['trainerId'] as String,
      slot: DateTime.parse(map['slot'] as String),
      note: map['note'] as String?,
      status: map['status'] as String,
      reason: map['reason'] as String?,
      roomId: map['roomId'] as String?,
      roomCode: map['roomCode'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
