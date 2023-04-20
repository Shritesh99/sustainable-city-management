import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:sustainable_city_management/app/constants/app_constants.dart';
import 'package:sustainable_city_management/app/services/bus_services.dart';
import 'package:sustainable_city_management/app/dashboard/models/bus_model.dart';

// Import the generated mocks.dart file before bus_services_test.dart
import 'bus_services_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  group('BusServices', () {
    test('listBusState returns a list of bus states for a given routeId',
        () async {
      // Arrange
      final dio = MockDio();
      // Replacing the dioClient instance in BusServices with the mocked instance
      final busServices = BusServices(dio: dio);
      const String routeId = '1';
      final uri = Uri.parse('${ApiPath.bus}?id=$routeId');
      final responseData = {
        'bus_data': {
          'busData': [
            {
              'routeID': '1',
              'vehicleID': '2',
              'latitude': 53.3464062899053,
              'longitude': -6.2570863424236,
            },
          ],
        },
      };

      when(dio.getUri(uri)).thenAnswer((_) async => Response(
          data: responseData, requestOptions: RequestOptions(path: '')));

      // Act
      final result = await busServices.listBusState(routeId);

      // Assert
      expect(result, isInstanceOf<List<BusModel>>());
      expect(result.length, 1);
      expect(result.first.routeId, '1');
      expect(result.first.vehicleId, '2');
      expect(result.first.latitude, 53.3464062899053);
      expect(result.first.longitude, -6.2570863424236);
    });
  });
}
