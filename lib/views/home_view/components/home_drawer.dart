import 'package:flutter/material.dart';
import 'package:office_attendence/helpers/common_helper.dart';
import 'package:office_attendence/views/change_password_view/change_password_view.dart';
import 'package:office_attendence/views/profile_edit_view/profile_edit_view.dart';
import 'package:office_attendence/views/request_list_view/request_list_view.dart';
import 'package:office_attendence/views/salary_info_view/salary_info_view.dart';

import '../../login_view.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
              child: AppBar(
            leadingWidth: 0,
            leading: const SizedBox(),
            // centerTitle: true,
            title: SizedBox(
              height: 40,
              child: Image.asset(
                "assets/images/xgenious_logo.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          )),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text("Requests"),
            onTap: () {
              Navigator.of(context).pushNamed(RequestListView.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Salary Info"),
            onTap: () {
              Navigator.of(context).pushNamed(SalaryInfoView.routeName);
            },
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(ProfileEditView.routeName);
            },
            leading: Icon(Icons.person),
            title: Text("Edit Profile"),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(ChangePasswordView.routeName);
            },
            leading: Icon(Icons.lock),
            title: Text("Change Password"),
          ),
          ListTile(
            onTap: () {
              setToken(null);
              Navigator.of(context).pushReplacementNamed(LoginView.routeName);
            },
            leading: Icon(Icons.logout),
            title: Text("Logout"),
          ),
        ],
      ),
    );
  }
}
