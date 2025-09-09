import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

/// Dialog widget for creating new comments on posts
class NewCommentView extends StatefulWidget {
  const NewCommentView({super.key, required this.callback});
  
  /// Callback function called when comment submission completes
  /// Parameters: success status and comment text
  final void Function(bool success, String commentText) callback;

  @override
  State<NewCommentView> createState() => _NewCommentViewState();
}

class _NewCommentViewState extends State<NewCommentView> {
  // Text input controller for the comment content
  late final TextEditingController _commentController;
  
  // Current text length and maximum allowed length
  int _currentTextLength = 0;
  int get _maxCommentLength => AppConfig.maxCommentLength;
  
  // Loading state for submit button
  bool _isSubmittingComment = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _commentController.addListener(_updateTextLength);
  }

  /// Updates the character count when text changes and enforces length limit
  void _updateTextLength() {
    final currentText = _commentController.text;
    final newLength = currentText.length;
    
    // Enforce maximum length by truncating text if necessary
    if (newLength > _maxCommentLength) {
      _commentController.text = currentText.substring(0, _maxCommentLength);
      _commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _maxCommentLength),
      );
    }
    
    setState(() {
      _currentTextLength = _commentController.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Material(
            color: AppColor.nicegrey,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              side: BorderSide(
                color: Colors.blue,
                width: 6,
              )
            ),
            child: Center(
              child: Column(
                children: [
                  _buildCommentTextField(context),
                  _buildCharacterCounter(),
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the main text field for comment input
  Widget _buildCommentTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _commentController,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        cursorRadius: const Radius.circular(10),
        maxLines: 10,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 3)
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 3),
          ),
          labelText: AppLocalizations.of(context)!.yourcomment,
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// Builds the character counter display
  Widget _buildCharacterCounter() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              "$_currentTextLength/$_maxCommentLength",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the submit button with loading state
  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          _submitComment(context);
        },
        hoverColor: Colors.blue,
        backgroundColor: Colors.blue.withAlpha((0.8 * 255).toInt()),
        label: _isSubmittingComment
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                AppLocalizations.of(context)!.reply,
                style: const TextStyle(color: Colors.white)
              ),
        icon: const Icon(Icons.reply, color: Colors.white),
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          0.5
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// Submits the comment to the blockchain and handles the response
  Future<void> _submitComment(BuildContext context) async {
    if (!mounted) return;
    
    setState(() {
      _isSubmittingComment = true;
    });

    try {
      // Get user credentials from global state
      final globalStatus = Provider.of<GlobalStatus>(context, listen: false);
      final username = globalStatus.username;
      final permission = globalStatus.permission;
      
      // Get upload ID from post viewer state
      final postViewerStatus = Provider.of<PostviewerStatus>(context, listen: false);
      final uploadId = postViewerStatus.currentupload.uploadid.toString();

      // Initialize chain actions with user credentials
      final chainActions = Chainactions();
      chainActions.setusernameandpermission(username, permission);

      // Submit the comment
      final success = await chainActions.addcomment(
        username, 
        _commentController.text, 
        uploadId, 
        "de"
      );

      if (!mounted) return;

      if (success) {
        // Notify parent widget of successful comment submission
        widget.callback(true, _commentController.text);
        Navigator.pop(context);
        return;
      }

      // Handle failed submission
      widget.callback(false, "");
    } catch (error) {
      // Handle any errors during submission
      if (mounted) {
        widget.callback(false, "");
      }
    } finally {
      // Reset loading state
      if (mounted) {
        setState(() {
          _isSubmittingComment = false;
        });
      }
    }
  }
}
