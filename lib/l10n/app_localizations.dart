import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('uk'),
    Locale('zh'),
  ];

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// No description provided for @countrycode.
  ///
  /// In en, this message translates to:
  /// **'US'**
  String get countrycode;

  /// No description provided for @thelanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get thelanguage;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @trends.
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get trends;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @unfollow.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollow;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @signin.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signin;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @loginnamekey.
  ///
  /// In en, this message translates to:
  /// **'Name/Key'**
  String get loginnamekey;

  /// No description provided for @loginfile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get loginfile;

  /// No description provided for @loginqrcode.
  ///
  /// In en, this message translates to:
  /// **'OR-Code'**
  String get loginqrcode;

  /// No description provided for @loginwith.
  ///
  /// In en, this message translates to:
  /// **'Login with'**
  String get loginwith;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @pictures.
  ///
  /// In en, this message translates to:
  /// **'Pictures'**
  String get pictures;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @accountbalance.
  ///
  /// In en, this message translates to:
  /// **'Account Balance'**
  String get accountbalance;

  /// No description provided for @accountname.
  ///
  /// In en, this message translates to:
  /// **'Accountname'**
  String get accountname;

  /// No description provided for @config.
  ///
  /// In en, this message translates to:
  /// **'Config'**
  String get config;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @infos.
  ///
  /// In en, this message translates to:
  /// **'Infos'**
  String get infos;

  /// No description provided for @categorynew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get categorynew;

  /// No description provided for @categorypopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get categorypopular;

  /// No description provided for @categorymixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get categorymixed;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @nocomments.
  ///
  /// In en, this message translates to:
  /// **'No comments'**
  String get nocomments;

  /// No description provided for @forexample.
  ///
  /// In en, this message translates to:
  /// **'For Example'**
  String get forexample;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @receive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get receive;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @changepublickey.
  ///
  /// In en, this message translates to:
  /// **'Change public key'**
  String get changepublickey;

  /// No description provided for @changeprivatekey.
  ///
  /// In en, this message translates to:
  /// **'Change private key'**
  String get changeprivatekey;

  /// No description provided for @whereisthekeystored.
  ///
  /// In en, this message translates to:
  /// **'Where is the key stored?'**
  String get whereisthekeystored;

  /// No description provided for @whatdoesthatmean.
  ///
  /// In en, this message translates to:
  /// **'What does that mean?'**
  String get whatdoesthatmean;

  /// No description provided for @sorrysomethingwentwrong.
  ///
  /// In en, this message translates to:
  /// **'Sorry, something went wrong'**
  String get sorrysomethingwentwrong;

  /// No description provided for @forthisfeatureyouhavetologin.
  ///
  /// In en, this message translates to:
  /// **'For this feature you have to login'**
  String get forthisfeatureyouhavetologin;

  /// No description provided for @youarenotloggedin.
  ///
  /// In en, this message translates to:
  /// **'You are not logged in'**
  String get youarenotloggedin;

  /// No description provided for @pagenotfound.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pagenotfound;

  /// No description provided for @thepageyouarelookingfordoesnotexist.
  ///
  /// In en, this message translates to:
  /// **'The page you are looking for does not exist.'**
  String get thepageyouarelookingfordoesnotexist;

  /// No description provided for @thisfeatureisnotavailableyet.
  ///
  /// In en, this message translates to:
  /// **'This feature is not available yet'**
  String get thisfeatureisnotavailableyet;

  /// No description provided for @thesystemtokenhasfourdecimalplaces.
  ///
  /// In en, this message translates to:
  /// **'The system token has 4 decimal places'**
  String get thesystemtokenhasfourdecimalplaces;

  /// No description provided for @statusoftheblockchain.
  ///
  /// In en, this message translates to:
  /// **'Status of the blockchain'**
  String get statusoftheblockchain;

  /// No description provided for @refund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refund;

  /// No description provided for @liquid.
  ///
  /// In en, this message translates to:
  /// **'Liquid'**
  String get liquid;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountisinvalid.
  ///
  /// In en, this message translates to:
  /// **'Amount is invalid'**
  String get amountisinvalid;

  /// No description provided for @liquidexplain.
  ///
  /// In en, this message translates to:
  /// **'This is the amount of tokens that can send to other accounts'**
  String get liquidexplain;

  /// No description provided for @stakeexplain.
  ///
  /// In en, this message translates to:
  /// **'This is the amount of tokens have staked for resources'**
  String get stakeexplain;

  /// No description provided for @refundexplain.
  ///
  /// In en, this message translates to:
  /// **'This is the amount of tokens that are frozen for 3 days after unstaking'**
  String get refundexplain;

  /// No description provided for @unstakedtokenkeepfrozenforthreedays.
  ///
  /// In en, this message translates to:
  /// **'Unstaked resources remain frozen for 3 days'**
  String get unstakedtokenkeepfrozenforthreedays;

  /// No description provided for @thisfeatureisnotsupportet.
  ///
  /// In en, this message translates to:
  /// **'This feature is not supportet'**
  String get thisfeatureisnotsupportet;

  /// No description provided for @platformnotsupportvideo.
  ///
  /// In en, this message translates to:
  /// **'This platform does not support video playback'**
  String get platformnotsupportvideo;

  /// No description provided for @rule1.
  ///
  /// In en, this message translates to:
  /// **'No representation or link of/to minors brute force, sexual, suggestive or nude content.'**
  String get rule1;

  /// No description provided for @rule2.
  ///
  /// In en, this message translates to:
  /// **'No representation or link of/to animal brute force, sexual (zoophilia), suggestive or fetish content. Material from the natural environment is allowed.'**
  String get rule2;

  /// No description provided for @rule3.
  ///
  /// In en, this message translates to:
  /// **'No trolling of users with video and images (e.g screamers, excessive flashing or other audio videos with the intent to annoy).'**
  String get rule3;

  /// No description provided for @rule4.
  ///
  /// In en, this message translates to:
  /// **'No phishing, scaming, spreading viruses or other malware to users.'**
  String get rule4;

  /// No description provided for @rule5.
  ///
  /// In en, this message translates to:
  /// **'No Repost of content in short intervals (Spamming on purpose).'**
  String get rule5;

  /// No description provided for @rule6.
  ///
  /// In en, this message translates to:
  /// **'No planning or executing of violence.'**
  String get rule6;

  /// No description provided for @rule7.
  ///
  /// In en, this message translates to:
  /// **'No sharing of pictures or videos if affected/shown people forbidden it.'**
  String get rule7;

  /// No description provided for @rule8.
  ///
  /// In en, this message translates to:
  /// **'Reveal anonymity of individuals without their consent.'**
  String get rule8;

  /// No description provided for @rule9.
  ///
  /// In en, this message translates to:
  /// **'Violation of the minimum quality standard of the content.'**
  String get rule9;

  /// No description provided for @rule10.
  ///
  /// In en, this message translates to:
  /// **'No vandalism or spamming of the platform.'**
  String get rule10;

  /// No description provided for @rule11.
  ///
  /// In en, this message translates to:
  /// **'sfw, nsfw and nsfl content must be marked accordingly for uploads.'**
  String get rule11;

  /// No description provided for @punishment0.
  ///
  /// In en, this message translates to:
  /// **'No Punishment'**
  String get punishment0;

  /// No description provided for @punishment1.
  ///
  /// In en, this message translates to:
  /// **'Pillory'**
  String get punishment1;

  /// No description provided for @punishment2.
  ///
  /// In en, this message translates to:
  /// **'Token Sanction'**
  String get punishment2;

  /// No description provided for @punishment3.
  ///
  /// In en, this message translates to:
  /// **'Ban for 14 days'**
  String get punishment3;

  /// No description provided for @punishment4.
  ///
  /// In en, this message translates to:
  /// **'Ban for 30 days'**
  String get punishment4;

  /// No description provided for @punishment5.
  ///
  /// In en, this message translates to:
  /// **'Ban forever'**
  String get punishment5;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resource'**
  String get resources;

  /// No description provided for @resourcesexplain.
  ///
  /// In en, this message translates to:
  /// **'Staked resources are consumed during transactions with the blockchain and are fully restored within 3 days'**
  String get resourcesexplain;

  /// No description provided for @staked.
  ///
  /// In en, this message translates to:
  /// **'Staked'**
  String get staked;

  /// No description provided for @stake.
  ///
  /// In en, this message translates to:
  /// **'Stake'**
  String get stake;

  /// No description provided for @unstake.
  ///
  /// In en, this message translates to:
  /// **'Unstake'**
  String get unstake;

  /// No description provided for @stakedexplain.
  ///
  /// In en, this message translates to:
  /// **'Will fully recover within 3 days'**
  String get stakedexplain;

  /// No description provided for @cpuexplain.
  ///
  /// In en, this message translates to:
  /// **'Computing time for transactions'**
  String get cpuexplain;

  /// No description provided for @netexplain.
  ///
  /// In en, this message translates to:
  /// **'Network bandwidth for transactions'**
  String get netexplain;

  /// No description provided for @ramexplain.
  ///
  /// In en, this message translates to:
  /// **'Used storage space on the blockchain'**
  String get ramexplain;

  /// No description provided for @purchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get purchased;

  /// No description provided for @purchasedexplain.
  ///
  /// In en, this message translates to:
  /// **'Storage space must be purchased'**
  String get purchasedexplain;

  /// No description provided for @advancedview.
  ///
  /// In en, this message translates to:
  /// **'Advanced view'**
  String get advancedview;

  /// No description provided for @fromusername.
  ///
  /// In en, this message translates to:
  /// **'From (username)'**
  String get fromusername;

  /// No description provided for @tousername.
  ///
  /// In en, this message translates to:
  /// **'To (username)'**
  String get tousername;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @wrongusername.
  ///
  /// In en, this message translates to:
  /// **'Wrong Username'**
  String get wrongusername;

  /// No description provided for @usernameinvalidformat.
  ///
  /// In en, this message translates to:
  /// **'Username does not fit the valid format'**
  String get usernameinvalidformat;

  /// No description provided for @privatekey.
  ///
  /// In en, this message translates to:
  /// **'Privatekey'**
  String get privatekey;

  /// No description provided for @wrongprivatekey.
  ///
  /// In en, this message translates to:
  /// **'Wrong Privatekey'**
  String get wrongprivatekey;

  /// No description provided for @privatekeyinvalidformat.
  ///
  /// In en, this message translates to:
  /// **'Privatekey does not fit the valid format'**
  String get privatekeyinvalidformat;

  /// No description provided for @loginsuccessfull.
  ///
  /// In en, this message translates to:
  /// **'Login successfull'**
  String get loginsuccessfull;

  /// No description provided for @logoutsuccessfull.
  ///
  /// In en, this message translates to:
  /// **'Logout successfull'**
  String get logoutsuccessfull;

  /// No description provided for @welcomeback.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeback;

  /// No description provided for @bye.
  ///
  /// In en, this message translates to:
  /// **'Bye'**
  String get bye;

  /// No description provided for @permission.
  ///
  /// In en, this message translates to:
  /// **'Permission'**
  String get permission;

  /// No description provided for @permissionexplain.
  ///
  /// In en, this message translates to:
  /// **'Active: for the normal use, Owner: Full control'**
  String get permissionexplain;

  /// No description provided for @transferexplained.
  ///
  /// In en, this message translates to:
  /// **'Transfer ? (if activated, resources will be owned by the receiver)'**
  String get transferexplained;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @remains.
  ///
  /// In en, this message translates to:
  /// **'Remains'**
  String get remains;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @slidetoconfirm.
  ///
  /// In en, this message translates to:
  /// **'Slide to confirm'**
  String get slidetoconfirm;

  /// No description provided for @claim.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get claim;

  /// No description provided for @claimable.
  ///
  /// In en, this message translates to:
  /// **'Claimable'**
  String get claimable;

  /// No description provided for @claimsuccess.
  ///
  /// In en, this message translates to:
  /// **'Claim was successfull'**
  String get claimsuccess;

  /// No description provided for @claimerror.
  ///
  /// In en, this message translates to:
  /// **'That did not work'**
  String get claimerror;

  /// No description provided for @claimrewards.
  ///
  /// In en, this message translates to:
  /// **'Claim Rewards'**
  String get claimrewards;

  /// No description provided for @claimrewardexplain.
  ///
  /// In en, this message translates to:
  /// **'Rewards are paid out for certain activities and can be exchanged.'**
  String get claimrewardexplain;

  /// No description provided for @token.
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get token;

  /// No description provided for @tokenACTexplain.
  ///
  /// In en, this message translates to:
  /// **'Will be paid out during actions (Voting, write comments, ...)'**
  String get tokenACTexplain;

  /// No description provided for @tokenFAMEexplain.
  ///
  /// In en, this message translates to:
  /// **'Paid out when a user likes your content'**
  String get tokenFAMEexplain;

  /// No description provided for @tokenTRUSTexplain.
  ///
  /// In en, this message translates to:
  /// **'Is paid out when you complete tasks as a truster'**
  String get tokenTRUSTexplain;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @selectprovider.
  ///
  /// In en, this message translates to:
  /// **'Select an proiver to host your media file'**
  String get selectprovider;

  /// No description provided for @byyourself.
  ///
  /// In en, this message translates to:
  /// **'by yourself'**
  String get byyourself;

  /// No description provided for @provideryourselftext.
  ///
  /// In en, this message translates to:
  /// **'Host by an Laptop or Raspberry Pi'**
  String get provideryourselftext;

  /// No description provided for @withpinata.
  ///
  /// In en, this message translates to:
  /// **'with Pinata'**
  String get withpinata;

  /// No description provided for @providerpinatatext.
  ///
  /// In en, this message translates to:
  /// **'Offers 1 GB free storage'**
  String get providerpinatatext;

  /// No description provided for @withfilebase.
  ///
  /// In en, this message translates to:
  /// **'with Filebase'**
  String get withfilebase;

  /// No description provided for @providerfilebasetext.
  ///
  /// In en, this message translates to:
  /// **'Offers 5 GB free storage'**
  String get providerfilebasetext;

  /// No description provided for @withfilecoin.
  ///
  /// In en, this message translates to:
  /// **'with Filecoin'**
  String get withfilecoin;

  /// No description provided for @providerfilecointext.
  ///
  /// In en, this message translates to:
  /// **'Host on an Blockchain Network'**
  String get providerfilecointext;

  /// No description provided for @withCloudProvider.
  ///
  /// In en, this message translates to:
  /// **'with Cloud Provider'**
  String get withCloudProvider;

  /// No description provided for @providercloudtext.
  ///
  /// In en, this message translates to:
  /// **'Host by an Cloud Provider of your choice'**
  String get providercloudtext;

  /// No description provided for @detailsabouttheupload.
  ///
  /// In en, this message translates to:
  /// **'Details about the upload'**
  String get detailsabouttheupload;

  /// No description provided for @ipfsHashofMedia.
  ///
  /// In en, this message translates to:
  /// **'IPFS Hash of Media'**
  String get ipfsHashofMedia;

  /// No description provided for @ipfsHashofThumb.
  ///
  /// In en, this message translates to:
  /// **'IPFS Hash of Thmub'**
  String get ipfsHashofThumb;

  /// No description provided for @filetype.
  ///
  /// In en, this message translates to:
  /// **'Filetype'**
  String get filetype;

  /// No description provided for @flag.
  ///
  /// In en, this message translates to:
  /// **'Flag'**
  String get flag;

  /// No description provided for @uploadtextoptional.
  ///
  /// In en, this message translates to:
  /// **'Uploadtext (optional)'**
  String get uploadtextoptional;

  /// No description provided for @uploadtext.
  ///
  /// In en, this message translates to:
  /// **'Upload Description'**
  String get uploadtext;

  /// No description provided for @uploadid.
  ///
  /// In en, this message translates to:
  /// **'Upload No.'**
  String get uploadid;

  /// No description provided for @popularid.
  ///
  /// In en, this message translates to:
  /// **'Popular No.'**
  String get popularid;

  /// No description provided for @trendingvalue.
  ///
  /// In en, this message translates to:
  /// **'Trend Value'**
  String get trendingvalue;

  /// No description provided for @numofcomments.
  ///
  /// In en, this message translates to:
  /// **'Number of Comments'**
  String get numofcomments;

  /// No description provided for @numoffavorites.
  ///
  /// In en, this message translates to:
  /// **'Number of Favorites'**
  String get numoffavorites;

  /// No description provided for @uploadipfshash.
  ///
  /// In en, this message translates to:
  /// **'Upload IPFS Hash'**
  String get uploadipfshash;

  /// No description provided for @uploadipfshashfiletyp.
  ///
  /// In en, this message translates to:
  /// **'File Type of Upload'**
  String get uploadipfshashfiletyp;

  /// No description provided for @thumbipfshash.
  ///
  /// In en, this message translates to:
  /// **'Thumb IPFS Hash'**
  String get thumbipfshash;

  /// No description provided for @thumbipfshashfiletyp.
  ///
  /// In en, this message translates to:
  /// **'File Type of Thumb'**
  String get thumbipfshashfiletyp;

  /// No description provided for @selectedlanguage.
  ///
  /// In en, this message translates to:
  /// **'Selected Language'**
  String get selectedlanguage;

  /// No description provided for @selecteduploadfiletype.
  ///
  /// In en, this message translates to:
  /// **'Selected filetype for Upload'**
  String get selecteduploadfiletype;

  /// No description provided for @selectedthumbfiletype.
  ///
  /// In en, this message translates to:
  /// **'Selected Filetype for Thmub'**
  String get selectedthumbfiletype;

  /// No description provided for @noinformationyet.
  ///
  /// In en, this message translates to:
  /// **'No information yet'**
  String get noinformationyet;

  /// No description provided for @pleasetestipfs.
  ///
  /// In en, this message translates to:
  /// **'Please test if the Media is reachable via IPFS Hash'**
  String get pleasetestipfs;

  /// No description provided for @testhere.
  ///
  /// In en, this message translates to:
  /// **'Test here'**
  String get testhere;

  /// No description provided for @tested.
  ///
  /// In en, this message translates to:
  /// **'Tested'**
  String get tested;

  /// No description provided for @agreeUploadRequirements.
  ///
  /// In en, this message translates to:
  /// **'Has agreed to the upload request'**
  String get agreeUploadRequirements;

  /// No description provided for @unserstoodIPFScharacteristics.
  ///
  /// In en, this message translates to:
  /// **'Unserstood IPFS special characteristics'**
  String get unserstoodIPFScharacteristics;

  /// No description provided for @noteverythingiscompleted.
  ///
  /// In en, this message translates to:
  /// **'Not everything is completed'**
  String get noteverythingiscompleted;

  /// No description provided for @pleasecheckyourinput.
  ///
  /// In en, this message translates to:
  /// **'Please check your input'**
  String get pleasecheckyourinput;

  /// No description provided for @max15MBfilesize.
  ///
  /// In en, this message translates to:
  /// **'Max. 15 filesize'**
  String get max15MBfilesize;

  /// No description provided for @uploadresolution.
  ///
  /// In en, this message translates to:
  /// **'Upload resolution min. 0,09 Megapixel'**
  String get uploadresolution;

  /// No description provided for @thumbresolution.
  ///
  /// In en, this message translates to:
  /// **'Thumb resolution 128x128px'**
  String get thumbresolution;

  /// No description provided for @validfileformatupload.
  ///
  /// In en, this message translates to:
  /// **'Valid filetyp for Upload:'**
  String get validfileformatupload;

  /// No description provided for @validfileformatthumb.
  ///
  /// In en, this message translates to:
  /// **'Valid filetyp for thumb'**
  String get validfileformatthumb;

  /// No description provided for @checkRequirements.
  ///
  /// In en, this message translates to:
  /// **'Check Requirements'**
  String get checkRequirements;

  /// No description provided for @alinewithRuleswithlink.
  ///
  /// In en, this message translates to:
  /// **'Aline with Rules (click to open)'**
  String get alinewithRuleswithlink;

  /// No description provided for @iagree.
  ///
  /// In en, this message translates to:
  /// **'I agree'**
  String get iagree;

  /// No description provided for @ireject.
  ///
  /// In en, this message translates to:
  /// **'I reject'**
  String get ireject;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @okiunderstood.
  ///
  /// In en, this message translates to:
  /// **'Ok, I have understood'**
  String get okiunderstood;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @goback.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goback;

  /// No description provided for @settingcommon.
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get settingcommon;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @showprofile.
  ///
  /// In en, this message translates to:
  /// **'Show Profile'**
  String get showprofile;

  /// No description provided for @follower.
  ///
  /// In en, this message translates to:
  /// **'Follower'**
  String get follower;

  /// No description provided for @unfollowuser.
  ///
  /// In en, this message translates to:
  /// **'Unfollow user'**
  String get unfollowuser;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @sendmessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendmessage;

  /// No description provided for @settingprofiledescription.
  ///
  /// In en, this message translates to:
  /// **'Name, Avatar, Bio, Website, Location, Social Media Links'**
  String get settingprofiledescription;

  /// No description provided for @ressources.
  ///
  /// In en, this message translates to:
  /// **'Ressources'**
  String get ressources;

  /// No description provided for @settingressourcesdescription.
  ///
  /// In en, this message translates to:
  /// **'Stake & Unstake CPU, NET, RAM'**
  String get settingressourcesdescription;

  /// No description provided for @settingprivacyandsecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get settingprivacyandsecurity;

  /// No description provided for @settingprivacyandsecuritydescription.
  ///
  /// In en, this message translates to:
  /// **'Private Keys, Cookies, Cache, Local Storage'**
  String get settingprivacyandsecuritydescription;

  /// No description provided for @friendrequests.
  ///
  /// In en, this message translates to:
  /// **'Friend requests'**
  String get friendrequests;

  /// No description provided for @rulesandguidelines.
  ///
  /// In en, this message translates to:
  /// **'Rules & Guidelines'**
  String get rulesandguidelines;

  /// No description provided for @openwebsite.
  ///
  /// In en, this message translates to:
  /// **'Open Website'**
  String get openwebsite;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pushnotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushnotifications;

  /// No description provided for @audionotifications.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get audionotifications;

  /// No description provided for @userinterface.
  ///
  /// In en, this message translates to:
  /// **'User interface'**
  String get userinterface;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightordark.
  ///
  /// In en, this message translates to:
  /// **'Light or Dark'**
  String get lightordark;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @chainstatus.
  ///
  /// In en, this message translates to:
  /// **'Chain Status'**
  String get chainstatus;

  /// No description provided for @blockproducers.
  ///
  /// In en, this message translates to:
  /// **'Block Producers'**
  String get blockproducers;

  /// No description provided for @currentlyproducing.
  ///
  /// In en, this message translates to:
  /// **'Producing'**
  String get currentlyproducing;

  /// No description provided for @database.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get database;

  /// No description provided for @lastblockid.
  ///
  /// In en, this message translates to:
  /// **'Last Block ID'**
  String get lastblockid;

  /// No description provided for @blockproducer.
  ///
  /// In en, this message translates to:
  /// **'Block Producer'**
  String get blockproducer;

  /// No description provided for @electedblockproducer.
  ///
  /// In en, this message translates to:
  /// **'Elected BP'**
  String get electedblockproducer;

  /// No description provided for @standbyblockproducer.
  ///
  /// In en, this message translates to:
  /// **'Standby BP'**
  String get standbyblockproducer;

  /// No description provided for @lastirreversibleblock.
  ///
  /// In en, this message translates to:
  /// **'Last irreversible Block'**
  String get lastirreversibleblock;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @transactionsum.
  ///
  /// In en, this message translates to:
  /// **'Transaction Sum'**
  String get transactionsum;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @usedram.
  ///
  /// In en, this message translates to:
  /// **'Used RAM'**
  String get usedram;

  /// No description provided for @totalvotes.
  ///
  /// In en, this message translates to:
  /// **'Total Votes'**
  String get totalvotes;

  /// No description provided for @unpaidblocks.
  ///
  /// In en, this message translates to:
  /// **'Unpaid Blocks'**
  String get unpaidblocks;

  /// No description provided for @isactive.
  ///
  /// In en, this message translates to:
  /// **'Is active'**
  String get isactive;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'Url'**
  String get url;

  /// No description provided for @documentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get documentation;

  /// No description provided for @arrowkeys.
  ///
  /// In en, this message translates to:
  /// **'Arrow keys'**
  String get arrowkeys;

  /// No description provided for @mousescroll.
  ///
  /// In en, this message translates to:
  /// **'Mouse scroll'**
  String get mousescroll;

  /// No description provided for @swipe.
  ///
  /// In en, this message translates to:
  /// **'Swipe'**
  String get swipe;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @uploadipfscarateristicsinfo.
  ///
  /// In en, this message translates to:
  /// **'The media (images, videos) are stored in the IPFS network. There, the data can be accessed by everyone, even outside this platform. Once uploaded, the file can be scattered uncontrolled all over the world. Be aware that it is highly unlikely that the file can be deleted.'**
  String get uploadipfscarateristicsinfo;

  /// No description provided for @usernotfound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get usernotfound;

  /// No description provided for @searchforauser.
  ///
  /// In en, this message translates to:
  /// **'Search for a user'**
  String get searchforauser;

  /// No description provided for @daysago.
  ///
  /// In en, this message translates to:
  /// **'Days ago'**
  String get daysago;

  /// No description provided for @hoursago.
  ///
  /// In en, this message translates to:
  /// **'Hours ago'**
  String get hoursago;

  /// No description provided for @minutesago.
  ///
  /// In en, this message translates to:
  /// **'Minutes ago'**
  String get minutesago;

  /// No description provided for @secondsago.
  ///
  /// In en, this message translates to:
  /// **'Seconds ago'**
  String get secondsago;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @reportuploadedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Report successfully created'**
  String get reportuploadedsuccessfully;

  /// No description provided for @reportuploadedfailed.
  ///
  /// In en, this message translates to:
  /// **'Report not created'**
  String get reportuploadedfailed;

  /// No description provided for @thankyou.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get thankyou;

  /// No description provided for @whichrulewasviolated.
  ///
  /// In en, this message translates to:
  /// **'Which rule was violated ?'**
  String get whichrulewasviolated;

  /// No description provided for @moreinformationaboutreport.
  ///
  /// In en, this message translates to:
  /// **'To help in the decision-making process. Please add more information if possible. Any evidence or information you present may add weight to your claim.'**
  String get moreinformationaboutreport;

  /// No description provided for @successfulreportsarerewarded.
  ///
  /// In en, this message translates to:
  /// **'Successful reports are rewarded'**
  String get successfulreportsarerewarded;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @reportbycommunitynode.
  ///
  /// In en, this message translates to:
  /// **'reported by community node'**
  String get reportbycommunitynode;

  /// No description provided for @reportwith.
  ///
  /// In en, this message translates to:
  /// **'Report with'**
  String get reportwith;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @replies.
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get replies;

  /// No description provided for @writecomment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get writecomment;

  /// No description provided for @addtag.
  ///
  /// In en, this message translates to:
  /// **'Add Tag'**
  String get addtag;

  /// No description provided for @yourcomment.
  ///
  /// In en, this message translates to:
  /// **'Your Comment'**
  String get yourcomment;

  /// No description provided for @showcomments.
  ///
  /// In en, this message translates to:
  /// **'Show Comments'**
  String get showcomments;

  /// No description provided for @copiedtoclipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedtoclipboard;

  /// No description provided for @uploads.
  ///
  /// In en, this message translates to:
  /// **'Uploads'**
  String get uploads;

  /// No description provided for @showtags.
  ///
  /// In en, this message translates to:
  /// **'Show Tags'**
  String get showtags;

  /// No description provided for @favoritedby.
  ///
  /// In en, this message translates to:
  /// **'Favorited by'**
  String get favoritedby;

  /// No description provided for @nologinviewresourcefromanotheruser.
  ///
  /// In en, this message translates to:
  /// **'Because you are not logged in, you see the resources of another user as an example.'**
  String get nologinviewresourcefromanotheruser;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @disclaimer1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the first decentralized image board. This platform is currently in beta phase. Errors may occur, or the content of this platform may change or be deleted without notice.'**
  String get disclaimer1;

  /// No description provided for @disclaimer2.
  ///
  /// In en, this message translates to:
  /// **'The content of this website is intended for mature audiences only and may not be suitable for minors. If you are a minor or if accessing mature images and language is illegal in your jurisdiction, please do not proceed.'**
  String get disclaimer2;

  /// No description provided for @disclaimer3.
  ///
  /// In en, this message translates to:
  /// **'This website is provided to you as is, with no warranty, express or implied. By clicking \"{iagree}\", you agree that the operator shall not be liable for any damages resulting from your use of the website. You also understand that the content posted on the website is not owned or created by the operator but rather by the users of this platform.'**
  String disclaimer3(Object iagree);

  /// No description provided for @disclaimer4.
  ///
  /// In en, this message translates to:
  /// **'By clicking the \"{iagree}\" button, you confirm that you have read and accepted the rules.'**
  String disclaimer4(Object iagree);

  /// No description provided for @disclaimer5.
  ///
  /// In en, this message translates to:
  /// **'This page has no association with Matt Furie or his creation Pepe the Frog.'**
  String get disclaimer5;

  /// No description provided for @lastclaimed.
  ///
  /// In en, this message translates to:
  /// **'Last claimed'**
  String get lastclaimed;

  /// No description provided for @reservesthisamountofresources.
  ///
  /// In en, this message translates to:
  /// **'Reserves this amount of resources'**
  String get reservesthisamountofresources;

  /// No description provided for @permanentexclusion.
  ///
  /// In en, this message translates to:
  /// **'Permanent exclusion'**
  String get permanentexclusion;

  /// No description provided for @punishment.
  ///
  /// In en, this message translates to:
  /// **'Punishment'**
  String get punishment;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'close'**
  String get close;

  /// No description provided for @blockchainnodes.
  ///
  /// In en, this message translates to:
  /// **'Blockchain nodes'**
  String get blockchainnodes;

  /// No description provided for @ipfsnodes.
  ///
  /// In en, this message translates to:
  /// **'IPFS nodes'**
  String get ipfsnodes;

  /// No description provided for @connectionoverview.
  ///
  /// In en, this message translates to:
  /// **'Connection Overview'**
  String get connectionoverview;

  /// No description provided for @sanctionandban.
  ///
  /// In en, this message translates to:
  /// **'Sanction and will be banned for further violations.'**
  String get sanctionandban;

  /// No description provided for @rule.
  ///
  /// In en, this message translates to:
  /// **'Rule'**
  String get rule;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get connecting;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @customblockchainnode.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customblockchainnode;

  /// No description provided for @customipfsnode.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customipfsnode;

  /// No description provided for @safeforwork.
  ///
  /// In en, this message translates to:
  /// **'Safe for work'**
  String get safeforwork;

  /// No description provided for @erotic.
  ///
  /// In en, this message translates to:
  /// **'Erotic'**
  String get erotic;

  /// No description provided for @brutal.
  ///
  /// In en, this message translates to:
  /// **'Brutal'**
  String get brutal;

  /// No description provided for @createdon.
  ///
  /// In en, this message translates to:
  /// **'Created on'**
  String get createdon;

  /// No description provided for @addtofavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addtofavorite;

  /// No description provided for @ipfsexplain.
  ///
  /// In en, this message translates to:
  /// **'IPFS is the network in which videos and images for this platform are stored'**
  String get ipfsexplain;

  /// No description provided for @chainexplain.
  ///
  /// In en, this message translates to:
  /// **'The blockchain is where all the platform\'s data is managed, such as comments, favorites, ratings, etc'**
  String get chainexplain;

  /// No description provided for @yourvote.
  ///
  /// In en, this message translates to:
  /// **'Your Vote'**
  String get yourvote;

  /// No description provided for @proxiedvoteweight.
  ///
  /// In en, this message translates to:
  /// **'Proxied Vote Weight'**
  String get proxiedvoteweight;

  /// No description provided for @producers.
  ///
  /// In en, this message translates to:
  /// **'Producers'**
  String get producers;

  /// No description provided for @lastvoteweight.
  ///
  /// In en, this message translates to:
  /// **'Last Vote Weight'**
  String get lastvoteweight;

  /// No description provided for @proxy.
  ///
  /// In en, this message translates to:
  /// **'Proxy'**
  String get proxy;

  /// No description provided for @vote.
  ///
  /// In en, this message translates to:
  /// **'Vote'**
  String get vote;

  /// No description provided for @noblockproducerfound.
  ///
  /// In en, this message translates to:
  /// **'No Block Producer found'**
  String get noblockproducerfound;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Teilen'**
  String get share;

  /// No description provided for @notfound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notfound;

  /// No description provided for @profilepictureloadingtimeout.
  ///
  /// In en, this message translates to:
  /// **'Profile picture not found'**
  String get profilepictureloadingtimeout;

  /// No description provided for @activitytoken.
  ///
  /// In en, this message translates to:
  /// **'Activity Token'**
  String get activitytoken;

  /// No description provided for @activitytokenexplain.
  ///
  /// In en, this message translates to:
  /// **'Rewards activity on the platform. Have a limit that is reset daily.'**
  String get activitytokenexplain;

  /// No description provided for @selectrule.
  ///
  /// In en, this message translates to:
  /// **'Select rule'**
  String get selectrule;

  /// No description provided for @automaticchooseipfsnode.
  ///
  /// In en, this message translates to:
  /// **'Choose automatic best IPFS Nodes'**
  String get automaticchooseipfsnode;

  /// No description provided for @automaticchooseblockchainnode.
  ///
  /// In en, this message translates to:
  /// **'Choose automatic best Blockchain Nodes'**
  String get automaticchooseblockchainnode;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get automatic;

  /// No description provided for @connectionname.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get connectionname;

  /// No description provided for @connectionport.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get connectionport;

  /// No description provided for @connectionprotokoll.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get connectionprotokoll;

  /// No description provided for @connectionaddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get connectionaddress;

  /// No description provided for @connectionpath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get connectionpath;

  /// No description provided for @connectionmethode.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get connectionmethode;

  /// No description provided for @connectionsuccessfull.
  ///
  /// In en, this message translates to:
  /// **'Connection successfull'**
  String get connectionsuccessfull;

  /// No description provided for @connectionfailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionfailed;

  /// No description provided for @choosenfile.
  ///
  /// In en, this message translates to:
  /// **'Choosen File'**
  String get choosenfile;

  /// No description provided for @choosefiles.
  ///
  /// In en, this message translates to:
  /// **'Choose Files'**
  String get choosefiles;

  /// No description provided for @selectfile.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectfile;

  /// No description provided for @selectthumb.
  ///
  /// In en, this message translates to:
  /// **'Select Thumb'**
  String get selectthumb;

  /// No description provided for @nofileselected.
  ///
  /// In en, this message translates to:
  /// **'No File selected'**
  String get nofileselected;

  /// No description provided for @thumb.
  ///
  /// In en, this message translates to:
  /// **'Thumb'**
  String get thumb;

  /// No description provided for @thumbexplain.
  ///
  /// In en, this message translates to:
  /// **'A “thumb” (short for thumbnail) is a small preview image of an image or video'**
  String get thumbexplain;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @searchingnodes.
  ///
  /// In en, this message translates to:
  /// **'Searching Nodes'**
  String get searchingnodes;

  /// No description provided for @checkquota.
  ///
  /// In en, this message translates to:
  /// **'Checking Quota'**
  String get checkquota;

  /// No description provided for @offerproviders.
  ///
  /// In en, this message translates to:
  /// **'Select Provider'**
  String get offerproviders;

  /// No description provided for @preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get preparing;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading'**
  String get uploading;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @providerlistuserslots.
  ///
  /// In en, this message translates to:
  /// **'Your Slots'**
  String get providerlistuserslots;

  /// No description provided for @providerlistoffersfreeslots.
  ///
  /// In en, this message translates to:
  /// **'Free Slots'**
  String get providerlistoffersfreeslots;

  /// No description provided for @memo.
  ///
  /// In en, this message translates to:
  /// **'Memo'**
  String get memo;

  /// No description provided for @whitepaper.
  ///
  /// In en, this message translates to:
  /// **'WhitePaper'**
  String get whitepaper;

  /// No description provided for @linktodocumentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get linktodocumentation;

  /// No description provided for @linktoupdown.
  ///
  /// In en, this message translates to:
  /// **'updown.io Status Page'**
  String get linktoupdown;

  /// No description provided for @impressum.
  ///
  /// In en, this message translates to:
  /// **'Legal notice'**
  String get impressum;

  /// No description provided for @impressumloadfailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load legal notice'**
  String get impressumloadfailed;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @links.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get links;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rules;

  /// No description provided for @nouploadsfound.
  ///
  /// In en, this message translates to:
  /// **'No uploads found'**
  String get nouploadsfound;

  /// No description provided for @nofavoritesfound.
  ///
  /// In en, this message translates to:
  /// **'No Favorites found'**
  String get nofavoritesfound;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @favoritize.
  ///
  /// In en, this message translates to:
  /// **'Favoritize'**
  String get favoritize;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @theaccountisalreadyonthelist.
  ///
  /// In en, this message translates to:
  /// **'The account is already on the list.'**
  String get theaccountisalreadyonthelist;

  /// No description provided for @voteforblockproducers.
  ///
  /// In en, this message translates to:
  /// **'Vote for Block Producers'**
  String get voteforblockproducers;

  /// No description provided for @enterproducername.
  ///
  /// In en, this message translates to:
  /// **'Enter producer name'**
  String get enterproducername;

  /// No description provided for @listofproducers.
  ///
  /// In en, this message translates to:
  /// **'List of Producers'**
  String get listofproducers;

  /// No description provided for @thelistisempty.
  ///
  /// In en, this message translates to:
  /// **'The list is empty!'**
  String get thelistisempty;

  /// No description provided for @votesuccessful.
  ///
  /// In en, this message translates to:
  /// **'Vote successful!'**
  String get votesuccessful;

  /// No description provided for @editprofile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editprofile;

  /// No description provided for @profilebio.
  ///
  /// In en, this message translates to:
  /// **'Profile Beschreibung'**
  String get profilebio;

  /// No description provided for @profileimageipfs.
  ///
  /// In en, this message translates to:
  /// **'IPFS Hash of profile picture'**
  String get profileimageipfs;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @trusterexplain.
  ///
  /// In en, this message translates to:
  /// **'Trusters review reported content. They keep the platform clean. Any user can become a Truster. For their work, they are rewarded with TRUST tokens.'**
  String get trusterexplain;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @forme.
  ///
  /// In en, this message translates to:
  /// **'For me'**
  String get forme;

  /// No description provided for @allreports.
  ///
  /// In en, this message translates to:
  /// **'All reports'**
  String get allreports;

  /// No description provided for @changestatus.
  ///
  /// In en, this message translates to:
  /// **'Change Status'**
  String get changestatus;

  /// No description provided for @vacation.
  ///
  /// In en, this message translates to:
  /// **'Vacation'**
  String get vacation;

  /// No description provided for @openreport.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openreport;

  /// No description provided for @closedreports.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closedreports;

  /// No description provided for @applyasatruster.
  ///
  /// In en, this message translates to:
  /// **'Apply as a truster'**
  String get applyasatruster;

  /// No description provided for @applysuccessful.
  ///
  /// In en, this message translates to:
  /// **'Applyed successful'**
  String get applysuccessful;

  /// No description provided for @criteriayear.
  ///
  /// In en, this message translates to:
  /// **'Registered for at least one year'**
  String get criteriayear;

  /// No description provided for @criteriauploads.
  ///
  /// In en, this message translates to:
  /// **'Has at least 20 uploads'**
  String get criteriauploads;

  /// No description provided for @criteriacomments.
  ///
  /// In en, this message translates to:
  /// **'Has at least 20 comments'**
  String get criteriacomments;

  /// No description provided for @urgentreport.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgentreport;

  /// No description provided for @important.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get important;

  /// No description provided for @selectedrule.
  ///
  /// In en, this message translates to:
  /// **'Selected Rule'**
  String get selectedrule;

  /// No description provided for @votes.
  ///
  /// In en, this message translates to:
  /// **'Votes'**
  String get votes;

  /// No description provided for @stakedtotal.
  ///
  /// In en, this message translates to:
  /// **'Total Staked'**
  String get stakedtotal;

  /// No description provided for @actionboard.
  ///
  /// In en, this message translates to:
  /// **'Action Board'**
  String get actionboard;

  /// No description provided for @actionboardreviewdesc.
  ///
  /// In en, this message translates to:
  /// **'See all open reports'**
  String get actionboardreviewdesc;

  /// No description provided for @actionboardstatusdesc.
  ///
  /// In en, this message translates to:
  /// **'View your current status'**
  String get actionboardstatusdesc;

  /// No description provided for @actionboardsettingsdesc.
  ///
  /// In en, this message translates to:
  /// **'Open truster settings'**
  String get actionboardsettingsdesc;

  /// No description provided for @violation.
  ///
  /// In en, this message translates to:
  /// **'Violation'**
  String get violation;

  /// No description provided for @inlinewiththerules.
  ///
  /// In en, this message translates to:
  /// **'In line with the rules'**
  String get inlinewiththerules;

  /// No description provided for @reportedby.
  ///
  /// In en, this message translates to:
  /// **'Reported by'**
  String get reportedby;

  /// No description provided for @uploadedby.
  ///
  /// In en, this message translates to:
  /// **'Uploaded by'**
  String get uploadedby;

  /// No description provided for @votingoverview.
  ///
  /// In en, this message translates to:
  /// **'Overview about voting'**
  String get votingoverview;

  /// No description provided for @reportvote.
  ///
  /// In en, this message translates to:
  /// **'Report Vote'**
  String get reportvote;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @inorder.
  ///
  /// In en, this message translates to:
  /// **'In line'**
  String get inorder;

  /// No description provided for @timeleft.
  ///
  /// In en, this message translates to:
  /// **'Time left'**
  String get timeleft;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'cs',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'uk',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
