import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../config.dart';

/// Popup dialog displaying the contents of the local `impressum.txt` file.
class ImpressumView extends StatefulWidget {
  const ImpressumView({super.key});

  @override
  State<ImpressumView> createState() => _ImpressumViewState();
}

class _ImpressumViewState extends State<ImpressumView> {
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
        _content =
            await rootBundle.loadString('assets/impressum.template.txt');
      } catch (_) {
        _content = 'Impressum konnte nicht geladen werden.';
      }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black38,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Center(
          child: SizedBox(
            width: 600,
            height: 600,
            child: Material(
              color: AppColor.nicegrey,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                side: BorderSide(
                    color: Colors.white, width: 6, strokeAlign: 4.0),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: AppColor.nicegrey,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text('Impressum'),
                  centerTitle: true,
                ),
                body: _content.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                            child: Text(
                          _content,
                          style: const TextStyle(color: Colors.white),
                        )),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
