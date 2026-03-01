import 'package:drift/drift.dart';

abstract class AppKitSeedEntry {
  const AppKitSeedEntry();

  void apply(Batch batch);
}

class AppKitSeedTable<T extends Table, D> {
  const AppKitSeedTable({
    required this.table,
    required this.rows,
    this.mode = InsertMode.insertOrIgnore,
  });

  final TableInfo<T, D> table;
  final List<Insertable<D>> rows;
  final InsertMode mode;
}

class _AppKitSeedEntry<T extends Table, D> extends AppKitSeedEntry {
  const _AppKitSeedEntry(this.seed);

  final AppKitSeedTable<T, D> seed;

  @override
  void apply(Batch batch) {
    final table = seed.table as TableInfo<Table, dynamic>;
    for (final row in seed.rows) {
      batch.insert<Table, dynamic>(table, row, mode: seed.mode);
    }
  }
}

AppKitSeedEntry appKitSeed<T extends Table, D>(
  TableInfo<T, D> table,
  List<Insertable<D>> rows, {
  InsertMode mode = InsertMode.insertOrIgnore,
}) {
  return _AppKitSeedEntry<T, D>(
    AppKitSeedTable<T, D>(table: table, rows: rows, mode: mode),
  );
}
