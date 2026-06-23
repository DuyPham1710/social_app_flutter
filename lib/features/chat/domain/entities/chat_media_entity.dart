import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

class ChatMediaEntity {
  final String url;
  final String? type; // image, video, file, audio, link
  final int? size;
  final String? name;
  final int? duration;
  final List<double>? waveform;
  final String messageId;
  final UserEntity? sender;
  final DateTime sentAt;

  const ChatMediaEntity({
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
}
