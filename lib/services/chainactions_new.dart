// Refactored ChainActions using service-oriented architecture
import 'package:fr0gsite/services/chainactions_base.dart';
import 'package:fr0gsite/services/user_service.dart';
import 'package:fr0gsite/services/content_service.dart';
import 'package:fr0gsite/services/messaging_service.dart';
import 'package:fr0gsite/services/reporting_service.dart';
import 'package:fr0gsite/services/tag_service.dart';
import 'package:fr0gsite/services/voting_service.dart';

// Data type imports
import 'package:eosdart/eosdart.dart';
import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:fr0gsite/datatypes/rewardcalc.dart';
import 'package:fr0gsite/datatypes/usersubscription.dart';
import 'package:fr0gsite/datatypes/truster.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/favoriteupload.dart';
import 'package:fr0gsite/datatypes/comment.dart';

import 'package:fr0gsite/datatypes/report.dart';
import 'package:fr0gsite/datatypes/reportstatus.dart';
import 'package:fr0gsite/datatypes/reportvotes.dart';
import 'package:fr0gsite/datatypes/blacklistentry.dart';
import 'package:fr0gsite/datatypes/globaltags.dart';
import 'package:fr0gsite/datatypes/tag.dart';
import 'package:fr0gsite/datatypes/favoritetag.dart';
import 'package:fr0gsite/datatypes/producerinfo.dart';

/// Main ChainActions class that aggregates all blockchain services
/// Following service-oriented architecture based on smart contract modules
class ChainActions extends ChainActionsBase {
  
  // Service instances
  late final UserService userService;
  late final ContentService contentService;
  late final MessagingService messagingService;
  late final ReportingService reportingService;
  late final TagService tagService;
  late final VotingService votingService;

  ChainActions() {
    // Initialize all services
    userService = UserService();
    contentService = ContentService();
    messagingService = MessagingService();
    reportingService = ReportingService();
    tagService = TagService();
    votingService = VotingService();
    
    // Set credentials for all services
    _propagateCredentials();
  }

  /// Propagate username and permission to all services
  void _propagateCredentials() {
    userService.setusernameandpermission(username, permission);
    contentService.setusernameandpermission(username, permission);
    messagingService.setusernameandpermission(username, permission);
    reportingService.setusernameandpermission(username, permission);
    tagService.setusernameandpermission(username, permission);
    votingService.setusernameandpermission(username, permission);
  }

  @override
  void setusernameandpermission(String username, String permission) {
    super.setusernameandpermission(username, permission);
    _propagateCredentials();
  }

  @override
  void setUsernameAndPermissionWithContext(context) {
    super.setUsernameAndPermissionWithContext(context);
    _propagateCredentials();
  }

  // ============================================================================
  // USER MANAGEMENT - Delegate to UserService
  // ============================================================================
  
  Future<bool> checkusercredentials(String usernamecheck, String keystring, String permission) 
    => userService.checkusercredentials(usernamecheck, keystring, permission);
  
  Future<Account> getaccountinfo(String username) 
    => userService.getaccountinfo(username);
  
  Future<UserConfig> getuserconfig(String username) 
    => userService.getuserconfig(username);
  
  Future<RewardCalc> getrewardtokeninfo(String username) 
    => userService.getrewardtokeninfo(username);
  
  Future<bool> setuserprofile(String autor, String profilepicipfshash, String coverpicipfshash, 
                              String description, String displayname, String website, String location) 
    => userService.setuserprofile(autor, profilepicipfshash, coverpicipfshash, description, displayname, website, location);
  
  Future<bool> applyfortrusterrole(String autor) 
    => userService.applyfortrusterrole(autor);
  
  Future<bool> isuserfollowinguser(String username, String usernametofollow) 
    => userService.isuserfollowinguser(username, usernametofollow);
  
  Future<List<Usersubscription>> getusersubscriptions(String username) 
    => userService.getusersubscriptions(username);
  
  Future<bool> followuser(String usernametofollow) 
    => userService.followuser(usernametofollow);
  
  Future<bool> unfollowuser(String usernametounfollow) 
    => userService.unfollowuser(usernametounfollow);
  
  Future<List<Truster>> gettrusters() 
    => userService.gettrusters();
  
  Future<Truster> gettruster(String trustername) 
    => userService.gettruster(trustername);

  // ============================================================================
  // CONTENT MANAGEMENT - Delegate to ContentService  
  // ============================================================================
  
  Future<bool> adduploadaction(String autor, String uploadipfshash, String thumbipfshash, 
                               String uploadtext, int uploadtype) 
    => contentService.adduploadaction(autor, uploadipfshash, thumbipfshash, uploadtext, uploadtype);
  
  Future<Upload> getupload(String uploadid) 
    => contentService.getupload(uploadid);
  
  Future<Upload> cachedgetupload(String uploadid) 
    => contentService.cachedgetupload(uploadid);
  
  Future<List<Upload>> getnewuploads() 
    => contentService.getnewuploads();
  
  Future<List<Upload>> getpopularuploads() 
    => contentService.getpopularuploads();
  
  Future<List<Upload>> getpopularuploadslowerthan(String popularid) 
    => contentService.getpopularuploadslowerthan(popularid);
  
  Future<List<Upload>> getpopularuploadsupperthan(String popularid) 
    => contentService.getpopularuploadsupperthan(popularid);
  
  Future<List<Upload>> gettrendinguploads() 
    => contentService.gettrendinguploads();
  
  Future<List<Upload>> gettrendinguploadsupperthan(String trendingid) 
    => contentService.gettrendinguploadsupperthan(trendingid);
  
  Future<List<Upload>> getnewuploadslowerthan(String uploadid) 
    => contentService.getnewuploadslowerthan(uploadid);
  
