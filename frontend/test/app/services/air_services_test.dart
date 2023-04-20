import 'package:mockito/annotations.dart';
import 'package:sustainable_city_management/app/constants/app_constants.dart';
import 'package:sustainable_city_management/app/dashboard/models/air_index_model.dart';
import 'package:sustainable_city_management/app/services/air_services.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
// Import the generated mocks.dart file before air_services_test.dart
import 'air_services_test.mocks.dart';

import 'package:flutter_test/flutter_test.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  group('AirServices', () {
    test('getAirIndices returns AQI data for a given stationId', () async {
      // Arrange
      final dio = MockDio();
      final airServices = AirServices(dio: dio);
      const String stationId = '1';
      final uri = Uri.parse('${ApiPath.airIndex}?id=$stationId');
      final responseData = {
        'aqi_data': {
          'id': 1,
          'stationId': '1',
          'stationName': 'Station 1',
          'aqi': 50,
          'pm10': 40,
          'pm25': 30,
          'no2': 20,
          'so2': 10.2,
          'ozone': 5.5,
          'latitude': 53,
          'longitude': -6
        },
      };
      when(dio.getUri(uri)).thenAnswer((_) async => Future.value(Response(
          data: responseData, requestOptions: RequestOptions(path: ''))));

      // Act
      final result = await airServices.getAirIndices(stationId, false);

      // Assert
      expect(result, isInstanceOf<AqiData>());
      expect(result.id, 1);
      expect(result.aqi, 50);
      expect(result.pm10, 40);
      expect(result.pm25, 30);
      expect(result.no2, 20);
      expect(result.so2, 10.2);
      expect(result.ozone, 5.5);
    });

    // test('listAirStation returns a list of air stations', () async {
    //   // Arrange
    //   final dio = MockDio();
    //   final airServices = AirServices(dio: dio);
    //   final uri = Uri.parse(ApiPath.airStation);
    //   final responseData = {
    //     'aqi_data': {
    //       'airData': [
    //         {
    //           'stationID': '1',
    //           'stationName': 'Station 1',
    //           'aqi': 50,
    //           'latitude': 53.342686,
    //           'longitude': -6.267118,
    //         }
    //       ],
    //     },
    //   };

    //   when(dio.getUri(uri)).thenAnswer((_) async => Response(
    //       data: responseData, requestOptions: RequestOptions(path: '')));

    //   // Act
    //   final result = await airServices.listAirStation(false);

    //   // Assert
    //   expect(result, isInstanceOf<List<AirStation>>());
    //   expect(result.length, 1);
    //   expect(result.first.stationId, '1');
    //   expect(result.first.stationName, 'Station 1');
    //   expect(result.first.aqi, 50);
    //   expect(result.first.latitude, 53.342686);
    //   expect(result.first.longitude, -6.267118);
    // });
  });
}
