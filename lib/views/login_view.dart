import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:office_attendence/services/profile_info_service.dart';
import 'package:office_attendence/services/sign_in_service.dart';
import 'package:office_attendence/views/rive_animation.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../common/custom_common_button.dart';
import '../common/field_title.dart';
import '../helpers/constant_colors.dart';
import '../helpers/empty_space_helper.dart';
import 'home_view/home_view.dart';

class LoginView extends StatelessWidget {
  static const routeName = 'login_view';
  LoginView({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  ValueNotifier isLoading = ValueNotifier(false);
  ValueNotifier obscurePass = ValueNotifier(true);
  FocusNode passFocused = FocusNode();

  SMIBool? _isChecking;
  SMIBool? _isHandsUp;
  SMINumber? _numLock;
  SMITrigger? _triggerSuccess;
  SMITrigger? _triggerFail;
  RiveAnimationController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
              height: 300,
              child: SimpleStateMachine(_isChecking, _isHandsUp, _numLock,
                  _triggerSuccess, _triggerFail, onRiveInit)),
          Form(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Welcome back!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              EmptySpaceHelper.emptyHight(20),
              FieldTitle('Email'),
              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset('assets/icons/profile_prefix.svg'),
                  ),
                ),
                onChanged: (value) {
                  _numLock?.value = value.length.toDouble() * 2;
                },
                onTap: () {
                  _isHandsUp?.value = false;
                  _numLock?.value = emailController.text.length.toDouble() * 2;
                  _isChecking?.value = true;
                },
                onEditingComplete: () {
                  _numLock?.value = 0.0;
                  passFocused.requestFocus();
                  _isHandsUp?.value = obscurePass.value;
                },
              ),
              EmptySpaceHelper.emptyHight(10),
              FieldTitle('Password'),
              ValueListenableBuilder(
                valueListenable: obscurePass,
                builder: (context, value, child) => TextFormField(
                  controller: passController,
                  focusNode: passFocused,
                  obscureText: obscurePass.value,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    hintText: 'Enter your Password',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset('assets/icons/pass_prefix.svg'),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _isHandsUp?.value = passFocused.hasFocus && !value;
                        obscurePass.value = !value;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          'assets/icons/${value ? 'obscure_on' : 'obscure_off'}.svg',
                          color: cc.blackColor,
                        ),
                      ),
                    ),
                  ),
                  onFieldSubmitted: (value) async {
                    tryLogin(context);
                  },
                  onTap: () {
                    debugPrint("raising hand".toString());
                    debugPrint(_isHandsUp.toString());
                    _isChecking?.value = true;
                    _isHandsUp?.value = value;
                  },
                ),
              ),
              EmptySpaceHelper.emptyHight(10),
              EmptySpaceHelper.emptyHight(10),
              ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, value, child) => CustomCommonButton(
                    btText: 'Login',
                    isLoading: value,
                    onPressed: () async {
                      tryLogin(context);
                    }),
              ),
              EmptySpaceHelper.emptyHight(30),
            ]),
          ))
        ],
      ),
    );
  }

  tryLogin(BuildContext context) async {
    _isHandsUp?.value = false;
    _numLock?.value = 0.0;
    _isChecking?.value = false;
    isLoading.value = true;
    final result = await Provider.of<SignInService>(context, listen: false)
        .signIn(emailController.text, passController.text);
    if (result) {
      debugPrint("fetching profile info".toString());
      _triggerSuccess?.fire();
      _triggerSuccess?.fire();
      await Provider.of<ProfileInfoService>(context, listen: false)
          .getProfileInfo();
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).popAndPushNamed(HomeView.routeName);
      isLoading.value = false;
      return;
    }
    debugPrint(_triggerFail.toString());

    _triggerFail?.fire();
    _triggerFail?.fire();
    isLoading.value = false;
  }

  void onRiveInit(Artboard artboard) {
    StateMachine();
    artboard.stateMachines.forEach((element) {
      debugPrint("Sate machine:".toString());
      debugPrint(element.name.toString());
    });
    final controller =
        StateMachineController.fromArtboard(artboard, 'Login Machine');
    _controller = controller;
    artboard.addController(controller!);

    _triggerSuccess = controller.findInput<bool>('trigSuccess') as SMITrigger;
    _triggerFail = controller.findInput<bool>('trigFail') as SMITrigger;
    _isChecking = controller.findInput<bool>('isChecking') as SMIBool;
    _isHandsUp = controller.findInput<bool>('isHandsUp') as SMIBool;
    _numLock = controller.findInput<double>('numLook') as SMINumber;
  }
}
