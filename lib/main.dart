import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap/bootstrap.dart';

void main() {
  bootstrap(() {
    return const ProviderScope(child: OfflineQuotesApp());
  });
}
