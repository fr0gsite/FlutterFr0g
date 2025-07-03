import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:flutter/foundation.dart';

/// Basic text search over uploads.
///
/// This search implementation fetches the newest uploads from the blockchain
/// and filters them locally by [query]. It is a very simple approach but
/// demonstrates how search could be implemented using the existing
/// [Chainactions] helper methods.
class SearchGeneral extends UploadOrderTemplate {
  final String query;
  final Chainactions chainactions = Chainactions();

  int lastid = 0;

  SearchGeneral(this.query);

  /// Initial request for search results.
  @override
  Future<List<Upload>> initsearch() async {
    try {
      // Fetch newest uploads and remember last id for pagination
      List<Upload> uploads = await chainactions.getnewuploads();
      if (uploads.isNotEmpty) {
        lastid = uploads.last.uploadid;
      }
      uploads = _filter(uploads);
      adduploadlist(uploads);
      sortcurrentview();
      return uploads;
    } catch (e) {
      debugPrint('SearchGeneral initsearch error: $e');
      return [];
    }
  }

  /// Fetch next batch of results.
  @override
  Future<List<Upload>> searchnext() async {
    if (!dosearchnext(lastid.toString())) {
      return [];
    }
    try {
      List<Upload> uploads =
          await chainactions.getnewuploadsupperthan(lastid.toString());
      if (uploads.isEmpty) {
        return [];
      }
      lastid = uploads.last.uploadid;
      uploads = _filter(uploads);
      adduploadlist(uploads);
      sortcurrentview();
      removeduplicates();
      return uploads;
    } catch (e) {
      debugPrint('SearchGeneral searchnext error: $e');
      return [];
    }
  }

  List<Upload> _filter(List<Upload> uploads) {
    final q = query.toLowerCase();
    return uploads
        .where((u) =>
            u.autor.toLowerCase().contains(q) ||
            u.uploadtext.toLowerCase().contains(q))
        .toList();
  }

  @override
  void sortcurrentview() {
    currentviewuploadlist.sort((a, b) => b.uploadid.compareTo(a.uploadid));
  }
}
