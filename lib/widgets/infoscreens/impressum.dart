import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ImpressumPage extends StatefulWidget {
  const ImpressumPage({super.key});

  @override
  State<ImpressumPage> createState() => _ImpressumPageState();
}

class _ImpressumPageState extends State<ImpressumPage> {
  String _content = '';

  @override
  void initState() {
    super.initState();
    _loadImpressum();
  }

  Future<void> _loadImpressum() async {
    try {
      _content = await rootBundle.loadString('assets/impressum.txt');
    } catch (_) {
      try {
        _content = await rootBundle.loadString('assets/impressum.template.txt');
      } catch (_) {
        _content = 'Impressum konnte nicht geladen werden.';
      }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impressum'),
      ),
      body: _content.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(child: Text(_content)),
            ),
    );
  }
}
