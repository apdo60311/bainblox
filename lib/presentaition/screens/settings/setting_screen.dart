import 'package:BrainBlox/core/routes/routes.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.teacherOrStudent);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.logout,
                    size: 50,
                  ),
                  Text(
                    "Log out",
                    style: theme.textTheme.titleLarge,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
