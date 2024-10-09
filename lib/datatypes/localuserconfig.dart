import 'package:fr0gsite/localstorage.dart';

class LocalUserConfig {
  String username;
  bool accepteddisclaimer;

  LocalUserConfig({required this.username, required this.accepteddisclaimer});

  factory LocalUserConfig.fromJson(Map<String, dynamic> json) {
    return LocalUserConfig(
      username: json['username'],
      accepteddisclaimer: json['accepteddisclaimer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'accepteddisclaimer': accepteddisclaimer,
    };
  }

  bool acceptdisclaimer() {
    accepteddisclaimer = true;
    savelocaluserconfig(this);
    return true;
  }

  static LocalUserConfig dummy() {
    return LocalUserConfig(
      username: "dummy",
      accepteddisclaimer: false,
    );
  }
}
