class SomeHelper {
  bool isPublicKeyValide(String public) {
    final regExpPubkey = RegExp('EOS[A-HJ-NP-Za-km-z1-9]{50}');
    return regExpPubkey.hasMatch(public);
  }

  bool isPrivateKeyValide(String private) {
    var regExpPubkey = RegExp('5[A-Za-z0-9]{50}');
    return regExpPubkey.hasMatch(private);
  }

  bool isUsernameValid(String username) {
    var regExpPubkey =
        RegExp('(^[a-z1-5.]{1,11}[a-z1-5]\$)|(^[a-z1-5.]{12}[a-j1-5]\$)');
    return regExpPubkey.hasMatch(username);
  }
}
