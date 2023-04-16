import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sustainable_city_management/app/config/routes/app_pages.dart';
import 'package:sustainable_city_management/app/constans/app_constants.dart';
import 'package:sustainable_city_management/app/constans/auth_constants.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/air_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/bike_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/bin_truck_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/bus_screen.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';
import 'package:sustainable_city_management/app/shared_components/profile_card.dart';
import 'package:sustainable_city_management/app/shared_components/selection_button.dart';

// a map of ("page name", WidgetBuilder) pairs
final _availablePages = <String, WidgetBuilder>{
  'AirScreen': (_) => const AirScreen(),
  'BikeScreen': (_) => const BikeScreen(),
  'BinTruckScreen': (_) => const BinTruckScreen(),
  'BusScreen': (_) => const BusScreen(),
};

// make this a `StateProvider` so we can change its value
final selectedPageNameProvider = StateProvider<String>((ref) {
  // default value
  return _availablePages.keys.first;
});

final selectedPageBuilderProvider = Provider<WidgetBuilder>((ref) {
  // watch for state changes inside selectedPageNameProvider
  final selectedPageKey = ref.watch(selectedPageNameProvider.state).state;
  // return the WidgetBuilder using the key as index
  return _availablePages[selectedPageKey]!;
});

// Providers
final profileCardDataProvider = FutureProvider<ProfileCardData>((ref) async {
  return await UserServices().loadProfileCardData();
});

final authsProvider = FutureProvider<List<String>>((ref) async {
  return await UserServices().loadAuths();
});

// 1. extend from ConsumerWidget
class AppMenu extends ConsumerWidget {
  const AppMenu({Key? key}) : super(key: key);

  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedPageNameProvider.state).state != pageName) {
      ref.read(selectedPageNameProvider.state).state = pageName;
      // dismiss the drawer of the ancestor Scaffold if we have one
      if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(profileCardDataProvider).when(
          data: (ProfileCardData data) => ref.watch(authsProvider).when(
                data: (List<String> auths) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    color: Theme.of(context).cardColor,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(kSpacing / 2),
                            child: ProfileCard(
                              data: data,
                            ),
                          ),
                          const Divider(thickness: 1),
                          SelectionButton(
                            data: [
                              if (auths.contains(AuthList.air))
                                SelectionButtonData(
                                  // icon to icondata class: https://api.flutter.dev/flutter/material/Icons-class.html
                                  activeIcon: const IconData(0xe064,
                                      fontFamily: 'MaterialIcons'),
                                  icon: const IconData(0xee55,
                                      fontFamily: 'MaterialIcons'),
                                  label: MenuLable.air,
                                ),
                              if (auths.contains(AuthList.noise))
                                SelectionButtonData(
                                  activeIcon: const IconData(0xe35c,
                                      fontFamily: 'MaterialIcons'),
                                  icon: const IconData(0xf147,
                                      fontFamily: 'MaterialIcons'),
                                  label: MenuLable.noise,
                                ),
                              if (auths.contains(AuthList.bike))
                                SelectionButtonData(
                                  activeIcon: const IconData(0xe1d2,
                                      fontFamily: 'MaterialIcons'),
                                  icon: const IconData(0xefc0,
                                      fontFamily: 'MaterialIcons'),
                                  label: MenuLable.bike,
                                ),
                              if (auths.contains(AuthList.bus))
                                SelectionButtonData(
                                  activeIcon: const IconData(0xe1d6,
                                      fontFamily: 'MaterialIcons'),
                                  icon: const IconData(0xefc3,
                                      fontFamily: 'MaterialIcons'),
                                  label: MenuLable.bus,
                                ),
                              if (auths.contains(AuthList.pedestrian))
                                SelectionButtonData(
                                  activeIcon: const IconData(0xe487,
                                      fontFamily: 'MaterialIcons'),
                                  icon: const IconData(0xf26a,
                                      fontFamily: 'MaterialIcons'),
                                  label: MenuLable.pedestrian,
                                ),
                              if (auths.contains(AuthList.binTruck))
                                SelectionButtonData(
                                  activeIcon: const IconData(0xf07a2,
                                      fontFamily: 'MaterialIcons'),
                                  icon: const IconData(0xf06f2,
                                      fontFamily: 'MaterialIcons'),
                                  label: MenuLable.binTruck,
                                ),
                              SelectionButtonData(
                                activeIcon: const IconData(0xe22a,
                                    fontFamily: 'MaterialIcons'),
                                // outline style when isn't seleted
                                icon: const IconData(0xf018,
                                    fontFamily: 'MaterialIcons'),
                                label: MenuLable.message,
                                totalNotif: 20,
                              ),
                              SelectionButtonData(
                                activeIcon: const IconData(0xe243,
                                    fontFamily: 'MaterialIcons'),
                                icon: const IconData(0xf031,
                                    fontFamily: 'MaterialIcons'),
                                label: MenuLable.logout,
                              ),
                            ],
                            onSelected: (index, value) {
                              debugPrint(
                                  "index : $index | label : ${value.label}");
                              if (value.label == MenuLable.logout) {
                                debugPrint("logout");
                                UserServices().logout();
                                Get.toNamed(Routes.login);
                              } else if (value.label != MenuLable.bus) {
                                _selectPage(context, ref, value.label);
                              }
                            },
                          ),
                          // const Divider(thickness: 1),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Error: $error')),
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        );
  }
}

// class PageListTile extends StatelessWidget {
//   const PageListTile({
//     Key? key,
//     this.selectedPageName,
//     required this.pageName,
//     this.onPressed,
//   }) : super(key: key);
//   final String? selectedPageName;
//   final String pageName;
//   final VoidCallback? onPressed;
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       // show a check icon if the page is currently selected
//       // note: we use Opacity to ensure that all tiles have a leading widget
//       // and all the titles are left-aligned
//       leading: Opacity(
//         opacity: selectedPageName == pageName ? 1.0 : 0.0,
//         child: Icon(Icons.check),
//       ),
//       title: Text(pageName),
//       onTap: onPressed,
//     );
//   }
// }
