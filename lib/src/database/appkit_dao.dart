import 'package:drift/drift.dart';
import 'appkit_table.dart';

/// Generic CRUD DAO for tables that use an integer id.
class AppKitCrudDao<
  D extends GeneratedDatabase,
  T extends AppKitTable,
  R extends Insertable<R>
> {
  AppKitCrudDao({
    required this.db,
    required this.table,
    required this.idColumn,
  });

  final D db;
  final TableInfo<T, R> table;
  final GeneratedColumn<int> idColumn;

  Future<List<R>> getAll() {
    return db.select(table).get();
  }

  Stream<List<R>> watchAll() {
    return db.select(table).watch();
  }

  Future<R?> getById(int id) {
    final query = db.select(table)..where((_) => idColumn.equals(id));
    return query.getSingleOrNull();
  }

  Future<int> insertOne(
    Insertable<R> row, {
    InsertMode mode = InsertMode.insert,
  }) {
    return db.into(table).insert(row, mode: mode);
  }

  Future<void> upsertOne(Insertable<R> row) {
    return db.into(table).insertOnConflictUpdate(row);
  }

  Future<bool> replaceOne(R row) {
    return db.update(table).replace(row);
  }

  Future<int> deleteById(int id) {
    final query = db.delete(table)..where((_) => idColumn.equals(id));
    return query.go();
  }

  Future<int> deleteAll() {
    return db.delete(table).go();
  }
}

extension AppKitCrudDatabaseX<D extends GeneratedDatabase> on D {
  AppKitCrudDao<D, T, R> crud<T extends AppKitTable, R extends Insertable<R>>(
    TableInfo<T, R> table, {
    String idColumnName = 'id',
  }) {
    final idColumn = table.columnsByName[idColumnName];
    if (idColumn == null) {
      throw ArgumentError(
        'Table ${table.actualTableName} does not have "$idColumnName" column.',
      );
    }
    return AppKitCrudDao<D, T, R>(
      db: this,
      table: table,
      idColumn: idColumn as GeneratedColumn<int>,
    );
  }
}
