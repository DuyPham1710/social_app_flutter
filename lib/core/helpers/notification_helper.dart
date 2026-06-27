import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app_fe/l10n/generated/app_localizations.dart';
import 'package:social_app_fe/features/comment/utils/comment_l10n_helper.dart';

class NotificationHelper {
  static Future<AppLocalizations> getAppLocalizations() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale_code') ?? 'vi';
    return lookupAppLocalizations(Locale(localeCode));
  }

  static String parseMentions(String text) {
    final RegExp regex = RegExp(r"@\[([^\]]+)\]\(([^)]+)\)");
    return text.replaceAllMapped(regex, (match) => '@${match.group(1)}');
  }

  static String buildNotificationMessage(
    String type,
    String senderName,
    String rawMessage,
    String content,
    AppLocalizations l10n,
  ) {
    switch (type) {
      case 'FRIEND_REQUEST':
        return '$senderName ${l10n.notificationFriendRequestMessage}';
      case 'FRIEND_ACCEPT':
        return '$senderName ${l10n.friendRequestAccepted}';
      case 'NEW_POST':
        return rawMessage;
      case 'POST_COMMENT':
        return '${l10n.notificationCommentedOnYourPost} ${parseMentions(rawMessage)}';
      case 'POST_REACTION':
        return '${l10n.notificationReactedToYourPost} ${localizedReactionLabel(l10n, rawMessage)}';
      case 'MENTION':
        return '${l10n.notificationMentionedYouInComment} ${parseMentions(rawMessage)}';
      case 'STORY_REACTION':
        return '${l10n.notificationReactedToYourStory} ${localizedReactionLabel(l10n, rawMessage)}';
      case 'COMMENT_REACTION':
        // COMMENT_REACTION uses CommentNotificationItem in UI which parses mentions on the message payload
        return '${l10n.notificationReactedToYourComment} ${parseMentions(rawMessage)}';
      case 'POST_REPORT_REVIEWED':
        return l10n.notificationReportReviewed;
      case 'TAG_POST':
        return '$senderName ${l10n.notificationTaggedYouInPost}';
      case 'FACE_DETECTED':
        return '$senderName ${l10n.notificationPostedWithYou}';
      case 'FACE_TAG_SUGGEST':
        final count = int.tryParse(rawMessage) ?? 0;
        return '${l10n.commonSystem} ${l10n.notificationFaceTagSuggestions(count)}';
      case 'COMMUNITY_PUBLIC_JOIN':
        return '$senderName ${l10n.notificationCommunityJoined} $content';
      case 'COMMUNITY_JOIN_REQUEST':
        return '$senderName ${l10n.notificationCommunityJoinRequestSent} $content';
      case 'COMMUNITY_INVITE':
        return '$senderName ${l10n.notificationInviteMessage} $content';
      case 'COMMUNITY_JOIN_APPROVED':
        return l10n.notificationCommunityJoinApprovedByAdmin;
      case 'COMMUNITY_JOIN_REJECTED':
        return l10n.notificationCommunityJoinRejectedByAdmin;
      case 'COMMUNITY_POST_APPROVED':
        return l10n.notificationCommunityPostApprovedByAdmin;
      case 'COMMUNITY_POST_REJECTED':
        return l10n.notificationCommunityPostRejectedByAdmin;
      case 'COMMUNITY_POST_PENDING':
        // UI widget has no spaces around actionText, but let's format it correctly for push:
        return '$senderName ${l10n.notificationCommunityPostRequestSent} $content';
      default:
        return rawMessage;
    }
  }

  static Map<String, String> getNotificationInfo(
    String type,
    AppLocalizations l10n,
  ) {
    switch (type) {
      case 'FRIEND_REQUEST':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleFriendRequest};
      case 'FRIEND_ACCEPT':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleFriendAccept};
      case 'NEW_POST':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleNewPost};
      case 'POST_COMMENT':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitlePostComment};
      case 'POST_REACTION':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitlePostReaction};
      case 'MENTION':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleMention};
      case 'STORY_REACTION':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleStoryReaction};
      case 'COMMENT_REACTION':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleCommentReaction};
      case 'POST_REPORT_REVIEWED':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleReportReviewed};
      case 'TAG_POST':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleTaggedYou};
      case 'FACE_DETECTED':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleFaceDetected};
      case 'FACE_TAG_SUGGEST':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleFaceTagSuggest};
      case 'COMMUNITY_PUBLIC_JOIN':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleCommunityPublicJoin};
      case 'COMMUNITY_JOIN_REQUEST':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleCommunityJoinRequest};
      case 'COMMUNITY_INVITE':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleCommunityInvite};
      case 'COMMUNITY_JOIN_APPROVED':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleCommunityJoinApproved};
      case 'COMMUNITY_JOIN_REJECTED':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleCommunityJoinRejected};
      case 'COMMUNITY_POST_APPROVED':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleCommunityPostApproved};
      case 'COMMUNITY_POST_REJECTED':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleCommunityPostRejected};
      case 'COMMUNITY_POST_PENDING':
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitleCommunityPostPending};
      default:
        return {'icon': '@mipmap/ic_launcher', 'title': l10n.notificationTitle};
    }
  }
}
