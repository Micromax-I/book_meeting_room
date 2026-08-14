import 'dart:convert';

import 'package:book_meeting_room/model/meeting_room_model.dart';

import '../model/employee_response.dart';
import '../model/generic_response.dart';
import '../model/meeting_detail.dart';
import '../model/version_response.dart';
import '../network/api_service_new.dart';

class MeetingRepository {
  MeetingRepository();

  Future<EmployeeResponse?> authenticateUser({
    required String userName,
    required String password,
  }) async {
    final userId = base64Encode(utf8.encode(userName.trim()));

    final pass = base64Encode(utf8.encode(password.trim()));

    final response = await ApiServiceNew.get(
      endpoint:
          '/Employee/GetEmpDetail?userid=$userId&pass=$pass&IMEI1=&IMEI2=',

      fromJson: (json) {
        return EmployeeResponse.fromJson(json);
      },
    );
    return response;
  }

  Future<VersionResponse?> checkVersion({
    required String versionCode,
    required String versionName,
  }) async {
    final response = await ApiServiceNew.get(
      endpoint:
          '/Account/GetAppVersion'
          '?VC=$versionCode'
          '&VN=$versionName'
          '&AppID=MeetingRoom',

      fromJson: (json) {
        return VersionResponse.fromJson(json);
      },
    );

    return response;
  }

  Future<List<MeetingDetail>?> loadBookedMeetingList() async {
    return await ApiServiceNew.get(
      endpoint: '/roombooking/getbookedmeetingroomlist',

      fromJson: (json) {
        final response = GenericResponse<List<MeetingDetail>>.fromJson(json, (
          data,
        ) {
          return (data as List<dynamic>)
              .map((e) => MeetingDetail.fromJson(e as Map<String, dynamic>))
              .toList();
        });

        // Status 1 = Success
        if (response.Status == 1) {
          return response.Data ?? <MeetingDetail>[];
        }

        // Status 0 = Failed
        throw Exception(response.message ?? 'Failed to get record');
      },
    );
  }

  Future<List<MeetingRoomModel>?> getMeetingRoomList() async {
    return await ApiServiceNew.get(
      endpoint: '/roombooking/getmeetingroomlist',

      fromJson: (json) {
        final response = GenericResponse<List<MeetingRoomModel>>.fromJson(
          json,
          (data) {
            return (data as List<dynamic>)
                .map(
                  (e) => MeetingRoomModel.fromJson(e as Map<String, dynamic>),
                )
                .toList();
          },
        );

        // Status 1 = Success
        if (response.Status == 1) {
          return response.Data ?? <MeetingRoomModel>[];
        }

        // Status 0 = Failed
        throw Exception(response.message ?? 'Failed to get meeting room list');
      },
    );
  }

  Future<GenericResponse<List<String>>?> saveBookingRecord({
    required Map<String, dynamic> body,
  }) async {
    final response = await ApiServiceNew.post(
      endpoint: '/roombooking/bookedmeetingroom',
      body: body,
      fromJson: (json) {
        print('Body-->json-->$json');
        return GenericResponse<List<String>>.fromJson(json, (data) {
          if (data == null) {
            return <String>[];
          }
          return (data as List<dynamic>).map((e) => e.toString()).toList();
        });
      },
    );
    return response;
  }

  Future<GenericResponse<List<String>>?> deleteBooking({
    required Map<String, dynamic> body,
  }) async {
    final response = await ApiServiceNew.post(
      endpoint: '/roombooking/bookingcancellation',
      body: body,
      fromJson: (json) {
        print('Body-->json-->$json');
        return GenericResponse<List<String>>.fromJson(json, (data) {
          if (data == null) {
            return <String>[];
          }
          return (data as List<dynamic>).map((e) => e.toString()).toList();
        });
      },
    );
    return response;
  }
}
