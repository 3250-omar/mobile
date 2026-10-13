import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import '../domain/backup_metadata.dart';
import '../domain/backup_result.dart';

/// Pure Dart implementation of SHA-256 (FIPS 180-4) with zero external dependencies.
class PureSha256 {
  const PureSha256();

  static const List<int> _k = [
    0x428a2f98,
    0x71374491,
    0xb5c0fbcf,
    0xe9b5dba5,
    0x3956c25b,
    0x59f111f1,
    0x923f82a4,
    0xab1c5ed5,
    0xd807aa98,
    0x12835b01,
    0x243185be,
    0x550c7dc3,
    0x72be5d74,
    0x80deb1fe,
    0x9bdc06a7,
    0xc19bf174,
    0xe49b69c1,
    0xefbe4786,
    0x0fc19dc6,
    0x240ca1cc,
    0x2de92c6f,
    0x4a7484aa,
    0x5cb0a9dc,
    0x76f988da,
    0x983e5152,
    0xa831c66d,
    0xb00327c8,
    0xbf597fc7,
    0xc6e00bf3,
    0xd5a79147,
    0x06ca6351,
    0x14292967,
    0x27b70a85,
    0x2e1b2138,
    0x4d2c6dfc,
    0x53380d13,
    0x650a7354,
    0x766a0abb,
    0x81c2c92e,
    0x92722c85,
    0xa2bfe8a1,
    0xa81a664b,
    0xc24b8b70,
    0xc76c51a3,
    0xd192e819,
    0xd6990624,
    0xf40e3585,
    0x106aa070,
    0x19a4c116,
    0x1e376c08,
    0x2748774c,
    0x34b0bcb5,
    0x391c0cb3,
    0x4ed8aa4a,
    0x5b9cca4f,
    0x682e6ff3,
    0x748f82ee,
    0x78a5636f,
    0x84c87814,
    0x8cc70208,
    0x90befffa,
    0xa4506ceb,
    0xbef9a3f7,
    0xc67178f2,
  ];

  static int _rotr(int x, int n) => ((x >> n) | (x << (32 - n))) & 0xFFFFFFFF;

  static List<int> hash(List<int> data) {
    var h0 = 0x6a09e667;
    var h1 = 0xbb67ae85;
    var h2 = 0x3c6ef372;
    var h3 = 0xa54ff53a;
    var h4 = 0x510e527f;
    var h5 = 0x9b05688c;
    var h6 = 0x1f83d9ab;
    var h7 = 0x5be0cd19;

    final length = data.length;
    final bitLength = length * 8;
    final paddingLength = (56 - (length + 1) % 64 + 64) % 64;
    final totalLength = length + 1 + paddingLength + 8;
    final padded = Uint8List(totalLength);
    padded.setRange(0, length, data);
    padded[length] = 0x80;

    final bd = ByteData.sublistView(padded);
    bd.setUint64(totalLength - 8, bitLength, Endian.big);

    final w = Uint32List(64);

    for (var i = 0; i < totalLength; i += 64) {
      for (var t = 0; t < 16; t++) {
        w[t] = bd.getUint32(i + t * 4, Endian.big);
      }
      for (var t = 16; t < 64; t++) {
        final s0 =
            _rotr(w[t - 15], 7) ^ _rotr(w[t - 15], 18) ^ (w[t - 15] >> 3);
        final s1 = _rotr(w[t - 2], 17) ^ _rotr(w[t - 2], 19) ^ (w[t - 2] >> 10);
        w[t] = (w[t - 16] + s0 + w[t - 7] + s1) & 0xFFFFFFFF;
      }

      var a = h0;
      var b = h1;
      var c = h2;
      var d = h3;
      var e = h4;
      var f = h5;
      var g = h6;
      var h = h7;

      for (var t = 0; t < 64; t++) {
        final s1 = _rotr(e, 6) ^ _rotr(e, 11) ^ _rotr(e, 25);
        final ch = (e & f) ^ (~e & g);
        final temp1 = (h + s1 + ch + _k[t] + w[t]) & 0xFFFFFFFF;
        final s0 = _rotr(a, 2) ^ _rotr(a, 13) ^ _rotr(a, 22);
        final maj = (a & b) ^ (a & c) ^ (b & c);
        final temp2 = (s0 + maj) & 0xFFFFFFFF;

        h = g;
        g = f;
        f = e;
        e = (d + temp1) & 0xFFFFFFFF;
        d = c;
        c = b;
        b = a;
        a = (temp1 + temp2) & 0xFFFFFFFF;
      }

      h0 = (h0 + a) & 0xFFFFFFFF;
      h1 = (h1 + b) & 0xFFFFFFFF;
      h2 = (h2 + c) & 0xFFFFFFFF;
      h3 = (h3 + d) & 0xFFFFFFFF;
      h4 = (h4 + e) & 0xFFFFFFFF;
      h5 = (h5 + f) & 0xFFFFFFFF;
      h6 = (h6 + g) & 0xFFFFFFFF;
      h7 = (h7 + h) & 0xFFFFFFFF;
    }

    final out = Uint8List(32);
    final outBd = ByteData.sublistView(out);
    outBd.setUint32(0, h0, Endian.big);
    outBd.setUint32(4, h1, Endian.big);
    outBd.setUint32(8, h2, Endian.big);
    outBd.setUint32(12, h3, Endian.big);
    outBd.setUint32(16, h4, Endian.big);
    outBd.setUint32(20, h5, Endian.big);
    outBd.setUint32(24, h6, Endian.big);
    outBd.setUint32(28, h7, Endian.big);
    return out;
  }

