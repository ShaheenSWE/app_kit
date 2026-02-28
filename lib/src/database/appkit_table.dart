import 'package:drift/drift.dart';

/// Base table for AppKit entities.
///
/// Includes common fixed columns to avoid repeating them in every table.
abstract class AppKitTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
