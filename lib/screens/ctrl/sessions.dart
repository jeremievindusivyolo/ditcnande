import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _sessionFile async {
  final path = await _localPath;
  return File('$path/78iurh45ff094hebskj3@jdhgv3h5j33k1b2k4.fl');
}

Future<File> writesession(String sessionData) async {
  final file = await _sessionFile;
  // Write the file
  return file.writeAsString('$sessionData');
}

Future<String> readSession() async {
  final file = await _sessionFile;
  // Read the file
  final contents = await file.readAsString();
  return contents;
}

Future<bool> deleteSession_FILE() async {
  try {
    final file = await _sessionFile;
    await file.delete();
    return true;
  } catch (e) {
    return false;
  }
}

Future<File> get _MyPostsFile async {
  final path = await _localPath;
  return File('$path/FK@.fl');
}

Future<File> writeUserPosts(String postData) async {
  final file = await _MyPostsFile;
  // Write the file
  return file.writeAsString('$postData');
}

Future<String> readUserPosts() async {
  final file = await _MyPostsFile;
  // Read the file
  final contents = await file.readAsString();
  return contents;
}

Future<bool> deleteUserPosts() async {
  try {
    final file = await _MyPostsFile;
    await file.delete();
    return true;
  } catch (e) {
    return false;
  }
}




Future<File> get _AllPostsFile async {
  final path = await _localPath;
  return File('$path/FK@.fl');
}

Future<File> writeAllPosts(String postData) async {
  final file = await _AllPostsFile;
  // Write the file
  return file.writeAsString('$postData');
}

Future<String> readAllPosts() async {
  final file = await _AllPostsFile;
  // Read the file
  final contents = await file.readAsString();
  return contents;
}

Future<bool> deleteAllPosts() async {
  try {
    final file = await _AllPostsFile;
    await file.delete();
    return true;
  } catch (e) {
    return false;
  }
}