  static String hashHex(List<int> data) {
    final h = hash(data);
    return h.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static List<int> hmac(List<int> key, List<int> data) {
    var k = key;
    if (k.length > 64) {
      k = hash(k);
    }
    final kPad = Uint8List(64);
    kPad.setRange(0, k.length, k);

    final iPad = Uint8List(64 + data.length);
    final oPad = Uint8List(64 + 32);

    for (var i = 0; i < 64; i++) {
      iPad[i] = kPad[i] ^ 0x36;
      oPad[i] = kPad[i] ^ 0x5c;
    }
    iPad.setRange(64, iPad.length, data);

    final innerHash = hash(iPad);
    oPad.setRange(64, oPad.length, innerHash);

    return hash(oPad);
  }
}

/// Simple keystream cipher using HMAC-SHA256 for authenticated encryption.
class SimpleStreamCipher {
  const SimpleStreamCipher();

  static List<int> deriveKey(
    String password,
    List<int> salt, {
    int iterations = 1000,
  }) {
    List<int> key = utf8.encode(password);
    for (var i = 0; i < iterations; i++) {
      key = PureSha256.hmac(key, salt);
    }
    return key;
  }

  static Uint8List crypt(Uint8List data, List<int> key, List<int> iv) {
    final out = Uint8List(data.length);
    var blockIndex = 0;
    var keyStream = <int>[];
    var keyStreamOffset = 0;

    for (var i = 0; i < data.length; i++) {
      if (keyStreamOffset >= keyStream.length) {
        final counterData = Uint8List(iv.length + 4);
        counterData.setRange(0, iv.length, iv);
        ByteData.sublistView(counterData)
            .setUint32(iv.length, blockIndex++, Endian.big);
        keyStream = PureSha256.hmac(key, counterData);
        keyStreamOffset = 0;
      }
      out[i] = data[i] ^ keyStream[keyStreamOffset++];
    }
    return out;
  }
}

/// Binary container encoder/decoder for `.aqb` backup files.
class BackupContainerCoder {
  const BackupContainerCoder();

  static const List<int> magicBytes = [0x41, 0x51, 0x42, 0x31]; // "AQB1"

