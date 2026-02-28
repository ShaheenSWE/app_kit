import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String appKitDefaultDatabaseFileName = 'app_kit.sqlite';

/// Creates a cross-platform Drift database connection.
LazyDatabase openAppKitConnection({
  String fileName = appKitDefaultDatabaseFileName,
}) {
  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }

    final file = File(p.join(directory.path, fileName));
    return NativeDatabase.createInBackground(file);
  });
}

/// Reusable migration strategy for all AppKit Drift databases.
mixin AppKitMigration on GeneratedDatabase {
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      await onAppKitUpgrade(migrator, from, to);
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Override this to handle schema upgrades.
  Future<void> onAppKitUpgrade(Migrator migrator, int from, int to) async {}
}
