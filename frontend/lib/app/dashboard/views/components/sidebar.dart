part of dashboard;

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.data,
    required this.auths,
    Key? key,
  }) : super(key: key);

  final ProfileCardData data;
  final List<String> auths;

  @override
  Widget build(BuildContext context) {
    // TODO: generate the sider bar for different actor
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
                    activeIcon:
                        const IconData(0xe064, fontFamily: 'MaterialIcons'),
                    icon: const IconData(0xee55, fontFamily: 'MaterialIcons'),
                    label: MenuLable.air,
                  ),
                if (auths.contains(AuthList.noise))
                  SelectionButtonData(
                    activeIcon:
                        const IconData(0xe35c, fontFamily: 'MaterialIcons'),
                    icon: const IconData(0xf147, fontFamily: 'MaterialIcons'),
                    label: MenuLable.noise,
                  ),
                if (auths.contains(AuthList.bike))
                  SelectionButtonData(
                    activeIcon:
                        const IconData(0xe1d2, fontFamily: 'MaterialIcons'),
                    icon: const IconData(0xefc0, fontFamily: 'MaterialIcons'),
                    label: MenuLable.bike,
                  ),
                if (auths.contains(AuthList.bus))
                  SelectionButtonData(
                    activeIcon:
                        const IconData(0xe1d6, fontFamily: 'MaterialIcons'),
                    icon: const IconData(0xefc3, fontFamily: 'MaterialIcons'),
                    label: MenuLable.bus,
                  ),
                if (auths.contains(AuthList.pedestrian))
                  SelectionButtonData(
                    activeIcon:
                        const IconData(0xe487, fontFamily: 'MaterialIcons'),
                    icon: const IconData(0xf26a, fontFamily: 'MaterialIcons'),
                    label: MenuLable.pedestrian,
                  ),
                if (auths.contains(AuthList.binTruck))
                  SelectionButtonData(
                    activeIcon:
                        const IconData(0xf07a2, fontFamily: 'MaterialIcons'),
                    icon: const IconData(0xf06f2, fontFamily: 'MaterialIcons'),
                    label: MenuLable.binTruck,
                  ),
                SelectionButtonData(
                  activeIcon:
                      const IconData(0xe22a, fontFamily: 'MaterialIcons'),
                  // outline style when isn't seleted
                  icon: const IconData(0xf018, fontFamily: 'MaterialIcons'),
                  label: MenuLable.message,
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon:
                      const IconData(0xe243, fontFamily: 'MaterialIcons'),
                  icon: const IconData(0xf031, fontFamily: 'MaterialIcons'),
                  label: MenuLable.logout,
                ),
              ],
              onSelected: (index, value) {
                log("index : $index | label : ${value.label}");
                if (value.label == MenuLable.air) {
                  Get.toNamed(Routes.air);
                } else if (value.label == MenuLable.bike) {
                  log("should jump to bike");
                  Get.toNamed(Routes.bike);
                } else if (value.label == MenuLable.bus) {
                  Get.toNamed(Routes.bus);
                } else if (value.label == MenuLable.binTruck) {
                  Get.toNamed(Routes.bin_truck);
                } else if (value.label == MenuLable.logout) {
                  UserServices().logout();
                  Get.toNamed(Routes.login);
                }
              },
            ),
            // const Divider(thickness: 1),
          ],
        ),
      ),
    );
  }
}
