import 'package:flutter/material.dart';
import 'package:flutter_family_controls/flutter_family_controls.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ExamplePage());
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  bool _supported = false;
  bool _authorized = false;
  int _selectedCount = 0;
  bool _restrictionsEnabled = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final supported = await FlutterFamilyControls.isSupported();
    final authorized = await FlutterFamilyControls.isAuthorized();
    final count = await FlutterFamilyControls.getSelectedAppCount();
    if (!mounted) return;
    setState(() {
      _supported = supported;
      _authorized = authorized;
      _selectedCount = count;
    });
  }

  Future<void> _requestAuthorization() async {
    await FlutterFamilyControls.requestAuthorization();
    await _refresh();
  }

  Future<void> _selectApps() async {
    await FlutterFamilyControls.showAppPicker(title: 'Select Apps to Restrict');
    await _refresh();
  }

  Future<void> _toggleRestrictions() async {
    if (_restrictionsEnabled) {
      await FlutterFamilyControls.disableRestrictions();
    } else {
      await FlutterFamilyControls.enableRestrictions();
    }
    setState(() => _restrictionsEnabled = !_restrictionsEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_family_controls example')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Supported: $_supported'),
          Text('Authorized: $_authorized'),
          Text('Selected apps/categories: $_selectedCount'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _supported && !_authorized
                ? _requestAuthorization
                : null,
            child: const Text('Request authorization'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _authorized ? _selectApps : null,
            child: const Text('Select apps'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _authorized && _selectedCount > 0
                ? _toggleRestrictions
                : null,
            child: Text(
              _restrictionsEnabled
                  ? 'Disable restrictions'
                  : 'Enable restrictions',
            ),
          ),
          const SizedBox(height: 24),
          if (_selectedCount > 0) ...[
            const Text('Selected app icons:'),
            const SizedBox(height: 8),
            // Native, horizontally scrollable row of the selected app icons
            const SelectedAppIconsView(height: 48, iconSize: 40),
          ],
        ],
      ),
    );
  }
}
