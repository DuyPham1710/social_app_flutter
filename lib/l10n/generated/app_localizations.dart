import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'commonshub'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get navHome;

  /// No description provided for @commonCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get commonClose;

  /// No description provided for @commonReport.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo'**
  String get commonReport;

  /// No description provided for @commonBlock.
  ///
  /// In vi, this message translates to:
  /// **'Chặn'**
  String get commonBlock;

  /// No description provided for @commonPrivacySupport.
  ///
  /// In vi, this message translates to:
  /// **'Quyền riêng tư & Hỗ trợ'**
  String get commonPrivacySupport;

  /// No description provided for @commonMoreActions.
  ///
  /// In vi, this message translates to:
  /// **'Hành động khác'**
  String get commonMoreActions;

  /// No description provided for @commonSavePhotoPermissionMessage.
  ///
  /// In vi, this message translates to:
  /// **'Cần quyền truy cập ảnh để lưu ảnh'**
  String get commonSavePhotoPermissionMessage;

  /// No description provided for @commonSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get commonSettings;

  /// No description provided for @commonOpenSettings.
  ///
  /// In vi, this message translates to:
  /// **'Mở Cài đặt'**
  String get commonOpenSettings;

  /// No description provided for @commonRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get commonRetry;

  /// No description provided for @commonSend.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get commonSend;

  /// No description provided for @commonError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi'**
  String get commonError;

  /// No description provided for @commonRestrict.
  ///
  /// In vi, this message translates to:
  /// **'Hạn chế'**
  String get commonRestrict;

  /// No description provided for @commonEnabled.
  ///
  /// In vi, this message translates to:
  /// **'Đang bật'**
  String get commonEnabled;

  /// No description provided for @commonUnknown.
  ///
  /// In vi, this message translates to:
  /// **'Không xác định'**
  String get commonUnknown;

  /// No description provided for @commonUser.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng'**
  String get commonUser;

  /// No description provided for @unableToLoadUserData.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải dữ liệu người dùng'**
  String get unableToLoadUserData;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get languageSystem;

  /// No description provided for @languageVietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get languageVietnamese;

  /// No description provided for @languageEnglish.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageCurrent.
  ///
  /// In vi, this message translates to:
  /// **'Hiện tại: {language}'**
  String languageCurrent(String language);

  /// No description provided for @menuTitle.
  ///
  /// In vi, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @menuFriends.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get menuFriends;

  /// No description provided for @menuGroups.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm'**
  String get menuGroups;

  /// No description provided for @menuReels.
  ///
  /// In vi, this message translates to:
  /// **'Thước phim'**
  String get menuReels;

  /// No description provided for @menuExplore.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá'**
  String get menuExplore;

  /// No description provided for @menuUtilities.
  ///
  /// In vi, this message translates to:
  /// **'Tiện ích'**
  String get menuUtilities;

  /// No description provided for @menuHelpSupport.
  ///
  /// In vi, this message translates to:
  /// **'Trợ giúp và hỗ trợ'**
  String get menuHelpSupport;

  /// No description provided for @menuSettingsPrivacy.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt và quyền riêng tư'**
  String get menuSettingsPrivacy;

  /// No description provided for @menuLogout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get menuLogout;

  /// No description provided for @menuLogoutDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất khỏi tài khoản của bạn?'**
  String get menuLogoutDialogTitle;

  /// No description provided for @menuError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi: {message}'**
  String menuError(String message);

  /// No description provided for @chatTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get chatTitle;

  /// No description provided for @chatChooseConversation.
  ///
  /// In vi, this message translates to:
  /// **'Chọn một đoạn chat hoặc bắt đầu cuộc trò chuyện mới'**
  String get chatChooseConversation;

  /// No description provided for @chatSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get chatSearchHint;

  /// No description provided for @chatYourStory.
  ///
  /// In vi, this message translates to:
  /// **'Tin của bạn'**
  String get chatYourStory;

  /// No description provided for @chatCreateStory.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tin'**
  String get chatCreateStory;

  /// No description provided for @chatYou.
  ///
  /// In vi, this message translates to:
  /// **'Bạn'**
  String get chatYou;

  /// No description provided for @chatSomeone.
  ///
  /// In vi, this message translates to:
  /// **'Ai đó'**
  String get chatSomeone;

  /// No description provided for @chatConnected.
  ///
  /// In vi, this message translates to:
  /// **'Đã kết nối'**
  String get chatConnected;

  /// No description provided for @chatSentAttachmentPreview.
  ///
  /// In vi, this message translates to:
  /// **'{senderPrefix}đã gửi {attachmentType}   •   {time}'**
  String chatSentAttachmentPreview(
    String senderPrefix,
    String attachmentType,
    String time,
  );

  /// No description provided for @chatTextPreview.
  ///
  /// In vi, this message translates to:
  /// **'{prefix}{message}   •   {time}'**
  String chatTextPreview(String prefix, String message, String time);

  /// No description provided for @chatGroupCreatedPreview.
  ///
  /// In vi, this message translates to:
  /// **'{creatorName} vừa tạo nhóm'**
  String chatGroupCreatedPreview(String creatorName);

  /// No description provided for @chatAiSummaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tóm tắt tin nhắn bằng AI'**
  String get chatAiSummaryTitle;

  /// No description provided for @chatCannotIdentifyConversation.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xác định cuộc hội thoại.'**
  String get chatCannotIdentifyConversation;

  /// No description provided for @chatSummaryButton.
  ///
  /// In vi, this message translates to:
  /// **'Tóm tắt'**
  String get chatSummaryButton;

  /// No description provided for @chatAiAnalyzingUnread.
  ///
  /// In vi, this message translates to:
  /// **'Đang phân tích tin nhắn chưa đọc...'**
  String get chatAiAnalyzingUnread;

  /// No description provided for @chatNoSummaryAvailable.
  ///
  /// In vi, this message translates to:
  /// **'Không có bản tóm tắt nào.'**
  String get chatNoSummaryAvailable;

  /// No description provided for @chatFailedToLoadSummary.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải bản tóm tắt'**
  String get chatFailedToLoadSummary;

  /// No description provided for @messageNoMessagesStartConversation.
  ///
  /// In vi, this message translates to:
  /// **'Không có tin nhắn nào. Bắt đầu cuộc trò chuyện ngay!'**
  String get messageNoMessagesStartConversation;

  /// No description provided for @messageDownloadingFile.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải file...'**
  String get messageDownloadingFile;

  /// No description provided for @messageFileOpenAppNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy ứng dụng để mở file này'**
  String get messageFileOpenAppNotFound;

  /// No description provided for @messageFileDownloadError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải file: {error}'**
  String messageFileDownloadError(String error);

  /// No description provided for @messageDeletedByYou.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã xóa tin nhắn này'**
  String get messageDeletedByYou;

  /// No description provided for @messageDeletedByUser.
  ///
  /// In vi, this message translates to:
  /// **'{name} đã xóa tin nhắn này'**
  String messageDeletedByUser(String name);

  /// No description provided for @messageUnreadCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =1{1 tin nhắn chưa đọc} other{{count} tin nhắn chưa đọc}}'**
  String messageUnreadCount(num count);

  /// No description provided for @messageEdited.
  ///
  /// In vi, this message translates to:
  /// **'Đã chỉnh sửa'**
  String get messageEdited;

  /// No description provided for @messageEditHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử chỉnh sửa'**
  String get messageEditHistoryTitle;

  /// No description provided for @messageHideEditHistory.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn lịch sử chỉnh sửa'**
  String get messageHideEditHistory;

  /// No description provided for @messageCurrentVersion.
  ///
  /// In vi, this message translates to:
  /// **'Hiện tại'**
  String get messageCurrentVersion;

  /// No description provided for @messageLoadingEditHistory.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải lịch sử chỉnh sửa...'**
  String get messageLoadingEditHistory;

  /// No description provided for @messageLoadMessagesError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải tin nhắn: {message}'**
  String messageLoadMessagesError(String message);

  /// No description provided for @messageSentAt.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi {time}'**
  String messageSentAt(String time);

  /// No description provided for @messageLocation.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí'**
  String get messageLocation;

  /// No description provided for @messageVoiceAttachment.
  ///
  /// In vi, this message translates to:
  /// **'[Tin nhắn thoại]'**
  String get messageVoiceAttachment;

  /// No description provided for @messageImageAttachment.
  ///
  /// In vi, this message translates to:
  /// **'[Ảnh]'**
  String get messageImageAttachment;

  /// No description provided for @messageVideoAttachment.
  ///
  /// In vi, this message translates to:
  /// **'[Video]'**
  String get messageVideoAttachment;

  /// No description provided for @messageFileAttachment.
  ///
  /// In vi, this message translates to:
  /// **'[Tệp tin]'**
  String get messageFileAttachment;

  /// No description provided for @messageGenericAttachment.
  ///
  /// In vi, this message translates to:
  /// **'[Đính kèm]'**
  String get messageGenericAttachment;

  /// No description provided for @messageDocumentFileName.
  ///
  /// In vi, this message translates to:
  /// **'Document'**
  String get messageDocumentFileName;

  /// No description provided for @messageDocumentPdfFileName.
  ///
  /// In vi, this message translates to:
  /// **'Document.pdf'**
  String get messageDocumentPdfFileName;

  /// No description provided for @messageDownloadedFileName.
  ///
  /// In vi, this message translates to:
  /// **'downloaded_file'**
  String get messageDownloadedFileName;

  /// No description provided for @dateYesterday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get dateYesterday;

  /// No description provided for @weekdayMondayShort.
  ///
  /// In vi, this message translates to:
  /// **'T2'**
  String get weekdayMondayShort;

  /// No description provided for @weekdayTuesdayShort.
  ///
  /// In vi, this message translates to:
  /// **'T3'**
  String get weekdayTuesdayShort;

  /// No description provided for @weekdayWednesdayShort.
  ///
  /// In vi, this message translates to:
  /// **'T4'**
  String get weekdayWednesdayShort;

  /// No description provided for @weekdayThursdayShort.
  ///
  /// In vi, this message translates to:
  /// **'T5'**
  String get weekdayThursdayShort;

  /// No description provided for @weekdayFridayShort.
  ///
  /// In vi, this message translates to:
  /// **'T6'**
  String get weekdayFridayShort;

  /// No description provided for @weekdaySaturdayShort.
  ///
  /// In vi, this message translates to:
  /// **'T7'**
  String get weekdaySaturdayShort;

  /// No description provided for @weekdaySundayShort.
  ///
  /// In vi, this message translates to:
  /// **'CN'**
  String get weekdaySundayShort;

  /// No description provided for @weekdayMondayDotShort.
  ///
  /// In vi, this message translates to:
  /// **'T.2'**
  String get weekdayMondayDotShort;

  /// No description provided for @weekdayTuesdayDotShort.
  ///
  /// In vi, this message translates to:
  /// **'T.3'**
  String get weekdayTuesdayDotShort;

  /// No description provided for @weekdayWednesdayDotShort.
  ///
  /// In vi, this message translates to:
  /// **'T.4'**
  String get weekdayWednesdayDotShort;

  /// No description provided for @weekdayThursdayDotShort.
  ///
  /// In vi, this message translates to:
  /// **'T.5'**
  String get weekdayThursdayDotShort;

  /// No description provided for @weekdayFridayDotShort.
  ///
  /// In vi, this message translates to:
  /// **'T.6'**
  String get weekdayFridayDotShort;

  /// No description provided for @weekdaySaturdayDotShort.
  ///
  /// In vi, this message translates to:
  /// **'T.7'**
  String get weekdaySaturdayDotShort;

  /// No description provided for @dateAtTime.
  ///
  /// In vi, this message translates to:
  /// **'{weekday} LÚC {time}'**
  String dateAtTime(String weekday, String time);

  /// No description provided for @timeMinutesAgo.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =1{1 phút trước} other{{count} phút trước}}'**
  String timeMinutesAgo(num count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =1{1 giờ trước} other{{count} giờ trước}}'**
  String timeHoursAgo(num count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =1{1 ngày trước} other{{count} ngày trước}}'**
  String timeDaysAgo(num count);

  /// No description provided for @commonOk.
  ///
  /// In vi, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get commonDelete;

  /// No description provided for @commonConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get commonConfirm;

  /// No description provided for @commonChoose.
  ///
  /// In vi, this message translates to:
  /// **'Chọn'**
  String get commonChoose;

  /// No description provided for @authEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get authPassword;

  /// No description provided for @authNewPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới'**
  String get authNewPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get authConfirmPassword;

  /// No description provided for @authConfirmNewPassword.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu mới'**
  String get authConfirmNewPassword;

  /// No description provided for @authUsername.
  ///
  /// In vi, this message translates to:
  /// **'Tên người dùng'**
  String get authUsername;

  /// No description provided for @authLogin.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get authLogin;

  /// No description provided for @authRegister.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get authRegister;

  /// No description provided for @authForgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu'**
  String get authForgotPassword;

  /// No description provided for @authForgotPasswordQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get authForgotPasswordQuestion;

  /// No description provided for @authForgotPasswordDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email của bạn để khôi phục tài khoản.'**
  String get authForgotPasswordDescription;

  /// No description provided for @authChangePassword.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi mật khẩu'**
  String get authChangePassword;

  /// No description provided for @authChangePasswordDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email của bạn để bắt đầu quá trình đổi mật khẩu.'**
  String get authChangePasswordDescription;

  /// No description provided for @authContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get authContinue;

  /// No description provided for @authSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get authSave;

  /// No description provided for @authOr.
  ///
  /// In vi, this message translates to:
  /// **'hoặc'**
  String get authOr;

  /// No description provided for @authLoginWithGoogle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập với Google'**
  String get authLoginWithGoogle;

  /// No description provided for @authNoAccount.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có tài khoản? '**
  String get authNoAccount;

  /// No description provided for @authHasAccount.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã có tài khoản? '**
  String get authHasAccount;

  /// No description provided for @authEnterEmail.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email'**
  String get authEnterEmail;

  /// No description provided for @authEnterPassword.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu'**
  String get authEnterPassword;

  /// No description provided for @authEnterUsername.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên người dùng'**
  String get authEnterUsername;

  /// No description provided for @authEnterConfirmPassword.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập xác nhận mật khẩu'**
  String get authEnterConfirmPassword;

  /// No description provided for @authEnterNewPassword.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu mới'**
  String get authEnterNewPassword;

  /// No description provided for @authEnterConfirmNewPassword.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập xác nhận mật khẩu mới'**
  String get authEnterConfirmNewPassword;

  /// No description provided for @authLoginFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thất bại'**
  String get authLoginFailed;

  /// No description provided for @authRegisterFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thất bại'**
  String get authRegisterFailed;

  /// No description provided for @authSendOtpFailed.
  ///
  /// In vi, this message translates to:
  /// **'Gửi OTP thất bại'**
  String get authSendOtpFailed;

  /// No description provided for @authVerifyOtpFailed.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực thất bại'**
  String get authVerifyOtpFailed;

  /// No description provided for @authResetPassword.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu'**
  String get authResetPassword;

  /// No description provided for @authResetPasswordDescription.
  ///
  /// In vi, this message translates to:
  /// **'Giúp chúng tôi bảo vệ tài khoản của bạn bằng cách chọn mật khẩu mạnh.'**
  String get authResetPasswordDescription;

  /// No description provided for @authResetPasswordSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu thành công'**
  String get authResetPasswordSuccess;

  /// No description provided for @authResetPasswordFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu thất bại'**
  String get authResetPasswordFailed;

  /// No description provided for @authOtpTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực OTP'**
  String get authOtpTitle;

  /// No description provided for @authOtpSentTo.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã OTP đã gửi đến {email}'**
  String authOtpSentTo(String email);

  /// No description provided for @authInvalidOtp.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mã OTP hợp lệ'**
  String get authInvalidOtp;

  /// No description provided for @authDidNotReceiveCode.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa nhận được mã? '**
  String get authDidNotReceiveCode;

  /// No description provided for @authResendingOtp.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi lại...'**
  String get authResendingOtp;

  /// No description provided for @authResendInSeconds.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại trong {seconds} giây'**
  String authResendInSeconds(int seconds);

  /// No description provided for @authResendCode.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại mã'**
  String get authResendCode;

  /// No description provided for @authVerify.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực'**
  String get authVerify;

  /// No description provided for @authPersonalInfoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cá nhân'**
  String get authPersonalInfoTitle;

  /// No description provided for @authPersonalInfoDescription.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng điền đầy đủ thông tin sau'**
  String get authPersonalInfoDescription;

  /// No description provided for @authFullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get authFullName;

  /// No description provided for @authPhoneNumber.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get authPhoneNumber;

  /// No description provided for @authDateOfBirth.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh'**
  String get authDateOfBirth;

  /// No description provided for @authGender.
  ///
  /// In vi, this message translates to:
  /// **'Giới tính'**
  String get authGender;

  /// No description provided for @authBio.
  ///
  /// In vi, this message translates to:
  /// **'Tiểu sử'**
  String get authBio;

  /// No description provided for @authEnterFullName.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập họ và tên'**
  String get authEnterFullName;

  /// No description provided for @authEnterPhoneNumber.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số điện thoại'**
  String get authEnterPhoneNumber;

  /// No description provided for @authEnterDateOfBirth.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập ngày sinh'**
  String get authEnterDateOfBirth;

  /// No description provided for @authEnterGender.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập giới tính'**
  String get authEnterGender;

  /// No description provided for @authUpdatePersonalInfoFailed.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thông tin cá nhân thất bại'**
  String get authUpdatePersonalInfoFailed;

  /// No description provided for @authChooseGender.
  ///
  /// In vi, this message translates to:
  /// **'Chọn giới tính'**
  String get authChooseGender;

  /// No description provided for @authGenderMale.
  ///
  /// In vi, this message translates to:
  /// **'Nam'**
  String get authGenderMale;

  /// No description provided for @authGenderFemale.
  ///
  /// In vi, this message translates to:
  /// **'Nữ'**
  String get authGenderFemale;

  /// No description provided for @authGenderOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get authGenderOther;

  /// No description provided for @faceScanTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhận diện khuôn mặt'**
  String get faceScanTitle;

  /// No description provided for @faceScanProcessing.
  ///
  /// In vi, this message translates to:
  /// **'Đang xử lý...'**
  String get faceScanProcessing;

  /// No description provided for @faceScanCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất!'**
  String get faceScanCompleted;

  /// No description provided for @faceScanHoldStill.
  ///
  /// In vi, this message translates to:
  /// **'Giữ yên...'**
  String get faceScanHoldStill;

  /// No description provided for @faceScanTooDarkTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thiếu ánh sáng'**
  String get faceScanTooDarkTitle;

  /// No description provided for @faceScanStep.
  ///
  /// In vi, this message translates to:
  /// **'Bước {step}/5'**
  String faceScanStep(int step);

  /// No description provided for @faceScanUploading.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi dữ liệu khuôn mặt lên máy chủ...'**
  String get faceScanUploading;

  /// No description provided for @faceScanStoredSafely.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu khuôn mặt đã được lưu trữ an toàn.'**
  String get faceScanStoredSafely;

  /// No description provided for @faceScanTooDarkMessage.
  ///
  /// In vi, this message translates to:
  /// **'Môi trường quá tối.\nVui lòng tìm nơi có ánh sáng tốt hơn.'**
  String get faceScanTooDarkMessage;

  /// No description provided for @faceScanLookStraight.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhìn thẳng vào camera'**
  String get faceScanLookStraight;

  /// No description provided for @faceScanLookUp.
  ///
  /// In vi, this message translates to:
  /// **'Ngẩng đầu lên một chút'**
  String get faceScanLookUp;

  /// No description provided for @faceScanLookDown.
  ///
  /// In vi, this message translates to:
  /// **'Cúi đầu xuống một chút'**
  String get faceScanLookDown;

  /// No description provided for @faceScanLookLeft.
  ///
  /// In vi, this message translates to:
  /// **'Quay mặt sang trái'**
  String get faceScanLookLeft;

  /// No description provided for @faceScanLookRight.
  ///
  /// In vi, this message translates to:
  /// **'Quay mặt sang phải'**
  String get faceScanLookRight;

  /// No description provided for @faceScanMissingAccount.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thông tin tài khoản. Vui lòng thử lại.'**
  String get faceScanMissingAccount;

  /// No description provided for @faceScanProcessImageFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi khi xử lý ảnh. Vui lòng thử lại.'**
  String get faceScanProcessImageFailed;

  /// No description provided for @authErrorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi xác thực'**
  String get authErrorTitle;

  /// No description provided for @languageSelectTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get languageSelectTitle;

  /// No description provided for @menuSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu'**
  String get menuSaved;

  /// No description provided for @menuCommunity.
  ///
  /// In vi, this message translates to:
  /// **'Cộng đồng'**
  String get menuCommunity;

  /// No description provided for @menuAppearance.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get menuAppearance;

  /// No description provided for @menuPrivacySecurity.
  ///
  /// In vi, this message translates to:
  /// **'Quyền riêng tư & bảo mật'**
  String get menuPrivacySecurity;

  /// No description provided for @profileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trang cá nhân'**
  String get profileTitle;

  /// No description provided for @profileLoadPostsError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải bài viết'**
  String get profileLoadPostsError;

  /// No description provided for @profileLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải trang cá nhân'**
  String get profileLoadError;

  /// No description provided for @profileNoPosts.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài viết nào'**
  String get profileNoPosts;

  /// No description provided for @profileEndOfPosts.
  ///
  /// In vi, this message translates to:
  /// **'Đã hiển thị hết bài viết'**
  String get profileEndOfPosts;

  /// No description provided for @profileAddToStory.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào tin'**
  String get profileAddToStory;

  /// No description provided for @profileEditInfo.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa thông tin'**
  String get profileEditInfo;

  /// No description provided for @profileAbout.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu'**
  String get profileAbout;

  /// No description provided for @profileStudiedAt.
  ///
  /// In vi, this message translates to:
  /// **'Đã học tại {school}'**
  String profileStudiedAt(String school);

  /// No description provided for @profileLivesIn.
  ///
  /// In vi, this message translates to:
  /// **'Sống tại {city}'**
  String profileLivesIn(String city);

  /// No description provided for @profileFrom.
  ///
  /// In vi, this message translates to:
  /// **'Đến từ {place}'**
  String profileFrom(String place);

  /// No description provided for @profileWorksAt.
  ///
  /// In vi, this message translates to:
  /// **'Làm việc tại {workplace}'**
  String profileWorksAt(String workplace);

  /// No description provided for @profileNoBio.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tiểu sử'**
  String get profileNoBio;

  /// No description provided for @profileCoverPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh bìa'**
  String get profileCoverPhoto;

  /// No description provided for @profileAvatarPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh đại diện'**
  String get profileAvatarPhoto;

  /// No description provided for @profileUserNameFallback.
  ///
  /// In vi, this message translates to:
  /// **'Tên người dùng'**
  String get profileUserNameFallback;

  /// No description provided for @profileEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get profileEdit;

  /// No description provided for @profilePostsTab.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết'**
  String get profilePostsTab;

  /// No description provided for @profilePhotosTab.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh'**
  String get profilePhotosTab;

  /// No description provided for @profileReelsTab.
  ///
  /// In vi, this message translates to:
  /// **'Reels'**
  String get profileReelsTab;

  /// No description provided for @profilePostsList.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách bài viết'**
  String get profilePostsList;

  /// No description provided for @profileYourPhotos.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh của bạn'**
  String get profileYourPhotos;

  /// No description provided for @profileYourReels.
  ///
  /// In vi, this message translates to:
  /// **'Reels của bạn'**
  String get profileYourReels;

  /// No description provided for @profileEditProfileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa trang cá nhân'**
  String get profileEditProfileTitle;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thất bại'**
  String get profileUpdateFailed;

  /// No description provided for @profileUsername.
  ///
  /// In vi, this message translates to:
  /// **'Tên người dùng'**
  String get profileUsername;

  /// No description provided for @profileEditName.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa tên'**
  String get profileEditName;

  /// No description provided for @profileAvatar.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh đại diện'**
  String get profileAvatar;

  /// No description provided for @profileCover.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh bìa'**
  String get profileCover;

  /// No description provided for @profileBio.
  ///
  /// In vi, this message translates to:
  /// **'Tiểu sử'**
  String get profileBio;

  /// No description provided for @profileEditBio.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa tiểu sử'**
  String get profileEditBio;

  /// No description provided for @profileDetails.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết'**
  String get profileDetails;

  /// No description provided for @profileNoBioPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tiểu sử'**
  String get profileNoBioPlaceholder;

  /// No description provided for @profileEnterField.
  ///
  /// In vi, this message translates to:
  /// **'Nhập {field}...'**
  String profileEnterField(String field);

  /// No description provided for @profileEditDetailsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa chi tiết'**
  String get profileEditDetailsTitle;

  /// No description provided for @profileSchool.
  ///
  /// In vi, this message translates to:
  /// **'Trường học'**
  String get profileSchool;

  /// No description provided for @profileCurrentCity.
  ///
  /// In vi, this message translates to:
  /// **'Thành phố hiện tại'**
  String get profileCurrentCity;

  /// No description provided for @profileHometown.
  ///
  /// In vi, this message translates to:
  /// **'Quê quán'**
  String get profileHometown;

  /// No description provided for @profileWorkplace.
  ///
  /// In vi, this message translates to:
  /// **'Nơi làm việc'**
  String get profileWorkplace;

  /// No description provided for @profileRelationshipStatus.
  ///
  /// In vi, this message translates to:
  /// **'Tình trạng quan hệ'**
  String get profileRelationshipStatus;

  /// No description provided for @profileSelectRelationshipStatus.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tình trạng quan hệ'**
  String get profileSelectRelationshipStatus;

  /// No description provided for @profileChooseAvatar.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh đại diện'**
  String get profileChooseAvatar;

  /// No description provided for @profileChooseCover.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh bìa'**
  String get profileChooseCover;

  /// No description provided for @profileImage.
  ///
  /// In vi, this message translates to:
  /// **'Hình ảnh'**
  String get profileImage;

  /// No description provided for @profileAddWorkplace.
  ///
  /// In vi, this message translates to:
  /// **'Thêm nơi làm việc'**
  String get profileAddWorkplace;

  /// No description provided for @profileAddRelationshipStatus.
  ///
  /// In vi, this message translates to:
  /// **'Thêm tình trạng mối quan hệ'**
  String get profileAddRelationshipStatus;

  /// No description provided for @profileWhatsOnYourMind.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang nghĩ gì?'**
  String get profileWhatsOnYourMind;

  /// No description provided for @profileNoFriends.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bạn bè nào'**
  String get profileNoFriends;

  /// No description provided for @profileFriends.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get profileFriends;

  /// No description provided for @profileViewAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get profileViewAll;

  /// No description provided for @profileFriendCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{0 người bạn} =1{1 người bạn} other{{count} người bạn}}'**
  String profileFriendCount(num count);

  /// No description provided for @profileUnnamed.
  ///
  /// In vi, this message translates to:
  /// **'Không tên'**
  String get profileUnnamed;

  /// No description provided for @profileAddFriend.
  ///
  /// In vi, this message translates to:
  /// **'Thêm bạn bè'**
  String get profileAddFriend;

  /// No description provided for @profileCancelFriendRequest.
  ///
  /// In vi, this message translates to:
  /// **'Hủy yêu cầu kết bạn'**
  String get profileCancelFriendRequest;

  /// No description provided for @profileAcceptFriend.
  ///
  /// In vi, this message translates to:
  /// **'Chấp nhận kết bạn'**
  String get profileAcceptFriend;

  /// No description provided for @profileRejectFriend.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get profileRejectFriend;

  /// No description provided for @profileUnfriend.
  ///
  /// In vi, this message translates to:
  /// **'Hủy kết bạn'**
  String get profileUnfriend;

  /// No description provided for @profileMessage.
  ///
  /// In vi, this message translates to:
  /// **'Nhắn tin'**
  String get profileMessage;

  /// No description provided for @profileConfirmUnfriendTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận hủy kết bạn'**
  String get profileConfirmUnfriendTitle;

  /// No description provided for @profileConfirmUnfriendMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn hủy kết bạn với người này không?'**
  String get profileConfirmUnfriendMessage;

  /// No description provided for @profileAgree.
  ///
  /// In vi, this message translates to:
  /// **'Đồng ý'**
  String get profileAgree;

  /// No description provided for @profileAccountSecurity.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật tài khoản'**
  String get profileAccountSecurity;

  /// No description provided for @profileFaceData.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu khuôn mặt'**
  String get profileFaceData;

  /// No description provided for @profileChangePasswordSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật mật khẩu bảo vệ tài khoản'**
  String get profileChangePasswordSubtitle;

  /// No description provided for @profileFaceRegistered.
  ///
  /// In vi, this message translates to:
  /// **'Đã thiết lập'**
  String get profileFaceRegistered;

  /// No description provided for @profileFaceNotRegistered.
  ///
  /// In vi, this message translates to:
  /// **'Chưa thiết lập'**
  String get profileFaceNotRegistered;

  /// No description provided for @profileFaceDataSuccessDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Xóa dữ liệu khuôn mặt thành công'**
  String get profileFaceDataSuccessDeleted;

  /// No description provided for @profileManageFaceData.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý dữ liệu khuôn mặt'**
  String get profileManageFaceData;

  /// No description provided for @profileAddFaceData.
  ///
  /// In vi, this message translates to:
  /// **'Thêm dữ liệu khuôn mặt'**
  String get profileAddFaceData;

  /// No description provided for @profileFaceDataRegisteredDescription.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu khuôn mặt của bạn đang được sử dụng để nhận diện và bảo vệ tài khoản.'**
  String get profileFaceDataRegisteredDescription;

  /// No description provided for @profileFaceDataUnregisteredDescription.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký khuôn mặt giúp AI nhận diện bạn trong ảnh và bảo vệ tài khoản tốt hơn.'**
  String get profileFaceDataUnregisteredDescription;

  /// No description provided for @profileDeleteFaceData.
  ///
  /// In vi, this message translates to:
  /// **'Xóa dữ liệu khuôn mặt'**
  String get profileDeleteFaceData;

  /// No description provided for @profileDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận xóa'**
  String get profileDeleteConfirmTitle;

  /// No description provided for @profileDeleteFaceConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xóa toàn bộ dữ liệu khuôn mặt? Hành động này không thể hoàn tác.'**
  String get profileDeleteFaceConfirmMessage;

  /// No description provided for @profileDeletingFaceData.
  ///
  /// In vi, this message translates to:
  /// **'Đang xóa dữ liệu khuôn mặt...'**
  String get profileDeletingFaceData;

  /// No description provided for @profileReportUser.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo người dùng'**
  String get profileReportUser;

  /// No description provided for @profileReportUserIntro.
  ///
  /// In vi, this message translates to:
  /// **'Hãy chọn lý do phù hợp để chúng tôi xem xét tài khoản này.'**
  String get profileReportUserIntro;

  /// No description provided for @profileReportUserSelfNotAllowed.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không thể báo cáo trang cá nhân của chính mình'**
  String get profileReportUserSelfNotAllowed;

  /// No description provided for @profileReportUserSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi báo cáo người dùng'**
  String get profileReportUserSuccess;

  /// No description provided for @profileReportUserFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi báo cáo người dùng'**
  String get profileReportUserFailed;

  /// No description provided for @profileReportReasonFakeAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản giả mạo'**
  String get profileReportReasonFakeAccount;

  /// No description provided for @appearanceDisplayModeSection.
  ///
  /// In vi, this message translates to:
  /// **'CHẾ ĐỘ HIỂN THỊ'**
  String get appearanceDisplayModeSection;

  /// No description provided for @appearanceAccentColorSection.
  ///
  /// In vi, this message translates to:
  /// **'MÀU CHỦ ĐẠO'**
  String get appearanceAccentColorSection;

  /// No description provided for @appearanceTextSizeSection.
  ///
  /// In vi, this message translates to:
  /// **'KÍCH THƯỚC CHỮ'**
  String get appearanceTextSizeSection;

  /// No description provided for @appearanceLightMode.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get appearanceLightMode;

  /// No description provided for @appearanceDarkMode.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get appearanceDarkMode;

  /// No description provided for @appearanceAutoMode.
  ///
  /// In vi, this message translates to:
  /// **'Tự động'**
  String get appearanceAutoMode;

  /// No description provided for @appearanceSmallText.
  ///
  /// In vi, this message translates to:
  /// **'Nhỏ'**
  String get appearanceSmallText;

  /// No description provided for @appearanceNormalText.
  ///
  /// In vi, this message translates to:
  /// **'Bình thường'**
  String get appearanceNormalText;

  /// No description provided for @appearanceLargeText.
  ///
  /// In vi, this message translates to:
  /// **'Lớn'**
  String get appearanceLargeText;

  /// No description provided for @appearanceChooseAccentColor.
  ///
  /// In vi, this message translates to:
  /// **'Chọn màu chủ đạo'**
  String get appearanceChooseAccentColor;

  /// No description provided for @appearanceCustomAccentColor.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chỉnh'**
  String get appearanceCustomAccentColor;

  /// No description provided for @appearanceDefaultAccent.
  ///
  /// In vi, this message translates to:
  /// **'Mặc định'**
  String get appearanceDefaultAccent;

  /// No description provided for @appearanceBlueAccent.
  ///
  /// In vi, this message translates to:
  /// **'Xanh dương'**
  String get appearanceBlueAccent;

  /// No description provided for @appearancePinkPurpleAccent.
  ///
  /// In vi, this message translates to:
  /// **'Hồng tím'**
  String get appearancePinkPurpleAccent;

  /// No description provided for @appearanceNeonPurpleAccent.
  ///
  /// In vi, this message translates to:
  /// **'Tím neon'**
  String get appearanceNeonPurpleAccent;

  /// No description provided for @appearanceBrightOrangeAccent.
  ///
  /// In vi, this message translates to:
  /// **'Cam sáng'**
  String get appearanceBrightOrangeAccent;

  /// No description provided for @appearanceCoralRedAccent.
  ///
  /// In vi, this message translates to:
  /// **'Đỏ coral'**
  String get appearanceCoralRedAccent;

  /// No description provided for @appearanceHighContrast.
  ///
  /// In vi, this message translates to:
  /// **'Độ tương phản cao'**
  String get appearanceHighContrast;

  /// No description provided for @appearanceReduceMotion.
  ///
  /// In vi, this message translates to:
  /// **'Giảm chuyển động'**
  String get appearanceReduceMotion;

  /// No description provided for @relationshipSingle.
  ///
  /// In vi, this message translates to:
  /// **'Độc thân'**
  String get relationshipSingle;

  /// No description provided for @relationshipDating.
  ///
  /// In vi, this message translates to:
  /// **'Hẹn hò'**
  String get relationshipDating;

  /// No description provided for @relationshipInRelationship.
  ///
  /// In vi, this message translates to:
  /// **'Đang hẹn hò'**
  String get relationshipInRelationship;

  /// No description provided for @relationshipMarried.
  ///
  /// In vi, this message translates to:
  /// **'Đã kết hôn'**
  String get relationshipMarried;

  /// No description provided for @relationshipComplicated.
  ///
  /// In vi, this message translates to:
  /// **'Phức tạp'**
  String get relationshipComplicated;

  /// No description provided for @relationshipOpen.
  ///
  /// In vi, this message translates to:
  /// **'Mối quan hệ mở'**
  String get relationshipOpen;

  /// No description provided for @relationshipDivorced.
  ///
  /// In vi, this message translates to:
  /// **'Ly hôn'**
  String get relationshipDivorced;

  /// No description provided for @menuCreateProfileOrPage.
  ///
  /// In vi, this message translates to:
  /// **'Tạo trang cá nhân hoặc Trang mới'**
  String get menuCreateProfileOrPage;

  /// No description provided for @commonAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get commonAll;

  /// No description provided for @commonBack.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get commonBack;

  /// No description provided for @commonCreate.
  ///
  /// In vi, this message translates to:
  /// **'Tạo'**
  String get commonCreate;

  /// No description provided for @commonDetails.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết'**
  String get commonDetails;

  /// No description provided for @commonDone.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get commonDone;

  /// No description provided for @commonErrorOccurred.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi'**
  String get commonErrorOccurred;

  /// No description provided for @commonErrorWithMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi: {error}'**
  String commonErrorWithMessage(String error);

  /// No description provided for @commonFeatureInDevelopment.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng đang phát triển'**
  String get commonFeatureInDevelopment;

  /// No description provided for @commonLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải'**
  String get commonLoading;

  /// No description provided for @commonNextWithCount.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp ({count})'**
  String commonNextWithCount(num count);

  /// No description provided for @commonNo.
  ///
  /// In vi, this message translates to:
  /// **'Không'**
  String get commonNo;

  /// No description provided for @commonRefresh.
  ///
  /// In vi, this message translates to:
  /// **'Tải lại'**
  String get commonRefresh;

  /// No description provided for @commonSaveChanges.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get commonSaveChanges;

  /// No description provided for @commonServerErrorRetryLater.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi máy chủ. Vui lòng thử lại sau.'**
  String get commonServerErrorRetryLater;

  /// No description provided for @commonSessionExpired.
  ///
  /// In vi, this message translates to:
  /// **'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'**
  String get commonSessionExpired;

  /// No description provided for @commonSystem.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống'**
  String get commonSystem;

  /// No description provided for @commonUnderstood.
  ///
  /// In vi, this message translates to:
  /// **'Đã hiểu'**
  String get commonUnderstood;

  /// No description provided for @commonUnexpectedErrorRetry.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.'**
  String get commonUnexpectedErrorRetry;

  /// No description provided for @commonUnknownError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi không xác định'**
  String get commonUnknownError;

  /// No description provided for @commonFeatureNotSupported.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng không hỗ trợ'**
  String get commonFeatureNotSupported;

  /// No description provided for @commonMobileOnlyFeature.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng {featureName} chỉ hỗ trợ thực hiện trên thiết bị điện thoại di động.'**
  String commonMobileOnlyFeature(String featureName);

  /// No description provided for @communityAdmin.
  ///
  /// In vi, this message translates to:
  /// **'Admin'**
  String get communityAdmin;

  /// No description provided for @communityAdminDemoted.
  ///
  /// In vi, this message translates to:
  /// **'Đã hạ quyền admin'**
  String get communityAdminDemoted;

  /// No description provided for @communityAdminPanelSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt thành viên mới và kiểm duyệt bài viết trước khi hiển thị.'**
  String get communityAdminPanelSubtitle;

  /// No description provided for @communityAdminPanelTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảng quản trị'**
  String get communityAdminPanelTitle;

  /// No description provided for @communityApproved.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt'**
  String get communityApproved;

  /// No description provided for @communityAvatar.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh đại diện'**
  String get communityAvatar;

  /// No description provided for @communityCancelJoinRequestConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn hủy yêu cầu tham gia cộng đồng này?'**
  String get communityCancelJoinRequestConfirm;

  /// No description provided for @communityCancelJoinRequestTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hủy yêu cầu'**
  String get communityCancelJoinRequestTitle;

  /// No description provided for @communityCancelRequestSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy yêu cầu tham gia'**
  String get communityCancelRequestSuccess;

  /// No description provided for @communityCannotIdentifyFriend.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi: Không thể xác định bạn bè'**
  String get communityCannotIdentifyFriend;

  /// No description provided for @communityChooseAvatar.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh đại diện'**
  String get communityChooseAvatar;

  /// No description provided for @communityChooseCover.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh bìa'**
  String get communityChooseCover;

  /// No description provided for @communityChooseFromLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Chọn từ thư viện'**
  String get communityChooseFromLibrary;

  /// No description provided for @communityClearSearch.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tìm kiếm'**
  String get communityClearSearch;

  /// No description provided for @communityCoverImage.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh bìa'**
  String get communityCoverImage;

  /// No description provided for @communityCreateGroup.
  ///
  /// In vi, this message translates to:
  /// **'Tạo nhóm'**
  String get communityCreateGroup;

  /// No description provided for @communityCreateIntro.
  ///
  /// In vi, this message translates to:
  /// **'Tạo không gian để bạn bè cùng trao đổi và chia sẻ nội dung.'**
  String get communityCreateIntro;

  /// No description provided for @communityCreatePostTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo bài viết trong nhóm'**
  String get communityCreatePostTitle;

  /// No description provided for @communityCreateSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Tạo cộng đồng thành công'**
  String get communityCreateSuccess;

  /// No description provided for @communityCreateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo cộng đồng'**
  String get communityCreateTitle;

  /// No description provided for @communityDeleteConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa cộng đồng này? Hành động này không thể hoàn tác.'**
  String get communityDeleteConfirm;

  /// No description provided for @communityDeleteGroup.
  ///
  /// In vi, this message translates to:
  /// **'Xóa nhóm'**
  String get communityDeleteGroup;

  /// No description provided for @communityDeleteSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa cộng đồng thành công'**
  String get communityDeleteSuccess;

  /// No description provided for @communityDeleteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa cộng đồng'**
  String get communityDeleteTitle;

  /// No description provided for @communityDescription.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả'**
  String get communityDescription;

  /// No description provided for @communityDescriptionHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mô tả cộng đồng'**
  String get communityDescriptionHint;

  /// No description provided for @communityEditGroup.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa nhóm'**
  String get communityEditGroup;

  /// No description provided for @communityEditIntro.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thông tin để thành viên hiểu rõ hơn về cộng đồng.'**
  String get communityEditIntro;

  /// No description provided for @communityEditTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa cộng đồng'**
  String get communityEditTitle;

  /// No description provided for @communityEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có cộng đồng nào'**
  String get communityEmpty;

  /// No description provided for @communityExploreSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá các cộng đồng và chia sẻ những điều thú vị.'**
  String get communityExploreSubtitle;

  /// No description provided for @communityExploreTab.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá'**
  String get communityExploreTab;

  /// No description provided for @communityExploreTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cộng đồng'**
  String get communityExploreTitle;

  /// No description provided for @communityFilterPosts.
  ///
  /// In vi, this message translates to:
  /// **'Lọc bài viết'**
  String get communityFilterPosts;

  /// No description provided for @communityHandleInviteFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xử lý lời mời'**
  String get communityHandleInviteFailed;

  /// No description provided for @communityInviteFriends.
  ///
  /// In vi, this message translates to:
  /// **'Mời bạn bè'**
  String get communityInviteFriends;

  /// No description provided for @communityInviteFriendsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia cộng đồng này'**
  String get communityInviteFriendsSubtitle;

  /// No description provided for @communityInviteFriendsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mời bạn bè'**
  String get communityInviteFriendsTitle;

  /// No description provided for @communityInvitePendingNotice.
  ///
  /// In vi, this message translates to:
  /// **'Lời mời tham gia cộng đồng đang chờ phản hồi.'**
  String get communityInvitePendingNotice;

  /// No description provided for @communityInviteSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm tên hoặc username...'**
  String get communityInviteSearchHint;

  /// No description provided for @communityInviteSendFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi lời mời'**
  String get communityInviteSendFailed;

  /// No description provided for @communityInviteSentSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lời mời thành công'**
  String get communityInviteSentSuccess;

  /// No description provided for @communityInviteStatusApproved.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã chấp nhận lời mời'**
  String get communityInviteStatusApproved;

  /// No description provided for @communityInviteStatusPending.
  ///
  /// In vi, this message translates to:
  /// **'Bạn được mời tham gia cộng đồng'**
  String get communityInviteStatusPending;

  /// No description provided for @communityInviteStatusRejected.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã từ chối lời mời'**
  String get communityInviteStatusRejected;

  /// No description provided for @communityInvited.
  ///
  /// In vi, this message translates to:
  /// **'Đã mời'**
  String get communityInvited;

  /// No description provided for @communityInvitesTab.
  ///
  /// In vi, this message translates to:
  /// **'Lời mời'**
  String get communityInvitesTab;

  /// No description provided for @communityInvitesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lời mời cộng đồng'**
  String get communityInvitesTitle;

  /// No description provided for @communityJoin.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia'**
  String get communityJoin;

  /// No description provided for @communityJoinRequestAccepted.
  ///
  /// In vi, this message translates to:
  /// **'Đã chấp nhận yêu cầu'**
  String get communityJoinRequestAccepted;

  /// No description provided for @communityJoinRequestPendingMessage.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu tham gia cộng đồng đang chờ bạn xét duyệt.'**
  String get communityJoinRequestPendingMessage;

  /// No description provided for @communityJoinRequestRejected.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối yêu cầu'**
  String get communityJoinRequestRejected;

  /// No description provided for @communityJoinRequestSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu tham gia cộng đồng'**
  String get communityJoinRequestSent;

  /// No description provided for @communityJoinShort.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia'**
  String get communityJoinShort;

  /// No description provided for @communityLeaveConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn rời khỏi cộng đồng này?'**
  String get communityLeaveConfirm;

  /// No description provided for @communityLeaveGroup.
  ///
  /// In vi, this message translates to:
  /// **'Rời nhóm'**
  String get communityLeaveGroup;

  /// No description provided for @communityLeaveSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã rời khỏi cộng đồng'**
  String get communityLeaveSuccess;

  /// No description provided for @communityLoadFriendsFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi tải danh sách bạn bè'**
  String get communityLoadFriendsFailed;

  /// No description provided for @communityLoadInvitesFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải lời mời'**
  String get communityLoadInvitesFailed;

  /// No description provided for @communityLoadMembersFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được danh sách'**
  String get communityLoadMembersFailed;

  /// No description provided for @communityLoadingFriends.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải danh sách bạn bè...'**
  String get communityLoadingFriends;

  /// No description provided for @communityMediaCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} media'**
  String communityMediaCount(num count);

  /// No description provided for @communityMember.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên'**
  String get communityMember;

  /// No description provided for @communityMemberOnlyContent.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung chỉ dành cho thành viên'**
  String get communityMemberOnlyContent;

  /// No description provided for @communityMemberOnlyPostsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia cộng đồng để xem bài viết trong nhóm.'**
  String get communityMemberOnlyPostsMessage;

  /// No description provided for @communityMemberOptions.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chọn thành viên'**
  String get communityMemberOptions;

  /// No description provided for @communityMemberPromoted.
  ///
  /// In vi, this message translates to:
  /// **'Đã nâng quyền thành viên'**
  String get communityMemberPromoted;

  /// No description provided for @communityMemberRemoved.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa thành viên'**
  String get communityMemberRemoved;

  /// No description provided for @communityMembers.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên'**
  String get communityMembers;

  /// No description provided for @communityMembersCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{0 thành viên} =1{1 thành viên} other{{count} thành viên}}'**
  String communityMembersCount(num count);

  /// No description provided for @communityMembersListTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách thành viên'**
  String get communityMembersListTitle;

  /// No description provided for @communityMineTab.
  ///
  /// In vi, this message translates to:
  /// **'Của tôi'**
  String get communityMineTab;

  /// No description provided for @communityName.
  ///
  /// In vi, this message translates to:
  /// **'Tên cộng đồng'**
  String get communityName;

  /// No description provided for @communityNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên cộng đồng'**
  String get communityNameHint;

  /// No description provided for @communityNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên cộng đồng'**
  String get communityNameRequired;

  /// No description provided for @communityNoApprovedPosts.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài viết đã duyệt'**
  String get communityNoApprovedPosts;

  /// No description provided for @communityNoAvailableFriends.
  ///
  /// In vi, this message translates to:
  /// **'Không có bạn bè khả dụng'**
  String get communityNoAvailableFriends;

  /// No description provided for @communityNoCommunityInvites.
  ///
  /// In vi, this message translates to:
  /// **'Không có lời mời tham gia cộng đồng'**
  String get communityNoCommunityInvites;

  /// No description provided for @communityNoDescription.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có mô tả'**
  String get communityNoDescription;

  /// No description provided for @communityNoInviteSearchResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy \"{query}\"'**
  String communityNoInviteSearchResults(String query);

  /// No description provided for @communityNoInvites.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không có lời mời nào'**
  String get communityNoInvites;

  /// No description provided for @communityNoJoinedCommunities.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa tham gia cộng đồng nào'**
  String get communityNoJoinedCommunities;

  /// No description provided for @communityNoMembers.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thành viên nào'**
  String get communityNoMembers;

  /// No description provided for @communityNoMembersFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thành viên'**
  String get communityNoMembersFound;

  /// No description provided for @communityNoMembersFoundMessage.
  ///
  /// In vi, this message translates to:
  /// **'Thử tìm bằng tên hoặc username khác.'**
  String get communityNoMembersFoundMessage;

  /// No description provided for @communityNoMembersMessage.
  ///
  /// In vi, this message translates to:
  /// **'Khi có người tham gia, danh sách sẽ hiển thị tại đây.'**
  String get communityNoMembersMessage;

  /// No description provided for @communityNoPendingCommunities.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có cộng đồng nào đang chờ duyệt'**
  String get communityNoPendingCommunities;

  /// No description provided for @communityNoPendingPosts.
  ///
  /// In vi, this message translates to:
  /// **'Không có bài viết đang chờ duyệt'**
  String get communityNoPendingPosts;

  /// No description provided for @communityNoPendingRequests.
  ///
  /// In vi, this message translates to:
  /// **'Không có yêu cầu tham gia đang chờ duyệt'**
  String get communityNoPendingRequests;

  /// No description provided for @communityNoPendingReviewPosts.
  ///
  /// In vi, this message translates to:
  /// **'Không có bài viết nào đang chờ duyệt'**
  String get communityNoPendingReviewPosts;

  /// No description provided for @communityNoPosts.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài viết nào'**
  String get communityNoPosts;

  /// No description provided for @communityNoPostsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Các bài viết trong cộng đồng sẽ xuất hiện tại đây.'**
  String get communityNoPostsMessage;

  /// No description provided for @communityNoPostsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài viết'**
  String get communityNoPostsTitle;

  /// No description provided for @communityNoSearchResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy cộng đồng phù hợp'**
  String get communityNoSearchResults;

  /// No description provided for @communityPendingApproval.
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get communityPendingApproval;

  /// No description provided for @communityPendingCommunitiesHint.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu tham gia cộng đồng sẽ xuất hiện tại đây'**
  String get communityPendingCommunitiesHint;

  /// No description provided for @communityPendingPostsHint.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết mới sẽ hiển thị tại đây để bạn kiểm duyệt.'**
  String get communityPendingPostsHint;

  /// No description provided for @communityPendingRequestsHint.
  ///
  /// In vi, this message translates to:
  /// **'Khi có thành viên mới gửi yêu cầu, bạn sẽ thấy ở đây.'**
  String get communityPendingRequestsHint;

  /// No description provided for @communityPendingTab.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ'**
  String get communityPendingTab;

  /// No description provided for @communityPickImageError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể chọn ảnh: {error}'**
  String communityPickImageError(String error);

  /// No description provided for @communityPostApprovedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt bài viết'**
  String get communityPostApprovedSuccess;

  /// No description provided for @communityPostNoText.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết không có nội dung văn bản.'**
  String get communityPostNoText;

  /// No description provided for @communityPostPendingApproval.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết đang chờ quản trị viên duyệt'**
  String get communityPostPendingApproval;

  /// No description provided for @communityPostRejectedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối bài viết'**
  String get communityPostRejectedSuccess;

  /// No description provided for @communityPostsInGroup.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết trong nhóm'**
  String get communityPostsInGroup;

  /// No description provided for @communityPostsTab.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết'**
  String get communityPostsTab;

  /// No description provided for @communityPrivacyMembers.
  ///
  /// In vi, this message translates to:
  /// **'{privacy} · {count, plural, =0{0 thành viên} =1{1 thành viên} other{{count} thành viên}}'**
  String communityPrivacyMembers(String privacy, num count);

  /// No description provided for @communityPrivate.
  ///
  /// In vi, this message translates to:
  /// **'Riêng tư'**
  String get communityPrivate;

  /// No description provided for @communityPrivateGroup.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm riêng tư'**
  String get communityPrivateGroup;

  /// No description provided for @communityPrivateOnly.
  ///
  /// In vi, this message translates to:
  /// **'Riêng tư'**
  String get communityPrivateOnly;

  /// No description provided for @communityPublic.
  ///
  /// In vi, this message translates to:
  /// **'Công khai'**
  String get communityPublic;

  /// No description provided for @communityPublicGroup.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm công khai'**
  String get communityPublicGroup;

  /// No description provided for @communityPublicOnly.
  ///
  /// In vi, this message translates to:
  /// **'Công khai'**
  String get communityPublicOnly;

  /// No description provided for @communityRemoveFromGroup.
  ///
  /// In vi, this message translates to:
  /// **'Xóa khỏi nhóm'**
  String get communityRemoveFromGroup;

  /// No description provided for @communityRemoveMemberConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn xóa {name} khỏi cộng đồng? Người này có thể gửi yêu cầu tham gia lại sau.'**
  String communityRemoveMemberConfirm(String name);

  /// No description provided for @communityRemoveMemberTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa thành viên'**
  String get communityRemoveMemberTitle;

  /// No description provided for @communityReviewMembers.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt thành viên'**
  String get communityReviewMembers;

  /// No description provided for @communityReviewMembersSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận yêu cầu tham gia cộng đồng'**
  String get communityReviewMembersSubtitle;

  /// No description provided for @communityReviewPosts.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt bài viết'**
  String get communityReviewPosts;

  /// No description provided for @communityReviewPostsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra nội dung trước khi bài được công khai'**
  String get communityReviewPostsSubtitle;

  /// No description provided for @communitySearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm cộng đồng'**
  String get communitySearchHint;

  /// No description provided for @communitySearchMembersHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm thành viên'**
  String get communitySearchMembersHint;

  /// No description provided for @communitySendingInvite.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi lời mời...'**
  String get communitySendingInvite;

  /// No description provided for @communityType.
  ///
  /// In vi, this message translates to:
  /// **'Loại cộng đồng'**
  String get communityType;

  /// No description provided for @communityRoadmap.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ'**
  String get communityRoadmap;

  /// No description provided for @communityRoadmapTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ lộ trình'**
  String get communityRoadmapTitle;

  /// No description provided for @communityRoadmapViewFull.
  ///
  /// In vi, this message translates to:
  /// **'Xem bản đồ lớn'**
  String get communityRoadmapViewFull;

  /// No description provided for @communityRoadmapEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có địa điểm nào trên bản đồ'**
  String get communityRoadmapEmpty;

  /// No description provided for @communityRoadmapMyLocation.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí của tôi'**
  String get communityRoadmapMyLocation;

  /// No description provided for @communityRoadmapPostCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} bài viết'**
  String communityRoadmapPostCount(num count);

  /// No description provided for @communityRoadmapViewPost.
  ///
  /// In vi, this message translates to:
  /// **'Xem bài viết'**
  String get communityRoadmapViewPost;

  /// No description provided for @communityRoadmapSearchNearby.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm quanh đây'**
  String get communityRoadmapSearchNearby;

  /// No description provided for @communityRoadmapRadius.
  ///
  /// In vi, this message translates to:
  /// **'Bán kính: {radius} km'**
  String communityRoadmapRadius(num radius);

  /// No description provided for @communityRoadmapRadiusLabel.
  ///
  /// In vi, this message translates to:
  /// **'{radius} km'**
  String communityRoadmapRadiusLabel(num radius);

  /// No description provided for @communityRoadmapApplyFilter.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get communityRoadmapApplyFilter;

  /// No description provided for @communityRoadmapErrorLoadPosts.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra'**
  String get communityRoadmapErrorLoadPosts;

  /// No description provided for @communityRoadmapNoPosts.
  ///
  /// In vi, this message translates to:
  /// **'Không có bài viết nào'**
  String get communityRoadmapNoPosts;

  /// No description provided for @communityRoadmapFirstCheckedInBy.
  ///
  /// In vi, this message translates to:
  /// **'Được check-in lần đầu bởi {name}'**
  String communityRoadmapFirstCheckedInBy(String name);

  /// No description provided for @communityRoadmapFilterTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Lọc quanh vị trí'**
  String get communityRoadmapFilterTooltip;

  /// No description provided for @communityUpdateSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật cộng đồng thành công'**
  String get communityUpdateSuccess;

  /// No description provided for @communityVisibleMembersCount.
  ///
  /// In vi, this message translates to:
  /// **'{visible}/{total} thành viên'**
  String communityVisibleMembersCount(num visible, num total);

  /// No description provided for @communityWritePostHint.
  ///
  /// In vi, this message translates to:
  /// **'Viết bài trong nhóm...'**
  String get communityWritePostHint;

  /// No description provided for @friendAccept.
  ///
  /// In vi, this message translates to:
  /// **'Chấp nhận'**
  String get friendAccept;

  /// No description provided for @friendActiveCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{0 đang hoạt động} =1{1 đang hoạt động} other{{count} đang hoạt động}}'**
  String friendActiveCount(num count);

  /// No description provided for @friendAdd.
  ///
  /// In vi, this message translates to:
  /// **'Thêm bạn bè'**
  String get friendAdd;

  /// No description provided for @friendBecameFriends.
  ///
  /// In vi, this message translates to:
  /// **'Đã trở thành bạn bè'**
  String get friendBecameFriends;

  /// No description provided for @friendCancelRequest.
  ///
  /// In vi, this message translates to:
  /// **'Hủy yêu cầu'**
  String get friendCancelRequest;

  /// No description provided for @friendCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{0 bạn bè} =1{1 bạn bè} other{{count} bạn bè}}'**
  String friendCount(num count);

  /// No description provided for @friendDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get friendDelete;

  /// No description provided for @friendFallbackUserWithIndex.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng {index}'**
  String friendFallbackUserWithIndex(num index);

  /// No description provided for @friendFriendsOf.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè của {name}'**
  String friendFriendsOf(String name);

  /// No description provided for @friendFriendsSince.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè từ {month} {year}'**
  String friendFriendsSince(String month, num year);

  /// No description provided for @friendJustActive.
  ///
  /// In vi, this message translates to:
  /// **'Vừa hoạt động'**
  String get friendJustActive;

  /// No description provided for @friendLoadDataError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải dữ liệu bạn bè'**
  String get friendLoadDataError;

  /// No description provided for @friendLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải bạn bè: {message}'**
  String friendLoadError(String message);

  /// No description provided for @friendLoadFriendsFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách bạn bè'**
  String get friendLoadFriendsFailed;

  /// No description provided for @friendLoadSuggestionsUnknownError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi không xác định khi tải gợi ý bạn bè'**
  String get friendLoadSuggestionsUnknownError;

  /// No description provided for @friendLoadingRequests.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải lời mời kết bạn...'**
  String get friendLoadingRequests;

  /// No description provided for @friendLoadingSentRequests.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải lời mời đã gửi...'**
  String get friendLoadingSentRequests;

  /// No description provided for @friendLoadingSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải gợi ý bạn bè...'**
  String get friendLoadingSuggestions;

  /// No description provided for @friendLongtimeFriend.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè lâu năm'**
  String get friendLongtimeFriend;

  /// No description provided for @friendMessageUser.
  ///
  /// In vi, this message translates to:
  /// **'Nhắn tin cho {name}'**
  String friendMessageUser(String name);

  /// No description provided for @friendMutualCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{Không có bạn chung} =1{1 bạn chung} other{{count} bạn chung}}'**
  String friendMutualCount(num count);

  /// No description provided for @friendNoFriends.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bạn bè'**
  String get friendNoFriends;

  /// No description provided for @friendNoRequests.
  ///
  /// In vi, this message translates to:
  /// **'Không có lời mời kết bạn'**
  String get friendNoRequests;

  /// No description provided for @friendNoRequestsDescription.
  ///
  /// In vi, this message translates to:
  /// **'Khi có người gửi lời mời, bạn sẽ thấy tại đây.'**
  String get friendNoRequestsDescription;

  /// No description provided for @friendNoSentRequests.
  ///
  /// In vi, this message translates to:
  /// **'Chưa gửi lời mời nào'**
  String get friendNoSentRequests;

  /// No description provided for @friendNoSentRequestsDescription.
  ///
  /// In vi, this message translates to:
  /// **'Các lời mời kết bạn bạn đã gửi sẽ hiển thị tại đây.'**
  String get friendNoSentRequestsDescription;

  /// No description provided for @friendNoSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Không có gợi ý bạn bè'**
  String get friendNoSuggestions;

  /// No description provided for @friendNoSuggestionsDescription.
  ///
  /// In vi, this message translates to:
  /// **'Hãy quay lại sau để xem thêm gợi ý mới.'**
  String get friendNoSuggestionsDescription;

  /// No description provided for @friendOnlineCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{Không có ai online} =1{1 người online} other{{count} người online}}'**
  String friendOnlineCount(num count);

  /// No description provided for @friendPeopleYouMayKnow.
  ///
  /// In vi, this message translates to:
  /// **'Những người bạn có thể biết'**
  String get friendPeopleYouMayKnow;

  /// No description provided for @friendReject.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get friendReject;

  /// No description provided for @friendRemove.
  ///
  /// In vi, this message translates to:
  /// **'Gỡ'**
  String get friendRemove;

  /// No description provided for @friendRequestAccepted.
  ///
  /// In vi, this message translates to:
  /// **'Đã chấp nhận lời mời kết bạn'**
  String get friendRequestAccepted;

  /// No description provided for @friendRequestCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy yêu cầu'**
  String get friendRequestCancelled;

  /// No description provided for @friendRequestNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy lời mời kết bạn'**
  String get friendRequestNotFound;

  /// No description provided for @friendRequestRejected.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối lời mời kết bạn'**
  String get friendRequestRejected;

  /// No description provided for @friendRequestRemoved.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa lời mời kết bạn'**
  String get friendRequestRemoved;

  /// No description provided for @friendRequestSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lời mời kết bạn'**
  String get friendRequestSent;

  /// No description provided for @friendRequestsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lời mời kết bạn'**
  String get friendRequestsTitle;

  /// No description provided for @friendSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm bạn bè'**
  String get friendSearchHint;

  /// No description provided for @friendSeeAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get friendSeeAll;

  /// No description provided for @friendSentRequestsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{0 lời mời đã gửi} =1{1 lời mời đã gửi} other{{count} lời mời đã gửi}}'**
  String friendSentRequestsCount(num count);

  /// No description provided for @friendSentRequestsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lời mời đã gửi'**
  String get friendSentRequestsTitle;

  /// No description provided for @friendSort.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp'**
  String get friendSort;

  /// No description provided for @friendSortBy.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp theo'**
  String get friendSortBy;

  /// No description provided for @friendSortLeastMutual.
  ///
  /// In vi, this message translates to:
  /// **'Ít bạn chung nhất'**
  String get friendSortLeastMutual;

  /// No description provided for @friendSortMostMutual.
  ///
  /// In vi, this message translates to:
  /// **'Nhiều bạn chung nhất'**
  String get friendSortMostMutual;

  /// No description provided for @friendSortName.
  ///
  /// In vi, this message translates to:
  /// **'Tên'**
  String get friendSortName;

  /// No description provided for @friendSortNameAz.
  ///
  /// In vi, this message translates to:
  /// **'Tên A-Z'**
  String get friendSortNameAz;

  /// No description provided for @friendSortNameZa.
  ///
  /// In vi, this message translates to:
  /// **'Tên Z-A'**
  String get friendSortNameZa;

  /// No description provided for @friendSortNewest.
  ///
  /// In vi, this message translates to:
  /// **'Mới nhất'**
  String get friendSortNewest;

  /// No description provided for @friendSortOldest.
  ///
  /// In vi, this message translates to:
  /// **'Cũ nhất'**
  String get friendSortOldest;

  /// No description provided for @friendSortOnline.
  ///
  /// In vi, this message translates to:
  /// **'Đang online'**
  String get friendSortOnline;

  /// No description provided for @friendSortRecent.
  ///
  /// In vi, this message translates to:
  /// **'Gần đây'**
  String get friendSortRecent;

  /// No description provided for @friendSuggestionsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý bạn bè'**
  String get friendSuggestionsTitle;

  /// No description provided for @friendTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get friendTitle;

  /// No description provided for @friendUnfriendConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn hủy kết bạn với {name}?'**
  String friendUnfriendConfirm(String name);

  /// No description provided for @friendUnfriendTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hủy kết bạn'**
  String get friendUnfriendTitle;

  /// No description provided for @friendUnfriendUser.
  ///
  /// In vi, this message translates to:
  /// **'Hủy kết bạn với {name}'**
  String friendUnfriendUser(String name);

  /// No description provided for @friendViewSentRequests.
  ///
  /// In vi, this message translates to:
  /// **'Xem lời mời đã gửi'**
  String get friendViewSentRequests;

  /// No description provided for @homeConnecting.
  ///
  /// In vi, this message translates to:
  /// **'Đang kết nối...'**
  String get homeConnecting;

  /// No description provided for @homeEndOfPosts.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã xem hết bài viết'**
  String get homeEndOfPosts;

  /// No description provided for @homeAddStory.
  ///
  /// In vi, this message translates to:
  /// **'Thêm tin'**
  String get homeAddStory;

  /// No description provided for @homeLoadPostsFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải bài viết'**
  String get homeLoadPostsFailed;

  /// No description provided for @monthName.
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month}'**
  String monthName(num month);

  /// No description provided for @notificationAdminNote.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú của quản trị viên'**
  String get notificationAdminNote;

  /// No description provided for @notificationApprove.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt'**
  String get notificationApprove;

  /// No description provided for @notificationApprovePostAction.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt bài'**
  String get notificationApprovePostAction;

  /// No description provided for @notificationApprovePostTitle.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt bài viết'**
  String get notificationApprovePostTitle;

  /// No description provided for @notificationCannotHandleInvite.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xử lý lời mời này'**
  String get notificationCannotHandleInvite;

  /// No description provided for @notificationCannotHandleJoinRequest.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xử lý yêu cầu tham gia này'**
  String get notificationCannotHandleJoinRequest;

  /// No description provided for @notificationCommentedOnYourPost.
  ///
  /// In vi, this message translates to:
  /// **'đã bình luận về bài viết của bạn:'**
  String get notificationCommentedOnYourPost;

  /// No description provided for @notificationCommunityJoinApprovedByAdmin.
  ///
  /// In vi, this message translates to:
  /// **'Admin đã chấp nhận yêu cầu tham gia cộng đồng'**
  String get notificationCommunityJoinApprovedByAdmin;

  /// No description provided for @notificationCommunityJoined.
  ///
  /// In vi, this message translates to:
  /// **'đã tham gia cộng đồng'**
  String get notificationCommunityJoined;

  /// No description provided for @notificationCommunityJoinRejectedByAdmin.
  ///
  /// In vi, this message translates to:
  /// **'Admin đã từ chối yêu cầu tham gia cộng đồng'**
  String get notificationCommunityJoinRejectedByAdmin;

  /// No description provided for @notificationCommunityJoinRequestSent.
  ///
  /// In vi, this message translates to:
  /// **'đã gửi yêu cầu tham gia cộng đồng'**
  String get notificationCommunityJoinRequestSent;

  /// No description provided for @notificationCommunityPostApprovedByAdmin.
  ///
  /// In vi, this message translates to:
  /// **'Admin đã duyệt bài viết của bạn trong cộng đồng'**
  String get notificationCommunityPostApprovedByAdmin;

  /// No description provided for @notificationCommunityPostRejectedByAdmin.
  ///
  /// In vi, this message translates to:
  /// **'Admin đã từ chối bài viết của bạn trong cộng đồng'**
  String get notificationCommunityPostRejectedByAdmin;

  /// No description provided for @notificationCommunityPostRequestSent.
  ///
  /// In vi, this message translates to:
  /// **'đã gửi yêu cầu đăng bài vào cộng đồng'**
  String get notificationCommunityPostRequestSent;

  /// No description provided for @notificationEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông báo nào'**
  String get notificationEmpty;

  /// No description provided for @notificationEndOfList.
  ///
  /// In vi, this message translates to:
  /// **'Đã xem hết thông báo'**
  String get notificationEndOfList;

  /// No description provided for @notificationExplanation.
  ///
  /// In vi, this message translates to:
  /// **'Giải thích'**
  String get notificationExplanation;

  /// No description provided for @notificationFaceTagSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Nhận diện {count} người trong ảnh của bạn. Gắn thẻ ngay!'**
  String notificationFaceTagSuggestions(int count);

  /// No description provided for @notificationFriendRequestMessage.
  ///
  /// In vi, this message translates to:
  /// **'đã gửi lời mời kết bạn'**
  String get notificationFriendRequestMessage;

  /// No description provided for @notificationInviteAccepted.
  ///
  /// In vi, this message translates to:
  /// **'Đã chấp nhận lời mời'**
  String get notificationInviteAccepted;

  /// No description provided for @notificationInviteFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xử lý lời mời'**
  String get notificationInviteFailed;

  /// No description provided for @notificationInviteMessage.
  ///
  /// In vi, this message translates to:
  /// **'đã mời bạn tham gia cộng đồng'**
  String get notificationInviteMessage;

  /// No description provided for @notificationInviteRejected.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối lời mời'**
  String get notificationInviteRejected;

  /// No description provided for @notificationJoinApprovedMessage.
  ///
  /// In vi, this message translates to:
  /// **'yêu cầu tham gia cộng đồng của bạn đã được chấp nhận'**
  String get notificationJoinApprovedMessage;

  /// No description provided for @notificationJoinRejectedMessage.
  ///
  /// In vi, this message translates to:
  /// **'yêu cầu tham gia cộng đồng của bạn đã bị từ chối'**
  String get notificationJoinRejectedMessage;

  /// No description provided for @notificationJoinRequestAccepted.
  ///
  /// In vi, this message translates to:
  /// **'Đã chấp nhận yêu cầu tham gia'**
  String get notificationJoinRequestAccepted;

  /// No description provided for @notificationJoinRequestFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xử lý yêu cầu tham gia'**
  String get notificationJoinRequestFailed;

  /// No description provided for @notificationJoinRequestMessage.
  ///
  /// In vi, this message translates to:
  /// **'muốn tham gia cộng đồng'**
  String get notificationJoinRequestMessage;

  /// No description provided for @notificationJoinRequestRejected.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối yêu cầu tham gia'**
  String get notificationJoinRequestRejected;

  /// No description provided for @notificationMentionedYouInComment.
  ///
  /// In vi, this message translates to:
  /// **'đã nhắc đến bạn trong một bình luận:'**
  String get notificationMentionedYouInComment;

  /// No description provided for @notificationNew.
  ///
  /// In vi, this message translates to:
  /// **'Mới'**
  String get notificationNew;

  /// No description provided for @notificationNewFriendRequest.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có lời mời kết bạn mới'**
  String get notificationNewFriendRequest;

  /// No description provided for @notificationOlder.
  ///
  /// In vi, this message translates to:
  /// **'Trước đó'**
  String get notificationOlder;

  /// No description provided for @notificationPendingPostNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bài viết đang chờ duyệt'**
  String get notificationPendingPostNotFound;

  /// No description provided for @notificationPostedWithYou.
  ///
  /// In vi, this message translates to:
  /// **'đã đăng một bài viết có mặt bạn'**
  String get notificationPostedWithYou;

  /// No description provided for @notificationPostApprovedMessage.
  ///
  /// In vi, this message translates to:
  /// **'bài viết của bạn đã được duyệt'**
  String get notificationPostApprovedMessage;

  /// No description provided for @notificationPostPendingMessage.
  ///
  /// In vi, this message translates to:
  /// **'đã gửi bài viết đang chờ duyệt'**
  String get notificationPostPendingMessage;

  /// No description provided for @notificationPostRejectedMessage.
  ///
  /// In vi, this message translates to:
  /// **'bài viết của bạn đã bị từ chối'**
  String get notificationPostRejectedMessage;

  /// No description provided for @notificationPostReportTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết báo cáo bài viết'**
  String get notificationPostReportTitle;

  /// No description provided for @notificationPublicJoinMessage.
  ///
  /// In vi, this message translates to:
  /// **'đã tham gia cộng đồng'**
  String get notificationPublicJoinMessage;

  /// No description provided for @notificationRefreshTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Tải lại thông báo'**
  String get notificationRefreshTooltip;

  /// No description provided for @notificationReactedToYourComment.
  ///
  /// In vi, this message translates to:
  /// **'đã thả cảm xúc về bình luận của bạn:'**
  String get notificationReactedToYourComment;

  /// No description provided for @notificationReactedToYourPost.
  ///
  /// In vi, this message translates to:
  /// **'đã bày tỏ cảm xúc về bài viết của bạn:'**
  String get notificationReactedToYourPost;

  /// No description provided for @notificationReactedToYourStory.
  ///
  /// In vi, this message translates to:
  /// **'đã bày tỏ cảm xúc về tin của bạn của bạn:'**
  String get notificationReactedToYourStory;

  /// No description provided for @notificationReportRejected.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo đã bị từ chối'**
  String get notificationReportRejected;

  /// No description provided for @notificationReportRejectedReason.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo không đủ điều kiện xử lý.'**
  String get notificationReportRejectedReason;

  /// No description provided for @notificationReportReviewed.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo đã được xử lý'**
  String get notificationReportReviewed;

  /// No description provided for @notificationReportReviewedReason.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo đã được quản trị viên xem xét.'**
  String get notificationReportReviewedReason;

  /// No description provided for @notificationReportStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái: {status}'**
  String notificationReportStatus(String status);

  /// No description provided for @notificationTaggedYouInPost.
  ///
  /// In vi, this message translates to:
  /// **'đã gắn thẻ bạn trong một bài viết'**
  String get notificationTaggedYouInPost;

  /// No description provided for @notificationTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notificationTitle;

  /// No description provided for @postAddCaptionHint.
  ///
  /// In vi, this message translates to:
  /// **'Thêm chú thích...'**
  String get postAddCaptionHint;

  /// No description provided for @postAddPhotoVideo.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ảnh/video'**
  String get postAddPhotoVideo;

  /// No description provided for @postAddToCollection.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào bộ sưu tập'**
  String get postAddToCollection;

  /// No description provided for @postAnd.
  ///
  /// In vi, this message translates to:
  /// **'và'**
  String get postAnd;

  /// No description provided for @postCamera.
  ///
  /// In vi, this message translates to:
  /// **'Camera'**
  String get postCamera;

  /// No description provided for @postShareCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{0 lượt chia sẻ} =1{1 lượt chia sẻ} other{{count} lượt chia sẻ}}'**
  String postShareCount(int count);

  /// No description provided for @postCameraErrorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi camera'**
  String get postCameraErrorTitle;

  /// No description provided for @postCameraInitFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể khởi tạo camera: {error}'**
  String postCameraInitFailed(String error);

  /// No description provided for @postCameraPermissionMessage.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng cấp quyền camera trong cài đặt để tiếp tục.'**
  String get postCameraPermissionMessage;

  /// No description provided for @postCameraPermissionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cần quyền camera'**
  String get postCameraPermissionTitle;

  /// No description provided for @postCannotAddPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Không thể thêm ảnh: {error}'**
  String postCannotAddPhoto(String error);

  /// No description provided for @postCheckIn.
  ///
  /// In vi, this message translates to:
  /// **'Check in'**
  String get postCheckIn;

  /// No description provided for @postChooseFolder.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thư mục'**
  String get postChooseFolder;

  /// No description provided for @postChooseLayout.
  ///
  /// In vi, this message translates to:
  /// **'Chọn bố cục'**
  String get postChooseLayout;

  /// No description provided for @postCollectionNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Tên bộ sưu tập'**
  String get postCollectionNameHint;

  /// No description provided for @postContentOrPhotoRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập nội dung hoặc thêm ảnh/video'**
  String get postContentOrPhotoRequired;

  /// No description provided for @postCreateCollectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo bộ sưu tập'**
  String get postCreateCollectionTitle;

  /// No description provided for @postCreateGenericError.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi khi tạo bài viết: {error}'**
  String postCreateGenericError(String error);

  /// No description provided for @postCreateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo bài viết'**
  String get postCreateTitle;

  /// No description provided for @postCreating.
  ///
  /// In vi, this message translates to:
  /// **'Đang tạo bài viết...'**
  String get postCreating;

  /// No description provided for @postCreatingWithProgress.
  ///
  /// In vi, this message translates to:
  /// **'Đang tạo bài viết... {progress}%'**
  String postCreatingWithProgress(num progress);

  /// No description provided for @postDeleteConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa bài viết này?'**
  String get postDeleteConfirmMessage;

  /// No description provided for @postDeleteFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xóa bài viết'**
  String get postDeleteFailed;

  /// No description provided for @postDeleteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bài viết'**
  String get postDeleteTitle;

  /// No description provided for @postDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa bài viết'**
  String get postDeleted;

  /// No description provided for @postEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get postEdit;

  /// No description provided for @postEditCount.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa ({count})'**
  String postEditCount(num count);

  /// No description provided for @postEditPrivacy.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa quyền riêng tư'**
  String get postEditPrivacy;

  /// No description provided for @privacyPostQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Ai có thể xem bài viết của bạn?'**
  String get privacyPostQuestion;

  /// No description provided for @privacyPostPublic.
  ///
  /// In vi, this message translates to:
  /// **'Công khai'**
  String get privacyPostPublic;

  /// No description provided for @privacyPostPublicDescription.
  ///
  /// In vi, this message translates to:
  /// **'Bất kỳ ai ở trên hoặc ngoài App'**
  String get privacyPostPublicDescription;

  /// No description provided for @privacyPostFriends.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get privacyPostFriends;

  /// No description provided for @privacyPostFriendsDescription.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè của bạn trên App'**
  String get privacyPostFriendsDescription;

  /// No description provided for @privacyPostFriendsExcept.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè ngoại trừ...'**
  String get privacyPostFriendsExcept;

  /// No description provided for @privacyPostFriendsExceptDescription.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn bài viết khỏi một số bạn bè'**
  String get privacyPostFriendsExceptDescription;

  /// No description provided for @privacyPostSpecificFriends.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè cụ thể'**
  String get privacyPostSpecificFriends;

  /// No description provided for @privacyPostSpecificFriendsDescription.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ hiển thị với một vài bạn'**
  String get privacyPostSpecificFriendsDescription;

  /// No description provided for @privacyPostOnlyMe.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ mình tôi'**
  String get privacyPostOnlyMe;

  /// No description provided for @privacyPostOnlyMeDescription.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ mình tôi'**
  String get privacyPostOnlyMeDescription;

  /// No description provided for @privacyPostEditDescription.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể thay đổi ai có thể xem bài viết này.'**
  String get privacyPostEditDescription;

  /// No description provided for @privacyPostCreateDescription.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết của bạn sẽ hiển thị trên Bảng feed, trang cá nhân và trong kết quả tìm kiếm.\n\nTùy đối tượng mặc định là {defaultPrivacy}, nhưng bạn có thể thay đổi đối tượng của riêng bài viết này.'**
  String privacyPostCreateDescription(String defaultPrivacy);

  /// No description provided for @privacyPostNoOneSelected.
  ///
  /// In vi, this message translates to:
  /// **'Chưa chọn ai'**
  String get privacyPostNoOneSelected;

  /// No description provided for @privacyPostOnePerson.
  ///
  /// In vi, this message translates to:
  /// **'1 người'**
  String get privacyPostOnePerson;

  /// No description provided for @privacyPostFallbackUser.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng'**
  String get privacyPostFallbackUser;

  /// No description provided for @privacyPostAndOthers.
  ///
  /// In vi, this message translates to:
  /// **'{firstNames} và {count} người khác'**
  String privacyPostAndOthers(String firstNames, num count);

  /// No description provided for @privacyPostHideFromTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn bài viết với'**
  String get privacyPostHideFromTitle;

  /// No description provided for @privacyPostSelectPeopleToShare.
  ///
  /// In vi, this message translates to:
  /// **'Chọn người để chia sẻ bài viết'**
  String get privacyPostSelectPeopleToShare;

  /// No description provided for @privacyPostCurrentDefault.
  ///
  /// In vi, this message translates to:
  /// **'Đây là đối tượng mặc định hiện tại'**
  String get privacyPostCurrentDefault;

  /// No description provided for @privacyPostSetAsDefault.
  ///
  /// In vi, this message translates to:
  /// **'Đặt làm đối tượng mặc định'**
  String get privacyPostSetAsDefault;

  /// No description provided for @privacyPostUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật quyền riêng tư'**
  String get privacyPostUpdated;

  /// No description provided for @privacyPostUpdateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật quyền riêng tư'**
  String get privacyPostUpdateFailed;

  /// No description provided for @postErrorPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi: {message}'**
  String postErrorPrefix(String message);

  /// No description provided for @postFeeling.
  ///
  /// In vi, this message translates to:
  /// **'Cảm xúc'**
  String get postFeeling;

  /// No description provided for @postFeelingActivity.
  ///
  /// In vi, this message translates to:
  /// **'Cảm xúc/Hoạt động'**
  String get postFeelingActivity;

  /// No description provided for @postGeneric.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết'**
  String get postGeneric;

  /// No description provided for @postGenericError.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi'**
  String get postGenericError;

  /// No description provided for @postHiddenFromProfile.
  ///
  /// In vi, this message translates to:
  /// **'Đã ẩn khỏi trang cá nhân'**
  String get postHiddenFromProfile;

  /// No description provided for @postHideAction.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn'**
  String get postHideAction;

  /// No description provided for @postHideFromProfileMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết này sẽ không hiển thị trên trang cá nhân của bạn.'**
  String get postHideFromProfileMessage;

  /// No description provided for @postHideFromProfileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn khỏi trang cá nhân'**
  String get postHideFromProfileTitle;

  /// No description provided for @postJustNow.
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get postJustNow;

  /// No description provided for @postLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết'**
  String get postLabel;

  /// No description provided for @postLayoutClassic.
  ///
  /// In vi, this message translates to:
  /// **'Cổ điển'**
  String get postLayoutClassic;

  /// No description provided for @postLayoutColumn.
  ///
  /// In vi, this message translates to:
  /// **'Cột'**
  String get postLayoutColumn;

  /// No description provided for @postLayoutFrame.
  ///
  /// In vi, this message translates to:
  /// **'Khung'**
  String get postLayoutFrame;

  /// No description provided for @postLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Thư viện'**
  String get postLibrary;

  /// No description provided for @postLiveVideo.
  ///
  /// In vi, this message translates to:
  /// **'Video trực tiếp'**
  String get postLiveVideo;

  /// No description provided for @postLoadingVideo.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải video...'**
  String get postLoadingVideo;

  /// No description provided for @postLocation.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí'**
  String get postLocation;

  /// No description provided for @postSelectImageForLocation.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn ảnh để gợi ý địa điểm'**
  String get postSelectImageForLocation;

  /// No description provided for @postLocationSuggestionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý check-in'**
  String get postLocationSuggestionTitle;

  /// No description provided for @postLocationSuggestionDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có muốn chia sẻ địa chỉ này trên bài viết không?'**
  String get postLocationSuggestionDesc;

  /// No description provided for @postAtLocation.
  ///
  /// In vi, this message translates to:
  /// **'tại'**
  String get postAtLocation;

  /// No description provided for @postMediaItemCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{0 mục} =1{1 mục} other{{count} mục}}'**
  String postMediaItemCount(num count);

  /// No description provided for @postMention.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc đến'**
  String get postMention;

  /// No description provided for @postMore.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get postMore;

  /// No description provided for @postMusic.
  ///
  /// In vi, this message translates to:
  /// **'Âm nhạc'**
  String get postMusic;

  /// No description provided for @postMutualFriends.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{Không có bạn chung} =1{1 bạn chung} other{{count} bạn chung}}'**
  String postMutualFriends(num count);

  /// No description provided for @postNoComments.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bình luận'**
  String get postNoComments;

  /// No description provided for @postNoReactions.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lượt bày tỏ cảm xúc'**
  String get postNoReactions;

  /// No description provided for @postNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bài viết'**
  String get postNotFound;

  /// No description provided for @postOnlyMe.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ mình tôi'**
  String get postOnlyMe;

  /// No description provided for @postOtherPeople.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =1{1 người khác} other{{count} người khác}}'**
  String postOtherPeople(num count);

  /// No description provided for @postPeopleReactedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Những người đã bày tỏ cảm xúc'**
  String get postPeopleReactedTitle;

  /// No description provided for @postPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh'**
  String get postPhoto;

  /// No description provided for @postPhotoLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Thư viện ảnh'**
  String get postPhotoLibrary;

  /// No description provided for @postPhotoPermissionRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng cấp quyền truy cập ảnh để tiếp tục.'**
  String get postPhotoPermissionRequired;

  /// No description provided for @postPhotoVideo.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh/Video'**
  String get postPhotoVideo;

  /// No description provided for @postPlayVideoFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể phát video: {error}'**
  String postPlayVideoFailed(String error);

  /// No description provided for @postPoll.
  ///
  /// In vi, this message translates to:
  /// **'Thăm dò ý kiến'**
  String get postPoll;

  /// No description provided for @postReactedFirstUserAndOthers.
  ///
  /// In vi, this message translates to:
  /// **'{firstUser} và {count, plural, =1{1 người khác} other{{count} người khác}}'**
  String postReactedFirstUserAndOthers(String firstUser, num count);

  /// No description provided for @postReactedYouAndOthers.
  ///
  /// In vi, this message translates to:
  /// **'Bạn và {count, plural, =1{1 người khác} other{{count} người khác}}'**
  String postReactedYouAndOthers(num count);

  /// No description provided for @postRecording.
  ///
  /// In vi, this message translates to:
  /// **'Đang quay'**
  String get postRecording;

  /// No description provided for @postRemoveTagAction.
  ///
  /// In vi, this message translates to:
  /// **'Gỡ thẻ'**
  String get postRemoveTagAction;

  /// No description provided for @postRemoveTagConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn gỡ thẻ khỏi bài viết này?'**
  String get postRemoveTagConfirmMessage;

  /// No description provided for @postRemoveTagTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gỡ thẻ'**
  String get postRemoveTagTitle;

  /// No description provided for @postRemovedTag.
  ///
  /// In vi, this message translates to:
  /// **'Đã gỡ thẻ'**
  String get postRemovedTag;

  /// No description provided for @postReport.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo'**
  String get postReport;

  /// No description provided for @postReportDescriptionHint.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả thêm về vấn đề'**
  String get postReportDescriptionHint;

  /// No description provided for @postReportDescriptionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả'**
  String get postReportDescriptionLabel;

  /// No description provided for @postReportDetailReason.
  ///
  /// In vi, this message translates to:
  /// **'Lý do chi tiết'**
  String get postReportDetailReason;

  /// No description provided for @postReportFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi báo cáo'**
  String get postReportFailed;

  /// No description provided for @postReportIntro.
  ///
  /// In vi, this message translates to:
  /// **'Hãy chọn lý do phù hợp để chúng tôi xem xét bài viết này.'**
  String get postReportIntro;

  /// No description provided for @postReportQuickReason.
  ///
  /// In vi, this message translates to:
  /// **'Lý do nhanh'**
  String get postReportQuickReason;

  /// No description provided for @postReportReasonHarassment.
  ///
  /// In vi, this message translates to:
  /// **'Quấy rối hoặc bắt nạt'**
  String get postReportReasonHarassment;

  /// No description provided for @postReportReasonHint.
  ///
  /// In vi, this message translates to:
  /// **'Chọn lý do'**
  String get postReportReasonHint;

  /// No description provided for @postReportReasonMisinformation.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin sai lệch'**
  String get postReportReasonMisinformation;

  /// No description provided for @postReportReasonOffensive.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung phản cảm'**
  String get postReportReasonOffensive;

  /// No description provided for @postReportReasonRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn lý do báo cáo'**
  String get postReportReasonRequired;

  /// No description provided for @postReportReasonSpam.
  ///
  /// In vi, this message translates to:
  /// **'Spam'**
  String get postReportReasonSpam;

  /// No description provided for @postReportReasonViolence.
  ///
  /// In vi, this message translates to:
  /// **'Bạo lực hoặc nguy hiểm'**
  String get postReportReasonViolence;

  /// No description provided for @postReportSelfNotAllowed.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không thể báo cáo bài viết của chính mình'**
  String get postReportSelfNotAllowed;

  /// No description provided for @postReportSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi báo cáo'**
  String get postReportSuccess;

  /// No description provided for @postReportTitle.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo bài viết'**
  String get postReportTitle;

  /// No description provided for @postSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get postSave;

  /// No description provided for @postSaveFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu bài viết'**
  String get postSaveFailed;

  /// No description provided for @postSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu'**
  String get postSaved;

  /// No description provided for @postSavedToCollection.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu vào {collection}'**
  String postSavedToCollection(String collection);

  /// No description provided for @postSeeOriginal.
  ///
  /// In vi, this message translates to:
  /// **'Xem bản gốc'**
  String get postSeeOriginal;

  /// No description provided for @postSeeTranslation.
  ///
  /// In vi, this message translates to:
  /// **'Xem bản dịch'**
  String get postSeeTranslation;

  /// No description provided for @postSelectAllowedFriendsRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn bạn bè được phép xem'**
  String get postSelectAllowedFriendsRequired;

  /// No description provided for @postSelectHiddenFriendsRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn bạn bè muốn ẩn'**
  String get postSelectHiddenFriendsRequired;

  /// No description provided for @postSelectedPhotos.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{Chưa chọn ảnh} =1{1 ảnh đã chọn} other{{count} ảnh đã chọn}}'**
  String postSelectedPhotos(num count);

  /// No description provided for @postSendReport.
  ///
  /// In vi, this message translates to:
  /// **'Gửi báo cáo'**
  String get postSendReport;

  /// No description provided for @postShare.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ'**
  String get postShare;

  /// No description provided for @postShowAction.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị'**
  String get postShowAction;

  /// No description provided for @postShowOnProfileMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết này sẽ hiển thị trên trang cá nhân của bạn.'**
  String get postShowOnProfileMessage;

  /// No description provided for @postShowOnProfileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị trên trang cá nhân'**
  String get postShowOnProfileTitle;

  /// No description provided for @postShownOnProfile.
  ///
  /// In vi, this message translates to:
  /// **'Đã hiển thị trên trang cá nhân'**
  String get postShownOnProfile;

  /// No description provided for @postSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Đăng'**
  String get postSubmit;

  /// No description provided for @postTag.
  ///
  /// In vi, this message translates to:
  /// **'Gắn thẻ'**
  String get postTag;

  /// No description provided for @postTagFriends.
  ///
  /// In vi, this message translates to:
  /// **'Gắn thẻ bạn bè'**
  String get postTagFriends;

  /// No description provided for @postTagPeople.
  ///
  /// In vi, this message translates to:
  /// **'Gắn thẻ người khác'**
  String get postTagPeople;

  /// No description provided for @postTagUpdateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật thẻ'**
  String get postTagUpdateFailed;

  /// No description provided for @postTagUpdateFailedWithMessage.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật thẻ: {message}'**
  String postTagUpdateFailedWithMessage(String message);

  /// No description provided for @postTagUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật thẻ'**
  String get postTagUpdated;

  /// No description provided for @postTranslateError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể dịch nội dung'**
  String get postTranslateError;

  /// No description provided for @postTranslateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Dịch thất bại'**
  String get postTranslateFailed;

  /// No description provided for @postUnknownTime.
  ///
  /// In vi, this message translates to:
  /// **'Không rõ thời gian'**
  String get postUnknownTime;

  /// No description provided for @postUnsave.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ lưu'**
  String get postUnsave;

  /// No description provided for @postUnsaveSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã bỏ lưu bài viết'**
  String get postUnsaveSuccess;

  /// No description provided for @postUnsupportedVideoType.
  ///
  /// In vi, this message translates to:
  /// **'Định dạng video không được hỗ trợ'**
  String get postUnsupportedVideoType;

  /// No description provided for @postVideo.
  ///
  /// In vi, this message translates to:
  /// **'Video'**
  String get postVideo;

  /// No description provided for @postViewAllComments.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả {count, plural, =1{1 bình luận} other{{count} bình luận}}'**
  String postViewAllComments(num count);

  /// No description provided for @postWith.
  ///
  /// In vi, this message translates to:
  /// **'cùng'**
  String get postWith;

  /// No description provided for @postWriteSomethingHint.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang nghĩ gì?'**
  String get postWriteSomethingHint;

  /// No description provided for @postYourPost.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết của bạn'**
  String get postYourPost;

  /// No description provided for @commonCopy.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép'**
  String get commonCopy;

  /// No description provided for @commonContentCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép nội dung'**
  String get commonContentCopied;

  /// No description provided for @commonEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get commonEdit;

  /// No description provided for @commonLinkCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép liên kết'**
  String get commonLinkCopied;

  /// No description provided for @commonRemove.
  ///
  /// In vi, this message translates to:
  /// **'Gỡ'**
  String get commonRemove;

  /// No description provided for @commonSeeMore.
  ///
  /// In vi, this message translates to:
  /// **'Xem thêm'**
  String get commonSeeMore;

  /// No description provided for @commonSendWithCount.
  ///
  /// In vi, this message translates to:
  /// **'Gửi ({count})'**
  String commonSendWithCount(num count);

  /// No description provided for @commonUpdate.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật'**
  String get commonUpdate;

  /// No description provided for @commonViewAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get commonViewAll;

  /// No description provided for @searchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get searchHint;

  /// No description provided for @searchUserHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm người dùng...'**
  String get searchUserHint;

  /// No description provided for @searchEnterKeyword.
  ///
  /// In vi, this message translates to:
  /// **'Nhập từ khóa để tìm kiếm'**
  String get searchEnterKeyword;

  /// No description provided for @searchNoResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy kết quả nào'**
  String get searchNoResults;

  /// No description provided for @searchRecent.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm gần đây'**
  String get searchRecent;

  /// No description provided for @searchHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get searchHistory;

  /// No description provided for @searchNoHistory.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch sử tìm kiếm'**
  String get searchNoHistory;

  /// No description provided for @searchNoRecent.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tìm kiếm gần đây'**
  String get searchNoRecent;

  /// No description provided for @searchClearAll.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tất cả'**
  String get searchClearAll;

  /// No description provided for @searchClearAllUppercase.
  ///
  /// In vi, this message translates to:
  /// **'XÓA TẤT CẢ'**
  String get searchClearAllUppercase;

  /// No description provided for @searchClearAllHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tất cả lịch sử tìm kiếm'**
  String get searchClearAllHistoryTitle;

  /// No description provided for @searchClearAllHistoryConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xóa tất cả lịch sử tìm kiếm? Hành động này không thể hoàn tác.'**
  String get searchClearAllHistoryConfirm;

  /// No description provided for @searchClearAllHistoryConfirmShort.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xóa tất cả lịch sử tìm kiếm?'**
  String get searchClearAllHistoryConfirmShort;

  /// No description provided for @searchEditHistory.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa lịch sử tìm kiếm'**
  String get searchEditHistory;

  /// No description provided for @searchHistoryLocalOnlyDescription.
  ///
  /// In vi, this message translates to:
  /// **'Các chi tiết thay đổi sẽ chỉ áp dụng cho danh sách tìm kiếm gần đây, thuộc phần lịch sử trên thiết bị này.'**
  String get searchHistoryLocalOnlyDescription;

  /// No description provided for @searchHistoryWillAppear.
  ///
  /// In vi, this message translates to:
  /// **'Các tìm kiếm gần đây sẽ xuất hiện ở đây'**
  String get searchHistoryWillAppear;

  /// No description provided for @searchRemoveFromHistory.
  ///
  /// In vi, this message translates to:
  /// **'Gỡ khỏi lịch sử tìm kiếm của bạn.'**
  String get searchRemoveFromHistory;

  /// No description provided for @searchPinThis.
  ///
  /// In vi, this message translates to:
  /// **'Ghim nội dung tìm kiếm này'**
  String get searchPinThis;

  /// No description provided for @searchPinLimit.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chỉ có thể ghim 3 nội dung tìm kiếm cùng lúc.'**
  String get searchPinLimit;

  /// No description provided for @friendNoSearchResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bạn bè'**
  String get friendNoSearchResults;

  /// No description provided for @friendLoadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi tải danh sách bạn bè'**
  String get friendLoadFailed;

  /// No description provided for @commentReply.
  ///
  /// In vi, this message translates to:
  /// **'Trả lời'**
  String get commentReply;

  /// No description provided for @commentViewReplies.
  ///
  /// In vi, this message translates to:
  /// **'Xem {count, plural, =1{1 phản hồi} other{{count} phản hồi}}'**
  String commentViewReplies(int count);

  /// No description provided for @commentEditTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa bình luận'**
  String get commentEditTitle;

  /// No description provided for @commentEditHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập nội dung mới...'**
  String get commentEditHint;

  /// No description provided for @commentDeleteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bình luận'**
  String get commentDeleteTitle;

  /// No description provided for @commentDeleteConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xóa vĩnh viễn bình luận này không?'**
  String get commentDeleteConfirm;

  /// No description provided for @commentViewEditHistory.
  ///
  /// In vi, this message translates to:
  /// **'Xem lịch sử chỉnh sửa'**
  String get commentViewEditHistory;

  /// No description provided for @commentShare.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ bình luận'**
  String get commentShare;

  /// No description provided for @commentReactionsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Biểu cảm về bình luận'**
  String get commentReactionsTitle;

  /// No description provided for @commentEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bình luận nào'**
  String get commentEmptyTitle;

  /// No description provided for @commentEmptySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hãy là người đầu tiên bình luận về bài viết này'**
  String get commentEmptySubtitle;

  /// No description provided for @commentWriteFirst.
  ///
  /// In vi, this message translates to:
  /// **'Viết bình luận đầu tiên'**
  String get commentWriteFirst;

  /// No description provided for @commentReplyingPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Đang trả lời '**
  String get commentReplyingPrefix;

  /// No description provided for @commentYourComment.
  ///
  /// In vi, this message translates to:
  /// **'bình luận của bạn'**
  String get commentYourComment;

  /// No description provided for @commentWriteReplyHint.
  ///
  /// In vi, this message translates to:
  /// **'Viết phản hồi...'**
  String get commentWriteReplyHint;

  /// No description provided for @commentReplyToHint.
  ///
  /// In vi, this message translates to:
  /// **'Trả lời {user}...'**
  String commentReplyToHint(String user);

  /// No description provided for @commentWriteHint.
  ///
  /// In vi, this message translates to:
  /// **'Viết bình luận...'**
  String get commentWriteHint;

  /// No description provided for @commentEditHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử chỉnh sửa'**
  String get commentEditHistoryTitle;

  /// No description provided for @commentNoEditHistory.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch sử chỉnh sửa'**
  String get commentNoEditHistory;

  /// No description provided for @commentCurrentVersion.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản hiện tại'**
  String get commentCurrentVersion;

  /// No description provided for @commentEditVersion.
  ///
  /// In vi, this message translates to:
  /// **'Lần chỉnh sửa {version} • {time}'**
  String commentEditVersion(num version, String time);

  /// No description provided for @commentOldContent.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung cũ'**
  String get commentOldContent;

  /// No description provided for @commentNewContent.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung mới'**
  String get commentNewContent;

  /// No description provided for @storyPrivacyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quyền riêng tư của tin'**
  String get storyPrivacyTitle;

  /// No description provided for @storyPrivacyQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Ai có thể xem tin của bạn?'**
  String get storyPrivacyQuestion;

  /// No description provided for @storyPrivacyVisibleFor24h.
  ///
  /// In vi, this message translates to:
  /// **'Tin của bạn sẽ hiển thị trong 24 giờ.'**
  String get storyPrivacyVisibleFor24h;

  /// No description provided for @storyPrivacyPublic.
  ///
  /// In vi, this message translates to:
  /// **'Công khai'**
  String get storyPrivacyPublic;

  /// No description provided for @storyPrivacyPublicDescription.
  ///
  /// In vi, this message translates to:
  /// **'Bất kỳ ai'**
  String get storyPrivacyPublicDescription;

  /// No description provided for @storyPrivacyFriends.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get storyPrivacyFriends;

  /// No description provided for @storyPrivacyFriendsDescription.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ bạn bè của bạn'**
  String get storyPrivacyFriendsDescription;

  /// No description provided for @storyPrivacyHideFrom.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn tin với'**
  String get storyPrivacyHideFrom;

  /// No description provided for @storyPrivacyCustom.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chỉnh'**
  String get storyPrivacyCustom;

  /// No description provided for @storyPrivacyNoOneSelected.
  ///
  /// In vi, this message translates to:
  /// **'Chưa chọn ai'**
  String get storyPrivacyNoOneSelected;

  /// No description provided for @storyPrivacyOnePerson.
  ///
  /// In vi, this message translates to:
  /// **'1 người'**
  String get storyPrivacyOnePerson;

  /// No description provided for @storyPrivacyAndOthers.
  ///
  /// In vi, this message translates to:
  /// **'{firstNames} và {count} người khác'**
  String storyPrivacyAndOthers(String firstNames, num count);

  /// No description provided for @storySelectPeopleToShare.
  ///
  /// In vi, this message translates to:
  /// **'Chọn người để chia sẻ tin'**
  String get storySelectPeopleToShare;

  /// No description provided for @storyPrivacyUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật quyền riêng tư'**
  String get storyPrivacyUpdated;

  /// No description provided for @storyPrivacyUpdateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật quyền riêng tư'**
  String get storyPrivacyUpdateFailed;

  /// No description provided for @storyDeleteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tin'**
  String get storyDeleteTitle;

  /// No description provided for @storyDeleteConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xóa tin này không?'**
  String get storyDeleteConfirm;

  /// No description provided for @storyDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa tin'**
  String get storyDeleted;

  /// No description provided for @storyDeleteFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xóa tin'**
  String get storyDeleteFailed;

  /// No description provided for @storyEditPrivacy.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa quyền riêng tư của tin'**
  String get storyEditPrivacy;

  /// No description provided for @storySendWithMessenger.
  ///
  /// In vi, this message translates to:
  /// **'Gửi bằng Messenger'**
  String get storySendWithMessenger;

  /// No description provided for @storySavePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ảnh'**
  String get storySavePhoto;

  /// No description provided for @storyArchivePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ ảnh'**
  String get storyArchivePhoto;

  /// No description provided for @storyArchivePhotoDescription.
  ///
  /// In vi, this message translates to:
  /// **'Gỡ ảnh khỏi tin và lưu vào kho lưu trữ.'**
  String get storyArchivePhotoDescription;

  /// No description provided for @storyArchiveTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ tin'**
  String get storyArchiveTitle;

  /// No description provided for @storyArchiveConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn lưu trữ tin này không? Tin sẽ được lưu vào kho lưu trữ và không còn hiển thị với người khác.'**
  String get storyArchiveConfirm;

  /// No description provided for @storyArchived.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu trữ tin'**
  String get storyArchived;

  /// No description provided for @storyArchiveFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu trữ tin'**
  String get storyArchiveFailed;

  /// No description provided for @storyDeletePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Xóa ảnh'**
  String get storyDeletePhoto;

  /// No description provided for @storyCopyShareLink.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép liên kết để chia sẻ tin này'**
  String get storyCopyShareLink;

  /// No description provided for @storyLinkVisibility.
  ///
  /// In vi, this message translates to:
  /// **'Tin sẽ hiển thị với đối tượng của {user} trong 24 giờ.'**
  String storyLinkVisibility(String user);

  /// No description provided for @storyArchivePageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tin lưu trữ'**
  String get storyArchivePageTitle;

  /// No description provided for @storyNoArchivedStories.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tin lưu trữ nào'**
  String get storyNoArchivedStories;

  /// No description provided for @storyDefaultName.
  ///
  /// In vi, this message translates to:
  /// **'Tin {number}'**
  String storyDefaultName(String number);

  /// No description provided for @storySendReplyHint.
  ///
  /// In vi, this message translates to:
  /// **'Gửi tin nhắn...'**
  String get storySendReplyHint;

  /// No description provided for @storyReplySent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi phản hồi tin'**
  String get storyReplySent;

  /// No description provided for @storyReplyErrorPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi: {error}'**
  String storyReplyErrorPrefix(String error);

  /// No description provided for @storyMusic.
  ///
  /// In vi, this message translates to:
  /// **'Nhạc'**
  String get storyMusic;

  /// No description provided for @storyMusicLoadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được danh sách nhạc. Vui lòng thử lại.'**
  String get storyMusicLoadFailed;

  /// No description provided for @storyMusicSearchFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy kết quả. Vui lòng thử lại.'**
  String get storyMusicSearchFailed;

  /// No description provided for @storyMusicForYou.
  ///
  /// In vi, this message translates to:
  /// **'Dành cho bạn'**
  String get storyMusicForYou;

  /// No description provided for @storyMusicSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm nhạc'**
  String get storyMusicSearchHint;

  /// No description provided for @storyMusicNoSearchResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bài hát phù hợp.'**
  String get storyMusicNoSearchResults;

  /// No description provided for @storyMusicEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Không có bài hát nào.'**
  String get storyMusicEmpty;

  /// No description provided for @storyCreateSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tin thành công'**
  String get storyCreateSuccess;

  /// No description provided for @storyImageOnlyEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ có thể chỉnh sửa ảnh'**
  String get storyImageOnlyEdit;

  /// No description provided for @storyCannotReadDeviceFile.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đọc file từ thiết bị'**
  String get storyCannotReadDeviceFile;

  /// No description provided for @storyImageEditFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi chỉnh sửa ảnh: {error}'**
  String storyImageEditFailed(String error);

  /// No description provided for @storyText.
  ///
  /// In vi, this message translates to:
  /// **'Văn bản'**
  String get storyText;

  /// No description provided for @storyPhotoGroup.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm ảnh'**
  String get storyPhotoGroup;

  /// No description provided for @storySelectMultipleFiles.
  ///
  /// In vi, this message translates to:
  /// **'Chọn nhiều file'**
  String get storySelectMultipleFiles;

  /// No description provided for @storyLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Thư viện'**
  String get storyLibrary;

  /// No description provided for @storyChooseFolder.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thư mục'**
  String get storyChooseFolder;

  /// No description provided for @storyItemCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} mục'**
  String storyItemCount(num count);

  /// No description provided for @storyLibraryPermissionRequired.
  ///
  /// In vi, this message translates to:
  /// **'Cần quyền truy cập thư viện để hiển thị ảnh/video.'**
  String get storyLibraryPermissionRequired;

  /// No description provided for @storyNoMediaInLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ảnh/video trong thư viện.'**
  String get storyNoMediaInLibrary;

  /// No description provided for @storyReactedPeople.
  ///
  /// In vi, this message translates to:
  /// **'Người đã bày tỏ cảm xúc'**
  String get storyReactedPeople;

  /// No description provided for @storyNoReactions.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có phản ứng nào'**
  String get storyNoReactions;

  /// No description provided for @chatMessageHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhắn tin...'**
  String get chatMessageHint;

  /// No description provided for @chatShareFile.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ file'**
  String get chatShareFile;

  /// No description provided for @chatAiImages.
  ///
  /// In vi, this message translates to:
  /// **'Hình ảnh AI'**
  String get chatAiImages;

  /// No description provided for @chatAiImagesInDevelopmentMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng Hình ảnh AI đang phát triển'**
  String get chatAiImagesInDevelopmentMessage;

  /// No description provided for @chatMembersCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =1{1 thành viên} other{{count} thành viên}}'**
  String chatMembersCount(int count);

  /// No description provided for @chatGroupChat.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm chat'**
  String get chatGroupChat;

  /// No description provided for @chatOnline.
  ///
  /// In vi, this message translates to:
  /// **'Đang online'**
  String get chatOnline;

  /// No description provided for @chatOffline.
  ///
  /// In vi, this message translates to:
  /// **'Ngoại tuyến'**
  String get chatOffline;

  /// No description provided for @chatActiveNow.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get chatActiveNow;

  /// No description provided for @chatAndOtherMembers.
  ///
  /// In vi, this message translates to:
  /// **'và {count, plural, =1{1 người khác} other{{count} người khác}}'**
  String chatAndOtherMembers(int count);

  /// No description provided for @chatViewGroupInfo.
  ///
  /// In vi, this message translates to:
  /// **'Xem thông tin nhóm'**
  String get chatViewGroupInfo;

  /// No description provided for @chatViewProfile.
  ///
  /// In vi, this message translates to:
  /// **'Xem trang cá nhân'**
  String get chatViewProfile;

  /// No description provided for @chatFriendsOnFacebook.
  ///
  /// In vi, this message translates to:
  /// **'Các bạn là bạn bè trên Facebook'**
  String get chatFriendsOnFacebook;

  /// No description provided for @chatYouAndFriendAreFriends.
  ///
  /// In vi, this message translates to:
  /// **'Bạn và {name} hiện đã là bạn bè.'**
  String chatYouAndFriendAreFriends(String name);

  /// No description provided for @chatThisFriend.
  ///
  /// In vi, this message translates to:
  /// **'bạn này'**
  String get chatThisFriend;

  /// No description provided for @voiceEffectTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa giọng nói'**
  String get voiceEffectTitle;

  /// No description provided for @voiceEffectLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang chuyển giọng, vui lòng đợi...'**
  String get voiceEffectLoading;

  /// No description provided for @voiceEffectApplied.
  ///
  /// In vi, this message translates to:
  /// **'Đã áp dụng giọng: {voice}'**
  String voiceEffectApplied(String voice);

  /// No description provided for @voiceEffectOriginal.
  ///
  /// In vi, this message translates to:
  /// **'Gốc'**
  String get voiceEffectOriginal;

  /// No description provided for @voiceEffectFemale.
  ///
  /// In vi, this message translates to:
  /// **'Con gái'**
  String get voiceEffectFemale;

  /// No description provided for @voiceEffectDeep.
  ///
  /// In vi, this message translates to:
  /// **'Trầm'**
  String get voiceEffectDeep;

  /// No description provided for @voiceEffectBaby.
  ///
  /// In vi, this message translates to:
  /// **'Em bé'**
  String get voiceEffectBaby;

  /// No description provided for @voiceEffectRobot.
  ///
  /// In vi, this message translates to:
  /// **'Robot'**
  String get voiceEffectRobot;

  /// No description provided for @voiceEffectDemon.
  ///
  /// In vi, this message translates to:
  /// **'Ác quỷ'**
  String get voiceEffectDemon;

  /// No description provided for @chatGroupLink.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết nhóm'**
  String get chatGroupLink;

  /// No description provided for @chatDeleteChat.
  ///
  /// In vi, this message translates to:
  /// **'Xóa đoạn chat'**
  String get chatDeleteChat;

  /// No description provided for @chatConversationInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin về đoạn chat'**
  String get chatConversationInfo;

  /// No description provided for @chatViewGroupMembers.
  ///
  /// In vi, this message translates to:
  /// **'Xem thành viên trong nhóm'**
  String get chatViewGroupMembers;

  /// No description provided for @chatLeaveConversation.
  ///
  /// In vi, this message translates to:
  /// **'Rời khỏi đoạn chat'**
  String get chatLeaveConversation;

  /// No description provided for @chatFeedbackAndReportConversation.
  ///
  /// In vi, this message translates to:
  /// **'Góp ý và báo cáo cuộc trò chuyện'**
  String get chatFeedbackAndReportConversation;

  /// No description provided for @chatReadReceipts.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo đã đọc'**
  String get chatReadReceipts;

  /// No description provided for @chatTypingIndicators.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ báo đang nhập'**
  String get chatTypingIndicators;

  /// No description provided for @chatMicrophonePermissionDenied.
  ///
  /// In vi, this message translates to:
  /// **'Không có quyền truy cập microphone'**
  String get chatMicrophonePermissionDenied;

  /// No description provided for @chatStartRecordingFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi bắt đầu ghi âm'**
  String get chatStartRecordingFailed;

  /// No description provided for @chatDownloadingFile.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải file...'**
  String get chatDownloadingFile;

  /// No description provided for @chatNoAppToOpenFile.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy ứng dụng để mở file này'**
  String get chatNoAppToOpenFile;

  /// No description provided for @chatOpenFileFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể mở file: {error}'**
  String chatOpenFileFailed(String error);

  /// No description provided for @chatLoadingEditHistory.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải lịch sử chỉnh sửa...'**
  String get chatLoadingEditHistory;

  /// No description provided for @chatPinInDevelopment.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng ghim tin nhắn đang phát triển'**
  String get chatPinInDevelopment;

  /// No description provided for @chatForwardInDevelopment.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng chuyển tiếp đang phát triển'**
  String get chatForwardInDevelopment;

  /// No description provided for @chatReportInDevelopment.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng báo cáo tin nhắn đang phát triển'**
  String get chatReportInDevelopment;

  /// No description provided for @chatAiImageInDevelopment.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng tạo hình ảnh AI đang phát triển'**
  String get chatAiImageInDevelopment;

  /// No description provided for @chatMissingConversationForReaction.
  ///
  /// In vi, this message translates to:
  /// **'Không thể thêm reaction: thiếu conversation ID'**
  String get chatMissingConversationForReaction;

  /// No description provided for @chatMessageCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép tin nhắn'**
  String get chatMessageCopied;

  /// No description provided for @chatGpsDisabledOpeningSettings.
  ///
  /// In vi, this message translates to:
  /// **'GPS đang tắt. Đang mở Cài đặt định vị...'**
  String get chatGpsDisabledOpeningSettings;

  /// No description provided for @chatLocationPermissionDenied.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa cấp quyền truy cập vị trí.'**
  String get chatLocationPermissionDenied;

  /// No description provided for @chatLocationPermissionDeniedForever.
  ///
  /// In vi, this message translates to:
  /// **'Quyền vị trí bị từ chối vĩnh viễn. Đang mở Cài đặt ứng dụng...'**
  String get chatLocationPermissionDeniedForever;

  /// No description provided for @chatSendLocationMessage.
  ///
  /// In vi, this message translates to:
  /// **'Gửi vị trí'**
  String get chatSendLocationMessage;

  /// No description provided for @chatCurrentLocation.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí hiện tại'**
  String get chatCurrentLocation;

  /// No description provided for @chatGetLocationFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lấy vị trí: {error}'**
  String chatGetLocationFailed(String error);

  /// No description provided for @chatSendingFile.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi file...'**
  String get chatSendingFile;

  /// No description provided for @chatPhotoPermissionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quyền truy cập ảnh'**
  String get chatPhotoPermissionTitle;

  /// No description provided for @chatPhotoPermissionMessage.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng cần quyền truy cập ảnh để hiển thị ảnh từ thư viện. Vui lòng cấp quyền trong Cài đặt.'**
  String get chatPhotoPermissionMessage;

  /// No description provided for @chatPhotoPermissionRequired.
  ///
  /// In vi, this message translates to:
  /// **'Cần quyền truy cập ảnh để hiển thị thư viện'**
  String get chatPhotoPermissionRequired;

  /// No description provided for @chatLoadPhotosFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi tải ảnh: {error}'**
  String chatLoadPhotosFailed(String error);

  /// No description provided for @chatCameraPermissionMessage.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng cần quyền truy cập camera để chụp ảnh.'**
  String get chatCameraPermissionMessage;

  /// No description provided for @chatOpenCameraFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi mở camera: {error}'**
  String chatOpenCameraFailed(String error);

  /// No description provided for @chatCapturedPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh vừa chụp'**
  String get chatCapturedPhoto;

  /// No description provided for @chatTapSendToShare.
  ///
  /// In vi, this message translates to:
  /// **'Nhấn gửi để chia sẻ'**
  String get chatTapSendToShare;

  /// No description provided for @chatMissingConversationForPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi ảnh: thiếu conversation ID'**
  String get chatMissingConversationForPhoto;

  /// No description provided for @chatSendPhotoFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi gửi ảnh: {error}'**
  String chatSendPhotoFailed(String error);

  /// No description provided for @chatCannotProcessPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xử lý ảnh'**
  String get chatCannotProcessPhoto;

  /// No description provided for @chatMissingConversationForFile.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi file: thiếu conversation ID'**
  String get chatMissingConversationForFile;

  /// No description provided for @chatPickFileFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi chọn file: {error}'**
  String chatPickFileFailed(String error);

  /// No description provided for @chatStartCallFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể thực hiện cuộc gọi: {error}'**
  String chatStartCallFailed(String error);

  /// No description provided for @chatCreateConversationFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tạo cuộc trò chuyện: {message}'**
  String chatCreateConversationFailed(String message);

  /// No description provided for @chatDeletedForEveryone.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa tin nhắn cho mọi người'**
  String get chatDeletedForEveryone;

  /// No description provided for @chatDeletedForMe.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa tin nhắn cho tôi'**
  String get chatDeletedForMe;

  /// No description provided for @chatOriginalMessageNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy tin nhắn gốc'**
  String get chatOriginalMessageNotFound;

  /// No description provided for @chatLoadMessagesFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi tải tin nhắn: {message}'**
  String chatLoadMessagesFailed(String message);

  /// No description provided for @chatMessagePlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'[Tin nhắn]'**
  String get chatMessagePlaceholder;

  /// No description provided for @chatMyself.
  ///
  /// In vi, this message translates to:
  /// **'chính mình'**
  String get chatMyself;

  /// No description provided for @chatReplyingTo.
  ///
  /// In vi, this message translates to:
  /// **'Trả lời {name}'**
  String chatReplyingTo(String name);

  /// No description provided for @chatAudioMessage.
  ///
  /// In vi, this message translates to:
  /// **'[Tin nhắn thoại]'**
  String get chatAudioMessage;

  /// No description provided for @chatPhoto.
  ///
  /// In vi, this message translates to:
  /// **'[Ảnh]'**
  String get chatPhoto;

  /// No description provided for @chatFile.
  ///
  /// In vi, this message translates to:
  /// **'[Tệp tin]'**
  String get chatFile;

  /// No description provided for @chatAttachment.
  ///
  /// In vi, this message translates to:
  /// **'[Đính kèm]'**
  String get chatAttachment;

  /// No description provided for @chatNoPhotos.
  ///
  /// In vi, this message translates to:
  /// **'Không có ảnh nào'**
  String get chatNoPhotos;

  /// No description provided for @chatUserNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy người dùng. Vui lòng đăng nhập lại.'**
  String get chatUserNotFound;

  /// No description provided for @chatFindConversationFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi tìm cuộc trò chuyện: {error}'**
  String chatFindConversationFailed(String error);

  /// No description provided for @chatConversationError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi cuộc trò chuyện: {message}'**
  String chatConversationError(String message);

  /// No description provided for @chatConversationsError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi danh sách cuộc trò chuyện: {message}'**
  String chatConversationsError(String message);

  /// No description provided for @chatNoFriendsToStart.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bạn bè. Hãy thêm bạn bè để bắt đầu nhắn tin!'**
  String get chatNoFriendsToStart;

  /// No description provided for @chatSuggestedFriends.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè gợi ý để nhắn tin'**
  String get chatSuggestedFriends;

  /// No description provided for @chatNoConversations.
  ///
  /// In vi, this message translates to:
  /// **'Không có cuộc trò chuyện nào'**
  String get chatNoConversations;

  /// No description provided for @chatPickImageFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi chọn ảnh: {error}'**
  String chatPickImageFailed(String error);

  /// No description provided for @chatTakePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh'**
  String get chatTakePhoto;

  /// No description provided for @chatChooseFromLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Chọn từ thư viện'**
  String get chatChooseFromLibrary;

  /// No description provided for @chatDiscardGroupTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hủy thao tác?'**
  String get chatDiscardGroupTitle;

  /// No description provided for @chatDiscardGroupMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn hủy tạo nhóm chat không?'**
  String get chatDiscardGroupMessage;

  /// No description provided for @chatSelectAtLeastOnePerson.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn ít nhất 1 người'**
  String get chatSelectAtLeastOnePerson;

  /// No description provided for @chatUserInfoNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thông tin người dùng'**
  String get chatUserInfoNotFound;

  /// No description provided for @chatCreateGroupFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi tạo nhóm chat: {error}'**
  String chatCreateGroupFailed(String error);

  /// No description provided for @chatNewGroup.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm chat mới'**
  String get chatNewGroup;

  /// No description provided for @chatGroupNameOptional.
  ///
  /// In vi, this message translates to:
  /// **'Tên nhóm (không bắt buộc)'**
  String get chatGroupNameOptional;

  /// No description provided for @chatSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý'**
  String get chatSuggestions;

  /// No description provided for @chatGroupName.
  ///
  /// In vi, this message translates to:
  /// **'Tên nhóm'**
  String get chatGroupName;

  /// No description provided for @chatCreateGroup.
  ///
  /// In vi, this message translates to:
  /// **'Tạo nhóm chat'**
  String get chatCreateGroup;

  /// No description provided for @chatPeopleYouMayKnow.
  ///
  /// In vi, this message translates to:
  /// **'Những người bạn có thể biết'**
  String get chatPeopleYouMayKnow;

  /// No description provided for @chatNoFriendSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Hiện chưa có gợi ý bạn bè'**
  String get chatNoFriendSuggestions;

  /// No description provided for @chatDeleteMessageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tin nhắn?'**
  String get chatDeleteMessageTitle;

  /// No description provided for @chatDeleteForEveryone.
  ///
  /// In vi, this message translates to:
  /// **'Xóa đối với mọi người'**
  String get chatDeleteForEveryone;

  /// No description provided for @chatDeleteForMe.
  ///
  /// In vi, this message translates to:
  /// **'Xóa cho tôi'**
  String get chatDeleteForMe;

  /// No description provided for @chatChangeGroupPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Đổi ảnh nhóm'**
  String get chatChangeGroupPhoto;

  /// No description provided for @chatChoosePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh'**
  String get chatChoosePhoto;

  /// No description provided for @chatChangeName.
  ///
  /// In vi, this message translates to:
  /// **'Đổi tên'**
  String get chatChangeName;

  /// No description provided for @chatCreatePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Tạo ảnh'**
  String get chatCreatePhoto;

  /// No description provided for @chatTheme.
  ///
  /// In vi, this message translates to:
  /// **'Chủ đề'**
  String get chatTheme;

  /// No description provided for @chatNickname.
  ///
  /// In vi, this message translates to:
  /// **'Biệt danh'**
  String get chatNickname;

  /// No description provided for @chatShareContactInfo.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ thông tin liên hệ'**
  String get chatShareContactInfo;

  /// No description provided for @chatViewMediaFilesLinks.
  ///
  /// In vi, this message translates to:
  /// **'Xem file phương tiện, file và liên kết'**
  String get chatViewMediaFilesLinks;

  /// No description provided for @chatPinnedMessages.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn đã ghim'**
  String get chatPinnedMessages;

  /// No description provided for @chatSearchInConversation.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm trong cuộc trò chuyện'**
  String get chatSearchInConversation;

  /// No description provided for @chatDeleteConversation.
  ///
  /// In vi, this message translates to:
  /// **'Xóa cuộc trò chuyện'**
  String get chatDeleteConversation;

  /// No description provided for @chatChangeGroupName.
  ///
  /// In vi, this message translates to:
  /// **'Đổi tên nhóm'**
  String get chatChangeGroupName;

  /// No description provided for @chatGroupNameChanged.
  ///
  /// In vi, this message translates to:
  /// **'Đã đổi tên nhóm thành công'**
  String get chatGroupNameChanged;

  /// No description provided for @chatChangeGroupNameFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đổi tên nhóm: {error}'**
  String chatChangeGroupNameFailed(String error);

  /// No description provided for @chatVideoCall.
  ///
  /// In vi, this message translates to:
  /// **'Cuộc gọi video'**
  String get chatVideoCall;

  /// No description provided for @chatAudioCall.
  ///
  /// In vi, this message translates to:
  /// **'Cuộc gọi thoại'**
  String get chatAudioCall;

  /// No description provided for @chatMissedCall.
  ///
  /// In vi, this message translates to:
  /// **'Nhỡ cuộc gọi'**
  String get chatMissedCall;

  /// No description provided for @chatVideoCallMissed.
  ///
  /// In vi, this message translates to:
  /// **'Đã bỏ lỡ cuộc gọi video'**
  String get chatVideoCallMissed;

  /// No description provided for @chatYouDeletedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã xóa tin nhắn này'**
  String get chatYouDeletedMessage;

  /// No description provided for @chatUserDeletedMessage.
  ///
  /// In vi, this message translates to:
  /// **'{user} đã xóa tin nhắn này'**
  String chatUserDeletedMessage(String user);

  /// No description provided for @chatUnreadMessages.
  ///
  /// In vi, this message translates to:
  /// **'{count} tin nhắn chưa đọc'**
  String chatUnreadMessages(num count);

  /// No description provided for @chatEdited.
  ///
  /// In vi, this message translates to:
  /// **'Đã chỉnh sửa'**
  String get chatEdited;

  /// No description provided for @chatSentAt.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi {time}'**
  String chatSentAt(String time);

  /// No description provided for @chatMore.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get chatMore;

  /// No description provided for @chatPin.
  ///
  /// In vi, this message translates to:
  /// **'Ghim'**
  String get chatPin;

  /// No description provided for @chatForward.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển tiếp'**
  String get chatForward;

  /// No description provided for @chatCreateAIImage.
  ///
  /// In vi, this message translates to:
  /// **'Tạo hình ảnh AI'**
  String get chatCreateAIImage;

  /// No description provided for @chatNoReactions.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có cảm xúc nào'**
  String get chatNoReactions;

  /// No description provided for @chatAnonymousUser.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng ẩn danh'**
  String get chatAnonymousUser;

  /// No description provided for @chatAddMember.
  ///
  /// In vi, this message translates to:
  /// **'Thêm thành viên'**
  String get chatAddMember;

  /// No description provided for @chatMuteNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Tắt thông báo'**
  String get chatMuteNotifications;

  /// No description provided for @communityInviteAction.
  ///
  /// In vi, this message translates to:
  /// **'Mời'**
  String get communityInviteAction;

  /// No description provided for @messageDownloadingPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải ảnh xuống...'**
  String get messageDownloadingPhoto;

  /// No description provided for @messageSavePhotoSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu ảnh vào thư viện'**
  String get messageSavePhotoSuccess;

  /// No description provided for @messageSavePhotoError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi lưu ảnh'**
  String get messageSavePhotoError;

  /// No description provided for @commonMaybeLater.
  ///
  /// In vi, this message translates to:
  /// **'Để sau'**
  String get commonMaybeLater;

  /// No description provided for @faceRecognitionSetup.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập nhận diện khuôn mặt'**
  String get faceRecognitionSetup;

  /// No description provided for @faceRecognitionDescription.
  ///
  /// In vi, this message translates to:
  /// **'Sử dụng dữ liệu khuôn mặt của bạn để bật các tính năng AI thông minh và bảo vệ tài khoản an toàn hơn.'**
  String get faceRecognitionDescription;

  /// No description provided for @faceRecognitionSmartSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý bạn bè thông minh'**
  String get faceRecognitionSmartSuggestions;

  /// No description provided for @faceRecognitionAutoTagDescription.
  ///
  /// In vi, this message translates to:
  /// **'AI tự động nhận diện khuôn mặt bạn trong ảnh và đề xuất gắn thẻ chính xác.'**
  String get faceRecognitionAutoTagDescription;

  /// No description provided for @faceRecognitionAntiSpoofing.
  ///
  /// In vi, this message translates to:
  /// **'Chống giả mạo tài khoản'**
  String get faceRecognitionAntiSpoofing;

  /// No description provided for @faceRecognitionAntiSpoofingDescription.
  ///
  /// In vi, this message translates to:
  /// **'Ngăn chặn người khác sử dụng hình ảnh của bạn để tạo tài khoản giả mạo.'**
  String get faceRecognitionAntiSpoofingDescription;

  /// No description provided for @faceRecognitionHighSecurity.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật tuyệt đối'**
  String get faceRecognitionHighSecurity;

  /// No description provided for @faceRecognitionSecurityDescription.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu khuôn mặt được mã hóa an toàn và không chia sẻ cho bên thứ ba.'**
  String get faceRecognitionSecurityDescription;

  /// No description provided for @faceRecognitionStartScan.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu quét khuôn mặt'**
  String get faceRecognitionStartScan;

  /// No description provided for @reactionLike.
  ///
  /// In vi, this message translates to:
  /// **'Thích'**
  String get reactionLike;

  /// No description provided for @reactionLove.
  ///
  /// In vi, this message translates to:
  /// **'Yêu thích'**
  String get reactionLove;

  /// No description provided for @reactionHaha.
  ///
  /// In vi, this message translates to:
  /// **'Haha'**
  String get reactionHaha;

  /// No description provided for @reactionWow.
  ///
  /// In vi, this message translates to:
  /// **'Wow'**
  String get reactionWow;

  /// No description provided for @reactionSad.
  ///
  /// In vi, this message translates to:
  /// **'Buồn'**
  String get reactionSad;

  /// No description provided for @storyAddMediaFromComputer.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ảnh/video từ máy tính'**
  String get storyAddMediaFromComputer;

  /// No description provided for @storySelectFile.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tệp'**
  String get storySelectFile;

  /// No description provided for @storyWebImageEditNotSupported.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa ảnh chưa hỗ trợ lưu trên nền tảng Web'**
  String get storyWebImageEditNotSupported;

  /// No description provided for @commonImageOnlySupport.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ hỗ trợ file ảnh'**
  String get commonImageOnlySupport;

  /// No description provided for @reactionAngry.
  ///
  /// In vi, this message translates to:
  /// **'Phẫn nộ'**
  String get reactionAngry;

  /// No description provided for @chatGiphySticker.
  ///
  /// In vi, this message translates to:
  /// **'Nhãn dán GIPHY'**
  String get chatGiphySticker;

  /// No description provided for @chatGiphySearch.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm sticker GIPHY...'**
  String get chatGiphySearch;

  /// No description provided for @chatGiphyError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải sticker GIPHY: {error}'**
  String chatGiphyError(Object error);

  /// No description provided for @communityRoadmapNoPoints.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có địa điểm nào trên bản đồ'**
  String get communityRoadmapNoPoints;

  /// No description provided for @communityRoadmapPoint.
  ///
  /// In vi, this message translates to:
  /// **'Điểm đến'**
  String get communityRoadmapPoint;

  /// No description provided for @communityRoadmapNearby.
  ///
  /// In vi, this message translates to:
  /// **'Địa điểm gần đây'**
  String get communityRoadmapNearby;

  /// No description provided for @communityRoadmapPosts.
  ///
  /// In vi, this message translates to:
  /// **'{count} bài viết'**
  String communityRoadmapPosts(num count);

  /// No description provided for @locationSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm vị trí...'**
  String get locationSearchHint;

  /// No description provided for @locationNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy vị trí'**
  String get locationNotFound;

  /// No description provided for @locationSearchError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tìm kiếm vị trí (có thể do lỗi kết nối hoặc không tìm thấy)'**
  String get locationSearchError;

  /// No description provided for @locationSelected.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí đã chọn'**
  String get locationSelected;

  /// No description provided for @locationNotSelected.
  ///
  /// In vi, this message translates to:
  /// **'Chưa chọn vị trí'**
  String get locationNotSelected;

  /// No description provided for @locationUnknown.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí không xác định'**
  String get locationUnknown;

  /// No description provided for @postShareSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ thành công'**
  String get postShareSuccess;

  /// No description provided for @notificationTitleFriendRequest.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu kết bạn'**
  String get notificationTitleFriendRequest;

  /// No description provided for @notificationTitleFriendAccept.
  ///
  /// In vi, this message translates to:
  /// **'Chấp nhận kết bạn'**
  String get notificationTitleFriendAccept;

  /// No description provided for @notificationTitleNewPost.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết mới'**
  String get notificationTitleNewPost;

  /// No description provided for @notificationTitlePostComment.
  ///
  /// In vi, this message translates to:
  /// **'Bình luận mới'**
  String get notificationTitlePostComment;

  /// No description provided for @notificationTitlePostReaction.
  ///
  /// In vi, this message translates to:
  /// **'Cảm xúc bài viết'**
  String get notificationTitlePostReaction;

  /// No description provided for @notificationTitleMention.
  ///
  /// In vi, this message translates to:
  /// **'Đã nhắc đến bạn'**
  String get notificationTitleMention;

  /// No description provided for @notificationTitleStoryReaction.
  ///
  /// In vi, this message translates to:
  /// **'Cảm xúc tin'**
  String get notificationTitleStoryReaction;

  /// No description provided for @notificationTitleCommentReaction.
  ///
  /// In vi, this message translates to:
  /// **'Cảm xúc bình luận'**
  String get notificationTitleCommentReaction;

  /// No description provided for @notificationTitleReportReviewed.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo đã xét duyệt'**
  String get notificationTitleReportReviewed;

  /// No description provided for @notificationTitleTaggedYou.
  ///
  /// In vi, this message translates to:
  /// **'Đã gắn thẻ bạn'**
  String get notificationTitleTaggedYou;

  /// No description provided for @notificationTitleFaceDetected.
  ///
  /// In vi, this message translates to:
  /// **'Phát hiện khuôn mặt'**
  String get notificationTitleFaceDetected;

  /// No description provided for @notificationTitleFaceTagSuggest.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý gắn thẻ'**
  String get notificationTitleFaceTagSuggest;

  /// No description provided for @notificationTitleCommunityPublicJoin.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên mới'**
  String get notificationTitleCommunityPublicJoin;

  /// No description provided for @notificationTitleCommunityJoinRequest.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu tham gia cộng đồng'**
  String get notificationTitleCommunityJoinRequest;

  /// No description provided for @notificationTitleCommunityInvite.
  ///
  /// In vi, this message translates to:
  /// **'Lời mời tham gia cộng đồng'**
  String get notificationTitleCommunityInvite;

  /// No description provided for @notificationTitleCommunityJoinApproved.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu tham gia được phê duyệt'**
  String get notificationTitleCommunityJoinApproved;

  /// No description provided for @notificationTitleCommunityJoinRejected.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu tham gia bị từ chối'**
  String get notificationTitleCommunityJoinRejected;

  /// No description provided for @notificationTitleCommunityPostApproved.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết trong cộng đồng được phê duyệt'**
  String get notificationTitleCommunityPostApproved;

  /// No description provided for @notificationTitleCommunityPostRejected.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết trong cộng đồng bị từ chối'**
  String get notificationTitleCommunityPostRejected;

  /// No description provided for @notificationTitleCommunityPostPending.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết trong cộng đồng đang chờ duyệt'**
  String get notificationTitleCommunityPostPending;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
