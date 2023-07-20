import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:office_attendence/common/custom_common_button.dart';
import 'package:office_attendence/services/change_password_service.dart';

import '../../common/field_title.dart';
import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';

class ChangePasswordView extends StatelessWidget {
  static const routeName = 'change_password_view';
  const ChangePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    TextEditingController passOldController = TextEditingController();
    TextEditingController passNewController = TextEditingController();
    ValueNotifier obscurePassCurrent = ValueNotifier(true);
    ValueNotifier obscurePassNew = ValueNotifier(true);
    ValueNotifier obscurePassCon = ValueNotifier(true);
    ValueNotifier isLoading = ValueNotifier(false);
    final GlobalKey<FormState> formKey = GlobalKey();
    return Scaffold(
        appBar: AppBar(
          title: Text("Change Password"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FieldTitle('Current Password'),
                // ValueListenableBuilder(
                //   valueListenable: obscurePassCurrent,
                //   builder: (context, value, child) => TextFormField(
                //       controller: passOldController,
                //       obscureText: obscurePassNew.value,
                //       textInputAction: TextInputAction.next,
                //       decoration: InputDecoration(
                //         hintText: 'Enter your current Password',
                //         prefixIcon: Padding(
                //           padding: const EdgeInsets.all(12),
                //           child:
                //               SvgPicture.asset('assets/icons/pass_prefix.svg'),
                //         ),
                //         suffixIcon: GestureDetector(
                //           onTap: () => obscurePassCurrent.value = !value,
                //           child: Padding(
                //             padding: const EdgeInsets.all(12),
                //             child: SvgPicture.asset(
                //               'assets/icons/${value ? 'obscure_on' : 'obscure_off'}.svg',
                //               color: cc.blackColor,
                //             ),
                //           ),
                //         ),
                //       )),
                // ),
                // EmptySpaceHelper.emptyHight(10),
                FieldTitle('New Password'),
                ValueListenableBuilder(
                  valueListenable: obscurePassNew,
                  builder: (context, value, child) => TextFormField(
                    controller: passNewController,
                    obscureText: obscurePassNew.value,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Enter your new Password',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset('assets/icons/pass_prefix.svg'),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => obscurePassNew.value = !value,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            'assets/icons/${value ? 'obscure_on' : 'obscure_off'}.svg',
                            color: cc.blackColor,
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (passNewController.text.length < 6) {
                        return "Password must be at least 6 character";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                EmptySpaceHelper.emptyHight(10),
                FieldTitle('Confirm Password'),
                ValueListenableBuilder(
                    valueListenable: obscurePassCon,
                    builder: (context, value, child) => TextFormField(
                          obscureText: obscurePassCon.value,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: 'Re-enter your new Password',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                  'assets/icons/pass_prefix.svg'),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () => obscurePassCon.value = !value,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                  'assets/icons/${value ? 'obscure_on' : 'obscure_off'}.svg',
                                  color: cc.blackColor,
                                ),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (passNewController.text != value) {
                              return "Password didn't match";
                            } else {
                              return null;
                            }
                          },
                        )),
                EmptySpaceHelper.emptyHight(16),
                ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context, value, child) => CustomCommonButton(
                      onPressed: () async {
                        final isValid = formKey.currentState!.validate();
                        if (!isValid) {
                          return;
                        }
                        isLoading.value = true;
                        await ChangePasswordService()
                            .changePassword(passNewController.text);
                        isLoading.value = false;
                        ;
                      },
                      btText: "Change Password",
                      isLoading: value),
                ),
                EmptySpaceHelper.emptyHight(10),
              ],
            ),
          ),
        ));
  }

  String? validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }
}
