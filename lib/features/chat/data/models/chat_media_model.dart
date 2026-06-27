import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import '../../domain/entities/chat_media_entity.dart';

class ChatMediaModel {
  final String url;
  final String? type; // image, video, file, audio, link
  final int? size;
  final String? name;
  final int? duration;
  final List<double>? waveform;
  final String messageId;
  final UserModel? sender;
  final DateTime sentAt;

  ChatMediaModel({
    required this.url,
    this.type,
    this.size,
    this.name,
    this.duration,
    this.waveform,
    required this.messageId,
    this.sender,
    required this.sentAt,
  });

  factory ChatMediaModel.fromJson(Map<String, dynamic> json) {
    return ChatMediaModel(
      url: json['url'] as String,
      type: json['type'] as String?,
      size: json['size'] as int?,
      name: json['name'] as String?,
      duration: json['duration'] as int?,
      waveform: (json['waveform'] as List<dynamic>?)
          ?.whereType<num>()
          .map((v) => v.toDouble())
          .toList(),
      messageId: json['messageId'] as String,
      sender: json['sender'] != null
          ? UserModel.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'type': type,
    'size': size,
    'name': name,
    'duration': duration,
    'waveform': waveform,
    'messageId': messageId,
    'sender': sender?.toJson(),
    'sentAt': sentAt.toIso8601String(),
  };

  ChatMediaEntity toEntity() => ChatMediaEntity(
    url: url,
    type: type,
    size: size,
    name: name,
    duration: duration,
    waveform: waveform,
    messageId: messageId,
    sender: sender?.toEntity(),
    sentAt: sentAt,
  );
}
