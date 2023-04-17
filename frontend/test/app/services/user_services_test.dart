import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
// import 'package:mockito/mockito.dart';
import 'package:sustainable_city_management/app/constans/app_constants.dart';
import 'package:sustainable_city_management/app/constans/localstorage_constants.dart';
import 'package:sustainable_city_management/app/network/dio_client.dart';
import 'package:sustainable_city_management/app/services/local_storage_services.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';
import 'package:sustainable_city_management/app/dashboard/models/login_model.dart';
import 'package:sustainable_city_management/app/dashboard/models/roles_model.dart';
import 'package:sustainable_city_management/app/dashboard/models/error_model.dart';

// class MockDioClient extends Mock implements Dio {}

void main() {
  group('UserServices', () {
    // late UserServices userService;
    // late MockDioClient mockDioClient;

    // setUp(() {
    //   mockDioClient = MockDioClient();
    //   userService =
    //       UserServices.withDio(mockDioClient); // Inject the mock Dio client
    // });

    test('login should return LoginModel on successful login', () async {
      final username = 'testuser';
      final password = 'testpassword';
      final responseJson = {
        "error": false,
        "Token": "testtoken",
        "email": "testuser@example.com",
        "expires": 123456,
        "firstName": "Test",
        "lastName": "User",
        "msg": "Success",
        "roleId": 1,
        "userId": 1,
      };
      final expectedLoginModel = LoginModel.fromJson(responseJson);
      final requestOptions = RequestOptions(path: ApiPath.login);

      // when(mockDioClient.post(ApiPath.login, data: anyNamed('data')))
      //     .thenAnswer((_) async => Response(
      //         data: responseJson,
      //         statusCode: 200,
      //         requestOptions: requestOptions));

      // final loginModel = await userService.login(username, password);

      // expect(loginModel, isNotNull);
      // expect(loginModel, expectedLoginModel);
    });

    test('login should return LoginModel with error on failed login', () async {
      final username = 'testuser';
      final password = 'testpassword';
      final responseJson = {
        "error": true,
        "msg": "Failed",
      };
      final expectedErrorModel = ErrorModel.fromJson(responseJson);
      final requestOptions = RequestOptions(path: ApiPath.login);

      // when(mockDioClient.post(ApiPath.login, data: anyNamed('data')))
      //     .thenThrow(DioError(
      //   requestOptions: requestOptions,
      //   error: "Invalid credentials",
      //   response: Response(
      //     requestOptions: requestOptions,
      //     data: responseJson,
      //     statusCode: 400,
      //   ),
      // ));

      // final loginModel = await userService.login(username, password);

      // expect(loginModel, isNotNull);
      // expect(loginModel!.error, expectedErrorModel.error);
      // expect(loginModel.msg, expectedErrorModel.msg);
    });
  });
}
//   test('login should return LoginModel with error on failed login', () async {
//   final username = 'testuser';
//   final password = 'testpassword';
//   final responseJson = {
//     "error": "Invalid credentials",
//     "msg": "Failed",
//   };
//   final expectedErrorModel = ErrorModel.fromJson(responseJson);
//   final requestOptions = RequestOptions(path: ApiPath.login);

//   when(mockDioClient.post(ApiPath.login, data: anyNamed('data')))
//       .thenThrow(DioError(
//         requestOptions: requestOptions,
//         response: Response(
//           requestOptions: requestOptions,
//           data: responseJson,
//           statusCode: 400,
//         ),
//       ));

//   final loginModel = await userService.login(username, password);

//   expect(loginModel, isNotNull);
//   expect(loginModel!.error, expectedErrorModel.error);
//   expect(loginModel.msg, expectedErrorModel.msg);
// });