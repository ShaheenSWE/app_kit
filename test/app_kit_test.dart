import 'package:app_kit/app_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

part 'app_kit_test.g.dart';

class Users extends AppKitTable {
  TextColumn get name => text().withLength(min: 1, max: 150)();
  IntColumn get age => integer().check(age.isBiggerOrEqualValue(0))();
}

@DriftDatabase(tables: <Type>[Users])
class AppDatabase extends _$AppDatabase with AppKitMigration {
  AppDatabase(QueryExecutor executor) : super(executor);

  AppDatabase.test() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;
}

void main() {
  test('fixed drift base table and dao work', () async {
    final db = AppDatabase.test();
    final dao = db.crud(db.users);

    final id = await dao.insertOne(
      UsersCompanion.insert(name: 'Mohamed', age: 30),
    );

    final one = await dao.getById(id);
    expect(one != null, isTrue);
    expect(one!.name, 'Mohamed');

    final rows = await dao.getAll();
    expect(rows.length, 1);

    await dao.replaceOne(one.copyWith(age: 31));
    final updated = await dao.getById(id);
    expect(updated!.age, 31);

    await dao.deleteById(id);
    expect(await dao.getAll(), isEmpty);

    await db.close();
  });
}
