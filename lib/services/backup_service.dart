import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dukan_tools/models/ledger_account.dart';
import 'package:dukan_tools/models/pl_entry.dart';
import 'package:dukan_tools/models/shop.dart';

class BackupService {
  static const String backupFileName = 'dukantools_ledger_backup.json';

  // Returns list of directories that can be used for backup/restore
  static Future<List<Directory>> getBackupDirectories() async {
    List<Directory> dirs = [];

    try {
      // 1. Path Provider Downloads
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir != null) {
        dirs.add(Directory('${downloadsDir.path}/DukanToolsBackup'));
      }
    } catch (e) {
      debugPrint('Error getting downloads dir: $e');
    }

    try {
      // 2. Path Provider Documents (Survives uninstall on desktop/Windows)
      final documentsDir = await getApplicationDocumentsDirectory();
      dirs.add(Directory('${documentsDir.path}/DukanToolsBackup'));
    } catch (e) {
      debugPrint('Error getting documents dir: $e');
    }

    // 3. Android specific public directories (survives uninstall)
    if (Platform.isAndroid) {
      dirs.add(Directory('/storage/emulated/0/Download/DukanToolsBackup'));
      dirs.add(Directory('/storage/emulated/0/Documents/DukanToolsBackup'));
    }

    return dirs;
  }

  // Request storage permission if on Android
  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    // Check current status
    var status = await Permission.storage.status;
    if (status.isGranted) return true;

    status = await Permission.storage.request();
    if (status.isGranted) return true;

    // Try requesting manageExternalStorage as fallback or photos/media
    var manageStatus = await Permission.manageExternalStorage.request();
    return manageStatus.isGranted;
  }

  // Back up ledger and P&L data to all available directories
  static Future<bool> backupData({
    required List<LedgerAccount> accounts,
    required List<PLEntry> plEntries,
    List<Shop>? shops,
  }) async {
    try {
      // Request permissions
      await requestStoragePermission();

      final backupData = {
        'version': 2,
        'timestamp': DateTime.now().toIso8601String(),
        'ledger': accounts.map((a) => a.toJson()).toList(),
        'p_and_l': plEntries.map((e) => e.toJson()).toList(),
        'shops': (shops ?? []).map((s) => s.toJson()).toList(),
      };

      final jsonString = jsonEncode(backupData);
      final dirs = await getBackupDirectories();
      bool success = false;

      for (var dir in dirs) {
        try {
          if (!await dir.exists()) {
            await dir.create(recursive: true);
          }
          final file = File('${dir.path}/$backupFileName');
          await file.writeAsString(jsonString);
          debugPrint('Backup written successfully to: ${file.path}');
          success = true;
        } catch (e) {
          debugPrint('Failed to write backup to ${dir.path}: $e');
        }
      }

      return success;
    } catch (e) {
      debugPrint('Backup error: $e');
      return false;
    }
  }

  // Scan directories for backup files and return the parsed data if found
  static Future<Map<String, dynamic>?> scanAndRestore() async {
    try {
      final dirs = await getBackupDirectories();
      for (var dir in dirs) {
        try {
          final file = File('${dir.path}/$backupFileName');
          if (await file.exists()) {
            final jsonString = await file.readAsString();
            final data = jsonDecode(jsonString) as Map<String, dynamic>;
            debugPrint('Found backup file at: ${file.path}');
            return data;
          }
        } catch (e) {
          debugPrint('Failed to read backup from ${dir.path}: $e');
        }
      }
    } catch (e) {
      debugPrint('Scan and restore error: $e');
    }
    return null;
  }
}
