import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SimpleStateMachine extends StatefulWidget {
  SimpleStateMachine(
    this.isChecking,
    this.isHandsUp,
    this.numLock,
    this.triggerSuccess,
    this.triggerFail,
    this.onRiveInit, {
    Key? key,
  }) : super(key: key);

  SMIBool? isChecking;

  SMIBool? isHandsUp;

  SMINumber? numLock;

  SMITrigger? triggerSuccess;

  SMITrigger? triggerFail;
  dynamic onRiveInit;

  @override
  _SimpleStateMachineState createState() => _SimpleStateMachineState();
}

class _SimpleStateMachineState extends State<SimpleStateMachine> {
  SMITrigger? _bump;
  SMITrigger? triggerFail;

  void _hitBump() => widget.triggerSuccess?.fire();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: RiveAnimation.asset(
          'assets/animations/animated_Login.riv',
          fit: BoxFit.cover,
          onInit: widget.onRiveInit,
        ),
        onTap: _hitBump,
      ),
    );
  }
}
