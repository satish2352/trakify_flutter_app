import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trakify/data/flat_class.dart';
import 'package:trakify/data/flatItem_class.dart';
import 'package:trakify/data/project_class.dart';
import 'package:trakify/data/wing_class.dart';

import 'history_item.dart';

class APIService {

  static const String URL = 'https://tracify-backend.vercel.app/';
  //static const String URL = 'https://trakify-backend.vercel.app/';

  static Future<String> fetchData(String endpoint) async {
    final response = await http.get(Uri.parse(URL+endpoint));
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
    }
  }

  static Future<FetchResult> fetchProjects(String userID) async {
    try {
      String jsonString =
          await APIService.fetchData('projects/m_projectList?_id=$userID');
      final parsed = json.decode(jsonString);
      List<Project> fetchedProjects =
          parsed['projects'].map<Project>((projectJson) {
        return Project.fromJson(projectJson);
      }).toList();
      return FetchResult(true, '', fetchedProjects);
    } catch (error) {
      return FetchResult(false, error.toString(), []);
    }
  }

  /*
  static Future<FetchResult> fetchProjectById(String projectId) async {
    try {
      String jsonString =
      await APIService.fetchData('projects/getProjectDetails?_id=$projectId');
      final parsed = json.decode(jsonString);
      Project fetchedProject = jsonString.Project
      return FetchResult(true, '', fetchedProjects);
    } catch (error) {
      return FetchResult(false, error.toString(), []);
    }
  }
  */

  static Future<FetchResult> fetchWings(String projectId) async {
    try {
      String jsonString =
          await APIService.fetchData('wings/m_wingList?project_id=$projectId');
      final parsed = json.decode(jsonString);
      List<Wing> fetchedWings = parsed['wings'].map<Wing>((wingJson) {
        return Wing.fromJson(wingJson);
      }).toList();
      return FetchResult(true, '', fetchedWings);
    } catch (error) {
      return FetchResult(false, error.toString(), []);
    }
  }

  static Future<FetchResult> fetchFloors(String wingId) async {
    try {
      String jsonString = await fetchData('floors/m_floorList/$wingId');
      final parsed = json.decode(jsonString);

      List<FlatItem> flatItems = [];
      if (parsed['floors'] != null) {
        for (var floor in parsed['floors']) {
          String floorId = floor['_id'];
          int floorNumber = floor['floorNumber'];
          List<FlatItem> createdFlats = [];
          if (floor['createdFlats'] != null) {
            for (var flat in floor['createdFlats']) {
              createdFlats.add(FlatItem(
                id: flat['_id'],
                flatNumber: flat['flatNumber'],
                flatStatus: flat['status'],
                floorId: floorId,
                floorNumber: floorNumber,
              ));
            }
          }
          flatItems.addAll(createdFlats);
        }
      }
      return FetchResult(true, '', flatItems);
    } catch (error) {
      return FetchResult(false, error.toString(), []);
    }
  }

  static Future<FetchResult<Flat>> fetchFlatDetails(
      String floorID, String flatID) async {
    try {
      String jsonString = await APIService.fetchData('flats/m_flatDetails/$floorID/$flatID');
      final parsed = json.decode(jsonString);
      Flat fetchedFlat = Flat.fromJson(parsed['flat']);
      return FetchResult<Flat>(true, '', [fetchedFlat]);
    } catch (error) {
      return FetchResult<Flat>(false, error.toString(), []);
    }
  }

  static Future<Map<String, dynamic>> updateFlatDetails(
      String floorId, String flatId, String newState, String comment, String userID, String dateTime) async {

    String apiUrl = '${URL}flats/m_updateFlat/$floorId/$flatId';

    Map<String, String> requestBody = {
      "status": newState,
      "comment": comment,
      "userId" : userID,
      "currentDate" : dateTime,
    };

    String jsonBody = jsonEncode(requestBody);

    try {
      http.Response response = await http.patch(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData['flat'];
      } else {
        return {
          'error': 'Failed to update flat details from API: ${responseData['error']}'
        };
      }
    } catch (e) {
      return {'error': 'Failed to update flat details in parsing: $e'};
    }
  }

  static Future<Map<String, dynamic>> signIn(String mobileNumber) async {
    final Uri uri = Uri.parse('${URL}m_signin');
    final Map<String, String> requestBody = {
      //'mobileNumber': mobileNumber,
      'contact': mobileNumber,
    };
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to sign in');
    }
  }

  static Future<FetchResult> fetchHistory(String flatID) async {
    try {
      String jsonString = await APIService.fetchData('flatHistory/m_readHistory/$flatID');
      final parsed = json.decode(jsonString);
      if (parsed.containsKey('message')){
        return FetchResult(false, parsed['message'], []);
      }
      List<HistoryItem> fetchedHistoryItems = parsed['historyEntries'].map<HistoryItem>((historyItemJson) {
        return HistoryItem.fromJson(historyItemJson);
      }).toList();
      return FetchResult(true, '', fetchedHistoryItems);
    } catch (error) {
      return FetchResult(false, error.toString(), []);
    }
  }
}

class FetchResult<T> {
  bool success;
  String? error;
  List<T> data;
  FetchResult(this.success, this.error, this.data);
}