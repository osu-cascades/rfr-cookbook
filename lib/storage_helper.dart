import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class StorageHelper {
  static final FirebaseStorage _storageInstance = FirebaseStorage.instance;

  Future<void> initializeStorage() async {
    final ListResult remoteParentDirectories = 
      await _storageInstance.ref('protocols/').listAll();

    for (Reference parentDirectory in remoteParentDirectories.prefixes) {
      final ListResult directoryListing = 
        await _storageInstance.ref(parentDirectory.fullPath).listAll();

      for (Reference file in directoryListing.items) {
        _downloadFile(file.fullPath);
      }
    }
  }

  Future<void> _uploadFileWithMetadata(String localPath, String remotePath) async {
    File file = File(localPath);

    SettableMetadata metadata = SettableMetadata(
      customMetadata: <String, String>{'md5Hash': await _generateMd5(file)}
    );

    try {
      await _storageInstance.ref(remotePath).putFile(file, metadata);
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<String> _generateMd5(File file) async {
    final fileStream = file.openRead();
    return (await md5.bind(fileStream).first).toString();
  }

  Future<void> _downloadFile(String path) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File downloadToFile = File('${appDocDir.path}/$path');

    try {
      await _storageInstance
        .ref(path)
        .writeToFile(downloadToFile);
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }
}