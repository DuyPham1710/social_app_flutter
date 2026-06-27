import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class UserBannedPage extends StatelessWidget {
  final String banMessage;

  const UserBannedPage({super.key, required this.banMessage});

  Future<void> _contactSupport(BuildContext context) async {
    final l10n = context.l10n;
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@socialnetwork.com',
      queryParameters: {
        'subject': l10n.authBannedEmailSubject,
        'body': l10n.authBannedEmailBody(banMessage),
      },
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.authBannedEmailError)));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.authBannedGenericError(e.toString()))),
        );
      }
    }
  }

  void _handleLogout(BuildContext context) {
    // Dispatch logout event to reset state
    context.read<MenuBloc>().add(LogoutEvent());
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Try to parse the banMessage
    // Example: "Tài khoản của bạn đã bị khóa đến 24/06/2026 22:00:00. Lý do: Spam"
    String mainMessage = l10n.authBannedTemporaryFallback;
    String? banUntil;
    String? banReason;

    if (banMessage.contains("khóa đến")) {
      final parts = banMessage.split("khóa đến");
      if (parts.length > 1) {
        final timeReasonPart = parts[1].split(". Lý do:");
        banUntil = timeReasonPart[0].trim();
        if (timeReasonPart.length > 1) {
          banReason = timeReasonPart[1].trim();
        }
      }
    } else if (banMessage.contains("khóa vĩnh viễn")) {
      mainMessage = l10n.authBannedPermanentFallback;
      final parts = banMessage.split(". Lý do:");
      if (parts.length > 1) {
        banReason = parts[1].trim();
      }
    } else {
      mainMessage = banMessage;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.isWebOrDesktop ? 500 : double.infinity,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 24.rs(context),
                vertical: 32.rsh(context),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Beautiful Banned Lock Animation / Illustration
                  Container(
                    width: 140.rs(context),
                    height: 140.rs(context),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.redAccent.withOpacity(0.1)
                          : Colors.red.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.lock_shield_fill,
                        size: 72.rs(context),
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.rsh(context)),

                  // Title
                  Text(
                    l10n.authBannedTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26.rsp(context),
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16.rsh(context)),

                  // Main Description Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.rsr(context)),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16.rsr(context)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mainMessage,
                          style: TextStyle(
                            fontSize: 16.rsp(context),
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ),
                        if (banUntil != null) ...[
                          SizedBox(height: 12.rsh(context)),
                          Text(
                            l10n.authBannedUntil,
                            style: TextStyle(
                              fontSize: 13.rsp(context),
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4.rsh(context)),
                          Text(
                            banUntil,
                            style: TextStyle(
                              fontSize: 15.rsp(context),
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                        if (banReason != null && banReason.isNotEmpty) ...[
                          SizedBox(height: 16.rsh(context)),
                          Text(
                            l10n.authBannedReason,
                            style: TextStyle(
                              fontSize: 13.rsp(context),
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4.rsh(context)),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.rsr(context)),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black.withOpacity(0.2)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                8.rsr(context),
                              ),
                              border: Border.all(
                                color: isDark
                                    ? Colors.grey[800]!
                                    : Colors.grey[300]!,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              banReason,
                              style: TextStyle(
                                fontSize: 14.rsp(context),
                                color: isDark
                                    ? Colors.grey[300]
                                    : Colors.grey[800],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 24.rsh(context)),

                  // Notice Text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.rs(context)),
                    child: Text(
                      l10n.authBannedNotice,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.rsp(context),
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.rsh(context)),

                  // Contact Support Button (Primary Accent)
                  SizedBox(
                    width: double.infinity,
                    height: 52.rsh(context),
                    child: ElevatedButton.icon(
                      onPressed: () => _contactSupport(context),
                      icon: const Icon(
                        CupertinoIcons.mail_solid,
                        color: Colors.white,
                      ),
                      label: Text(
                        l10n.authBannedContactSupport,
                        style: TextStyle(
                          fontSize: 16.rsp(context),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.rsr(context)),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.rsh(context)),

                  // Logout/Back Button (Secondary Outline)
                  SizedBox(
                    width: double.infinity,
                    height: 52.rsh(context),
                    child: OutlinedButton.icon(
                      onPressed: () => _handleLogout(context),
                      icon: Icon(
                        CupertinoIcons.arrow_left_square_fill,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      label: Text(
                        l10n.authBannedLogout,
                        style: TextStyle(
                          fontSize: 16.rsp(context),
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.rsr(context)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
