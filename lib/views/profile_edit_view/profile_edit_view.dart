import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:office_attendence/common/custom_common_button.dart';
import 'package:office_attendence/services/edit_profile_service.dart';
import 'package:office_attendence/services/profile_info_service.dart';
import 'package:provider/provider.dart';

import '../../common/field_title.dart';
import '../../helpers/empty_space_helper.dart';

class ProfileEditView extends StatelessWidget {
  static const routeName = 'profile_edit_view';
  ProfileEditView({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  ValueNotifier isLoading = ValueNotifier(false);
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    initializeControllers(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldTitle('Name'),
                TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child:
                            SvgPicture.asset('assets/icons/profile_prefix.svg'),
                      ),
                    )),
                EmptySpaceHelper.emptyHight(10),
                FieldTitle('Email'),
                TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.alternate_email_rounded),
                      ),
                    )),
                EmptySpaceHelper.emptyHight(10),
                FieldTitle('Phone'),
                TextFormField(
                    controller: phoneController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.phone_outlined),
                      ),
                    )),
                EmptySpaceHelper.emptyHight(10),
                FieldTitle('Address'),
                TextFormField(
                  controller: addressController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Enter your address',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.home_outlined),
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    saveChanges(context);
                  },
                ),
                EmptySpaceHelper.emptyHight(20),
                ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context, value, child) => CustomCommonButton(
                      onPressed: () async {
                        saveChanges(context);
                      },
                      btText: "Save Changes",
                      isLoading: value),
                )
              ],
            ),
          ),
        ));
  }

  saveChanges(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isLoading.value = true;
    final result = await EditProfileService().editProfile(nameController.text,
        emailController.text, phoneController.text, addressController.text);
    if (result) {
      await Provider.of<ProfileInfoService>(context, listen: false)
          .getProfileInfo();
    }
    isLoading.value = false;
  }

  initializeControllers(BuildContext context) {
    final piProvider = Provider.of<ProfileInfoService>(context, listen: false);

    nameController.text = piProvider.profileInfo?.userInfo?.name ?? '';
    emailController.text = piProvider.profileInfo?.userInfo?.email ?? '';
    phoneController.text = piProvider.profileInfo?.userInfo?.phone ?? '';
    addressController.text = piProvider.profileInfo?.userInfo?.address ?? '';
  }
}
