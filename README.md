# app_kit

All-in-one Flutter toolkit package.

```dart
import 'package:app_kit/app_kit.dart';
```

## What `app_kit.dart` exports

- Drift API: `package:drift/drift.dart`
- Database helpers:
  - `AppKitTable`
  - `openAppKitConnection()`
  - `AppKitMigration`
  - `AppKitCrudDao`
  - `db.crud(table)` extension
- Utilities:
  - `AppSnack`
  - `AppKitColors`
- Widgets:
  - `AppTable`
  - `AppSearchField`
  - `AppTextField`
  - `AppDropdown`
  - `AppRibbon`
  - `AppSpinner`
- External exports for convenience:
  - `HugeIcons` (`package:hugeicons/hugeicons.dart`)
  - GetX (`package:get/get.dart` with `Value` hidden)

## Database usage (Drift)

```dart
import 'package:app_kit/app_kit.dart';

part 'app_database.g.dart';

class Users extends AppKitTable {
  TextColumn get name => text().withLength(min: 1, max: 150)();
  IntColumn get age => integer()();
}

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase with AppKitMigration {
  AppDatabase() : super(openAppKitConnection(fileName: 'my_app.sqlite'));

  @override
  int get schemaVersion => 1;
}

final db = AppDatabase();
final usersDao = db.crud(db.users);

final id = await usersDao.insertOne(UsersCompanion.insert(name: 'Mohamed', age: 30));
final all = await usersDao.getAll();
final one = await usersDao.getById(id);
await usersDao.deleteById(id);
```

Generate Drift code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Snackbar usage

```dart
AppSnack.success('Saved');
AppSnack.error('Something went wrong');
AppSnack.warning('Be careful');
```

## Colors usage

```dart
Container(color: AppKitColors.blue);
```

## Widgets usage

### `AppTable<T>`

```dart
AppTable<User>(
  headers: const ['Name', 'Age'],
  cellWidths: const [
    AppTableCellWidth.flex(2),
    AppTableCellWidth.flex(1),
  ],
  stream: db.select(db.users).watch(),
  cellBuilders: [
    (u) => Text(u.name),
    (u) => Text('${u.age}'),
  ],
  isExpanded: true,
)
```

### `AppSearchField`

```dart
AppSearchField(
  onChanged: (value) {},
  onClear: () {},
)
```

### `AppTextField`

```dart
AppTextField(
  label: 'Name',
  icon: HugeIcons.strokeRoundedUser,
  onChanged: (value) {},
)
```

### `AppDropdown<T>`

```dart
AppDropdown<String>(
  label: 'City',
  icon: HugeIcons.strokeRoundedLocation01,
  items: const ['Riyadh', 'Cairo'],
  onChanged: (value) {},
)
```

### `AppRibbon`

```dart
const AppRibbon()
```

### `AppSpinner`

```dart
const AppSpinner()
```

## GetX and HugeIcons

Because they are re-exported, you can use them directly after importing `app_kit`:

```dart
Get.toNamed('/home');
const HugeIcon(icon: HugeIcons.strokeRoundedHome01);
```
