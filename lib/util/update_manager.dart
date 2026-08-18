import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateDialog extends StatefulWidget {
  final String apkUrl;

  const UpdateDialog({super.key, required this.apkUrl});

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  double progress = 0.0;
  bool downloading = false;
  String status = "Update Available";

  Future<void> _downloadAndInstallApk() async {
    // Ask storage permission (Android 10 and below)
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }

    setState(() {
      downloading = true;
      status = "Downloading Update";
    });

    // Get app-specific directory
    Directory dir =
        await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
    String filePath = "${dir.path}/update.apk";
    File file = File(filePath);

    // Start download
    Dio dio = Dio();
    await dio.download(
      widget.apkUrl,
      filePath,
      onReceiveProgress: (rec, total) {
        setState(() {
          if (total > 0) {
            progress = rec / total;
          } else {
            progress = 0.0;
          }
        });
      },
    );

    // Ask install packages permission (for Android 8+)
    if (await Permission.requestInstallPackages.isDenied) {
      await Permission.requestInstallPackages.request();
    }

    // Install APK
    await _installApk(file);
  }

  Future<void> _installApk(File file) async {
    if (Platform.isAndroid) {
      try {
        final result = await OpenFilex.open(
          file.path,
          type: "application/vnd.android.package-archive",
        );
        // debugPrint("Install result: $result");
      } catch (e) {
        // debugPrint("Install error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(status),
      content:
          downloading
              ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(
                    value: progress > 0 ? progress : null,
                  ),
                  SizedBox(height: 12),
                  Text("${(progress * 100).toStringAsFixed(0)}%"),
                ],
              )
              : Text("Update available. Please update app before proceeding."),
      actions: [
        TextButton(
          onPressed: () => SystemNavigator.pop(),
          child: Text("Cancel"),
        ),
        if (!downloading)
          TextButton(
            onPressed: _downloadAndInstallApk,
            child: Text("Update Now"),
          ),
      ],
    );
  }
}
