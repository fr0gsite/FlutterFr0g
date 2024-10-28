import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:convert/convert.dart';
import 'package:pointycastle/key_generators/ec_key_generator.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/random/fortuna_random.dart';

class Uploadkey {
  Uint8List _generateRandomBytes(int length) {
    final rnd = FortunaRandom();
    final seed = Uint8List.fromList(
        List<int>.generate(32, (i) => Random.secure().nextInt(256)));
    rnd.seed(KeyParameter(seed));
    return rnd.nextBytes(length);
  }

  AsymmetricKeyPair<PublicKey, PrivateKey> generateKeyPair() {
    final keyParams = ECKeyGeneratorParameters(ECCurve_secp256k1());
    final random = SecureRandom('Fortuna')
      ..seed(KeyParameter(_generateRandomBytes(32)));

    final generator = ECKeyGenerator()
      ..init(ParametersWithRandom(keyParams, random));

    final pair = generator.generateKeyPair();
    return AsymmetricKeyPair<PublicKey, PrivateKey>(
      pair.publicKey,
      pair.privateKey,
    );
  }

  String privateKeyToHex(ECPrivateKey privateKey) {
    return privateKey.d!.toRadixString(16);
  }

  String publicKeyToHex(ECPublicKey publicKey) {
    return hex.encode(publicKey.Q!.getEncoded(false));
  }

  String publicKeyToBase64(ECPublicKey publicKey) {
    return base64.encode(publicKey.Q!.getEncoded(false));
  }
}
