import 'package:flutter/material.dart';

class RememberSession extends StatelessWidget {
  const RememberSession({
    super.key,
    required this.rememberSession,
  });

  final ValueNotifier rememberSession;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: rememberSession,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: value,
                onChanged: (value) {
                  rememberSession.value = value;
                },
              ),
            );
          },
        ),
        Text(
          "Remember me",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