  Future<List<Upload>> getnewuploadsupperthan(String uploadid) 
    => contentService.getnewuploadsupperthan(uploadid);
  
  Future<List<Upload>> getuploadsforglobaltag(String globaltagid, int limit) 
    => contentService.getuploadsforglobaltag(globaltagid, limit);
  
  Future<List<Upload>> getuploadsforglobaltagupperthan(String globaltagid, String upperid, int limit) 
    => contentService.getuploadsforglobaltagupperthan(globaltagid, upperid, limit);
  
  Future<List<Upload>> getuploadsfromuser(String username, int limit) 
    => contentService.getuploadsfromuser(username, limit);
  
  Future<List<Upload>> getuploadsfromuserlowerthan(String username, String uploadid, int limit) 
    => contentService.getuploadsfromuserlowerthan(username, uploadid, limit);
  
  Future<List<Upload>> getuploadsfromuserupperthan(String username, String uploadid, int limit) 
    => contentService.getuploadsfromuserupperthan(username, uploadid, limit);
  
  Future<List<FavoriteUpload>> getfavoriteuploadsofuser(String username) 
    => contentService.getfavoriteuploadsofuser(username);
  
  Future<bool> addfavoriteupload(String uploadid) 
    => contentService.addfavoriteupload(uploadid);
  
  Future<bool> deletefavoriteupload(String uploadid) 
    => contentService.deletefavoriteupload(uploadid);

  // ============================================================================
  // MESSAGING SYSTEM - Delegate to MessagingService
  // ============================================================================
  
  Future<bool> addcomment(String autor, String commenttext, String uploadid) 
    => messagingService.addcomment(autor, commenttext, uploadid);
  
  Future<bool> addcommentreply(String autor, String commenttext, String commentid, String uploadid) 
    => messagingService.addcommentreply(autor, commenttext, commentid, uploadid);
  
  Future<List<Comment>> fetchComments(String uploadid) 
    => messagingService.fetchComments(uploadid);
  
  Future<Comment> getcommentbyglobalid(String commentid) 
    => messagingService.getcommentbyglobalid(commentid);
  
  Future<List<Comment>> getfavoritecommentsofuser(String username) 
    => messagingService.getfavoritecommentsofuser(username);
  
  Future<bool> addfavoritecomment(String commentid) 
    => messagingService.addfavoritecomment(commentid);
  
  Future<bool> deletefavoritecomment(String commentid) 
    => messagingService.deletefavoritecomment(commentid);

  // ============================================================================
  // REPORTING SYSTEM - Delegate to ReportingService
  // ============================================================================
  
  Future<bool> addreport(String autor, int typ, int contentid, int violatedrule, String reporttext) 
    => reportingService.addreport(autor, typ, contentid, violatedrule, reporttext);
  
  Future<bool> reportuploadwithcommunity(ReportStatus report) 
    => reportingService.reportuploadwithcommunity(report);
  
  Future<List<Report>> getreports() 
    => reportingService.getreports();
  
  Future<Report> getreport(String reportid) 
    => reportingService.getreport(reportid);
  
  Future<List<ReportVotes>> getreportvotes(String reportid) 
    => reportingService.getreportvotes(reportid);
  
  Future<bool> trustervote(String reportid, int vote) 
    => reportingService.trustervote(reportid, vote);
  
  Future<List<BlacklistEntry>> getblacklist() 
    => reportingService.getblacklist();

  // ============================================================================
  // TAG SYSTEM - Delegate to TagService
  // ============================================================================
  
  Future<bool> addtag(String uploadid, String tagtext) 
    => tagService.addtag(uploadid, tagtext);
  
  Future<List<GlobalTags>> getmixedtags() 
    => tagService.getmixedtags();
  
  Future<List<GlobalTags>> getpopularglobaltags() 
    => tagService.getpopularglobaltags();
  
  Future<List<GlobalTags>> gettrendingtags() 
    => tagService.gettrendingtags();
  
  Future<List<GlobalTags>> getnewtags() 
    => tagService.getnewtags();
  
  Future<GlobalTags> getglobaltagbyid(String globaltagid) 
    => tagService.getglobaltagbyid(globaltagid);
  
  Future<List<Tag>> fetchTags(String uploadid) 
    => tagService.fetchTags(uploadid);
  
  Future<List<FavoriteTag>> getfavoritetagsofuser(String username) 
    => tagService.getfavoritetagsofuser(username);
  
  Future<bool> isglobaltagfavorite(String username, String globaltagid) 
    => tagService.isglobaltagfavorite(username, globaltagid);
  
  Future<bool> addfavoritetag(String globaltagid) 
    => tagService.addfavoritetag(globaltagid);
  
  Future<bool> deletefavoritetag(String globaltagid) 
    => tagService.deletefavoritetag(globaltagid);

  // ============================================================================
  // VOTING SYSTEM - Delegate to VotingService
  // ============================================================================
  
  Future<bool> voteupload(int uploadid, int vote) 
    => votingService.voteupload(uploadid, vote);
  
  Future<bool> votetag(String tagid, int vote) 
    => votingService.votetag(tagid, vote);
  
  Future<bool> votecomment(String commentid, int vote) 
    => votingService.votecomment(commentid, vote);
  
  Future<bool> voteproducer(List<String> producernamelist) 
    => votingService.voteproducer(producernamelist);
  
  Future<List<ProducerInfo>> getproducerlist() 
    => votingService.getproducerlist();
  
  Future<bool> sendtoken(String from, String to, String quantity, String memo) 
    => votingService.sendtoken(from, to, quantity, memo);
  
  Future<bool> claimreward(String accountName, String symbol) 
    => votingService.claimreward(accountName, symbol);
}