import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:sustainable_city_management/app/constants/app_constants.dart';
import 'package:sustainable_city_management/app/constants/localstorage_constants.dart';
import 'package:sustainable_city_management/app/services/local_storage_services.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';
import 'package:sustainable_city_management/app/dashboard/models/roles_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sustainable_city_management/app/dashboard/models/profile_model.dart';
import 'package:sustainable_city_management/app/dashboard/models/user.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<LocalStorageServices>()])
import 'user_services_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Change this line

  // Add this block to set up a mock channel for flutter_secure_storage
  const MethodChannel channel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'read') {
      return '''{"Token": "testToken",
        "userId": 1,
        "roleId": 1,
        "email": "john.doe@example.com",
        "firstName": "John",
        "lastName": "Doe",
        "expires": ${DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch},
        "error": false,
        "msg": "success"}'''; // Return a JSON string for testing purposes
    }
    return null;
  });

  group('UserServices', () {
    late MockDio mockDio;
    late MockLocalStorageServices mockLocalStorageServices;
    late UserServices userServices;

    setUpAll(() {
      mockDio = MockDio();
      mockLocalStorageServices = MockLocalStorageServices();
      userServices = UserServices(dio: mockDio);
      TestWidgetsFlutterBinding.ensureInitialized();
      // localStorageServices.resetStorage();
      // mockLocalStorageServices.deleteAll();
    });

    test('register', () async {
      final user = User(
        firstName: 'John',
        lastName: 'Doe',
        username: 'john.doe@example.com',
        password: 'password123',
      );

      when(mockDio.post(ApiPath.register, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {'error': false, 'msg': 'Registration successful'},
        ),
      );

      final result = await userServices.register(user);
      expect(result.error, false);
      expect(result.msg, 'Registration successful');
    });

    test('login', () async {
      const username = 'john.doe@example.com';
      const password = 'password123';

      when(mockDio.post(ApiPath.login, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'Token': 'testToken',
            'userId': 1,
            'roleId': 1,
            'email': username,
            'firstName': 'John',
            'lastName': 'Doe',
            'expires': DateTime.now()
                .add(const Duration(days: 1))
                .millisecondsSinceEpoch,
            'error': false,
            'msg': 'Login successful',
          },
        ),
      );

      final result = await userServices.login(username, password);
      expect(result?.token, 'testToken');
      expect(result?.email, username);
      expect(result?.error, false);
      expect(result?.msg, 'Login successful');
    });

    test('loadAuths - success', () async {
      // Set up the mock channel for flutter_secure_storage
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'read') {
          return 'auth1,auth2,auth3'; // Return a comma-separated string for testing purposes
        }
        return null;
      });

      List<String> auths = await userServices.loadAuths();
      expect(auths, ['auth1', 'auth2', 'auth3']);
    });

    test('loadProfileCardData - success', () async {
      // Set up the mock channel for flutter_secure_storage
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'read') {
          switch (methodCall.arguments['key']) {
            case LocalStorageKey.USER_INFO:
              return '''{"Token": "testToken",
                "userId": 1,
                "roleId": 1,
                "email": "johndoe@example.com",
                "firstName": "John",
                "lastName": "Doe",
                "expires": ${DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch},
                "error": false,
                "msg": "success"}''';
            case LocalStorageKey.ROLE:
              return '''{"role_id": 1, "role_name": "Admin",
                  "auths": [
                      "AirQuality",
                      "NoiseInformation",
                      "BikeHeatmap",
                      "BusMap",
                      "PedestrianHeatmap",
                      "BinTrucksMap"
                  ]}''';
            default:
              return null;
          }
        }
        return null;
      });

      ProfileCardData profileCardData =
          await userServices.loadProfileCardData();
      expect(profileCardData.name, 'John, Doe');
      expect(profileCardData.email, 'johndoe@example.com');
      expect(profileCardData.role, 'Admin');
    });

    test('getRole - success', () async {
      // Set up the mock channel for flutter_secure_storage
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'read') {
          return '''{"role_id": 1, "role_name": "Admin",
            "auths": [
                "AirQuality",
                "NoiseInformation",
                "BikeHeatmap",
                "BusMap",
                "PedestrianHeatmap",
                "BinTrucksMap"
            ]}'''; // Return a JSON string for testing purposes
        }
        return null;
      });

      RolesDatum? role = await userServices.getRole();
      expect(role!.roleId, 1);
      expect(role.roleName, 'Admin');
    });

    // test('loadToken', () async {
    //   // when(mockLocalStorageServices.read(any)).thenAnswer((_) async => '''
    //   // {
    //   //   "Token": "testToken",
    //   //   "user_id": 1,
    //   //   "role_id": 1,
    //   //   "email": "john.doe@example.com",
    //   //   "firstName": "John",
    //   //   "lastName": "Doe",
    //   //   "expires": ${DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch},
    //   //   "error": false,
    //   //   "msg": "success"
    //   // }
    //   // ''');

    //   final result = await userServices.loadToken();
    //   expect(result, 'testToken');
    // });

    tearDownAll(() {
      mockLocalStorageServices.deleteAll();
    });
  });
}
