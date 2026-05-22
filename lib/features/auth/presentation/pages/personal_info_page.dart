import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/ui_utils.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_state.dart';
import 'package:social_app_fe/features/auth/presentation/widgets/modal_gender.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/component/button_custom.dart';
import 'package:social_app_fe/shared/component/textFormField_custom.dart';
import 'package:social_app_fe/shared/helpers/date_picker_widget.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController dateOfBirthController = TextEditingController();

  final TextEditingController genderController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  String? _selectedGenderValue;

  final FocusNode fullNameFocusNode = FocusNode();

  final FocusNode phoneNumberFocusNode = FocusNode();

  final FocusNode dateOfBirthFocusNode = FocusNode();

  final FocusNode genderFocusNode = FocusNode();

  final FocusNode bioFocusNode = FocusNode();

  void _onInfoSubmitted(BuildContext context, String userId) {
    if (_formKey.currentState!.validate()) {
      final fullName = fullNameController.text.trim();
      final phoneNumber = phoneNumberController.text.trim();
      final dateOfBirth = dateOfBirthController.text
          .trim()
          .split('/') // tách chuỗi thành danh sách
          .reversed // đảo ngược danh sách
          .join('-'); // nối lại thành chuỗi với dấu '-'
      final gender = _selectedGenderValue ?? genderController.text.trim();
      final bio = bioController.text.trim();

      BlocProvider.of<AuthBloc>(context).add(
        UpdatePersonalInfoEvent(
          user: UserModel(
            userId: userId,
            fullName: fullName,
            phoneNumber: phoneNumber,
            dateOfBirth: dateOfBirth,
            gender: gender,
            bio: bio,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();
    bioController.dispose();
    fullNameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    dateOfBirthFocusNode.dispose();
    genderFocusNode.dispose();
    bioFocusNode.dispose();
    super.dispose();
  }

  String _localizedGenderLabel(BuildContext context, String gender) {
    switch (gender) {
      case 'Nam':
        return context.l10n.authGenderMale;
      case 'Nữ':
        return context.l10n.authGenderFemale;
      case 'Khác':
        return context.l10n.authGenderOther;
      default:
        return gender;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final userId = args['id'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoaded && state.flowType == 'update_personal_info') {
            BlocProvider.of<AuthBloc>(context).add(AuthReset());
            // Navigate to face registration page (instead of login)
            Navigator.pushReplacementNamed(
              context,
              '/face-registration',
              arguments: {'userId': userId},
            );
          } else if (state is AuthError &&
              state.flowType == 'update_personal_info') {
            final message =
                state.errorMessage ??
                context.l10n.authUpdatePersonalInfoFailed;
            UIUtils.showErrorMessage(context, message);
          }
        },

        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        CupertinoIcons.back,
                        color: AppColors.unselectedIcon,
                      ),
                    ),

                    SizedBox(height: 50.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.l10n.authPersonalInfoTitle,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      context.l10n.authPersonalInfoDescription,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 40.h),

                    TextformfieldCustom(
                      label: context.l10n.authFullName,
                      isPassword: false,
                      controller: fullNameController,
                      focusNode: fullNameFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.authEnterFullName;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    TextformfieldCustom(
                      label: context.l10n.authPhoneNumber,
                      isPassword: false,
                      controller: phoneNumberController,
                      focusNode: phoneNumberFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.authEnterPhoneNumber;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextformfieldCustom(
                          width: 150.w,
                          label: context.l10n.authDateOfBirth,
                          isPassword: false,
                          controller: dateOfBirthController,
                          focusNode: dateOfBirthFocusNode,
                          suffixIcon: Icon(
                            CupertinoIcons.calendar,
                            size: 20.sp,
                            color: dateOfBirthFocusNode.hasFocus
                                ? AppColors.primary
                                : AppColors.unselectedIcon,
                          ),
                          onTap: () async {
                            FocusScope.of(
                              context,
                            ).requestFocus(FocusNode()); // tắt bàn phím
                            final picked = await DatePickerWidget.show(context);
                            if (picked != null) {
                              dateOfBirthController.text =
                                  "${picked.day}/${picked.month}/${picked.year}";
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.l10n.authEnterDateOfBirth;
                            }
                            return null;
                          },
                        ),

                        TextformfieldCustom(
                          width: 150.w,
                          label: context.l10n.authGender,
                          isPassword: false,
                          controller: genderController,
                          focusNode: genderFocusNode,
                          suffixIcon: Icon(
                            Icons.arrow_drop_down,
                            size: 20.sp,
                            color: genderFocusNode.hasFocus
                                ? AppColors.primary
                                : AppColors.unselectedIcon,
                          ),
                          onTap: () async {
                            FocusScope.of(
                              context,
                            ).requestFocus(FocusNode()); // tắt bàn phím
                            final gender =
                                await showCupertinoModalPopup<String>(
                                  context: context,
                                  builder: (context) {
                                    return ModalGender();
                                  },
                                );
                            // final gender = await showModalBottomSheet<String>(
                            //   context: context,
                            //   builder: (context) {
                            //     return ModalGender();
                            //   },
                            // );
                            if (gender != null) {
                              _selectedGenderValue = gender;
                              genderController.text = _localizedGenderLabel(
                                context,
                                gender,
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.l10n.authEnterGender;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    TextformfieldCustom(
                      label: context.l10n.authBio,
                      isPassword: false,
                      controller: bioController,
                      focusNode: bioFocusNode,
                    ),

                    SizedBox(height: 70.h),

                    state is AuthLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : ButtonCustom(
                            onPressed: () => _onInfoSubmitted(context, userId),
                            text: context.l10n.authContinue,
                          ),

                    SizedBox(height: 24.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.authHasAccount,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            context.l10n.authLogin,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
