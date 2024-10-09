import 'package:fr0gsite/config.dart';
import 'package:eosdart/eosdart.dart';

List<Action> addupload(
    String autor,
    String uploadipfshash,
    String thumbipfshash,
    String uploadtext,
    String language,
    String uploadfiletyp,
    String thumbfiletyp,
    int flag,
    auth) {
  List<Action> actions = [
    Action()
      ..account = AppConfig.maincontract
      ..name = "addupload"
      ..authorization = auth
      ..data = {
        "autor": autor,
        "uploadipfshash": uploadipfshash,
        "thumbipfshash": thumbipfshash,
        "uploadtext": uploadtext,
        "language": language,
        "uploadfiletyp": uploadfiletyp,
        "thumbfiletyp": thumbfiletyp,
        "flag": flag,
      }
  ];
  return actions;
}

List<Action> addfavorite(String autor, int uploadid, auth) {
  List<Action> actions = [
    Action()
      ..account = AppConfig.maincontract
      ..name = "addfavorite"
      ..authorization = auth
      ..data = {
        "autor": autor,
        "uploadid": uploadid,
      }
  ];
  return actions;
}

List<Action> deletefavorite(String autor, int uploadid, auth) {
  List<Action> actions = [
    Action()
      ..account = AppConfig.maincontract
      ..name = "delfavorite"
      ..authorization = auth
      ..data = {
        "autor": autor,
        "uploadid": uploadid,
      }
  ];
  return actions;
}

List<Action> actionlistvoteupload(String autor, int uploadid, int vote, auth) {
  List<Action> actions = [
    Action()
      ..account = AppConfig.maincontract
      ..name = "voteupload"
      ..authorization = auth
      ..data = {
        "autor": autor,
        "vote": vote,
        "uploadid": uploadid,
      }
  ];
  return actions;
}

List<Action> stakeressources(
    String from, String receiver, String cpu, String net, auth) {
  List<Action> actions = [
    Action()
      ..account = "eosio"
      ..name = "delegatebw"
      ..authorization = auth
      ..data = {
        "from": from,
        "receiver": receiver,
        "stake_cpu_quantity": "$cpu ${AppConfig.systemtoken}",
        "stake_net_quantity": "$net ${AppConfig.systemtoken}",
        "transfer": false,
      }
  ];
  return actions;
}

List<Action> unstakeressources(
    String from, String receiver, String cpu, String net, auth) {
  List<Action> actions = [
    Action()
      ..account = "eosio"
      ..data = {
        "from": from,
        "receiver": receiver,
        "unstake_cpu_quantity": "$cpu ${AppConfig.systemtoken}",
        "unstake_net_quantity": "$net ${AppConfig.systemtoken}"
      }
      ..name = "undelegatebw"
      ..authorization = auth,
  ];
  return actions;
}

List<Action> buyram(String payer, String receiver, int bytes, auth) {
  List<Action> actions = [
    Action()
      ..account = "eosio"
      ..data = {"payer": payer, "receiver": receiver, "bytes": bytes}
      ..name = "buyrambytes"
      ..authorization = auth,
  ];
  return actions;
}

//Not tested
List<Action> sellram(String account, int bytes, auth) {
  List<Action> actions = [
    Action()
      ..account = "eosio"
      ..data = {"account": account, "bytes": bytes}
      ..name = "sellram"
      ..authorization = auth,
  ];
  return actions;
}

List<Action> newaccount(String creator, String newusername, String ownerpubkey,
    String activepubkey, auth) {
  List<Action> actions = [
    Action()
      ..account = "eosio"
      ..data = {
        "creator": creator,
        "name": newusername,
        "owner": {
          "threshold": 1,
          "keys": [
            {"key": ownerpubkey, "weight": 1}
          ],
          "accounts": [],
          "waits": []
        },
        "active": {
          "threshold": 1,
          "keys": [
            {"key": activepubkey, "weight": 1}
          ],
          "accounts": [],
          "waits": []
        },
      }
      ..name = "newaccount"
      ..authorization = auth,
  ];
  return actions;
}

List<Action> sendtokenlistaction(
    String from, String to, String amount, String memo, auth) {
  List<Action> actions = [
    Action()
      ..account = "eosio.token"
      ..data = {"from": from, "to": to, "quantity": amount, "memo": memo}
      ..name = "transfer"
      ..authorization = auth,
  ];
  return actions;
}

List<Action> createuser(String creator, String newusername, String ownerpubkey,
    String activepubkey, auth) {
  List<Action> actions = [
    newaccount(creator, newusername, ownerpubkey, activepubkey, auth).first,
    buyram(creator, newusername, 4996, auth).first,
    stakeressources(creator, newusername, "1.000", "1.000", auth).first,
  ];
  return actions;
}
