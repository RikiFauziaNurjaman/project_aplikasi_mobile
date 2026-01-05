import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Initialize database for native platforms (Windows, Linux, macOS, Android, iOS)
Future<void> initializeDatabase() async {
  // Only initialize FFI for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // Android and iOS use default sqflite, no initialization needed
}