  /// Encodes raw SQLite payload and metadata into binary container bytes.
  Uint8List encode({
    required Uint8List sqliteBytes,
    required int schemaVersion,
    int totalProducts = 0,
    int totalQuotations = 0,
    int totalInvoices = 0,
    String? password,
  }) {
    final isEncrypted = password != null && password.isNotEmpty;
    Uint8List payloadToStore;
    String? saltBase64;
    String? ivBase64;
    final checksum = PureSha256.hashHex(sqliteBytes);

    if (isEncrypted) {
      final rng = Random.secure();
      final salt = Uint8List.fromList(
        List.generate(16, (_) => rng.nextInt(256)),
      );
      final iv = Uint8List.fromList(List.generate(12, (_) => rng.nextInt(256)));
      saltBase64 = base64.encode(salt);
      ivBase64 = base64.encode(iv);

      final key = SimpleStreamCipher.deriveKey(password, salt);
      payloadToStore = SimpleStreamCipher.crypt(sqliteBytes, key, iv);
    } else {
      payloadToStore = sqliteBytes;
    }

    final metadata = BackupMetadata(
      schemaVersion: schemaVersion,
      createdAt: DateTime.now(),
      checksumSha256: checksum,
      isEncrypted: isEncrypted,
      saltBase64: saltBase64,
      ivBase64: ivBase64,
      totalProductsCount: totalProducts,
      totalQuotationsCount: totalQuotations,
      totalInvoicesCount: totalInvoices,
    );

    final metaJsonBytes = utf8.encode(jsonEncode(metadata.toJson()));
    final totalBytes = 4 + 1 + 4 + metaJsonBytes.length + payloadToStore.length;
    final buffer = Uint8List(totalBytes);
    final bd = ByteData.sublistView(buffer);

    // 1. Magic
    buffer.setRange(0, 4, magicBytes);
    // 2. Flags (bit 0 = encrypted)
    buffer[4] = isEncrypted ? 1 : 0;
    // 3. Metadata length
    bd.setUint32(5, metaJsonBytes.length, Endian.big);
    // 4. Metadata
    buffer.setRange(9, 9 + metaJsonBytes.length, metaJsonBytes);
    // 5. Payload
    buffer.setRange(9 + metaJsonBytes.length, totalBytes, payloadToStore);

    return buffer;
  }

  /// Inspects container bytes and extracts metadata without full decryption.
  RestoreValidationResult inspect(Uint8List containerBytes) {
    if (containerBytes.length < 9) {
      return const RestoreValidationResult(
        isValid: false,
        error: RestoreValidationError.invalidContainerHeader,
        diagnosticMessage: 'File size too small for header',
      );
    }

    for (var i = 0; i < 4; i++) {
      if (containerBytes[i] != magicBytes[i]) {
        return const RestoreValidationResult(
          isValid: false,
          error: RestoreValidationError.invalidContainerHeader,
          diagnosticMessage: 'Invalid magic bytes',
        );
      }
    }

    final bd = ByteData.sublistView(containerBytes);
    final metaLen = bd.getUint32(5, Endian.big);

    if (containerBytes.length < 9 + metaLen) {
      return const RestoreValidationResult(
        isValid: false,
        error: RestoreValidationError.invalidContainerHeader,
        diagnosticMessage: 'Truncated metadata length',
      );
    }

    try {
      final metaBytes = containerBytes.sublist(9, 9 + metaLen);
      final metaJson =
          jsonDecode(utf8.decode(metaBytes)) as Map<String, dynamic>;
      final metadata = BackupMetadata.fromJson(metaJson);

      return RestoreValidationResult(isValid: true, metadata: metadata);
    } catch (e) {
      return RestoreValidationResult(
        isValid: false,
        error: RestoreValidationError.invalidContainerHeader,
        diagnosticMessage: e.toString(),
      );
    }
  }

  /// Unpacks container bytes and returns the verified SQLite database payload.
  Uint8List decode(Uint8List containerBytes, {String? password}) {
    final validation = inspect(containerBytes);
    if (!validation.isValid || validation.metadata == null) {
      throw const FormatException('Invalid backup file');
    }

    final meta = validation.metadata!;
    final bd = ByteData.sublistView(containerBytes);
    final metaLen = bd.getUint32(5, Endian.big);
    final payloadBytes = containerBytes.sublist(9 + metaLen);

    Uint8List decryptedSqlite;

    if (meta.isEncrypted) {
      if (password == null || password.isEmpty) {
        throw const FormatException('Password required for encrypted backup');
      }
      final salt = base64.decode(meta.saltBase64!);
      final iv = base64.decode(meta.ivBase64!);
      final key = SimpleStreamCipher.deriveKey(password, salt);
      decryptedSqlite = SimpleStreamCipher.crypt(payloadBytes, key, iv);
    } else {
      decryptedSqlite = payloadBytes;
    }

    final computedHash = PureSha256.hashHex(decryptedSqlite);
    if (computedHash != meta.checksumSha256) {
      throw const FormatException(
        'Checksum mismatch: payload corrupted or wrong password',
      );
    }

    return decryptedSqlite;
  }
}
