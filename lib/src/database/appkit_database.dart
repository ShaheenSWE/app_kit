import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'appkit_seed.dart';

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
///
/// Seed rows are inserted in batch during first database creation (`onCreate`) only.
mixin AppKitMigration on GeneratedDatabase {
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _insertSeedRowsOnCreate();
    },
    onUpgrade: (migrator, from, to) async {
      await onAppKitUpgrade(migrator, from, to);
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Override this with your app seed definitions.
  List<AppKitSeedEntry> get appKitSeeds => const <AppKitSeedEntry>[];

  /// Helper to define seeds in the simplest way from inside database class.
  AppKitSeedEntry seed<T extends Table, D>(
    TableInfo<T, D> table,
    List<Insertable<D>> rows, {
    InsertMode mode = InsertMode.insertOrIgnore,
  }) {
    return appKitSeed<T, D>(table, rows, mode: mode);
  }

  /// Override this to handle schema upgrades.
  Future<void> onAppKitUpgrade(Migrator migrator, int from, int to) async {}

  Future<void> _insertSeedRowsOnCreate() async {
    if (appKitSeeds.isEmpty) {
      return;
    }

    await batch((b) {
      for (final seed in appKitSeeds) {
        seed.apply(b);
      }
    });
  }
}
