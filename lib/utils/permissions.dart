import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/services.dart';

class Permissions {
  static Future<bool> cameraAndMicrophonePermissionsGranted() async {
    PermissionStatus cameraPermissionStatus = await _getCameraPermission();
    PermissionStatus microphonePermissionStatus = await _getMicrophonePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
/*      _handleInvalidPermissions(
          cameraPermissionStatus, microphonePermissionStatus);*/
      return false;
    }
  }

  static Future<PermissionStatus> _getCameraPermission() async {
    PermissionStatus permission = await Permission.camera.status;
    if(permission != PermissionStatus.granted){
      Map<Permission, PermissionStatus> permissionStatus = await [
        Permission.camera,
      ].request();
      return permissionStatus[Permission.camera] ??
          PermissionStatus.denied;
    }
    return permission;

/*    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      Map<Permission, PermissionStatus> permissionStatus = await [
        Permission.camera,
      ].request();
      return permissionStatus[Permission.camera] ??
          PermissionStatus.restricted;
    } else {
      return permission;
    }*/
  }

  static Future<PermissionStatus> _getMicrophonePermission() async {
    PermissionStatus permission = await Permission.microphone.status;
    if(permission != PermissionStatus.granted){
      Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.microphone].request();
      return permissionStatus[Permission.microphone] ??
          PermissionStatus.denied;
    }
    return permission;
/*
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.microphone].request();
      return permissionStatus[Permission.microphone] ??
          PermissionStatus.restricted;
    } else {
      return permission;
    }*/
  }

  static void _handleInvalidPermissions(
      PermissionStatus cameraPermissionStatus,
      PermissionStatus microphonePermissionStatus,
      ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to camera and microphone denied",
          details: null,
      stacktrace: null);
    }
  }
}