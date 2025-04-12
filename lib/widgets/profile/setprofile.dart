import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fr0gsite/config.dart';

class SetProfile extends StatefulWidget {
  const SetProfile({super.key});

  @override
  State<SetProfile> createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  final TextEditingController memotextcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
  
  return Scaffold(
    appBar: AppBar(
      title: const Text('Set Profile'),
    ),
    backgroundColor: AppColor.niceblack,
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.profileimageipfs,
            ),
          ),
          const SizedBox(height: 16), 
                  TextField(
                  controller: memotextcontroller,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.profilebio,
                      labelStyle: const TextStyle(color: Colors.white),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 3),
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey),
                  onSubmitted: (value) {
                    
                  },
                  onChanged: (value) {
                    
                  },
                  maxLength: 256,
                  maxLines: 3,
                ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
          
        ],
      ),
    ),
  );
  }
}