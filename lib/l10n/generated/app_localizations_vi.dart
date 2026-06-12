// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'commonhub';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonReport => 'Báo cáo';

  @override
  String get commonBlock => 'Chặn';

  @override
  String get commonPrivacySupport => 'Quyền riêng tư & Hỗ trợ';

  @override
  String get commonMoreActions => 'Hành động khác';

  @override
  String get commonSavePhotoPermissionMessage =>
      'Cần quyền truy cập ảnh để lưu ảnh';

  @override
  String get commonSettings => 'Cài đặt';

  @override
  String get commonOpenSettings => 'Mở Cài đặt';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get commonSend => 'Gửi';

  @override
  String get commonError => 'Lỗi';

  @override
  String get commonRestrict => 'Hạn chế';

  @override
  String get commonEnabled => 'Đang bật';

  @override
  String get commonUnknown => 'Không xác định';

  @override
  String get commonUser => 'Người dùng';

  @override
  String get unableToLoadUserData => 'Không thể tải dữ liệu người dùng';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Theo hệ thống';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageEnglish => 'English';

  @override
  String languageCurrent(String language) {
    return 'Hiện tại: $language';
  }

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuFriends => 'Bạn bè';

  @override
  String get menuGroups => 'Nhóm';

  @override
  String get menuReels => 'Thước phim';

  @override
  String get menuExplore => 'Khám phá';

  @override
  String get menuUtilities => 'Tiện ích';

  @override
  String get menuHelpSupport => 'Trợ giúp và hỗ trợ';

  @override
  String get menuSettingsPrivacy => 'Cài đặt và quyền riêng tư';

  @override
  String get menuLogout => 'Đăng xuất';

  @override
  String get menuLogoutDialogTitle => 'Đăng xuất khỏi tài khoản của bạn?';

  @override
  String menuError(String message) {
    return 'Lỗi: $message';
  }

  @override
  String get chatTitle => 'Tin nhắn';

  @override
  String get chatSearchHint => 'Tìm kiếm';

  @override
  String get chatYourStory => 'Tin của bạn';

  @override
  String get chatCreateStory => 'Tạo tin';

  @override
  String get chatYou => 'Bạn';

  @override
  String get chatSomeone => 'Ai đó';

  @override
  String get chatConnected => 'Đã kết nối';

  @override
  String chatSentAttachmentPreview(
    String senderPrefix,
    String attachmentType,
    String time,
  ) {
    return '$senderPrefixđã gửi $attachmentType   •   $time';
  }

  @override
  String chatTextPreview(String prefix, String message, String time) {
    return '$prefix$message   •   $time';
  }

  @override
  String chatGroupCreatedPreview(String creatorName) {
    return '$creatorName vừa tạo nhóm';
  }

  @override
  String get messageNoMessagesStartConversation =>
      'Không có tin nhắn nào. Bắt đầu cuộc trò chuyện ngay!';

  @override
  String get messageDownloadingFile => 'Đang tải file...';

  @override
  String get messageFileOpenAppNotFound =>
      'Không tìm thấy ứng dụng để mở file này';

  @override
  String messageFileDownloadError(String error) {
    return 'Lỗi tải file: $error';
  }

  @override
  String get messageDeletedByYou => 'Bạn đã xóa tin nhắn này';

  @override
  String messageDeletedByUser(String name) {
    return '$name đã xóa tin nhắn này';
  }

  @override
  String messageUnreadCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tin nhắn chưa đọc',
      one: '1 tin nhắn chưa đọc',
    );
    return '$_temp0';
  }

  @override
  String get messageEdited => 'Đã chỉnh sửa';

  @override
  String get messageEditHistoryTitle => 'Lịch sử chỉnh sửa';

  @override
  String get messageHideEditHistory => 'Ẩn lịch sử chỉnh sửa';

  @override
  String get messageCurrentVersion => 'Hiện tại';

  @override
  String get messageLoadingEditHistory => 'Đang tải lịch sử chỉnh sửa...';

  @override
  String messageLoadMessagesError(String message) {
    return 'Lỗi tải tin nhắn: $message';
  }

  @override
  String messageSentAt(String time) {
    return 'Đã gửi $time';
  }

  @override
  String get messageLocation => 'Vị trí';

  @override
  String get messageVoiceAttachment => '[Tin nhắn thoại]';

  @override
  String get messageImageAttachment => '[Ảnh]';

  @override
  String get messageVideoAttachment => '[Video]';

  @override
  String get messageFileAttachment => '[Tệp tin]';

  @override
  String get messageGenericAttachment => '[Đính kèm]';

  @override
  String get messageDocumentFileName => 'Document';

  @override
  String get messageDocumentPdfFileName => 'Document.pdf';

  @override
  String get messageDownloadedFileName => 'downloaded_file';

  @override
  String get dateYesterday => 'Hôm qua';

  @override
  String get weekdayMondayShort => 'T2';

  @override
  String get weekdayTuesdayShort => 'T3';

  @override
  String get weekdayWednesdayShort => 'T4';

  @override
  String get weekdayThursdayShort => 'T5';

  @override
  String get weekdayFridayShort => 'T6';

  @override
  String get weekdaySaturdayShort => 'T7';

  @override
  String get weekdaySundayShort => 'CN';

  @override
  String get weekdayMondayDotShort => 'T.2';

  @override
  String get weekdayTuesdayDotShort => 'T.3';

  @override
  String get weekdayWednesdayDotShort => 'T.4';

  @override
  String get weekdayThursdayDotShort => 'T.5';

  @override
  String get weekdayFridayDotShort => 'T.6';

  @override
  String get weekdaySaturdayDotShort => 'T.7';

  @override
  String dateAtTime(String weekday, String time) {
    return '$weekday LÚC $time';
  }

  @override
  String timeMinutesAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count phút trước',
      one: '1 phút trước',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giờ trước',
      one: '1 giờ trước',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày trước',
      one: '1 ngày trước',
    );
    return '$_temp0';
  }

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonDelete => 'Xóa';

  @override
  String get commonConfirm => 'Xác nhận';

  @override
  String get commonChoose => 'Chọn';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Mật khẩu';

  @override
  String get authNewPassword => 'Mật khẩu mới';

  @override
  String get authConfirmPassword => 'Xác nhận mật khẩu';

  @override
  String get authConfirmNewPassword => 'Xác nhận mật khẩu mới';

  @override
  String get authUsername => 'Tên người dùng';

  @override
  String get authLogin => 'Đăng nhập';

  @override
  String get authRegister => 'Đăng ký';

  @override
  String get authForgotPassword => 'Quên mật khẩu';

  @override
  String get authForgotPasswordQuestion => 'Quên mật khẩu?';

  @override
  String get authForgotPasswordDescription =>
      'Nhập email của bạn để khôi phục tài khoản.';

  @override
  String get authContinue => 'Tiếp tục';

  @override
  String get authSave => 'Lưu';

  @override
  String get authOr => 'hoặc';

  @override
  String get authLoginWithGoogle => 'Đăng nhập với Google';

  @override
  String get authNoAccount => 'Bạn chưa có tài khoản? ';

  @override
  String get authHasAccount => 'Bạn đã có tài khoản? ';

  @override
  String get authEnterEmail => 'Vui lòng nhập email';

  @override
  String get authEnterPassword => 'Vui lòng nhập mật khẩu';

  @override
  String get authEnterUsername => 'Vui lòng nhập tên người dùng';

  @override
  String get authEnterConfirmPassword => 'Vui lòng nhập xác nhận mật khẩu';

  @override
  String get authEnterNewPassword => 'Vui lòng nhập mật khẩu mới';

  @override
  String get authEnterConfirmNewPassword =>
      'Vui lòng nhập xác nhận mật khẩu mới';

  @override
  String get authLoginFailed => 'Đăng nhập thất bại';

  @override
  String get authRegisterFailed => 'Đăng ký thất bại';

  @override
  String get authSendOtpFailed => 'Gửi OTP thất bại';

  @override
  String get authVerifyOtpFailed => 'Xác thực thất bại';

  @override
  String get authResetPassword => 'Đặt lại mật khẩu';

  @override
  String get authResetPasswordDescription =>
      'Giúp chúng tôi bảo vệ tài khoản của bạn bằng cách chọn mật khẩu mạnh.';

  @override
  String get authResetPasswordSuccess => 'Đặt lại mật khẩu thành công';

  @override
  String get authResetPasswordFailed => 'Đặt lại mật khẩu thất bại';

  @override
  String get authOtpTitle => 'Xác thực OTP';

  @override
  String authOtpSentTo(String email) {
    return 'Nhập mã OTP đã gửi đến $email';
  }

  @override
  String get authInvalidOtp => 'Vui lòng nhập mã OTP hợp lệ';

  @override
  String get authDidNotReceiveCode => 'Bạn chưa nhận được mã? ';

  @override
  String get authResendingOtp => 'Đang gửi lại...';

  @override
  String authResendInSeconds(int seconds) {
    return 'Gửi lại trong $seconds giây';
  }

  @override
  String get authResendCode => 'Gửi lại mã';

  @override
  String get authVerify => 'Xác thực';

  @override
  String get authPersonalInfoTitle => 'Thông tin cá nhân';

  @override
  String get authPersonalInfoDescription =>
      'Vui lòng điền đầy đủ thông tin sau';

  @override
  String get authFullName => 'Họ và tên';

  @override
  String get authPhoneNumber => 'Số điện thoại';

  @override
  String get authDateOfBirth => 'Ngày sinh';

  @override
  String get authGender => 'Giới tính';

  @override
  String get authBio => 'Tiểu sử';

  @override
  String get authEnterFullName => 'Vui lòng nhập họ và tên';

  @override
  String get authEnterPhoneNumber => 'Vui lòng nhập số điện thoại';

  @override
  String get authEnterDateOfBirth => 'Vui lòng nhập ngày sinh';

  @override
  String get authEnterGender => 'Vui lòng nhập giới tính';

  @override
  String get authUpdatePersonalInfoFailed =>
      'Cập nhật thông tin cá nhân thất bại';

  @override
  String get authChooseGender => 'Chọn giới tính';

  @override
  String get authGenderMale => 'Nam';

  @override
  String get authGenderFemale => 'Nữ';

  @override
  String get authGenderOther => 'Khác';

  @override
  String get faceScanTitle => 'Nhận diện khuôn mặt';

  @override
  String get faceScanProcessing => 'Đang xử lý...';

  @override
  String get faceScanCompleted => 'Hoàn tất!';

  @override
  String get faceScanHoldStill => 'Giữ yên...';

  @override
  String get faceScanTooDarkTitle => 'Thiếu ánh sáng';

  @override
  String faceScanStep(int step) {
    return 'Bước $step/5';
  }

  @override
  String get faceScanUploading => 'Đang gửi dữ liệu khuôn mặt lên máy chủ...';

  @override
  String get faceScanStoredSafely =>
      'Dữ liệu khuôn mặt đã được lưu trữ an toàn.';

  @override
  String get faceScanTooDarkMessage =>
      'Môi trường quá tối.\nVui lòng tìm nơi có ánh sáng tốt hơn.';

  @override
  String get faceScanLookStraight => 'Vui lòng nhìn thẳng vào camera';

  @override
  String get faceScanLookUp => 'Ngẩng đầu lên một chút';

  @override
  String get faceScanLookDown => 'Cúi đầu xuống một chút';

  @override
  String get faceScanLookLeft => 'Quay mặt sang trái';

  @override
  String get faceScanLookRight => 'Quay mặt sang phải';

  @override
  String get faceScanMissingAccount =>
      'Không tìm thấy thông tin tài khoản. Vui lòng thử lại.';

  @override
  String get faceScanProcessImageFailed =>
      'Đã xảy ra lỗi khi xử lý ảnh. Vui lòng thử lại.';

  @override
  String get authErrorTitle => 'Lỗi xác thực';

  @override
  String get languageSelectTitle => 'Chọn ngôn ngữ';

  @override
  String get menuSaved => 'Đã lưu';

  @override
  String get menuCommunity => 'Cộng đồng';

  @override
  String get menuAppearance => 'Giao diện';

  @override
  String get menuPrivacySecurity => 'Quyền riêng tư & bảo mật';

  @override
  String get profileTitle => 'Trang cá nhân';

  @override
  String get profileLoadPostsError => 'Lỗi tải bài viết';

  @override
  String get profileLoadError => 'Không thể tải trang cá nhân';

  @override
  String get profileNoPosts => 'Chưa có bài viết nào';

  @override
  String get profileEndOfPosts => 'Đã hiển thị hết bài viết';

  @override
  String get profileAddToStory => 'Thêm vào tin';

  @override
  String get profileEditInfo => 'Chỉnh sửa thông tin';

  @override
  String get profileAbout => 'Giới thiệu';

  @override
  String profileStudiedAt(String school) {
    return 'Đã học tại $school';
  }

  @override
  String profileLivesIn(String city) {
    return 'Sống tại $city';
  }

  @override
  String profileFrom(String place) {
    return 'Đến từ $place';
  }

  @override
  String profileWorksAt(String workplace) {
    return 'Làm việc tại $workplace';
  }

  @override
  String get profileNoBio => 'Chưa có tiểu sử';

  @override
  String get profileCoverPhoto => 'Ảnh bìa';

  @override
  String get profileAvatarPhoto => 'Ảnh đại diện';

  @override
  String get profileUserNameFallback => 'Tên người dùng';

  @override
  String get profileEdit => 'Chỉnh sửa';

  @override
  String get profilePostsTab => 'Bài viết';

  @override
  String get profilePhotosTab => 'Ảnh';

  @override
  String get profileReelsTab => 'Reels';

  @override
  String get profilePostsList => 'Danh sách bài viết';

  @override
  String get profileYourPhotos => 'Ảnh của bạn';

  @override
  String get profileYourReels => 'Reels của bạn';

  @override
  String get profileEditProfileTitle => 'Chỉnh sửa trang cá nhân';

  @override
  String get profileUpdateFailed => 'Cập nhật thất bại';

  @override
  String get profileUsername => 'Tên người dùng';

  @override
  String get profileEditName => 'Chỉnh sửa tên';

  @override
  String get profileAvatar => 'Ảnh đại diện';

  @override
  String get profileCover => 'Ảnh bìa';

  @override
  String get profileBio => 'Tiểu sử';

  @override
  String get profileEditBio => 'Chỉnh sửa tiểu sử';

  @override
  String get profileDetails => 'Chi tiết';

  @override
  String get profileNoBioPlaceholder => 'Chưa có tiểu sử';

  @override
  String profileEnterField(String field) {
    return 'Nhập $field...';
  }

  @override
  String get profileEditDetailsTitle => 'Chỉnh sửa chi tiết';

  @override
  String get profileSchool => 'Trường học';

  @override
  String get profileCurrentCity => 'Thành phố hiện tại';

  @override
  String get profileHometown => 'Quê quán';

  @override
  String get profileWorkplace => 'Nơi làm việc';

  @override
  String get profileRelationshipStatus => 'Tình trạng quan hệ';

  @override
  String get profileSelectRelationshipStatus => 'Chọn tình trạng quan hệ';

  @override
  String get profileChooseAvatar => 'Chọn ảnh đại diện';

  @override
  String get profileChooseCover => 'Chọn ảnh bìa';

  @override
  String get profileImage => 'Hình ảnh';

  @override
  String get profileAddWorkplace => 'Thêm nơi làm việc';

  @override
  String get profileAddRelationshipStatus => 'Thêm tình trạng mối quan hệ';

  @override
  String get profileWhatsOnYourMind => 'Bạn đang nghĩ gì?';

  @override
  String get profileNoFriends => 'Chưa có bạn bè nào';

  @override
  String get profileFriends => 'Bạn bè';

  @override
  String get profileViewAll => 'Xem tất cả';

  @override
  String profileFriendCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count người bạn',
      one: '1 người bạn',
      zero: '0 người bạn',
    );
    return '$_temp0';
  }

  @override
  String get profileUnnamed => 'Không tên';

  @override
  String get profileAddFriend => 'Thêm bạn bè';

  @override
  String get profileCancelFriendRequest => 'Hủy yêu cầu kết bạn';

  @override
  String get profileAcceptFriend => 'Chấp nhận kết bạn';

  @override
  String get profileRejectFriend => 'Xóa';

  @override
  String get profileUnfriend => 'Hủy kết bạn';

  @override
  String get profileMessage => 'Nhắn tin';

  @override
  String get profileConfirmUnfriendTitle => 'Xác nhận hủy kết bạn';

  @override
  String get profileConfirmUnfriendMessage =>
      'Bạn có chắc chắn muốn hủy kết bạn với người này không?';

  @override
  String get profileAgree => 'Đồng ý';

  @override
  String get profileAccountSecurity => 'Bảo mật tài khoản';

  @override
  String get profileFaceData => 'Dữ liệu khuôn mặt';

  @override
  String get profileFaceRegistered => 'Đã thiết lập';

  @override
  String get profileFaceNotRegistered => 'Chưa thiết lập';

  @override
  String get profileFaceDataSuccessDeleted =>
      'Xóa dữ liệu khuôn mặt thành công';

  @override
  String get profileManageFaceData => 'Quản lý dữ liệu khuôn mặt';

  @override
  String get profileAddFaceData => 'Thêm dữ liệu khuôn mặt';

  @override
  String get profileFaceDataRegisteredDescription =>
      'Dữ liệu khuôn mặt của bạn đang được sử dụng để nhận diện và bảo vệ tài khoản.';

  @override
  String get profileFaceDataUnregisteredDescription =>
      'Đăng ký khuôn mặt giúp AI nhận diện bạn trong ảnh và bảo vệ tài khoản tốt hơn.';

  @override
  String get profileDeleteFaceData => 'Xóa dữ liệu khuôn mặt';

  @override
  String get profileDeleteConfirmTitle => 'Xác nhận xóa';

  @override
  String get profileDeleteFaceConfirmMessage =>
      'Bạn có chắc chắn muốn xóa toàn bộ dữ liệu khuôn mặt? Hành động này không thể hoàn tác.';

  @override
  String get profileDeletingFaceData => 'Đang xóa dữ liệu khuôn mặt...';

  @override
  String get appearanceDisplayModeSection => 'CHẾ ĐỘ HIỂN THỊ';

  @override
  String get appearanceAccentColorSection => 'MÀU CHỦ ĐẠO';

  @override
  String get appearanceTextSizeSection => 'KÍCH THƯỚC CHỮ';

  @override
  String get appearanceLightMode => 'Sáng';

  @override
  String get appearanceDarkMode => 'Tối';

  @override
  String get appearanceAutoMode => 'Tự động';

  @override
  String get appearanceSmallText => 'Nhỏ';

  @override
  String get appearanceNormalText => 'Bình thường';

  @override
  String get appearanceLargeText => 'Lớn';

  @override
  String get appearanceChooseAccentColor => 'Chọn màu chủ đạo';

  @override
  String get appearanceCustomAccentColor => 'Tùy chỉnh';

  @override
  String get appearanceDefaultAccent => 'Mặc định';

  @override
  String get appearanceBlueAccent => 'Xanh dương';

  @override
  String get appearancePinkPurpleAccent => 'Hồng tím';

  @override
  String get appearanceNeonPurpleAccent => 'Tím neon';

  @override
  String get appearanceBrightOrangeAccent => 'Cam sáng';

  @override
  String get appearanceCoralRedAccent => 'Đỏ coral';

  @override
  String get appearanceHighContrast => 'Độ tương phản cao';

  @override
  String get appearanceReduceMotion => 'Giảm chuyển động';

  @override
  String get relationshipSingle => 'Độc thân';

  @override
  String get relationshipDating => 'Hẹn hò';

  @override
  String get relationshipInRelationship => 'Đang hẹn hò';

  @override
  String get relationshipMarried => 'Đã kết hôn';

  @override
  String get relationshipComplicated => 'Phức tạp';

  @override
  String get relationshipOpen => 'Mối quan hệ mở';

  @override
  String get relationshipDivorced => 'Ly hôn';

  @override
  String get menuCreateProfileOrPage => 'Tạo trang cá nhân hoặc Trang mới';

  @override
  String get commonAll => 'Tất cả';

  @override
  String get commonBack => 'Quay lại';

  @override
  String get commonCreate => 'Tạo';

  @override
  String get commonDetails => 'Chi tiết';

  @override
  String get commonDone => 'Xong';

  @override
  String get commonErrorOccurred => 'Đã xảy ra lỗi';

  @override
  String commonErrorWithMessage(String error) {
    return 'Đã xảy ra lỗi: $error';
  }

  @override
  String get commonFeatureInDevelopment => 'Tính năng đang phát triển';

  @override
  String get commonLoading => 'Đang tải';

  @override
  String commonNextWithCount(num count) {
    return 'Tiếp ($count)';
  }

  @override
  String get commonNo => 'Không';

  @override
  String get commonRefresh => 'Tải lại';

  @override
  String get commonSaveChanges => 'Lưu thay đổi';

  @override
  String get commonServerErrorRetryLater =>
      'Lỗi máy chủ. Vui lòng thử lại sau.';

  @override
  String get commonSessionExpired =>
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';

  @override
  String get commonSystem => 'Hệ thống';

  @override
  String get commonUnderstood => 'Đã hiểu';

  @override
  String get commonUnexpectedErrorRetry =>
      'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.';

  @override
  String get commonUnknownError => 'Lỗi không xác định';

  @override
  String get communityAdmin => 'Admin';

  @override
  String get communityAdminDemoted => 'Đã hạ quyền admin';

  @override
  String get communityAdminPanelSubtitle =>
      'Duyệt thành viên mới và kiểm duyệt bài viết trước khi hiển thị.';

  @override
  String get communityAdminPanelTitle => 'Bảng quản trị';

  @override
  String get communityApproved => 'Đã duyệt';

  @override
  String get communityAvatar => 'Ảnh đại diện';

  @override
  String get communityCancelJoinRequestConfirm =>
      'Bạn có chắc muốn hủy yêu cầu tham gia cộng đồng này?';

  @override
  String get communityCancelJoinRequestTitle => 'Hủy yêu cầu';

  @override
  String get communityCancelRequestSuccess => 'Đã hủy yêu cầu tham gia';

  @override
  String get communityCannotIdentifyFriend => 'Lỗi: Không thể xác định bạn bè';

  @override
  String get communityChooseAvatar => 'Chọn ảnh đại diện';

  @override
  String get communityChooseCover => 'Chọn ảnh bìa';

  @override
  String get communityChooseFromLibrary => 'Chọn từ thư viện';

  @override
  String get communityClearSearch => 'Xóa tìm kiếm';

  @override
  String get communityCoverImage => 'Ảnh bìa';

  @override
  String get communityCreateGroup => 'Tạo nhóm';

  @override
  String get communityCreateIntro =>
      'Tạo không gian để bạn bè cùng trao đổi và chia sẻ nội dung.';

  @override
  String get communityCreatePostTitle => 'Tạo bài viết trong nhóm';

  @override
  String get communityCreateSuccess => 'Tạo cộng đồng thành công';

  @override
  String get communityCreateTitle => 'Tạo cộng đồng';

  @override
  String get communityDeleteConfirm =>
      'Bạn có chắc muốn xóa cộng đồng này? Hành động này không thể hoàn tác.';

  @override
  String get communityDeleteGroup => 'Xóa nhóm';

  @override
  String get communityDeleteSuccess => 'Đã xóa cộng đồng thành công';

  @override
  String get communityDeleteTitle => 'Xóa cộng đồng';

  @override
  String get communityDescription => 'Mô tả';

  @override
  String get communityDescriptionHint => 'Nhập mô tả cộng đồng';

  @override
  String get communityEditGroup => 'Chỉnh sửa nhóm';

  @override
  String get communityEditIntro =>
      'Cập nhật thông tin để thành viên hiểu rõ hơn về cộng đồng.';

  @override
  String get communityEditTitle => 'Chỉnh sửa cộng đồng';

  @override
  String get communityEmpty => 'Chưa có cộng đồng nào';

  @override
  String get communityExploreSubtitle =>
      'Khám phá nhóm phù hợp và theo dõi các bài viết đang chờ duyệt.';

  @override
  String get communityExploreTab => 'Khám phá';

  @override
  String get communityExploreTitle => 'Cộng đồng';

  @override
  String get communityFilterPosts => 'Lọc bài viết';

  @override
  String get communityHandleInviteFailed => 'Không thể xử lý lời mời';

  @override
  String get communityInviteFriends => 'Mời bạn bè';

  @override
  String get communityInviteFriendsSubtitle => 'Tham gia cộng đồng này';

  @override
  String get communityInviteFriendsTitle => 'Mời bạn bè';

  @override
  String get communityInvitePendingNotice =>
      'Lời mời tham gia cộng đồng đang chờ phản hồi.';

  @override
  String get communityInviteSearchHint => 'Tìm tên hoặc username...';

  @override
  String get communityInviteSendFailed => 'Không thể gửi lời mời';

  @override
  String get communityInviteSentSuccess => 'Đã gửi lời mời thành công';

  @override
  String get communityInviteStatusApproved => 'Bạn đã chấp nhận lời mời';

  @override
  String get communityInviteStatusPending => 'Bạn được mời tham gia cộng đồng';

  @override
  String get communityInviteStatusRejected => 'Bạn đã từ chối lời mời';

  @override
  String get communityInvited => 'Đã mời';

  @override
  String get communityInvitesTab => 'Lời mời';

  @override
  String get communityInvitesTitle => 'Lời mời cộng đồng';

  @override
  String get communityJoin => 'Tham gia';

  @override
  String get communityJoinRequestAccepted => 'Đã chấp nhận yêu cầu';

  @override
  String get communityJoinRequestPendingMessage =>
      'Yêu cầu tham gia cộng đồng đang chờ bạn xét duyệt.';

  @override
  String get communityJoinRequestRejected => 'Đã từ chối yêu cầu';

  @override
  String get communityJoinRequestSent => 'Đã gửi yêu cầu tham gia cộng đồng';

  @override
  String get communityJoinShort => 'Tham gia';

  @override
  String get communityLeaveConfirm =>
      'Bạn có chắc muốn rời khỏi cộng đồng này?';

  @override
  String get communityLeaveGroup => 'Rời nhóm';

  @override
  String get communityLeaveSuccess => 'Đã rời khỏi cộng đồng';

  @override
  String get communityLoadFriendsFailed => 'Lỗi khi tải danh sách bạn bè';

  @override
  String get communityLoadInvitesFailed => 'Không thể tải lời mời';

  @override
  String get communityLoadMembersFailed => 'Không tải được danh sách';

  @override
  String get communityLoadingFriends => 'Đang tải danh sách bạn bè...';

  @override
  String communityMediaCount(num count) {
    return '$count media';
  }

  @override
  String get communityMember => 'Thành viên';

  @override
  String get communityMemberOnlyContent => 'Nội dung chỉ dành cho thành viên';

  @override
  String get communityMemberOnlyPostsMessage =>
      'Tham gia cộng đồng để xem bài viết trong nhóm.';

  @override
  String get communityMemberOptions => 'Tùy chọn thành viên';

  @override
  String get communityMemberPromoted => 'Đã nâng quyền thành viên';

  @override
  String get communityMemberRemoved => 'Đã xóa thành viên';

  @override
  String get communityMembers => 'Thành viên';

  @override
  String communityMembersCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thành viên',
      one: '1 thành viên',
      zero: '0 thành viên',
    );
    return '$_temp0';
  }

  @override
  String get communityMembersListTitle => 'Danh sách thành viên';

  @override
  String get communityMineTab => 'Của tôi';

  @override
  String get communityName => 'Tên cộng đồng';

  @override
  String get communityNameHint => 'Nhập tên cộng đồng';

  @override
  String get communityNameRequired => 'Vui lòng nhập tên cộng đồng';

  @override
  String get communityNoApprovedPosts => 'Chưa có bài viết đã duyệt';

  @override
  String get communityNoAvailableFriends => 'Không có bạn bè khả dụng';

  @override
  String get communityNoCommunityInvites =>
      'Không có lời mời tham gia cộng đồng';

  @override
  String get communityNoDescription => 'Chưa có mô tả';

  @override
  String communityNoInviteSearchResults(String query) {
    return 'Không tìm thấy \"$query\"';
  }

  @override
  String get communityNoInvites => 'Bạn không có lời mời nào';

  @override
  String get communityNoJoinedCommunities => 'Bạn chưa tham gia cộng đồng nào';

  @override
  String get communityNoMembers => 'Chưa có thành viên nào';

  @override
  String get communityNoMembersFound => 'Không tìm thấy thành viên';

  @override
  String get communityNoMembersFoundMessage =>
      'Thử tìm bằng tên hoặc username khác.';

  @override
  String get communityNoMembersMessage =>
      'Khi có người tham gia, danh sách sẽ hiển thị tại đây.';

  @override
  String get communityNoPendingCommunities =>
      'Chưa có cộng đồng nào đang chờ duyệt';

  @override
  String get communityNoPendingPosts => 'Không có bài viết đang chờ duyệt';

  @override
  String get communityNoPendingRequests =>
      'Không có yêu cầu tham gia đang chờ duyệt';

  @override
  String get communityNoPendingReviewPosts =>
      'Không có bài viết nào đang chờ duyệt';

  @override
  String get communityNoPosts => 'Chưa có bài viết nào';

  @override
  String get communityNoPostsMessage =>
      'Các bài viết trong cộng đồng sẽ xuất hiện tại đây.';

  @override
  String get communityNoPostsTitle => 'Chưa có bài viết';

  @override
  String get communityNoSearchResults => 'Không tìm thấy cộng đồng phù hợp';

  @override
  String get communityPendingApproval => 'Chờ duyệt';

  @override
  String get communityPendingCommunitiesHint =>
      'Yêu cầu tham gia cộng đồng sẽ xuất hiện tại đây';

  @override
  String get communityPendingPostsHint =>
      'Bài viết mới sẽ hiển thị tại đây để bạn kiểm duyệt.';

  @override
  String get communityPendingRequestsHint =>
      'Khi có thành viên mới gửi yêu cầu, bạn sẽ thấy ở đây.';

  @override
  String get communityPendingTab => 'Đang chờ';

  @override
  String communityPickImageError(String error) {
    return 'Không thể chọn ảnh: $error';
  }

  @override
  String get communityPostApprovedSuccess => 'Đã duyệt bài viết';

  @override
  String get communityPostNoText => 'Bài viết không có nội dung văn bản.';

  @override
  String get communityPostPendingApproval =>
      'Bài viết đang chờ quản trị viên duyệt';

  @override
  String get communityPostRejectedSuccess => 'Đã từ chối bài viết';

  @override
  String get communityPostsInGroup => 'Bài viết trong nhóm';

  @override
  String get communityPostsTab => 'Bài viết';

  @override
  String communityPrivacyMembers(String privacy, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thành viên',
      one: '1 thành viên',
      zero: '0 thành viên',
    );
    return '$privacy · $_temp0';
  }

  @override
  String get communityPrivate => 'Riêng tư';

  @override
  String get communityPrivateGroup => 'Nhóm riêng tư';

  @override
  String get communityPrivateOnly => 'Riêng tư';

  @override
  String get communityPublic => 'Công khai';

  @override
  String get communityPublicGroup => 'Nhóm công khai';

  @override
  String get communityPublicOnly => 'Công khai';

  @override
  String get communityRemoveFromGroup => 'Xóa khỏi nhóm';

  @override
  String communityRemoveMemberConfirm(String name) {
    return 'Bạn muốn xóa $name khỏi cộng đồng? Người này có thể gửi yêu cầu tham gia lại sau.';
  }

  @override
  String get communityRemoveMemberTitle => 'Xóa thành viên';

  @override
  String get communityReviewMembers => 'Duyệt thành viên';

  @override
  String get communityReviewMembersSubtitle =>
      'Xác nhận yêu cầu tham gia cộng đồng';

  @override
  String get communityReviewPosts => 'Duyệt bài viết';

  @override
  String get communityReviewPostsSubtitle =>
      'Kiểm tra nội dung trước khi bài được công khai';

  @override
  String get communitySearchHint => 'Tìm cộng đồng';

  @override
  String get communitySearchMembersHint => 'Tìm thành viên';

  @override
  String get communitySendingInvite => 'Đang gửi lời mời...';

  @override
  String get communityType => 'Loại cộng đồng';

  @override
  String get communityUpdateSuccess => 'Cập nhật cộng đồng thành công';

  @override
  String communityVisibleMembersCount(num visible, num total) {
    return '$visible/$total thành viên';
  }

  @override
  String get communityWritePostHint => 'Viết bài trong nhóm...';

  @override
  String get friendAccept => 'Chấp nhận';

  @override
  String friendActiveCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count đang hoạt động',
      one: '1 đang hoạt động',
      zero: '0 đang hoạt động',
    );
    return '$_temp0';
  }

  @override
  String get friendAdd => 'Thêm bạn bè';

  @override
  String get friendBecameFriends => 'Đã trở thành bạn bè';

  @override
  String get friendCancelRequest => 'Hủy yêu cầu';

  @override
  String friendCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bạn bè',
      one: '1 bạn bè',
      zero: '0 bạn bè',
    );
    return '$_temp0';
  }

  @override
  String get friendDelete => 'Xóa';

  @override
  String friendFallbackUserWithIndex(num index) {
    return 'Người dùng $index';
  }

  @override
  String friendFriendsOf(String name) {
    return 'Bạn bè của $name';
  }

  @override
  String friendFriendsSince(String month, num year) {
    return 'Bạn bè từ $month $year';
  }

  @override
  String get friendJustActive => 'Vừa hoạt động';

  @override
  String get friendLoadDataError => 'Không thể tải dữ liệu bạn bè';

  @override
  String friendLoadError(String message) {
    return 'Lỗi tải bạn bè: $message';
  }

  @override
  String get friendLoadFriendsFailed => 'Không thể tải danh sách bạn bè';

  @override
  String get friendLoadSuggestionsUnknownError =>
      'Lỗi không xác định khi tải gợi ý bạn bè';

  @override
  String get friendLoadingRequests => 'Đang tải lời mời kết bạn...';

  @override
  String get friendLoadingSentRequests => 'Đang tải lời mời đã gửi...';

  @override
  String get friendLoadingSuggestions => 'Đang tải gợi ý bạn bè...';

  @override
  String get friendLongtimeFriend => 'Bạn bè lâu năm';

  @override
  String friendMessageUser(String name) {
    return 'Nhắn tin cho $name';
  }

  @override
  String friendMutualCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bạn chung',
      one: '1 bạn chung',
      zero: 'Không có bạn chung',
    );
    return '$_temp0';
  }

  @override
  String get friendNoFriends => 'Chưa có bạn bè';

  @override
  String get friendNoRequests => 'Không có lời mời kết bạn';

  @override
  String get friendNoRequestsDescription =>
      'Khi có người gửi lời mời, bạn sẽ thấy tại đây.';

  @override
  String get friendNoSentRequests => 'Chưa gửi lời mời nào';

  @override
  String get friendNoSentRequestsDescription =>
      'Các lời mời kết bạn bạn đã gửi sẽ hiển thị tại đây.';

  @override
  String get friendNoSuggestions => 'Không có gợi ý bạn bè';

  @override
  String get friendNoSuggestionsDescription =>
      'Hãy quay lại sau để xem thêm gợi ý mới.';

  @override
  String friendOnlineCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count người online',
      one: '1 người online',
      zero: 'Không có ai online',
    );
    return '$_temp0';
  }

  @override
  String get friendPeopleYouMayKnow => 'Những người bạn có thể biết';

  @override
  String get friendReject => 'Từ chối';

  @override
  String get friendRemove => 'Gỡ';

  @override
  String get friendRequestAccepted => 'Đã chấp nhận lời mời kết bạn';

  @override
  String get friendRequestCancelled => 'Đã hủy yêu cầu';

  @override
  String get friendRequestNotFound => 'Không tìm thấy lời mời kết bạn';

  @override
  String get friendRequestRejected => 'Đã từ chối lời mời kết bạn';

  @override
  String get friendRequestRemoved => 'Đã xóa lời mời kết bạn';

  @override
  String get friendRequestSent => 'Đã gửi lời mời kết bạn';

  @override
  String get friendRequestsTitle => 'Lời mời kết bạn';

  @override
  String get friendSearchHint => 'Tìm kiếm bạn bè';

  @override
  String get friendSeeAll => 'Xem tất cả';

  @override
  String friendSentRequestsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lời mời đã gửi',
      one: '1 lời mời đã gửi',
      zero: '0 lời mời đã gửi',
    );
    return '$_temp0';
  }

  @override
  String get friendSentRequestsTitle => 'Lời mời đã gửi';

  @override
  String get friendSort => 'Sắp xếp';

  @override
  String get friendSortBy => 'Sắp xếp theo';

  @override
  String get friendSortLeastMutual => 'Ít bạn chung nhất';

  @override
  String get friendSortMostMutual => 'Nhiều bạn chung nhất';

  @override
  String get friendSortName => 'Tên';

  @override
  String get friendSortNameAz => 'Tên A-Z';

  @override
  String get friendSortNameZa => 'Tên Z-A';

  @override
  String get friendSortNewest => 'Mới nhất';

  @override
  String get friendSortOldest => 'Cũ nhất';

  @override
  String get friendSortOnline => 'Đang online';

  @override
  String get friendSortRecent => 'Gần đây';

  @override
  String get friendSuggestionsTitle => 'Gợi ý bạn bè';

  @override
  String get friendTitle => 'Bạn bè';

  @override
  String friendUnfriendConfirm(String name) {
    return 'Bạn có chắc muốn hủy kết bạn với $name?';
  }

  @override
  String get friendUnfriendTitle => 'Hủy kết bạn';

  @override
  String friendUnfriendUser(String name) {
    return 'Hủy kết bạn với $name';
  }

  @override
  String get friendViewSentRequests => 'Xem lời mời đã gửi';

  @override
  String get homeConnecting => 'Đang kết nối...';

  @override
  String get homeEndOfPosts => 'Bạn đã xem hết bài viết';

  @override
  String get homeAddStory => 'Thêm tin';

  @override
  String get homeLoadPostsFailed => 'Không thể tải bài viết';

  @override
  String monthName(num month) {
    return 'Tháng $month';
  }

  @override
  String get notificationAdminNote => 'Ghi chú của quản trị viên';

  @override
  String get notificationApprove => 'Duyệt';

  @override
  String get notificationApprovePostAction => 'Duyệt bài';

  @override
  String get notificationApprovePostTitle => 'Duyệt bài viết';

  @override
  String get notificationCannotHandleInvite => 'Không thể xử lý lời mời này';

  @override
  String get notificationCannotHandleJoinRequest =>
      'Không thể xử lý yêu cầu tham gia này';

  @override
  String get notificationCommentedOnYourPost =>
      'đã bình luận về bài viết của bạn:';

  @override
  String get notificationCommunityJoinApprovedByAdmin =>
      'Admin đã chấp nhận yêu cầu tham gia cộng đồng';

  @override
  String get notificationCommunityJoined => 'đã tham gia cộng đồng';

  @override
  String get notificationCommunityJoinRejectedByAdmin =>
      'Admin đã từ chối yêu cầu tham gia cộng đồng';

  @override
  String get notificationCommunityJoinRequestSent =>
      'đã gửi yêu cầu tham gia cộng đồng';

  @override
  String get notificationCommunityPostApprovedByAdmin =>
      'Admin đã duyệt bài viết của bạn trong cộng đồng';

  @override
  String get notificationCommunityPostRejectedByAdmin =>
      'Admin đã từ chối bài viết của bạn trong cộng đồng';

  @override
  String get notificationCommunityPostRequestSent =>
      'đã gửi yêu cầu đăng bài vào cộng đồng';

  @override
  String get notificationEmpty => 'Chưa có thông báo nào';

  @override
  String get notificationEndOfList => 'Đã xem hết thông báo';

  @override
  String get notificationExplanation => 'Giải thích';

  @override
  String notificationFaceTagSuggestions(int count) {
    return 'Nhận diện $count người trong ảnh của bạn. Gắn thẻ ngay!';
  }

  @override
  String get notificationFriendRequestMessage => 'đã gửi lời mời kết bạn';

  @override
  String get notificationInviteAccepted => 'Đã chấp nhận lời mời';

  @override
  String get notificationInviteFailed => 'Không thể xử lý lời mời';

  @override
  String get notificationInviteMessage => 'đã mời bạn tham gia cộng đồng';

  @override
  String get notificationInviteRejected => 'Đã từ chối lời mời';

  @override
  String get notificationJoinApprovedMessage =>
      'yêu cầu tham gia cộng đồng của bạn đã được chấp nhận';

  @override
  String get notificationJoinRejectedMessage =>
      'yêu cầu tham gia cộng đồng của bạn đã bị từ chối';

  @override
  String get notificationJoinRequestAccepted => 'Đã chấp nhận yêu cầu tham gia';

  @override
  String get notificationJoinRequestFailed =>
      'Không thể xử lý yêu cầu tham gia';

  @override
  String get notificationJoinRequestMessage => 'muốn tham gia cộng đồng';

  @override
  String get notificationJoinRequestRejected => 'Đã từ chối yêu cầu tham gia';

  @override
  String get notificationMentionedYouInComment =>
      'đã nhắc đến bạn trong một bình luận:';

  @override
  String get notificationNew => 'Mới';

  @override
  String get notificationNewFriendRequest => 'Bạn có lời mời kết bạn mới';

  @override
  String get notificationOlder => 'Trước đó';

  @override
  String get notificationPendingPostNotFound =>
      'Không tìm thấy bài viết đang chờ duyệt';

  @override
  String get notificationPostedWithYou => 'đã đăng một bài viết có mặt bạn';

  @override
  String get notificationPostApprovedMessage =>
      'bài viết của bạn đã được duyệt';

  @override
  String get notificationPostPendingMessage => 'đã gửi bài viết đang chờ duyệt';

  @override
  String get notificationPostRejectedMessage =>
      'bài viết của bạn đã bị từ chối';

  @override
  String get notificationPostReportTitle => 'Chi tiết báo cáo bài viết';

  @override
  String get notificationPublicJoinMessage => 'đã tham gia cộng đồng';

  @override
  String get notificationRefreshTooltip => 'Tải lại thông báo';

  @override
  String get notificationReactedToYourComment =>
      'đã thả cảm xúc về bình luận của bạn:';

  @override
  String get notificationReactedToYourPost =>
      'đã bày tỏ cảm xúc về bài viết của bạn:';

  @override
  String get notificationReactedToYourStory =>
      'đã bày tỏ cảm xúc về tin của bạn của bạn:';

  @override
  String get notificationReportRejected => 'Báo cáo đã bị từ chối';

  @override
  String get notificationReportRejectedReason =>
      'Báo cáo không đủ điều kiện xử lý.';

  @override
  String get notificationReportReviewed => 'Báo cáo đã được xử lý';

  @override
  String get notificationReportReviewedReason =>
      'Báo cáo đã được quản trị viên xem xét.';

  @override
  String notificationReportStatus(String status) {
    return 'Trạng thái: $status';
  }

  @override
  String get notificationTaggedYouInPost => 'đã gắn thẻ bạn trong một bài viết';

  @override
  String get notificationTitle => 'Thông báo';

  @override
  String get postAddCaptionHint => 'Thêm chú thích...';

  @override
  String get postAddPhotoVideo => 'Thêm ảnh/video';

  @override
  String get postAddToCollection => 'Thêm vào bộ sưu tập';

  @override
  String get postAnd => 'và';

  @override
  String get postCamera => 'Camera';

  @override
  String postShareCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lượt chia sẻ',
      one: '1 lượt chia sẻ',
      zero: '0 lượt chia sẻ',
    );
    return '$_temp0';
  }

  @override
  String get postCameraErrorTitle => 'Lỗi camera';

  @override
  String postCameraInitFailed(String error) {
    return 'Không thể khởi tạo camera: $error';
  }

  @override
  String get postCameraPermissionMessage =>
      'Vui lòng cấp quyền camera trong cài đặt để tiếp tục.';

  @override
  String get postCameraPermissionTitle => 'Cần quyền camera';

  @override
  String postCannotAddPhoto(String error) {
    return 'Không thể thêm ảnh: $error';
  }

  @override
  String get postCheckIn => 'Check in';

  @override
  String get postChooseFolder => 'Chọn thư mục';

  @override
  String get postChooseLayout => 'Chọn bố cục';

  @override
  String get postCollectionNameHint => 'Tên bộ sưu tập';

  @override
  String get postContentOrPhotoRequired =>
      'Vui lòng nhập nội dung hoặc thêm ảnh/video';

  @override
  String get postCreateCollectionTitle => 'Tạo bộ sưu tập';

  @override
  String postCreateGenericError(String error) {
    return 'Đã xảy ra lỗi khi tạo bài viết: $error';
  }

  @override
  String get postCreateTitle => 'Tạo bài viết';

  @override
  String get postCreating => 'Đang tạo bài viết...';

  @override
  String postCreatingWithProgress(num progress) {
    return 'Đang tạo bài viết... $progress%';
  }

  @override
  String get postDeleteConfirmMessage => 'Bạn có chắc muốn xóa bài viết này?';

  @override
  String get postDeleteFailed => 'Không thể xóa bài viết';

  @override
  String get postDeleteTitle => 'Xóa bài viết';

  @override
  String get postDeleted => 'Đã xóa bài viết';

  @override
  String get postEdit => 'Chỉnh sửa';

  @override
  String postEditCount(num count) {
    return 'Chỉnh sửa ($count)';
  }

  @override
  String get postEditPrivacy => 'Chỉnh sửa quyền riêng tư';

  @override
  String get privacyPostQuestion => 'Ai có thể xem bài viết của bạn?';

  @override
  String get privacyPostPublic => 'Công khai';

  @override
  String get privacyPostPublicDescription => 'Bất kỳ ai ở trên hoặc ngoài App';

  @override
  String get privacyPostFriends => 'Bạn bè';

  @override
  String get privacyPostFriendsDescription => 'Bạn bè của bạn trên App';

  @override
  String get privacyPostFriendsExcept => 'Bạn bè ngoại trừ...';

  @override
  String get privacyPostFriendsExceptDescription =>
      'Ẩn bài viết khỏi một số bạn bè';

  @override
  String get privacyPostSpecificFriends => 'Bạn bè cụ thể';

  @override
  String get privacyPostSpecificFriendsDescription =>
      'Chỉ hiển thị với một vài bạn';

  @override
  String get privacyPostOnlyMe => 'Chỉ mình tôi';

  @override
  String get privacyPostOnlyMeDescription => 'Chỉ mình tôi';

  @override
  String get privacyPostEditDescription =>
      'Bạn có thể thay đổi ai có thể xem bài viết này.';

  @override
  String privacyPostCreateDescription(String defaultPrivacy) {
    return 'Bài viết của bạn sẽ hiển thị trên Bảng feed, trang cá nhân và trong kết quả tìm kiếm.\n\nTùy đối tượng mặc định là $defaultPrivacy, nhưng bạn có thể thay đổi đối tượng của riêng bài viết này.';
  }

  @override
  String get privacyPostNoOneSelected => 'Chưa chọn ai';

  @override
  String get privacyPostOnePerson => '1 người';

  @override
  String get privacyPostFallbackUser => 'Người dùng';

  @override
  String privacyPostAndOthers(String firstNames, num count) {
    return '$firstNames và $count người khác';
  }

  @override
  String get privacyPostHideFromTitle => 'Ẩn bài viết với';

  @override
  String get privacyPostSelectPeopleToShare => 'Chọn người để chia sẻ bài viết';

  @override
  String get privacyPostCurrentDefault => 'Đây là đối tượng mặc định hiện tại';

  @override
  String get privacyPostSetAsDefault => 'Đặt làm đối tượng mặc định';

  @override
  String get privacyPostUpdated => 'Đã cập nhật quyền riêng tư';

  @override
  String get privacyPostUpdateFailed => 'Không thể cập nhật quyền riêng tư';

  @override
  String postErrorPrefix(String message) {
    return 'Lỗi: $message';
  }

  @override
  String get postFeeling => 'Cảm xúc';

  @override
  String get postFeelingActivity => 'Cảm xúc/Hoạt động';

  @override
  String get postGeneric => 'Bài viết';

  @override
  String get postGenericError => 'Đã xảy ra lỗi';

  @override
  String get postHiddenFromProfile => 'Đã ẩn khỏi trang cá nhân';

  @override
  String get postHideAction => 'Ẩn';

  @override
  String get postHideFromProfileMessage =>
      'Bài viết này sẽ không hiển thị trên trang cá nhân của bạn.';

  @override
  String get postHideFromProfileTitle => 'Ẩn khỏi trang cá nhân';

  @override
  String get postJustNow => 'Vừa xong';

  @override
  String get postLabel => 'Bài viết';

  @override
  String get postLayoutClassic => 'Cổ điển';

  @override
  String get postLayoutColumn => 'Cột';

  @override
  String get postLayoutFrame => 'Khung';

  @override
  String get postLibrary => 'Thư viện';

  @override
  String get postLiveVideo => 'Video trực tiếp';

  @override
  String get postLoadingVideo => 'Đang tải video...';

  @override
  String get postLocation => 'Vị trí';

  @override
  String postMediaItemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mục',
      one: '1 mục',
      zero: '0 mục',
    );
    return '$_temp0';
  }

  @override
  String get postMention => 'Nhắc đến';

  @override
  String get postMore => 'Khác';

  @override
  String get postMusic => 'Âm nhạc';

  @override
  String postMutualFriends(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bạn chung',
      one: '1 bạn chung',
      zero: 'Không có bạn chung',
    );
    return '$_temp0';
  }

  @override
  String get postNoComments => 'Chưa có bình luận';

  @override
  String get postNoReactions => 'Chưa có lượt bày tỏ cảm xúc';

  @override
  String get postNotFound => 'Không tìm thấy bài viết';

  @override
  String get postOnlyMe => 'Chỉ mình tôi';

  @override
  String postOtherPeople(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count người khác',
      one: '1 người khác',
    );
    return '$_temp0';
  }

  @override
  String get postPeopleReactedTitle => 'Những người đã bày tỏ cảm xúc';

  @override
  String get postPhoto => 'Ảnh';

  @override
  String get postPhotoLibrary => 'Thư viện ảnh';

  @override
  String get postPhotoPermissionRequired =>
      'Vui lòng cấp quyền truy cập ảnh để tiếp tục.';

  @override
  String get postPhotoVideo => 'Ảnh/Video';

  @override
  String postPlayVideoFailed(String error) {
    return 'Không thể phát video: $error';
  }

  @override
  String get postPoll => 'Thăm dò ý kiến';

  @override
  String postReactedFirstUserAndOthers(String firstUser, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count người khác',
      one: '1 người khác',
    );
    return '$firstUser và $_temp0';
  }

  @override
  String postReactedYouAndOthers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count người khác',
      one: '1 người khác',
    );
    return 'Bạn và $_temp0';
  }

  @override
  String get postRecording => 'Đang quay';

  @override
  String get postRemoveTagAction => 'Gỡ thẻ';

  @override
  String get postRemoveTagConfirmMessage =>
      'Bạn có chắc muốn gỡ thẻ khỏi bài viết này?';

  @override
  String get postRemoveTagTitle => 'Gỡ thẻ';

  @override
  String get postRemovedTag => 'Đã gỡ thẻ';

  @override
  String get postReport => 'Báo cáo';

  @override
  String get postReportDescriptionHint => 'Mô tả thêm về vấn đề';

  @override
  String get postReportDescriptionLabel => 'Mô tả';

  @override
  String get postReportDetailReason => 'Lý do chi tiết';

  @override
  String get postReportFailed => 'Không thể gửi báo cáo';

  @override
  String get postReportIntro =>
      'Hãy chọn lý do phù hợp để chúng tôi xem xét bài viết này.';

  @override
  String get postReportQuickReason => 'Lý do nhanh';

  @override
  String get postReportReasonHarassment => 'Quấy rối hoặc bắt nạt';

  @override
  String get postReportReasonHint => 'Chọn lý do';

  @override
  String get postReportReasonMisinformation => 'Thông tin sai lệch';

  @override
  String get postReportReasonOffensive => 'Nội dung phản cảm';

  @override
  String get postReportReasonRequired => 'Vui lòng chọn lý do báo cáo';

  @override
  String get postReportReasonSpam => 'Spam';

  @override
  String get postReportReasonViolence => 'Bạo lực hoặc nguy hiểm';

  @override
  String get postReportSelfNotAllowed =>
      'Bạn không thể báo cáo bài viết của chính mình';

  @override
  String get postReportSuccess => 'Đã gửi báo cáo';

  @override
  String get postReportTitle => 'Báo cáo bài viết';

  @override
  String get postSave => 'Lưu';

  @override
  String get postSaveFailed => 'Không thể lưu bài viết';

  @override
  String get postSaved => 'Đã lưu';

  @override
  String postSavedToCollection(String collection) {
    return 'Đã lưu vào $collection';
  }

  @override
  String get postSeeOriginal => 'Xem bản gốc';

  @override
  String get postSeeTranslation => 'Xem bản dịch';

  @override
  String get postSelectAllowedFriendsRequired =>
      'Vui lòng chọn bạn bè được phép xem';

  @override
  String get postSelectHiddenFriendsRequired => 'Vui lòng chọn bạn bè muốn ẩn';

  @override
  String postSelectedPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ảnh đã chọn',
      one: '1 ảnh đã chọn',
      zero: 'Chưa chọn ảnh',
    );
    return '$_temp0';
  }

  @override
  String get postSendReport => 'Gửi báo cáo';

  @override
  String get postShare => 'Chia sẻ';

  @override
  String get postShowAction => 'Hiển thị';

  @override
  String get postShowOnProfileMessage =>
      'Bài viết này sẽ hiển thị trên trang cá nhân của bạn.';

  @override
  String get postShowOnProfileTitle => 'Hiển thị trên trang cá nhân';

  @override
  String get postShownOnProfile => 'Đã hiển thị trên trang cá nhân';

  @override
  String get postSubmit => 'Đăng';

  @override
  String get postTag => 'Gắn thẻ';

  @override
  String get postTagFriends => 'Gắn thẻ bạn bè';

  @override
  String get postTagPeople => 'Gắn thẻ người khác';

  @override
  String get postTagUpdateFailed => 'Không thể cập nhật thẻ';

  @override
  String postTagUpdateFailedWithMessage(String message) {
    return 'Không thể cập nhật thẻ: $message';
  }

  @override
  String get postTagUpdated => 'Đã cập nhật thẻ';

  @override
  String get postTranslateError => 'Không thể dịch nội dung';

  @override
  String get postTranslateFailed => 'Dịch thất bại';

  @override
  String get postUnknownTime => 'Không rõ thời gian';

  @override
  String get postUnsave => 'Bỏ lưu';

  @override
  String get postUnsaveSuccess => 'Đã bỏ lưu bài viết';

  @override
  String get postUnsupportedVideoType => 'Định dạng video không được hỗ trợ';

  @override
  String get postVideo => 'Video';

  @override
  String postViewAllComments(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bình luận',
      one: '1 bình luận',
    );
    return 'Xem tất cả $_temp0';
  }

  @override
  String get postWith => 'cùng';

  @override
  String get postWriteSomethingHint => 'Bạn đang nghĩ gì?';

  @override
  String get postYourPost => 'Bài viết của bạn';

  @override
  String get commonCopy => 'Sao chép';

  @override
  String get commonContentCopied => 'Đã sao chép nội dung';

  @override
  String get commonEdit => 'Chỉnh sửa';

  @override
  String get commonLinkCopied => 'Đã sao chép liên kết';

  @override
  String get commonRemove => 'Gỡ';

  @override
  String get commonSeeMore => 'Xem thêm';

  @override
  String commonSendWithCount(num count) {
    return 'Gửi ($count)';
  }

  @override
  String get commonUpdate => 'Cập nhật';

  @override
  String get commonViewAll => 'Xem tất cả';

  @override
  String get searchHint => 'Tìm kiếm';

  @override
  String get searchUserHint => 'Tìm kiếm người dùng...';

  @override
  String get searchEnterKeyword => 'Nhập từ khóa để tìm kiếm';

  @override
  String get searchNoResults => 'Không tìm thấy kết quả nào';

  @override
  String get searchRecent => 'Tìm kiếm gần đây';

  @override
  String get searchHistory => 'Lịch sử';

  @override
  String get searchNoHistory => 'Chưa có lịch sử tìm kiếm';

  @override
  String get searchNoRecent => 'Chưa có tìm kiếm gần đây';

  @override
  String get searchClearAll => 'Xóa tất cả';

  @override
  String get searchClearAllUppercase => 'XÓA TẤT CẢ';

  @override
  String get searchClearAllHistoryTitle => 'Xóa tất cả lịch sử tìm kiếm';

  @override
  String get searchClearAllHistoryConfirm =>
      'Bạn có chắc chắn muốn xóa tất cả lịch sử tìm kiếm? Hành động này không thể hoàn tác.';

  @override
  String get searchClearAllHistoryConfirmShort =>
      'Bạn có chắc chắn muốn xóa tất cả lịch sử tìm kiếm?';

  @override
  String get searchEditHistory => 'Chỉnh sửa lịch sử tìm kiếm';

  @override
  String get searchHistoryLocalOnlyDescription =>
      'Các chi tiết thay đổi sẽ chỉ áp dụng cho danh sách tìm kiếm gần đây, thuộc phần lịch sử trên thiết bị này.';

  @override
  String get searchHistoryWillAppear =>
      'Các tìm kiếm gần đây sẽ xuất hiện ở đây';

  @override
  String get searchRemoveFromHistory => 'Gỡ khỏi lịch sử tìm kiếm của bạn.';

  @override
  String get searchPinThis => 'Ghim nội dung tìm kiếm này';

  @override
  String get searchPinLimit =>
      'Bạn chỉ có thể ghim 3 nội dung tìm kiếm cùng lúc.';

  @override
  String get friendNoSearchResults => 'Không tìm thấy bạn bè';

  @override
  String get friendLoadFailed => 'Lỗi khi tải danh sách bạn bè';

  @override
  String get commentReply => 'Trả lời';

  @override
  String commentViewReplies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count phản hồi',
      one: '1 phản hồi',
    );
    return 'Xem $_temp0';
  }

  @override
  String get commentEditTitle => 'Chỉnh sửa bình luận';

  @override
  String get commentEditHint => 'Nhập nội dung mới...';

  @override
  String get commentDeleteTitle => 'Xóa bình luận';

  @override
  String get commentDeleteConfirm =>
      'Bạn có chắc chắn muốn xóa vĩnh viễn bình luận này không?';

  @override
  String get commentViewEditHistory => 'Xem lịch sử chỉnh sửa';

  @override
  String get commentShare => 'Chia sẻ bình luận';

  @override
  String get commentReactionsTitle => 'Biểu cảm về bình luận';

  @override
  String get commentEmptyTitle => 'Chưa có bình luận nào';

  @override
  String get commentEmptySubtitle =>
      'Hãy là người đầu tiên bình luận về bài viết này';

  @override
  String get commentWriteFirst => 'Viết bình luận đầu tiên';

  @override
  String get commentReplyingPrefix => 'Đang trả lời ';

  @override
  String get commentYourComment => 'bình luận của bạn';

  @override
  String get commentWriteReplyHint => 'Viết phản hồi...';

  @override
  String commentReplyToHint(String user) {
    return 'Trả lời $user...';
  }

  @override
  String get commentWriteHint => 'Viết bình luận...';

  @override
  String get commentEditHistoryTitle => 'Lịch sử chỉnh sửa';

  @override
  String get commentNoEditHistory => 'Chưa có lịch sử chỉnh sửa';

  @override
  String get commentCurrentVersion => 'Phiên bản hiện tại';

  @override
  String commentEditVersion(num version, String time) {
    return 'Lần chỉnh sửa $version • $time';
  }

  @override
  String get commentOldContent => 'Nội dung cũ';

  @override
  String get commentNewContent => 'Nội dung mới';

  @override
  String get storyPrivacyTitle => 'Quyền riêng tư của tin';

  @override
  String get storyPrivacyQuestion => 'Ai có thể xem tin của bạn?';

  @override
  String get storyPrivacyVisibleFor24h =>
      'Tin của bạn sẽ hiển thị trong 24 giờ.';

  @override
  String get storyPrivacyPublic => 'Công khai';

  @override
  String get storyPrivacyPublicDescription => 'Bất kỳ ai';

  @override
  String get storyPrivacyFriends => 'Bạn bè';

  @override
  String get storyPrivacyFriendsDescription => 'Chỉ bạn bè của bạn';

  @override
  String get storyPrivacyHideFrom => 'Ẩn tin với';

  @override
  String get storyPrivacyCustom => 'Tùy chỉnh';

  @override
  String get storyPrivacyNoOneSelected => 'Chưa chọn ai';

  @override
  String get storyPrivacyOnePerson => '1 người';

  @override
  String storyPrivacyAndOthers(String firstNames, num count) {
    return '$firstNames và $count người khác';
  }

  @override
  String get storySelectPeopleToShare => 'Chọn người để chia sẻ tin';

  @override
  String get storyPrivacyUpdated => 'Đã cập nhật quyền riêng tư';

  @override
  String get storyPrivacyUpdateFailed => 'Không thể cập nhật quyền riêng tư';

  @override
  String get storyDeleteTitle => 'Xóa tin';

  @override
  String get storyDeleteConfirm => 'Bạn có chắc chắn muốn xóa tin này không?';

  @override
  String get storyDeleted => 'Đã xóa tin';

  @override
  String get storyDeleteFailed => 'Không thể xóa tin';

  @override
  String get storyEditPrivacy => 'Chỉnh sửa quyền riêng tư của tin';

  @override
  String get storySendWithMessenger => 'Gửi bằng Messenger';

  @override
  String get storySavePhoto => 'Lưu ảnh';

  @override
  String get storyArchivePhoto => 'Lưu trữ ảnh';

  @override
  String get storyArchivePhotoDescription =>
      'Gỡ ảnh khỏi tin và lưu vào kho lưu trữ.';

  @override
  String get storyDeletePhoto => 'Xóa ảnh';

  @override
  String get storyCopyShareLink => 'Sao chép liên kết để chia sẻ tin này';

  @override
  String storyLinkVisibility(String user) {
    return 'Tin sẽ hiển thị với đối tượng của $user trong 24 giờ.';
  }

  @override
  String get storyMusic => 'Nhạc';

  @override
  String get storyMusicLoadFailed =>
      'Không tải được danh sách nhạc. Vui lòng thử lại.';

  @override
  String get storyMusicSearchFailed =>
      'Không tìm thấy kết quả. Vui lòng thử lại.';

  @override
  String get storyMusicForYou => 'Dành cho bạn';

  @override
  String get storyMusicSearchHint => 'Tìm kiếm nhạc';

  @override
  String get storyMusicNoSearchResults => 'Không tìm thấy bài hát phù hợp.';

  @override
  String get storyMusicEmpty => 'Không có bài hát nào.';

  @override
  String get storyCreateSuccess => 'Tạo tin thành công';

  @override
  String get storyImageOnlyEdit => 'Chỉ có thể chỉnh sửa ảnh';

  @override
  String get storyCannotReadDeviceFile => 'Không thể đọc file từ thiết bị';

  @override
  String storyImageEditFailed(String error) {
    return 'Lỗi khi chỉnh sửa ảnh: $error';
  }

  @override
  String get storyText => 'Văn bản';

  @override
  String get storyPhotoGroup => 'Nhóm ảnh';

  @override
  String get storySelectMultipleFiles => 'Chọn nhiều file';

  @override
  String get storyLibrary => 'Thư viện';

  @override
  String get storyChooseFolder => 'Chọn thư mục';

  @override
  String storyItemCount(num count) {
    return '$count mục';
  }

  @override
  String get storyLibraryPermissionRequired =>
      'Cần quyền truy cập thư viện để hiển thị ảnh/video.';

  @override
  String get storyNoMediaInLibrary => 'Chưa có ảnh/video trong thư viện.';

  @override
  String get storyReactedPeople => 'Người đã bày tỏ cảm xúc';

  @override
  String get storyNoReactions => 'Chưa có phản ứng nào';

  @override
  String get chatMessageHint => 'Nhắn tin...';

  @override
  String get chatShareFile => 'Chia sẻ file';

  @override
  String get chatAiImages => 'Hình ảnh AI';

  @override
  String get chatAiImagesInDevelopmentMessage =>
      'Tính năng Hình ảnh AI đang phát triển';

  @override
  String chatMembersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thành viên',
      one: '1 thành viên',
    );
    return '$_temp0';
  }

  @override
  String get chatGroupChat => 'Nhóm chat';

  @override
  String get chatOnline => 'Đang online';

  @override
  String get chatOffline => 'Ngoại tuyến';

  @override
  String get chatActiveNow => 'Đang hoạt động';

  @override
  String chatAndOtherMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count người khác',
      one: '1 người khác',
    );
    return 'và $_temp0';
  }

  @override
  String get chatViewGroupInfo => 'Xem thông tin nhóm';

  @override
  String get chatViewProfile => 'Xem trang cá nhân';

  @override
  String get chatFriendsOnFacebook => 'Các bạn là bạn bè trên Facebook';

  @override
  String chatYouAndFriendAreFriends(String name) {
    return 'Bạn và $name hiện đã là bạn bè.';
  }

  @override
  String get chatThisFriend => 'bạn này';

  @override
  String get voiceEffectTitle => 'Chỉnh sửa giọng nói';

  @override
  String get voiceEffectLoading => 'Đang chuyển giọng, vui lòng đợi...';

  @override
  String voiceEffectApplied(String voice) {
    return 'Đã áp dụng giọng: $voice';
  }

  @override
  String get voiceEffectOriginal => 'Gốc';

  @override
  String get voiceEffectFemale => 'Con gái';

  @override
  String get voiceEffectDeep => 'Trầm';

  @override
  String get voiceEffectBaby => 'Em bé';

  @override
  String get voiceEffectRobot => 'Robot';

  @override
  String get voiceEffectDemon => 'Ác quỷ';

  @override
  String get chatGroupLink => 'Liên kết nhóm';

  @override
  String get chatDeleteChat => 'Xóa đoạn chat';

  @override
  String get chatConversationInfo => 'Thông tin về đoạn chat';

  @override
  String get chatViewGroupMembers => 'Xem thành viên trong nhóm';

  @override
  String get chatLeaveConversation => 'Rời khỏi đoạn chat';

  @override
  String get chatFeedbackAndReportConversation =>
      'Góp ý và báo cáo cuộc trò chuyện';

  @override
  String get chatReadReceipts => 'Thông báo đã đọc';

  @override
  String get chatTypingIndicators => 'Chỉ báo đang nhập';

  @override
  String get chatMicrophonePermissionDenied =>
      'Không có quyền truy cập microphone';

  @override
  String get chatStartRecordingFailed => 'Lỗi khi bắt đầu ghi âm';

  @override
  String get chatDownloadingFile => 'Đang tải file...';

  @override
  String get chatNoAppToOpenFile => 'Không tìm thấy ứng dụng để mở file này';

  @override
  String chatOpenFileFailed(String error) {
    return 'Không thể mở file: $error';
  }

  @override
  String get chatLoadingEditHistory => 'Đang tải lịch sử chỉnh sửa...';

  @override
  String get chatPinInDevelopment => 'Tính năng ghim tin nhắn đang phát triển';

  @override
  String get chatForwardInDevelopment =>
      'Tính năng chuyển tiếp đang phát triển';

  @override
  String get chatReportInDevelopment =>
      'Tính năng báo cáo tin nhắn đang phát triển';

  @override
  String get chatAiImageInDevelopment =>
      'Tính năng tạo hình ảnh AI đang phát triển';

  @override
  String get chatMissingConversationForReaction =>
      'Không thể thêm reaction: thiếu conversation ID';

  @override
  String get chatMessageCopied => 'Đã sao chép tin nhắn';

  @override
  String get chatGpsDisabledOpeningSettings =>
      'GPS đang tắt. Đang mở Cài đặt định vị...';

  @override
  String get chatLocationPermissionDenied =>
      'Bạn chưa cấp quyền truy cập vị trí.';

  @override
  String get chatLocationPermissionDeniedForever =>
      'Quyền vị trí bị từ chối vĩnh viễn. Đang mở Cài đặt ứng dụng...';

  @override
  String get chatSendLocationMessage => 'Gửi vị trí';

  @override
  String get chatCurrentLocation => 'Vị trí hiện tại';

  @override
  String chatGetLocationFailed(String error) {
    return 'Không thể lấy vị trí: $error';
  }

  @override
  String get chatSendingFile => 'Đang gửi file...';

  @override
  String get chatPhotoPermissionTitle => 'Quyền truy cập ảnh';

  @override
  String get chatPhotoPermissionMessage =>
      'Ứng dụng cần quyền truy cập ảnh để hiển thị ảnh từ thư viện. Vui lòng cấp quyền trong Cài đặt.';

  @override
  String get chatPhotoPermissionRequired =>
      'Cần quyền truy cập ảnh để hiển thị thư viện';

  @override
  String chatLoadPhotosFailed(String error) {
    return 'Lỗi khi tải ảnh: $error';
  }

  @override
  String get chatCameraPermissionMessage =>
      'Ứng dụng cần quyền truy cập camera để chụp ảnh.';

  @override
  String chatOpenCameraFailed(String error) {
    return 'Lỗi khi mở camera: $error';
  }

  @override
  String get chatCapturedPhoto => 'Ảnh vừa chụp';

  @override
  String get chatTapSendToShare => 'Nhấn gửi để chia sẻ';

  @override
  String get chatMissingConversationForPhoto =>
      'Không thể gửi ảnh: thiếu conversation ID';

  @override
  String chatSendPhotoFailed(String error) {
    return 'Lỗi khi gửi ảnh: $error';
  }

  @override
  String get chatCannotProcessPhoto => 'Không thể xử lý ảnh';

  @override
  String get chatMissingConversationForFile =>
      'Không thể gửi file: thiếu conversation ID';

  @override
  String chatPickFileFailed(String error) {
    return 'Lỗi khi chọn file: $error';
  }

  @override
  String chatStartCallFailed(String error) {
    return 'Không thể thực hiện cuộc gọi: $error';
  }

  @override
  String chatCreateConversationFailed(String message) {
    return 'Lỗi tạo cuộc trò chuyện: $message';
  }

  @override
  String get chatDeletedForEveryone => 'Đã xóa tin nhắn cho mọi người';

  @override
  String get chatDeletedForMe => 'Đã xóa tin nhắn cho tôi';

  @override
  String get chatOriginalMessageNotFound => 'Không tìm thấy tin nhắn gốc';

  @override
  String chatLoadMessagesFailed(String message) {
    return 'Lỗi khi tải tin nhắn: $message';
  }

  @override
  String get chatMessagePlaceholder => '[Tin nhắn]';

  @override
  String get chatMyself => 'chính mình';

  @override
  String chatReplyingTo(String name) {
    return 'Trả lời $name';
  }

  @override
  String get chatAudioMessage => '[Tin nhắn thoại]';

  @override
  String get chatPhoto => '[Ảnh]';

  @override
  String get chatFile => '[Tệp tin]';

  @override
  String get chatAttachment => '[Đính kèm]';

  @override
  String get chatNoPhotos => 'Không có ảnh nào';

  @override
  String get chatUserNotFound =>
      'Không tìm thấy người dùng. Vui lòng đăng nhập lại.';

  @override
  String chatFindConversationFailed(String error) {
    return 'Lỗi khi tìm cuộc trò chuyện: $error';
  }

  @override
  String chatConversationError(String message) {
    return 'Lỗi cuộc trò chuyện: $message';
  }

  @override
  String chatConversationsError(String message) {
    return 'Lỗi danh sách cuộc trò chuyện: $message';
  }

  @override
  String get chatNoFriendsToStart =>
      'Chưa có bạn bè. Hãy thêm bạn bè để bắt đầu nhắn tin!';

  @override
  String get chatSuggestedFriends => 'Bạn bè gợi ý để nhắn tin';

  @override
  String get chatNoConversations => 'Không có cuộc trò chuyện nào';

  @override
  String chatPickImageFailed(String error) {
    return 'Lỗi khi chọn ảnh: $error';
  }

  @override
  String get chatTakePhoto => 'Chụp ảnh';

  @override
  String get chatChooseFromLibrary => 'Chọn từ thư viện';

  @override
  String get chatDiscardGroupTitle => 'Hủy thao tác?';

  @override
  String get chatDiscardGroupMessage =>
      'Bạn có chắc chắn muốn hủy tạo nhóm chat không?';

  @override
  String get chatSelectAtLeastOnePerson => 'Vui lòng chọn ít nhất 1 người';

  @override
  String get chatUserInfoNotFound => 'Không tìm thấy thông tin người dùng';

  @override
  String chatCreateGroupFailed(String error) {
    return 'Lỗi khi tạo nhóm chat: $error';
  }

  @override
  String get chatNewGroup => 'Nhóm chat mới';

  @override
  String get chatGroupNameOptional => 'Tên nhóm (không bắt buộc)';

  @override
  String get chatSuggestions => 'Gợi ý';

  @override
  String get chatGroupName => 'Tên nhóm';

  @override
  String get chatCreateGroup => 'Tạo nhóm chat';

  @override
  String get chatPeopleYouMayKnow => 'Những người bạn có thể biết';

  @override
  String get chatNoFriendSuggestions => 'Hiện chưa có gợi ý bạn bè';

  @override
  String get chatDeleteMessageTitle => 'Xóa tin nhắn?';

  @override
  String get chatDeleteForEveryone => 'Xóa đối với mọi người';

  @override
  String get chatDeleteForMe => 'Xóa cho tôi';

  @override
  String get chatChangeGroupPhoto => 'Đổi ảnh nhóm';

  @override
  String get chatChoosePhoto => 'Chọn ảnh';

  @override
  String get chatChangeName => 'Đổi tên';

  @override
  String get chatCreatePhoto => 'Tạo ảnh';

  @override
  String get chatTheme => 'Chủ đề';

  @override
  String get chatNickname => 'Biệt danh';

  @override
  String get chatShareContactInfo => 'Chia sẻ thông tin liên hệ';

  @override
  String get chatViewMediaFilesLinks =>
      'Xem file phương tiện, file và liên kết';

  @override
  String get chatPinnedMessages => 'Tin nhắn đã ghim';

  @override
  String get chatSearchInConversation => 'Tìm kiếm trong cuộc trò chuyện';

  @override
  String get chatDeleteConversation => 'Xóa cuộc trò chuyện';

  @override
  String get chatChangeGroupName => 'Đổi tên nhóm';

  @override
  String get chatGroupNameChanged => 'Đã đổi tên nhóm thành công';

  @override
  String chatChangeGroupNameFailed(String error) {
    return 'Không thể đổi tên nhóm: $error';
  }

  @override
  String get chatVideoCall => 'Cuộc gọi video';

  @override
  String get chatAudioCall => 'Cuộc gọi thoại';

  @override
  String get chatMissedCall => 'Nhỡ cuộc gọi';

  @override
  String get chatVideoCallMissed => 'Đã bỏ lỡ cuộc gọi video';

  @override
  String get chatYouDeletedMessage => 'Bạn đã xóa tin nhắn này';

  @override
  String chatUserDeletedMessage(String user) {
    return '$user đã xóa tin nhắn này';
  }

  @override
  String chatUnreadMessages(num count) {
    return '$count tin nhắn chưa đọc';
  }

  @override
  String get chatEdited => 'Đã chỉnh sửa';

  @override
  String chatSentAt(String time) {
    return 'Đã gửi $time';
  }

  @override
  String get chatMore => 'Khác';

  @override
  String get chatPin => 'Ghim';

  @override
  String get chatForward => 'Chuyển tiếp';

  @override
  String get chatCreateAIImage => 'Tạo hình ảnh AI';

  @override
  String get chatNoReactions => 'Chưa có cảm xúc nào';

  @override
  String get chatAnonymousUser => 'Người dùng ẩn danh';

  @override
  String get chatAddMember => 'Thêm thành viên';

  @override
  String get chatMuteNotifications => 'Tắt thông báo';

  @override
  String get communityInviteAction => 'Mời';

  @override
  String get messageDownloadingPhoto => 'Đang tải ảnh xuống...';

  @override
  String get messageSavePhotoSuccess => 'Đã lưu ảnh vào thư viện';

  @override
  String get messageSavePhotoError => 'Lỗi khi lưu ảnh';

  @override
  String get commonMaybeLater => 'Để sau';

  @override
  String get faceRecognitionSetup => 'Thiết lập nhận diện khuôn mặt';

  @override
  String get faceRecognitionDescription =>
      'Sử dụng dữ liệu khuôn mặt của bạn để bật các tính năng AI thông minh và bảo vệ tài khoản an toàn hơn.';

  @override
  String get faceRecognitionSmartSuggestions => 'Gợi ý bạn bè thông minh';

  @override
  String get faceRecognitionAutoTagDescription =>
      'AI tự động nhận diện khuôn mặt bạn trong ảnh và đề xuất gắn thẻ chính xác.';

  @override
  String get faceRecognitionAntiSpoofing => 'Chống giả mạo tài khoản';

  @override
  String get faceRecognitionAntiSpoofingDescription =>
      'Ngăn chặn người khác sử dụng hình ảnh của bạn để tạo tài khoản giả mạo.';

  @override
  String get faceRecognitionHighSecurity => 'Bảo mật tuyệt đối';

  @override
  String get faceRecognitionSecurityDescription =>
      'Dữ liệu khuôn mặt được mã hóa an toàn và không chia sẻ cho bên thứ ba.';

  @override
  String get faceRecognitionStartScan => 'Bắt đầu quét khuôn mặt';

  @override
  String get reactionLike => 'Thích';

  @override
  String get reactionLove => 'Yêu thích';

  @override
  String get reactionHaha => 'Haha';

  @override
  String get reactionWow => 'Wow';

  @override
  String get reactionSad => 'Buồn';

  @override
  String get reactionAngry => 'Phẫn nộ';

  @override
  String get storyAddMediaFromComputer => 'Thêm ảnh/video từ máy tính';

  @override
  String get storySelectFile => 'Chọn tệp';

  @override
  String get storyWebImageEditNotSupported =>
      'Chỉnh sửa ảnh chưa hỗ trợ lưu trên nền tảng Web';

  @override
  String get commonImageOnlySupport => 'Chỉ hỗ trợ file ảnh';
}
