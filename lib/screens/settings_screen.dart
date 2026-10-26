import 'package:flutter/material.dart';

import '../utils/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.school_outlined),
            title: Text('StudyFlow'),
            subtitle: Text('Organise tes études et tes tâches.'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.phone_android),
            title: Text('Application'),
            subtitle: Text('${AppConstants.appName} — version 1.0.0'),
          ),
          ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('Stockage local'),
            subtitle: Text('Les tâches sont conservées sur cet appareil.'),
          ),
        ],
      ),
    );
  }
}
