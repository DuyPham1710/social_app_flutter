enum NotificationType {
  FRIEND_REQUEST,
  POST_COMMENT,
  POST_REACTION,
  MENTION,
  STORY_REACTION,
  COMMENT_REACTION,
  POST_REPORT_REVIEWED, // Admin đã xử lý báo cáo
  FACE_DETECTED,        // Phát hiện khuôn mặt
  TAG_POST,             // Được gắn thẻ
  UNKNOWN,              // Fallback
}
