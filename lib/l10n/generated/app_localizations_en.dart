// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'commonhub';

  @override
  String get navHome => 'Home';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonReport => 'Report';

  @override
  String get commonBlock => 'Block';

  @override
  String get commonPrivacySupport => 'Privacy & support';

  @override
  String get commonMoreActions => 'More actions';

  @override
  String get commonSavePhotoPermissionMessage =>
      'Photo access permission is required to save images';

  @override
  String get commonSettings => 'Settings';

  @override
  String get commonOpenSettings => 'Open Settings';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonSend => 'Send';

  @override
  String get commonError => 'Error';

  @override
  String get commonRestrict => 'Restrict';

  @override
  String get commonEnabled => 'Enabled';

  @override
  String get commonUnknown => 'Unknown';

  @override
  String get commonUser => 'User';

  @override
  String get unableToLoadUserData => 'Unable to load user data';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageEnglish => 'English';

  @override
  String languageCurrent(String language) {
    return 'Current: $language';
  }

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuFriends => 'Friends';

  @override
  String get menuGroups => 'Groups';

  @override
  String get menuReels => 'Reels';

  @override
  String get menuExplore => 'Explore';

  @override
  String get menuUtilities => 'Shortcuts';

  @override
  String get menuHelpSupport => 'Help & support';

  @override
  String get menuSettingsPrivacy => 'Settings & privacy';

  @override
  String get menuLogout => 'Log out';

  @override
  String get menuLogoutDialogTitle => 'Log out of your account?';

  @override
  String menuError(String message) {
    return 'Error: $message';
  }

  @override
  String get chatTitle => 'Chats';

  @override
  String get chatSearchHint => 'Search';

  @override
  String get chatYourStory => 'Your story';

  @override
  String get chatCreateStory => 'Create story';

  @override
  String get chatYou => 'You';

  @override
  String get chatSomeone => 'Someone';

  @override
  String get chatConnected => 'Connected';

  @override
  String chatSentAttachmentPreview(
    String senderPrefix,
    String attachmentType,
    String time,
  ) {
    return '${senderPrefix}sent $attachmentType   •   $time';
  }

  @override
  String chatTextPreview(String prefix, String message, String time) {
    return '$prefix$message   •   $time';
  }

  @override
  String chatGroupCreatedPreview(String creatorName) {
    return '$creatorName created the group';
  }

  @override
  String get messageNoMessagesStartConversation =>
      'No messages yet. Start the conversation now!';

  @override
  String get messageDownloadingFile => 'Downloading file...';

  @override
  String get messageFileOpenAppNotFound => 'No app found to open this file';

  @override
  String messageFileDownloadError(String error) {
    return 'File download failed: $error';
  }

  @override
  String get messageDeletedByYou => 'You deleted this message';

  @override
  String messageDeletedByUser(String name) {
    return '$name deleted this message';
  }

  @override
  String messageUnreadCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread messages',
      one: '1 unread message',
    );
    return '$_temp0';
  }

  @override
  String get messageEdited => 'Edited';

  @override
  String get messageEditHistoryTitle => 'Edit history';

  @override
  String get messageHideEditHistory => 'Hide edit history';

  @override
  String get messageCurrentVersion => 'Current';

  @override
  String get messageLoadingEditHistory => 'Loading edit history...';

  @override
  String messageLoadMessagesError(String message) {
    return 'Error loading messages: $message';
  }

  @override
  String messageSentAt(String time) {
    return 'Sent $time';
  }

  @override
  String get messageLocation => 'Location';

  @override
  String get messageVoiceAttachment => '[Voice message]';

  @override
  String get messageImageAttachment => '[Photo]';

  @override
  String get messageVideoAttachment => '[Video]';

  @override
  String get messageFileAttachment => '[File]';

  @override
  String get messageGenericAttachment => '[Attachment]';

  @override
  String get messageDocumentFileName => 'Document';

  @override
  String get messageDocumentPdfFileName => 'Document.pdf';

  @override
  String get messageDownloadedFileName => 'downloaded_file';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get weekdayMondayShort => 'Mon';

  @override
  String get weekdayTuesdayShort => 'Tue';

  @override
  String get weekdayWednesdayShort => 'Wed';

  @override
  String get weekdayThursdayShort => 'Thu';

  @override
  String get weekdayFridayShort => 'Fri';

  @override
  String get weekdaySaturdayShort => 'Sat';

  @override
  String get weekdaySundayShort => 'Sun';

  @override
  String get weekdayMondayDotShort => 'Mon';

  @override
  String get weekdayTuesdayDotShort => 'Tue';

  @override
  String get weekdayWednesdayDotShort => 'Wed';

  @override
  String get weekdayThursdayDotShort => 'Thu';

  @override
  String get weekdayFridayDotShort => 'Fri';

  @override
  String get weekdaySaturdayDotShort => 'Sat';

  @override
  String dateAtTime(String weekday, String time) {
    return '$weekday at $time';
  }

  @override
  String timeMinutesAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonChoose => 'Choose';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authNewPassword => 'New password';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get authConfirmNewPassword => 'Confirm new password';

  @override
  String get authUsername => 'Username';

  @override
  String get authLogin => 'Log in';

  @override
  String get authRegister => 'Sign up';

  @override
  String get authForgotPassword => 'Forgot password';

  @override
  String get authForgotPasswordQuestion => 'Forgot password?';

  @override
  String get authForgotPasswordDescription =>
      'Enter your email to recover your account.';

  @override
  String get authContinue => 'Continue';

  @override
  String get authSave => 'Save';

  @override
  String get authOr => 'or';

  @override
  String get authLoginWithGoogle => 'Log in with Google';

  @override
  String get authNoAccount => 'Don\'t have an account? ';

  @override
  String get authHasAccount => 'Already have an account? ';

  @override
  String get authEnterEmail => 'Please enter your email';

  @override
  String get authEnterPassword => 'Please enter your password';

  @override
  String get authEnterUsername => 'Please enter your username';

  @override
  String get authEnterConfirmPassword =>
      'Please enter your password confirmation';

  @override
  String get authEnterNewPassword => 'Please enter your new password';

  @override
  String get authEnterConfirmNewPassword =>
      'Please enter your new password confirmation';

  @override
  String get authLoginFailed => 'Login failed';

  @override
  String get authRegisterFailed => 'Sign up failed';

  @override
  String get authSendOtpFailed => 'Failed to send OTP';

  @override
  String get authVerifyOtpFailed => 'Verification failed';

  @override
  String get authResetPassword => 'Reset password';

  @override
  String get authResetPasswordDescription =>
      'Help us protect your account by choosing a strong password.';

  @override
  String get authResetPasswordSuccess => 'Password reset successfully';

  @override
  String get authResetPasswordFailed => 'Password reset failed';

  @override
  String get authOtpTitle => 'OTP verification';

  @override
  String authOtpSentTo(String email) {
    return 'Enter the OTP sent to $email';
  }

  @override
  String get authInvalidOtp => 'Please enter a valid OTP';

  @override
  String get authDidNotReceiveCode => 'Didn\'t receive the code? ';

  @override
  String get authResendingOtp => 'Resending...';

  @override
  String authResendInSeconds(int seconds) {
    return 'Resend in $seconds seconds';
  }

  @override
  String get authResendCode => 'Resend code';

  @override
  String get authVerify => 'Verify';

  @override
  String get authPersonalInfoTitle => 'Personal information';

  @override
  String get authPersonalInfoDescription =>
      'Please complete the information below';

  @override
  String get authFullName => 'Full name';

  @override
  String get authPhoneNumber => 'Phone number';

  @override
  String get authDateOfBirth => 'Date of birth';

  @override
  String get authGender => 'Gender';

  @override
  String get authBio => 'Bio';

  @override
  String get authEnterFullName => 'Please enter your full name';

  @override
  String get authEnterPhoneNumber => 'Please enter your phone number';

  @override
  String get authEnterDateOfBirth => 'Please enter your date of birth';

  @override
  String get authEnterGender => 'Please enter your gender';

  @override
  String get authUpdatePersonalInfoFailed =>
      'Failed to update personal information';

  @override
  String get authChooseGender => 'Choose gender';

  @override
  String get authGenderMale => 'Male';

  @override
  String get authGenderFemale => 'Female';

  @override
  String get authGenderOther => 'Other';

  @override
  String get faceScanTitle => 'Face recognition';

  @override
  String get faceScanProcessing => 'Processing...';

  @override
  String get faceScanCompleted => 'Completed!';

  @override
  String get faceScanHoldStill => 'Hold still...';

  @override
  String get faceScanTooDarkTitle => 'Not enough light';

  @override
  String faceScanStep(int step) {
    return 'Step $step/5';
  }

  @override
  String get faceScanUploading => 'Uploading face data to the server...';

  @override
  String get faceScanStoredSafely => 'Your face data has been stored securely.';

  @override
  String get faceScanTooDarkMessage =>
      'The environment is too dark.\nPlease move to a brighter place.';

  @override
  String get faceScanLookStraight => 'Please look straight at the camera';

  @override
  String get faceScanLookUp => 'Raise your head slightly';

  @override
  String get faceScanLookDown => 'Lower your head slightly';

  @override
  String get faceScanLookLeft => 'Turn your face to the left';

  @override
  String get faceScanLookRight => 'Turn your face to the right';

  @override
  String get faceScanMissingAccount =>
      'Account information was not found. Please try again.';

  @override
  String get faceScanProcessImageFailed =>
      'An error occurred while processing the image. Please try again.';

  @override
  String get authErrorTitle => 'Authentication error';

  @override
  String get languageSelectTitle => 'Choose language';

  @override
  String get menuSaved => 'Saved';

  @override
  String get menuCommunity => 'Communities';

  @override
  String get menuAppearance => 'Appearance';

  @override
  String get menuPrivacySecurity => 'Privacy & security';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileLoadPostsError => 'Unable to load posts';

  @override
  String get profileLoadError => 'Unable to load profile';

  @override
  String get profileNoPosts => 'No posts yet';

  @override
  String get profileEndOfPosts => 'All posts shown';

  @override
  String get profileAddToStory => 'Add to story';

  @override
  String get profileEditInfo => 'Edit details';

  @override
  String get profileAbout => 'About';

  @override
  String profileStudiedAt(String school) {
    return 'Studied at $school';
  }

  @override
  String profileLivesIn(String city) {
    return 'Lives in $city';
  }

  @override
  String profileFrom(String place) {
    return 'From $place';
  }

  @override
  String profileWorksAt(String workplace) {
    return 'Works at $workplace';
  }

  @override
  String get profileNoBio => 'No bio yet';

  @override
  String get profileCoverPhoto => 'Cover photo';

  @override
  String get profileAvatarPhoto => 'Profile photo';

  @override
  String get profileUserNameFallback => 'User Name';

  @override
  String get profileEdit => 'Edit';

  @override
  String get profilePostsTab => 'Posts';

  @override
  String get profilePhotosTab => 'Photos';

  @override
  String get profileReelsTab => 'Reels';

  @override
  String get profilePostsList => 'Post list';

  @override
  String get profileYourPhotos => 'Your photos';

  @override
  String get profileYourReels => 'Your reels';

  @override
  String get profileEditProfileTitle => 'Edit profile';

  @override
  String get profileUpdateFailed => 'Update failed';

  @override
  String get profileUsername => 'User name';

  @override
  String get profileEditName => 'Edit name';

  @override
  String get profileAvatar => 'Profile photo';

  @override
  String get profileCover => 'Cover photo';

  @override
  String get profileBio => 'Bio';

  @override
  String get profileEditBio => 'Edit bio';

  @override
  String get profileDetails => 'Details';

  @override
  String get profileNoBioPlaceholder => 'No bio yet';

  @override
  String profileEnterField(String field) {
    return 'Enter $field...';
  }

  @override
  String get profileEditDetailsTitle => 'Edit details';

  @override
  String get profileSchool => 'School';

  @override
  String get profileCurrentCity => 'Current city';

  @override
  String get profileHometown => 'Hometown';

  @override
  String get profileWorkplace => 'Workplace';

  @override
  String get profileRelationshipStatus => 'Relationship status';

  @override
  String get profileSelectRelationshipStatus => 'Choose relationship status';

  @override
  String get profileChooseAvatar => 'Choose profile photo';

  @override
  String get profileChooseCover => 'Choose cover photo';

  @override
  String get profileImage => 'Image';

  @override
  String get profileAddWorkplace => 'Add workplace';

  @override
  String get profileAddRelationshipStatus => 'Add relationship status';

  @override
  String get profileWhatsOnYourMind => 'What\'s on your mind?';

  @override
  String get profileNoFriends => 'No friends yet';

  @override
  String get profileFriends => 'Friends';

  @override
  String get profileViewAll => 'View all';

  @override
  String profileFriendCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends',
      one: '1 friend',
      zero: 'No friends',
    );
    return '$_temp0';
  }

  @override
  String get profileUnnamed => 'No name';

  @override
  String get profileAddFriend => 'Add friend';

  @override
  String get profileCancelFriendRequest => 'Cancel friend request';

  @override
  String get profileAcceptFriend => 'Accept request';

  @override
  String get profileRejectFriend => 'Delete';

  @override
  String get profileUnfriend => 'Unfriend';

  @override
  String get profileMessage => 'Message';

  @override
  String get profileConfirmUnfriendTitle => 'Confirm unfriend';

  @override
  String get profileConfirmUnfriendMessage =>
      'Are you sure you want to unfriend this person?';

  @override
  String get profileAgree => 'Agree';

  @override
  String get profileAccountSecurity => 'Account security';

  @override
  String get profileFaceData => 'Face data';

  @override
  String get profileFaceRegistered => 'Set up';

  @override
  String get profileFaceNotRegistered => 'Not set up';

  @override
  String get profileFaceDataSuccessDeleted => 'Face data deleted successfully';

  @override
  String get profileManageFaceData => 'Manage face data';

  @override
  String get profileAddFaceData => 'Add face data';

  @override
  String get profileFaceDataRegisteredDescription =>
      'Your face data is being used for recognition and account protection.';

  @override
  String get profileFaceDataUnregisteredDescription =>
      'Registering your face helps AI recognize you in photos and better protect your account.';

  @override
  String get profileDeleteFaceData => 'Delete face data';

  @override
  String get profileDeleteConfirmTitle => 'Confirm deletion';

  @override
  String get profileDeleteFaceConfirmMessage =>
      'Are you sure you want to delete all face data? This action cannot be undone.';

  @override
  String get profileDeletingFaceData => 'Deleting face data...';

  @override
  String get appearanceDisplayModeSection => 'DISPLAY MODE';

  @override
  String get appearanceAccentColorSection => 'ACCENT COLOR';

  @override
  String get appearanceTextSizeSection => 'TEXT SIZE';

  @override
  String get appearanceLightMode => 'Light';

  @override
  String get appearanceDarkMode => 'Dark';

  @override
  String get appearanceAutoMode => 'Auto';

  @override
  String get appearanceSmallText => 'Small';

  @override
  String get appearanceNormalText => 'Normal';

  @override
  String get appearanceLargeText => 'Large';

  @override
  String get appearanceChooseAccentColor => 'Choose accent color';

  @override
  String get appearanceCustomAccentColor => 'Custom';

  @override
  String get appearanceDefaultAccent => 'Default';

  @override
  String get appearanceBlueAccent => 'Blue';

  @override
  String get appearancePinkPurpleAccent => 'Pink purple';

  @override
  String get appearanceNeonPurpleAccent => 'Neon purple';

  @override
  String get appearanceBrightOrangeAccent => 'Bright orange';

  @override
  String get appearanceCoralRedAccent => 'Coral red';

  @override
  String get appearanceHighContrast => 'High contrast';

  @override
  String get appearanceReduceMotion => 'Reduce motion';

  @override
  String get relationshipSingle => 'Single';

  @override
  String get relationshipDating => 'Dating';

  @override
  String get relationshipInRelationship => 'In a relationship';

  @override
  String get relationshipMarried => 'Married';

  @override
  String get relationshipComplicated => 'It\'s complicated';

  @override
  String get relationshipOpen => 'Open relationship';

  @override
  String get relationshipDivorced => 'Divorced';

  @override
  String get menuCreateProfileOrPage => 'Create a profile or new Page';

  @override
  String get commonAll => 'All';

  @override
  String get commonBack => 'Back';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonDetails => 'Details';

  @override
  String get commonDone => 'Done';

  @override
  String get commonErrorOccurred => 'An error occurred';

  @override
  String commonErrorWithMessage(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get commonFeatureInDevelopment => 'Feature in development';

  @override
  String get commonLoading => 'Loading';

  @override
  String commonNextWithCount(num count) {
    return 'Next ($count)';
  }

  @override
  String get commonNo => 'No';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonSaveChanges => 'Save changes';

  @override
  String get commonServerErrorRetryLater =>
      'Server error. Please try again later.';

  @override
  String get commonSessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get commonSystem => 'System';

  @override
  String get commonUnderstood => 'Got it';

  @override
  String get commonUnexpectedErrorRetry =>
      'An unexpected error occurred. Please try again.';

  @override
  String get commonUnknownError => 'Unknown error';

  @override
  String get communityAdmin => 'Admin';

  @override
  String get communityAdminDemoted => 'Admin role removed';

  @override
  String get communityAdminPanelSubtitle =>
      'Review new members and moderate posts before they appear.';

  @override
  String get communityAdminPanelTitle => 'Admin panel';

  @override
  String get communityApproved => 'Approved';

  @override
  String get communityAvatar => 'Avatar';

  @override
  String get communityCancelJoinRequestConfirm =>
      'Are you sure you want to cancel this community join request?';

  @override
  String get communityCancelJoinRequestTitle => 'Cancel request';

  @override
  String get communityCancelRequestSuccess => 'Join request cancelled';

  @override
  String get communityCannotIdentifyFriend =>
      'Error: Unable to identify friend';

  @override
  String get communityChooseAvatar => 'Choose avatar';

  @override
  String get communityChooseCover => 'Choose cover image';

  @override
  String get communityChooseFromLibrary => 'Choose from library';

  @override
  String get communityClearSearch => 'Clear search';

  @override
  String get communityCoverImage => 'Cover image';

  @override
  String get communityCreateGroup => 'Create group';

  @override
  String get communityCreateIntro =>
      'Create a space for friends to discuss and share content.';

  @override
  String get communityCreatePostTitle => 'Create group post';

  @override
  String get communityCreateSuccess => 'Community created successfully';

  @override
  String get communityCreateTitle => 'Create community';

  @override
  String get communityDeleteConfirm =>
      'Are you sure you want to delete this community? This action cannot be undone.';

  @override
  String get communityDeleteGroup => 'Delete group';

  @override
  String get communityDeleteSuccess => 'Community deleted successfully';

  @override
  String get communityDeleteTitle => 'Delete community';

  @override
  String get communityDescription => 'Description';

  @override
  String get communityDescriptionHint => 'Enter a community description';

  @override
  String get communityEditGroup => 'Edit group';

  @override
  String get communityEditIntro =>
      'Update details so members understand this community better.';

  @override
  String get communityEditTitle => 'Edit community';

  @override
  String get communityEmpty => 'No communities yet';

  @override
  String get communityExploreSubtitle =>
      'Discover relevant groups and keep track of posts waiting for review.';

  @override
  String get communityExploreTab => 'Explore';

  @override
  String get communityExploreTitle => 'Communities';

  @override
  String get communityFilterPosts => 'Filter posts';

  @override
  String get communityHandleInviteFailed => 'Unable to process invite';

  @override
  String get communityInviteFriends => 'Invite friends';

  @override
  String get communityInviteFriendsSubtitle => 'Join this community';

  @override
  String get communityInviteFriendsTitle => 'Invite friends';

  @override
  String get communityInvitePendingNotice =>
      'Your community invite is waiting for a response.';

  @override
  String get communityInviteSearchHint => 'Search name or username...';

  @override
  String get communityInviteSendFailed => 'Unable to send invite';

  @override
  String get communityInviteSentSuccess => 'Invite sent successfully';

  @override
  String get communityInviteStatusApproved => 'You accepted the invite';

  @override
  String get communityInviteStatusPending =>
      'You were invited to join this community';

  @override
  String get communityInviteStatusRejected => 'You rejected the invite';

  @override
  String get communityInvited => 'Invited';

  @override
  String get communityInvitesTab => 'Invites';

  @override
  String get communityInvitesTitle => 'Community invites';

  @override
  String get communityJoin => 'Join';

  @override
  String get communityJoinRequestAccepted => 'Join request accepted';

  @override
  String get communityJoinRequestPendingMessage =>
      'This community join request is waiting for your review.';

  @override
  String get communityJoinRequestRejected => 'Join request rejected';

  @override
  String get communityJoinRequestSent => 'Community join request sent';

  @override
  String get communityJoinShort => 'Join';

  @override
  String get communityLeaveConfirm =>
      'Are you sure you want to leave this community?';

  @override
  String get communityLeaveGroup => 'Leave group';

  @override
  String get communityLeaveSuccess => 'You left the community';

  @override
  String get communityLoadFriendsFailed => 'Error loading friends list';

  @override
  String get communityLoadInvitesFailed => 'Unable to load invites';

  @override
  String get communityLoadMembersFailed => 'Unable to load list';

  @override
  String get communityLoadingFriends => 'Loading friends list...';

  @override
  String communityMediaCount(num count) {
    return '$count media';
  }

  @override
  String get communityMember => 'Member';

  @override
  String get communityMemberOnlyContent => 'Members-only content';

  @override
  String get communityMemberOnlyPostsMessage =>
      'Join the community to view group posts.';

  @override
  String get communityMemberOptions => 'Member options';

  @override
  String get communityMemberPromoted => 'Member promoted';

  @override
  String get communityMemberRemoved => 'Member removed';

  @override
  String get communityMembers => 'Members';

  @override
  String communityMembersCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
      zero: '0 members',
    );
    return '$_temp0';
  }

  @override
  String get communityMembersListTitle => 'Members list';

  @override
  String get communityMineTab => 'Mine';

  @override
  String get communityName => 'Community name';

  @override
  String get communityNameHint => 'Enter community name';

  @override
  String get communityNameRequired => 'Please enter a community name';

  @override
  String get communityNoApprovedPosts => 'No approved posts yet';

  @override
  String get communityNoAvailableFriends => 'No available friends';

  @override
  String get communityNoCommunityInvites => 'No community invites';

  @override
  String get communityNoDescription => 'No description yet';

  @override
  String communityNoInviteSearchResults(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get communityNoInvites => 'You have no invites';

  @override
  String get communityNoJoinedCommunities =>
      'You have not joined any communities yet';

  @override
  String get communityNoMembers => 'No members yet';

  @override
  String get communityNoMembersFound => 'No members found';

  @override
  String get communityNoMembersFoundMessage =>
      'Try searching by another name or username.';

  @override
  String get communityNoMembersMessage =>
      'When people join, the member list will appear here.';

  @override
  String get communityNoPendingCommunities => 'No pending communities';

  @override
  String get communityNoPendingPosts => 'No pending posts';

  @override
  String get communityNoPendingRequests => 'No pending join requests';

  @override
  String get communityNoPendingReviewPosts => 'No posts waiting for review';

  @override
  String get communityNoPosts => 'No posts yet';

  @override
  String get communityNoPostsMessage => 'Community posts will appear here.';

  @override
  String get communityNoPostsTitle => 'No posts yet';

  @override
  String get communityNoSearchResults => 'No matching communities found';

  @override
  String get communityPendingApproval => 'Pending';

  @override
  String get communityPendingCommunitiesHint =>
      'Community join requests will appear here';

  @override
  String get communityPendingPostsHint =>
      'New posts will appear here for review.';

  @override
  String get communityPendingRequestsHint =>
      'New member requests will appear here.';

  @override
  String get communityPendingTab => 'Pending';

  @override
  String communityPickImageError(String error) {
    return 'Unable to choose image: $error';
  }

  @override
  String get communityPostApprovedSuccess => 'Post approved';

  @override
  String get communityPostNoText => 'This post has no text content.';

  @override
  String get communityPostPendingApproval =>
      'Post is waiting for admin approval';

  @override
  String get communityPostRejectedSuccess => 'Post rejected';

  @override
  String get communityPostsInGroup => 'Group posts';

  @override
  String get communityPostsTab => 'Posts';

  @override
  String communityPrivacyMembers(String privacy, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
      zero: '0 members',
    );
    return '$privacy · $_temp0';
  }

  @override
  String get communityPrivate => 'Private';

  @override
  String get communityPrivateGroup => 'Private group';

  @override
  String get communityPrivateOnly => 'Private';

  @override
  String get communityPublic => 'Public';

  @override
  String get communityPublicGroup => 'Public group';

  @override
  String get communityPublicOnly => 'Public';

  @override
  String get communityRemoveFromGroup => 'Remove from group';

  @override
  String communityRemoveMemberConfirm(String name) {
    return 'Remove $name from this community? This person can request to join again later.';
  }

  @override
  String get communityRemoveMemberTitle => 'Remove member';

  @override
  String get communityReviewMembers => 'Review members';

  @override
  String get communityReviewMembersSubtitle =>
      'Confirm community join requests';

  @override
  String get communityReviewPosts => 'Review posts';

  @override
  String get communityReviewPostsSubtitle =>
      'Check content before posts go public';

  @override
  String get communitySearchHint => 'Search communities';

  @override
  String get communitySearchMembersHint => 'Search members';

  @override
  String get communitySendingInvite => 'Sending invite...';

  @override
  String get communityType => 'Community type';

  @override
  String get communityUpdateSuccess => 'Community updated successfully';

  @override
  String communityVisibleMembersCount(num visible, num total) {
    return '$visible/$total members';
  }

  @override
  String get communityWritePostHint => 'Write something in the group...';

  @override
  String get friendAccept => 'Accept';

  @override
  String friendActiveCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active',
      one: '1 active',
      zero: '0 active',
    );
    return '$_temp0';
  }

  @override
  String get friendAdd => 'Add friend';

  @override
  String get friendBecameFriends => 'You became friends';

  @override
  String get friendCancelRequest => 'Cancel request';

  @override
  String friendCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends',
      one: '1 friend',
      zero: '0 friends',
    );
    return '$_temp0';
  }

  @override
  String get friendDelete => 'Delete';

  @override
  String friendFallbackUserWithIndex(num index) {
    return 'User $index';
  }

  @override
  String friendFriendsOf(String name) {
    return '$name\'s friends';
  }

  @override
  String friendFriendsSince(String month, num year) {
    return 'Friends since $month $year';
  }

  @override
  String get friendJustActive => 'Just active';

  @override
  String get friendLoadDataError => 'Unable to load friend data';

  @override
  String friendLoadError(String message) {
    return 'Error loading friends: $message';
  }

  @override
  String get friendLoadFriendsFailed => 'Unable to load friends list';

  @override
  String get friendLoadSuggestionsUnknownError =>
      'Unknown error loading friend suggestions';

  @override
  String get friendLoadingRequests => 'Loading friend requests...';

  @override
  String get friendLoadingSentRequests => 'Loading sent requests...';

  @override
  String get friendLoadingSuggestions => 'Loading friend suggestions...';

  @override
  String get friendLongtimeFriend => 'Longtime friend';

  @override
  String friendMessageUser(String name) {
    return 'Message $name';
  }

  @override
  String friendMutualCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mutual friends',
      one: '1 mutual friend',
      zero: 'No mutual friends',
    );
    return '$_temp0';
  }

  @override
  String get friendNoFriends => 'No friends yet';

  @override
  String get friendNoRequests => 'No friend requests';

  @override
  String get friendNoRequestsDescription =>
      'When someone sends a request, you will see it here.';

  @override
  String get friendNoSentRequests => 'No sent requests';

  @override
  String get friendNoSentRequestsDescription =>
      'Friend requests you send will appear here.';

  @override
  String get friendNoSuggestions => 'No friend suggestions';

  @override
  String get friendNoSuggestionsDescription =>
      'Check back later for more suggestions.';

  @override
  String friendOnlineCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people online',
      one: '1 person online',
      zero: 'No one online',
    );
    return '$_temp0';
  }

  @override
  String get friendPeopleYouMayKnow => 'Recommended for you';

  @override
  String get friendReject => 'Reject';

  @override
  String get friendRemove => 'Remove';

  @override
  String get friendRequestAccepted => 'Friend request accepted';

  @override
  String get friendRequestCancelled => 'Request cancelled';

  @override
  String get friendRequestNotFound => 'Friend request not found';

  @override
  String get friendRequestRejected => 'Friend request rejected';

  @override
  String get friendRequestRemoved => 'Friend request removed';

  @override
  String get friendRequestSent => 'Friend request sent';

  @override
  String get friendRequestsTitle => 'Friend requests';

  @override
  String get friendSearchHint => 'Search friends';

  @override
  String get friendSeeAll => 'See all';

  @override
  String friendSentRequestsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sent requests',
      one: '1 sent request',
      zero: '0 sent requests',
    );
    return '$_temp0';
  }

  @override
  String get friendSentRequestsTitle => 'Sent requests';

  @override
  String get friendSort => 'Sort';

  @override
  String get friendSortBy => 'Sort by';

  @override
  String get friendSortLeastMutual => 'Fewest mutual friends';

  @override
  String get friendSortMostMutual => 'Most mutual friends';

  @override
  String get friendSortName => 'Name';

  @override
  String get friendSortNameAz => 'Name A-Z';

  @override
  String get friendSortNameZa => 'Name Z-A';

  @override
  String get friendSortNewest => 'Newest';

  @override
  String get friendSortOldest => 'Oldest';

  @override
  String get friendSortOnline => 'Online';

  @override
  String get friendSortRecent => 'Recent';

  @override
  String get friendSuggestionsTitle => 'Friend suggestions';

  @override
  String get friendTitle => 'Friends';

  @override
  String friendUnfriendConfirm(String name) {
    return 'Are you sure you want to unfriend $name?';
  }

  @override
  String get friendUnfriendTitle => 'Unfriend';

  @override
  String friendUnfriendUser(String name) {
    return 'Unfriend $name';
  }

  @override
  String get friendViewSentRequests => 'View sent requests';

  @override
  String get homeConnecting => 'Connecting...';

  @override
  String get homeEndOfPosts => 'You have seen all posts';

  @override
  String get homeAddStory => 'Add story';

  @override
  String get homeLoadPostsFailed => 'Unable to load posts';

  @override
  String monthName(num month) {
    return 'Month $month';
  }

  @override
  String get notificationAdminNote => 'Admin note';

  @override
  String get notificationApprove => 'Approve';

  @override
  String get notificationApprovePostAction => 'Approve';

  @override
  String get notificationApprovePostTitle => 'Review post';

  @override
  String get notificationCannotHandleInvite => 'Unable to handle this invite';

  @override
  String get notificationCannotHandleJoinRequest =>
      'Unable to handle this join request';

  @override
  String get notificationCommentedOnYourPost => 'commented on your post:';

  @override
  String get notificationCommunityJoinApprovedByAdmin =>
      'Admin approved your community join request';

  @override
  String get notificationCommunityJoined => 'joined the community';

  @override
  String get notificationCommunityJoinRejectedByAdmin =>
      'Admin rejected your community join request';

  @override
  String get notificationCommunityJoinRequestSent =>
      'sent a request to join the community';

  @override
  String get notificationCommunityPostApprovedByAdmin =>
      'Admin approved your post in the community';

  @override
  String get notificationCommunityPostRejectedByAdmin =>
      'Admin rejected your post in the community';

  @override
  String get notificationCommunityPostRequestSent =>
      'sent a post request to the community';

  @override
  String get notificationEmpty => 'No notifications yet';

  @override
  String get notificationEndOfList => 'You have seen all notifications';

  @override
  String get notificationExplanation => 'Explanation';

  @override
  String notificationFaceTagSuggestions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Recognized $count people in your photo. Tag them now!',
      one: 'Recognized 1 person in your photo. Tag them now!',
      zero: 'Recognized 0 people in your photo. Tag them now!',
    );
    return '$_temp0';
  }

  @override
  String get notificationFriendRequestMessage => 'sent you a friend request';

  @override
  String get notificationInviteAccepted => 'Invite accepted';

  @override
  String get notificationInviteFailed => 'Unable to handle invite';

  @override
  String get notificationInviteMessage => 'invited you to join a community';

  @override
  String get notificationInviteRejected => 'Invite rejected';

  @override
  String get notificationJoinApprovedMessage =>
      'your community join request was approved';

  @override
  String get notificationJoinRejectedMessage =>
      'your community join request was rejected';

  @override
  String get notificationJoinRequestAccepted => 'Join request accepted';

  @override
  String get notificationJoinRequestFailed => 'Unable to handle join request';

  @override
  String get notificationJoinRequestMessage => 'wants to join the community';

  @override
  String get notificationJoinRequestRejected => 'Join request rejected';

  @override
  String get notificationMentionedYouInComment => 'mentioned you in a comment:';

  @override
  String get notificationNew => 'New';

  @override
  String get notificationNewFriendRequest => 'You have a new friend request';

  @override
  String get notificationOlder => 'Earlier';

  @override
  String get notificationPendingPostNotFound => 'Pending post not found';

  @override
  String get notificationPostedWithYou => 'posted something with you in it';

  @override
  String get notificationPostApprovedMessage => 'your post was approved';

  @override
  String get notificationPostPendingMessage =>
      'submitted a post waiting for review';

  @override
  String get notificationPostRejectedMessage => 'your post was rejected';

  @override
  String get notificationPostReportTitle => 'Post report details';

  @override
  String get notificationPublicJoinMessage => 'joined the community';

  @override
  String get notificationRefreshTooltip => 'Refresh notifications';

  @override
  String get notificationReactedToYourComment => 'reacted to your comment:';

  @override
  String get notificationReactedToYourPost => 'reacted to your post:';

  @override
  String get notificationReactedToYourStory => 'reacted to your story:';

  @override
  String get notificationReportRejected => 'Report rejected';

  @override
  String get notificationReportRejectedReason =>
      'The report did not meet the requirements for action.';

  @override
  String get notificationReportReviewed => 'Report reviewed';

  @override
  String get notificationReportReviewedReason =>
      'The report was reviewed by an admin.';

  @override
  String notificationReportStatus(String status) {
    return 'Status: $status';
  }

  @override
  String get notificationTaggedYouInPost => 'tagged you in a post';

  @override
  String get notificationTitle => 'Notifications';

  @override
  String get postAddCaptionHint => 'Add a caption...';

  @override
  String get postAddPhotoVideo => 'Add photo/video';

  @override
  String get postAddToCollection => 'Add to collection';

  @override
  String get postAnd => 'and';

  @override
  String get postCamera => 'Camera';

  @override
  String postShareCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shares',
      one: '1 share',
      zero: '0 shares',
    );
    return '$_temp0';
  }

  @override
  String get postCameraErrorTitle => 'Camera error';

  @override
  String postCameraInitFailed(String error) {
    return 'Unable to initialize camera: $error';
  }

  @override
  String get postCameraPermissionMessage =>
      'Please allow camera access in settings to continue.';

  @override
  String get postCameraPermissionTitle => 'Camera permission required';

  @override
  String postCannotAddPhoto(String error) {
    return 'Unable to add photo: $error';
  }

  @override
  String get postCheckIn => 'Check in';

  @override
  String get postChooseFolder => 'Choose folder';

  @override
  String get postChooseLayout => 'Choose layout';

  @override
  String get postCollectionNameHint => 'Collection name';

  @override
  String get postContentOrPhotoRequired =>
      'Please enter content or add a photo/video';

  @override
  String get postCreateCollectionTitle => 'Create collection';

  @override
  String postCreateGenericError(String error) {
    return 'An error occurred while creating the post: $error';
  }

  @override
  String get postCreateTitle => 'Create post';

  @override
  String get postCreating => 'Creating post...';

  @override
  String postCreatingWithProgress(num progress) {
    return 'Creating post... $progress%';
  }

  @override
  String get postDeleteConfirmMessage =>
      'Are you sure you want to delete this post?';

  @override
  String get postDeleteFailed => 'Unable to delete post';

  @override
  String get postDeleteTitle => 'Delete post';

  @override
  String get postDeleted => 'Post deleted';

  @override
  String get postEdit => 'Edit';

  @override
  String postEditCount(num count) {
    return 'Edit ($count)';
  }

  @override
  String get postEditPrivacy => 'Edit privacy';

  @override
  String get privacyPostQuestion => 'Who can see your post?';

  @override
  String get privacyPostPublic => 'Public';

  @override
  String get privacyPostPublicDescription => 'Anyone on or off the app';

  @override
  String get privacyPostFriends => 'Friends';

  @override
  String get privacyPostFriendsDescription => 'Your friends on the app';

  @override
  String get privacyPostFriendsExcept => 'Friends except...';

  @override
  String get privacyPostFriendsExceptDescription =>
      'Hide this post from some friends';

  @override
  String get privacyPostSpecificFriends => 'Specific friends';

  @override
  String get privacyPostSpecificFriendsDescription =>
      'Only show this to a few friends';

  @override
  String get privacyPostOnlyMe => 'Only me';

  @override
  String get privacyPostOnlyMeDescription => 'Only me';

  @override
  String get privacyPostEditDescription =>
      'You can change who can see this post.';

  @override
  String privacyPostCreateDescription(String defaultPrivacy) {
    return 'Your post will appear in Feed, on your profile, and in search results.\n\nThe default audience is $defaultPrivacy, but you can change the audience for this post.';
  }

  @override
  String get privacyPostNoOneSelected => 'No one selected';

  @override
  String get privacyPostOnePerson => '1 person';

  @override
  String get privacyPostFallbackUser => 'User';

  @override
  String privacyPostAndOthers(String firstNames, num count) {
    return '$firstNames and $count others';
  }

  @override
  String get privacyPostHideFromTitle => 'Hide post from';

  @override
  String get privacyPostSelectPeopleToShare =>
      'Choose people to share this post with';

  @override
  String get privacyPostCurrentDefault =>
      'This is your current default audience';

  @override
  String get privacyPostSetAsDefault => 'Set as default audience';

  @override
  String get privacyPostUpdated => 'Privacy updated';

  @override
  String get privacyPostUpdateFailed => 'Unable to update privacy';

  @override
  String postErrorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String get postFeeling => 'Feeling';

  @override
  String get postFeelingActivity => 'Feeling/Activity';

  @override
  String get postGeneric => 'Post';

  @override
  String get postGenericError => 'An error occurred';

  @override
  String get postHiddenFromProfile => 'Hidden from profile';

  @override
  String get postHideAction => 'Hide';

  @override
  String get postHideFromProfileMessage =>
      'This post will no longer appear on your profile.';

  @override
  String get postHideFromProfileTitle => 'Hide from profile';

  @override
  String get postJustNow => 'Just now';

  @override
  String get postLabel => 'Post';

  @override
  String get postLayoutClassic => 'Classic';

  @override
  String get postLayoutColumn => 'Column';

  @override
  String get postLayoutFrame => 'Frame';

  @override
  String get postLibrary => 'Library';

  @override
  String get postLiveVideo => 'Live video';

  @override
  String get postLoadingVideo => 'Loading video...';

  @override
  String get postLocation => 'Location';

  @override
  String postMediaItemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: '0 items',
    );
    return '$_temp0';
  }

  @override
  String get postMention => 'Mention';

  @override
  String get postMore => 'More';

  @override
  String get postMusic => 'Music';

  @override
  String postMutualFriends(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mutual friends',
      one: '1 mutual friend',
      zero: 'No mutual friends',
    );
    return '$_temp0';
  }

  @override
  String get postNoComments => 'No comments yet';

  @override
  String get postNoReactions => 'No reactions yet';

  @override
  String get postNotFound => 'Post not found';

  @override
  String get postOnlyMe => 'Only me';

  @override
  String postOtherPeople(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count other people',
      one: '1 other person',
    );
    return '$_temp0';
  }

  @override
  String get postPeopleReactedTitle => 'People who reacted';

  @override
  String get postPhoto => 'Photo';

  @override
  String get postPhotoLibrary => 'Photo library';

  @override
  String get postPhotoPermissionRequired =>
      'Please allow photo access to continue.';

  @override
  String get postPhotoVideo => 'Photo/Video';

  @override
  String postPlayVideoFailed(String error) {
    return 'Unable to play video: $error';
  }

  @override
  String get postPoll => 'Poll';

  @override
  String postReactedFirstUserAndOthers(String firstUser, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count others',
      one: '1 other person',
    );
    return '$firstUser and $_temp0';
  }

  @override
  String postReactedYouAndOthers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count others',
      one: '1 other person',
    );
    return 'You and $_temp0';
  }

  @override
  String get postRecording => 'Recording';

  @override
  String get postRemoveTagAction => 'Remove tag';

  @override
  String get postRemoveTagConfirmMessage =>
      'Are you sure you want to remove this tag from the post?';

  @override
  String get postRemoveTagTitle => 'Remove tag';

  @override
  String get postRemovedTag => 'Tag removed';

  @override
  String get postReport => 'Report';

  @override
  String get postReportDescriptionHint => 'Add more details about the issue';

  @override
  String get postReportDescriptionLabel => 'Description';

  @override
  String get postReportDetailReason => 'Detailed reason';

  @override
  String get postReportFailed => 'Unable to send report';

  @override
  String get postReportIntro =>
      'Choose the right reason so we can review this post.';

  @override
  String get postReportQuickReason => 'Quick reason';

  @override
  String get postReportReasonHarassment => 'Harassment or bullying';

  @override
  String get postReportReasonHint => 'Choose a reason';

  @override
  String get postReportReasonMisinformation => 'Misinformation';

  @override
  String get postReportReasonOffensive => 'Offensive content';

  @override
  String get postReportReasonRequired => 'Please choose a report reason';

  @override
  String get postReportReasonSpam => 'Spam';

  @override
  String get postReportReasonViolence => 'Violence or danger';

  @override
  String get postReportSelfNotAllowed => 'You cannot report your own post';

  @override
  String get postReportSuccess => 'Report sent';

  @override
  String get postReportTitle => 'Report post';

  @override
  String get postSave => 'Save';

  @override
  String get postSaveFailed => 'Unable to save post';

  @override
  String get postSaved => 'Saved';

  @override
  String postSavedToCollection(String collection) {
    return 'Saved to $collection';
  }

  @override
  String get postSeeOriginal => 'See original';

  @override
  String get postSeeTranslation => 'See translation';

  @override
  String get postSelectAllowedFriendsRequired =>
      'Please choose friends who can view this';

  @override
  String get postSelectHiddenFriendsRequired =>
      'Please choose friends to hide from';

  @override
  String postSelectedPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos selected',
      one: '1 photo selected',
      zero: 'No photos selected',
    );
    return '$_temp0';
  }

  @override
  String get postSendReport => 'Send report';

  @override
  String get postShare => 'Share';

  @override
  String get postShowAction => 'Show';

  @override
  String get postShowOnProfileMessage =>
      'This post will appear on your profile.';

  @override
  String get postShowOnProfileTitle => 'Show on profile';

  @override
  String get postShownOnProfile => 'Shown on profile';

  @override
  String get postSubmit => 'Post';

  @override
  String get postTag => 'Tag';

  @override
  String get postTagFriends => 'Tag friends';

  @override
  String get postTagPeople => 'Tag people';

  @override
  String get postTagUpdateFailed => 'Unable to update tags';

  @override
  String postTagUpdateFailedWithMessage(String message) {
    return 'Unable to update tags: $message';
  }

  @override
  String get postTagUpdated => 'Tags updated';

  @override
  String get postTranslateError => 'Unable to translate content';

  @override
  String get postTranslateFailed => 'Translation failed';

  @override
  String get postUnknownTime => 'Unknown time';

  @override
  String get postUnsave => 'Unsave';

  @override
  String get postUnsaveSuccess => 'Post unsaved';

  @override
  String get postUnsupportedVideoType => 'Unsupported video type';

  @override
  String get postVideo => 'Video';

  @override
  String postViewAllComments(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comments',
      one: '1 comment',
    );
    return 'View all $_temp0';
  }

  @override
  String get postWith => 'with';

  @override
  String get postWriteSomethingHint => 'What\'s on your mind?';

  @override
  String get postYourPost => 'Your post';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonContentCopied => 'Content copied';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonLinkCopied => 'Link copied';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonSeeMore => 'See more';

  @override
  String commonSendWithCount(num count) {
    return 'Send ($count)';
  }

  @override
  String get commonUpdate => 'Update';

  @override
  String get commonViewAll => 'View all';

  @override
  String get searchHint => 'Search';

  @override
  String get searchUserHint => 'Search users...';

  @override
  String get searchEnterKeyword => 'Enter a keyword to search';

  @override
  String get searchNoResults => 'No results found';

  @override
  String get searchRecent => 'Recent searches';

  @override
  String get searchHistory => 'History';

  @override
  String get searchNoHistory => 'No search history yet';

  @override
  String get searchNoRecent => 'No recent searches';

  @override
  String get searchClearAll => 'Clear all';

  @override
  String get searchClearAllUppercase => 'CLEAR ALL';

  @override
  String get searchClearAllHistoryTitle => 'Clear all search history';

  @override
  String get searchClearAllHistoryConfirm =>
      'Are you sure you want to clear all search history? This action cannot be undone.';

  @override
  String get searchClearAllHistoryConfirmShort =>
      'Are you sure you want to clear all search history?';

  @override
  String get searchEditHistory => 'Edit search history';

  @override
  String get searchHistoryLocalOnlyDescription =>
      'Changes only apply to recent searches in the history on this device.';

  @override
  String get searchHistoryWillAppear => 'Recent searches will appear here';

  @override
  String get searchRemoveFromHistory => 'Remove from your search history.';

  @override
  String get searchPinThis => 'Pin this search';

  @override
  String get searchPinLimit => 'You can only pin 3 searches at the same time.';

  @override
  String get friendNoSearchResults => 'No friends found';

  @override
  String get friendLoadFailed => 'Failed to load friends';

  @override
  String get commentReply => 'Reply';

  @override
  String commentViewReplies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count replies',
      one: '1 reply',
    );
    return 'View $_temp0';
  }

  @override
  String get commentEditTitle => 'Edit comment';

  @override
  String get commentEditHint => 'Enter new content...';

  @override
  String get commentDeleteTitle => 'Delete comment';

  @override
  String get commentDeleteConfirm =>
      'Are you sure you want to permanently delete this comment?';

  @override
  String get commentViewEditHistory => 'View edit history';

  @override
  String get commentShare => 'Share comment';

  @override
  String get commentReactionsTitle => 'Comment reactions';

  @override
  String get commentEmptyTitle => 'No comments yet';

  @override
  String get commentEmptySubtitle => 'Be the first to comment on this post';

  @override
  String get commentWriteFirst => 'Write the first comment';

  @override
  String get commentReplyingPrefix => 'Replying to ';

  @override
  String get commentYourComment => 'your comment';

  @override
  String get commentWriteReplyHint => 'Write a reply...';

  @override
  String commentReplyToHint(String user) {
    return 'Reply to $user...';
  }

  @override
  String get commentWriteHint => 'Write a comment...';

  @override
  String get commentEditHistoryTitle => 'Edit history';

  @override
  String get commentNoEditHistory => 'No edit history yet';

  @override
  String get commentCurrentVersion => 'Current version';

  @override
  String commentEditVersion(num version, String time) {
    return 'Edit $version • $time';
  }

  @override
  String get commentOldContent => 'Old content';

  @override
  String get commentNewContent => 'New content';

  @override
  String get storyPrivacyTitle => 'Story privacy';

  @override
  String get storyPrivacyQuestion => 'Who can see your story?';

  @override
  String get storyPrivacyVisibleFor24h =>
      'Your story will be visible for 24 hours.';

  @override
  String get storyPrivacyPublic => 'Public';

  @override
  String get storyPrivacyPublicDescription => 'Anyone';

  @override
  String get storyPrivacyFriends => 'Friends';

  @override
  String get storyPrivacyFriendsDescription => 'Only your friends';

  @override
  String get storyPrivacyHideFrom => 'Hide story from';

  @override
  String get storyPrivacyCustom => 'Custom';

  @override
  String get storyPrivacyNoOneSelected => 'No one selected';

  @override
  String get storyPrivacyOnePerson => '1 person';

  @override
  String storyPrivacyAndOthers(String firstNames, num count) {
    return '$firstNames and $count others';
  }

  @override
  String get storySelectPeopleToShare =>
      'Choose people to share your story with';

  @override
  String get storyPrivacyUpdated => 'Privacy updated';

  @override
  String get storyPrivacyUpdateFailed => 'Could not update privacy';

  @override
  String get storyDeleteTitle => 'Delete story';

  @override
  String get storyDeleteConfirm =>
      'Are you sure you want to delete this story?';

  @override
  String get storyDeleted => 'Story deleted';

  @override
  String get storyDeleteFailed => 'Could not delete story';

  @override
  String get storyEditPrivacy => 'Edit story privacy';

  @override
  String get storySendWithMessenger => 'Send with Messenger';

  @override
  String get storySavePhoto => 'Save photo';

  @override
  String get storyArchivePhoto => 'Archive photo';

  @override
  String get storyArchivePhotoDescription =>
      'Remove the photo from your story and save it to archive.';

  @override
  String get storyDeletePhoto => 'Delete photo';

  @override
  String get storyCopyShareLink => 'Copy link to share this story';

  @override
  String storyLinkVisibility(String user) {
    return 'The story will be visible to $user\'s audience for 24 hours.';
  }

  @override
  String get storyMusic => 'Music';

  @override
  String get storyMusicLoadFailed => 'Could not load music. Please try again.';

  @override
  String get storyMusicSearchFailed => 'No results found. Please try again.';

  @override
  String get storyMusicForYou => 'For you';

  @override
  String get storyMusicSearchHint => 'Search music';

  @override
  String get storyMusicNoSearchResults => 'No matching songs found.';

  @override
  String get storyMusicEmpty => 'No songs available.';

  @override
  String get storyCreateSuccess => 'Story created';

  @override
  String get storyImageOnlyEdit => 'Only photos can be edited';

  @override
  String get storyCannotReadDeviceFile => 'Could not read file from device';

  @override
  String storyImageEditFailed(String error) {
    return 'Failed to edit image: $error';
  }

  @override
  String get storyText => 'Text';

  @override
  String get storyPhotoGroup => 'Photo group';

  @override
  String get storySelectMultipleFiles => 'Select multiple files';

  @override
  String get storyLibrary => 'Library';

  @override
  String get storyChooseFolder => 'Choose folder';

  @override
  String storyItemCount(num count) {
    return '$count items';
  }

  @override
  String get storyLibraryPermissionRequired =>
      'Library access is required to show photos/videos.';

  @override
  String get storyNoMediaInLibrary => 'No photos/videos in the library yet.';

  @override
  String get storyReactedPeople => 'People who reacted';

  @override
  String get storyNoReactions => 'No reactions yet';

  @override
  String get chatMessageHint => 'Message...';

  @override
  String get chatShareFile => 'Share file';

  @override
  String get chatAiImages => 'AI images';

  @override
  String get chatAiImagesInDevelopmentMessage =>
      'AI image feature is under development';

  @override
  String chatMembersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get chatGroupChat => 'Group chat';

  @override
  String get chatOnline => 'Online';

  @override
  String get chatOffline => 'Offline';

  @override
  String get chatActiveNow => 'Active now';

  @override
  String chatAndOtherMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count others',
      one: '1 other person',
    );
    return 'and $_temp0';
  }

  @override
  String get chatViewGroupInfo => 'View group info';

  @override
  String get chatViewProfile => 'View profile';

  @override
  String get chatFriendsOnFacebook => 'You are friends on Facebook';

  @override
  String chatYouAndFriendAreFriends(String name) {
    return 'You and $name are now friends.';
  }

  @override
  String get chatThisFriend => 'this friend';

  @override
  String get voiceEffectTitle => 'Edit voice';

  @override
  String get voiceEffectLoading => 'Changing voice, please wait...';

  @override
  String voiceEffectApplied(String voice) {
    return 'Applied voice: $voice';
  }

  @override
  String get voiceEffectOriginal => 'Original';

  @override
  String get voiceEffectFemale => 'Female';

  @override
  String get voiceEffectDeep => 'Deep';

  @override
  String get voiceEffectBaby => 'Baby';

  @override
  String get voiceEffectRobot => 'Robot';

  @override
  String get voiceEffectDemon => 'Demon';

  @override
  String get chatGroupLink => 'Group link';

  @override
  String get chatDeleteChat => 'Delete chat';

  @override
  String get chatConversationInfo => 'Chat info';

  @override
  String get chatViewGroupMembers => 'View group members';

  @override
  String get chatLeaveConversation => 'Leave chat';

  @override
  String get chatFeedbackAndReportConversation =>
      'Feedback and report conversation';

  @override
  String get chatReadReceipts => 'Read receipts';

  @override
  String get chatTypingIndicators => 'Typing indicators';

  @override
  String get chatMicrophonePermissionDenied => 'No microphone permission';

  @override
  String get chatStartRecordingFailed => 'Failed to start recording';

  @override
  String get chatDownloadingFile => 'Downloading file...';

  @override
  String get chatNoAppToOpenFile => 'No app found to open this file';

  @override
  String chatOpenFileFailed(String error) {
    return 'Could not open file: $error';
  }

  @override
  String get chatLoadingEditHistory => 'Loading edit history...';

  @override
  String get chatPinInDevelopment => 'Pin message is in development';

  @override
  String get chatForwardInDevelopment => 'Forward message is in development';

  @override
  String get chatReportInDevelopment => 'Report message is in development';

  @override
  String get chatAiImageInDevelopment =>
      'AI image generation is in development';

  @override
  String get chatMissingConversationForReaction =>
      'Could not add reaction: missing conversation ID';

  @override
  String get chatMessageCopied => 'Message copied';

  @override
  String get chatGpsDisabledOpeningSettings =>
      'GPS is off. Opening location settings...';

  @override
  String get chatLocationPermissionDenied =>
      'Location permission was not granted.';

  @override
  String get chatLocationPermissionDeniedForever =>
      'Location permission is permanently denied. Opening app settings...';

  @override
  String get chatSendLocationMessage => 'Send location';

  @override
  String get chatCurrentLocation => 'Current location';

  @override
  String chatGetLocationFailed(String error) {
    return 'Could not get location: $error';
  }

  @override
  String get chatSendingFile => 'Sending file...';

  @override
  String get chatPhotoPermissionTitle => 'Photo access';

  @override
  String get chatPhotoPermissionMessage =>
      'The app needs photo access to show photos from your library. Please grant permission in Settings.';

  @override
  String get chatPhotoPermissionRequired =>
      'Photo access is required to show the library';

  @override
  String chatLoadPhotosFailed(String error) {
    return 'Failed to load photos: $error';
  }

  @override
  String get chatCameraPermissionMessage =>
      'The app needs camera access to take photos.';

  @override
  String chatOpenCameraFailed(String error) {
    return 'Failed to open camera: $error';
  }

  @override
  String get chatCapturedPhoto => 'Captured photo';

  @override
  String get chatTapSendToShare => 'Tap send to share';

  @override
  String get chatMissingConversationForPhoto =>
      'Could not send photo: missing conversation ID';

  @override
  String chatSendPhotoFailed(String error) {
    return 'Failed to send photo: $error';
  }

  @override
  String get chatCannotProcessPhoto => 'Could not process photo';

  @override
  String get chatMissingConversationForFile =>
      'Could not send file: missing conversation ID';

  @override
  String chatPickFileFailed(String error) {
    return 'Failed to choose file: $error';
  }

  @override
  String chatStartCallFailed(String error) {
    return 'Could not start call: $error';
  }

  @override
  String chatCreateConversationFailed(String message) {
    return 'Failed to create conversation: $message';
  }

  @override
  String get chatDeletedForEveryone => 'Message deleted for everyone';

  @override
  String get chatDeletedForMe => 'Message deleted for me';

  @override
  String get chatOriginalMessageNotFound => 'Original message not found';

  @override
  String chatLoadMessagesFailed(String message) {
    return 'Failed to load messages: $message';
  }

  @override
  String get chatMessagePlaceholder => '[Message]';

  @override
  String get chatMyself => 'myself';

  @override
  String chatReplyingTo(String name) {
    return 'Replying to $name';
  }

  @override
  String get chatAudioMessage => '[Voice message]';

  @override
  String get chatPhoto => '[Photo]';

  @override
  String get chatFile => '[File]';

  @override
  String get chatAttachment => '[Attachment]';

  @override
  String get chatNoPhotos => 'No photos';

  @override
  String get chatUserNotFound => 'User not found. Please log in again.';

  @override
  String chatFindConversationFailed(String error) {
    return 'Error finding conversation: $error';
  }

  @override
  String chatConversationError(String message) {
    return 'Conversation error: $message';
  }

  @override
  String chatConversationsError(String message) {
    return 'Conversations error: $message';
  }

  @override
  String get chatNoFriendsToStart =>
      'No friends found. Add some friends to start chatting!';

  @override
  String get chatSuggestedFriends => 'Suggested friends to message';

  @override
  String get chatNoConversations => 'No conversations found';

  @override
  String chatPickImageFailed(String error) {
    return 'Failed to choose image: $error';
  }

  @override
  String get chatTakePhoto => 'Take photo';

  @override
  String get chatChooseFromLibrary => 'Choose from library';

  @override
  String get chatDiscardGroupTitle => 'Discard changes?';

  @override
  String get chatDiscardGroupMessage =>
      'Are you sure you want to cancel creating this group chat?';

  @override
  String get chatSelectAtLeastOnePerson => 'Please select at least 1 person';

  @override
  String get chatUserInfoNotFound => 'User information not found';

  @override
  String chatCreateGroupFailed(String error) {
    return 'Failed to create group chat: $error';
  }

  @override
  String get chatNewGroup => 'New group chat';

  @override
  String get chatGroupNameOptional => 'Group name (optional)';

  @override
  String get chatSuggestions => 'Suggestions';

  @override
  String get chatGroupName => 'Group name';

  @override
  String get chatCreateGroup => 'Create group chat';

  @override
  String get chatPeopleYouMayKnow => 'Suggested for you';

  @override
  String get chatNoFriendSuggestions => 'No friend suggestions yet';

  @override
  String get chatDeleteMessageTitle => 'Delete message?';

  @override
  String get chatDeleteForEveryone => 'Delete for everyone';

  @override
  String get chatDeleteForMe => 'Delete for me';

  @override
  String get chatChangeGroupPhoto => 'Change group photo';

  @override
  String get chatChoosePhoto => 'Choose photo';

  @override
  String get chatChangeName => 'Rename';

  @override
  String get chatCreatePhoto => 'Create photo';

  @override
  String get chatTheme => 'Theme';

  @override
  String get chatNickname => 'Nickname';

  @override
  String get chatShareContactInfo => 'Share contact info';

  @override
  String get chatViewMediaFilesLinks => 'View media, files, and links';

  @override
  String get chatPinnedMessages => 'Pinned messages';

  @override
  String get chatSearchInConversation => 'Search in conversation';

  @override
  String get chatDeleteConversation => 'Delete conversation';

  @override
  String get chatChangeGroupName => 'Change group name';

  @override
  String get chatGroupNameChanged => 'Group name changed';

  @override
  String chatChangeGroupNameFailed(String error) {
    return 'Could not change group name: $error';
  }

  @override
  String get chatVideoCall => 'Video call';

  @override
  String get chatAudioCall => 'Audio call';

  @override
  String get chatMissedCall => 'Missed call';

  @override
  String get chatVideoCallMissed => 'Missed video call';

  @override
  String get chatYouDeletedMessage => 'You deleted this message';

  @override
  String chatUserDeletedMessage(String user) {
    return '$user deleted this message';
  }

  @override
  String chatUnreadMessages(num count) {
    return '$count unread messages';
  }

  @override
  String get chatEdited => 'Edited';

  @override
  String chatSentAt(String time) {
    return 'Sent $time';
  }

  @override
  String get chatMore => 'More';

  @override
  String get chatPin => 'Pin';

  @override
  String get chatForward => 'Forward';

  @override
  String get chatCreateAIImage => 'Create AI image';

  @override
  String get chatNoReactions => 'No reactions yet';

  @override
  String get chatAnonymousUser => 'Anonymous user';

  @override
  String get chatAddMember => 'Add member';

  @override
  String get chatMuteNotifications => 'Mute notifications';

  @override
  String get communityInviteAction => 'Invite';

  @override
  String get messageDownloadingPhoto => 'Downloading image...';

  @override
  String get messageSavePhotoSuccess => 'Image saved to gallery';

  @override
  String get messageSavePhotoError => 'Failed to save image';

  @override
  String get commonMaybeLater => 'Maybe later';

  @override
  String get faceRecognitionSetup => 'Set up face recognition';

  @override
  String get faceRecognitionDescription =>
      'Use your facial data to enable smart AI features and enhance account security.';

  @override
  String get faceRecognitionSmartSuggestions => 'Smart friend suggestions';

  @override
  String get faceRecognitionAutoTagDescription =>
      'AI automatically recognizes your face in photos and suggests accurate tags.';

  @override
  String get faceRecognitionAntiSpoofing => 'Account anti-spoofing';

  @override
  String get faceRecognitionAntiSpoofingDescription =>
      'Prevent others from using your photos to create fake accounts.';

  @override
  String get faceRecognitionHighSecurity => 'Maximum security';

  @override
  String get faceRecognitionSecurityDescription =>
      'Your facial data is securely encrypted and never shared with third parties.';

  @override
  String get faceRecognitionStartScan => 'Start face scan';

  @override
  String get reactionLike => 'Like';

  @override
  String get reactionLove => 'Love';

  @override
  String get reactionHaha => 'Haha';

  @override
  String get reactionWow => 'Wow';

  @override
  String get reactionSad => 'Sad';

  @override
  String get reactionAngry => 'Angry';
}
