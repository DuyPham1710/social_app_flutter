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
import 'package:social_app_fe/shared/component/button_custom.dart';
import 'package:social_app_fe/shared/component/textFormField_custom.dart';
import 'package:social_app_fe/shared/helpers/date_picker_widget.dart';
import 'package:social_app_fe/shared/helpers/show_dialog_success.dart';

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
      final gender = genderController.text.trim();
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

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final userId = args['id'];

    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoaded) {
              BlocProvider.of<AuthBloc>(context).add(AuthReset());
              showDialogSuccess(context, "Registration");
            } else if (state is AuthError) {
              final message = state.errorMessage ?? 'Đăng ký thất bại';
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
                          color: Colors.grey[600],
                        ),
                      ),

                      SizedBox(height: 50.h),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Personal Information",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      Text(
                        "Please fill the following information",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),

                      SizedBox(height: 40.h),

                      TextformfieldCustom(
                        label: "Full Name",
                        isPassword: false,
                        controller: fullNameController,
                        focusNode: fullNameFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Full Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      TextformfieldCustom(
                        label: "Phone Number",
                        isPassword: false,
                        controller: phoneNumberController,
                        focusNode: phoneNumberFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Phone Number';
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
                            label: "Date of Birth",
                            isPassword: false,
                            controller: dateOfBirthController,
                            focusNode: dateOfBirthFocusNode,
                            suffixIcon: Icon(
                              CupertinoIcons.calendar,
                              size: 20.sp,
                              color: dateOfBirthFocusNode.hasFocus
                                  ? AppColors.primary
                                  : Colors.grey,
                            ),
                            onTap: () async {
                              FocusScope.of(
                                context,
                              ).requestFocus(FocusNode()); // tắt bàn phím
                              final picked = await DatePickerWidget.show(
                                context,
                              );
                              if (picked != null) {
                                dateOfBirthController.text =
                                    "${picked.day}/${picked.month}/${picked.year}";
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Date of Birth';
                              }
                              return null;
                            },
                          ),

                          TextformfieldCustom(
                            width: 150.w,
                            label: "Gender",
                            isPassword: false,
                            controller: genderController,
                            focusNode: genderFocusNode,
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              size: 20.sp,
                              color: genderFocusNode.hasFocus
                                  ? AppColors.primary
                                  : Colors.grey,
                            ),
                            onTap: () async {
                              FocusScope.of(
                                context,
                              ).requestFocus(FocusNode()); // tắt bàn phím
                              final gender = await showModalBottomSheet<String>(
                                context: context,
                                builder: (context) {
                                  return ModalGender();
                                },
                              );
                              if (gender != null) {
                                genderController.text = gender;
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Gender';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      TextformfieldCustom(
                        label: "Bio",
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
                              onPressed: () =>
                                  _onInfoSubmitted(context, userId),
                              text: "Continue",
                            ),

                      SizedBox(height: 24.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an Account? ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              "Sign in",
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
      ),
    );
  }
}
