import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:sustainable_city_management/app/constants/app_constants.dart';
import 'package:sustainable_city_management/app/services/bike_services.dart';
import 'package:sustainable_city_management/app/dashboard/models/bike_station_model.dart';

import 'bike_services_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  group('BikeServices', () {
    test('listBikeStation returns a list of bike stations', () async {
      // Arrange
      final dio = MockDio();
      final bikeServices = BikeServices(dio: dio);
      final uri = Uri.parse(ApiPath.bike);

      final responseData = [
        {
          "bike_data": {
            "bikes": [
              {
                'id': 1,
                'contractName': 'Example Contract',
                'name': 'Example Station',
                'address': 'Example Address',
                'latitude': 12.34,
                'longitude': 56.78,
                'banking': true,
                'bonus': false,
                "status": "OPEN",
                "lastUpdate": 1681847223,
                "bikes": 5,
                "stands": 15,
                "mechanicalBikes": 4,
                "electricalBikes": 1
              },
              {
                "id": 88,
                "contractName": "dublin",
                "name": "BLACKHALL PLACE",
                "address": "Blackhall Place",
                "latitude": 53.3488,
                "longitude": -6.281637,
                "status": "OPEN",
                "lastUpdate": 1681847144,
                "bikes": 17,
                "stands": 13,
                "mechanicalBikes": 11,
                "electricalBikes": 6
              }
            ]
          },
          "error": false,
          "msg": "success"
        }
      ];

      when(dio.getUri(uri)).thenAnswer((_) async => Response(
            data: responseData,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await bikeServices.listBikeStation();

      // Assert
      expect(result, isInstanceOf<List<BikeStationModel>>());
      // expect(result.length, 1);
      // expect(result.first.number, 1);
      // expect(result.first.contractName, 'Example Contract');
      // expect(result.first.name, 'Example Station');
      // expect(result.first.address, 'Example Address');
      // expect(result.first.position.latitude, 12.34);
      // expect(result.first.position.longitude, 56.78);
      // expect(result.first.banking, true);
      // expect(result.first.bonus, false);
      // expect(result.first.status, 'OPEN');
      // expect(result.first.lastUpdate, DateTime.parse('2023-04-19T10:00:00Z'));
      // expect(result.first.connected, true);
      // expect(result.first.overflow, false);
      // expect(result.first.shape, null);
      // expect(result.first.totalStands.availabilities.bikes, 5);
      // expect(result.first.totalStands.availabilities.stands, 3);
      // expect(result.first.mainStands.availabilities.bikes, 5);
      // expect(result.first.mainStands.availabilities.stands, 3);
      // expect(result.first.overflowStands, null);
    });
  });
}
