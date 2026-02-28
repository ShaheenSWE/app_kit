# app_kit

`app_kit` provides reusable app foundations (database + utilities).

## Database (Drift)

- `AppKitTable`: fixed columns (`id`, `createdAt`)
- `AppKitMigration`: fixed migration defaults (`createAll`, FK ON)
- `db.crud(table)`: generic CRUD for any `AppKitTable`

## Code generation (Drift)

Keep Drift's generated part in your DB file:

```dart
part 'app_database.g.dart';
```

Run generator:

```bash
dart run build_runner build --delete-conflicting-outputs
```
