part of dashboard;

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.data,
    Key? key,
  }) : super(key: key);

  final ProfileCardData data;

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
                SelectionButtonData(
                  // icon to icondata class: https://api.flutter.dev/flutter/material/Icons-class.html
                  activeIcon:
                      const IconData(0xe064, fontFamily: 'MaterialIcons'),
                  icon: const IconData(0xee55, fontFamily: 'MaterialIcons'),
                  label: "Air Quality",
                ),
                SelectionButtonData(
                  activeIcon:
                      const IconData(0xe35c, fontFamily: 'MaterialIcons'),
                  icon: const IconData(0xf147, fontFamily: 'MaterialIcons'),
                  label: "Noise",
                ),
                SelectionButtonData(
                  activeIcon:
                      const IconData(0xe1d2, fontFamily: 'MaterialIcons'),
                  icon: const IconData(0xefc0, fontFamily: 'MaterialIcons'),
                  label: "Bike",
                ),
                SelectionButtonData(
                  activeIcon:
                      const IconData(0xe1d6, fontFamily: 'MaterialIcons'),
                  icon: const IconData(0xefc3, fontFamily: 'MaterialIcons'),
                  label: "Bus",
                ),
                SelectionButtonData(
                  activeIcon:
                      const IconData(0xe487, fontFamily: 'MaterialIcons'),
                  icon: const IconData(0xf26a, fontFamily: 'MaterialIcons'),
                  label: "Pedestrian",
                ),
                SelectionButtonData(
                  activeIcon:
                      const IconData(0xf07a2, fontFamily: 'MaterialIcons'),
                  icon: const IconData(0xf06f2, fontFamily: 'MaterialIcons'),
                  label: "Bin Trucks",
                ),
                SelectionButtonData(
                  activeIcon:
                      const IconData(0xe22a, fontFamily: 'MaterialIcons'),
                  // outline style when isn't seleted
                  icon: const IconData(0xf018, fontFamily: 'MaterialIcons'),
                  label: "Messages",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon:
                      const IconData(0xe57f, fontFamily: 'MaterialIcons'),
                  icon: const IconData(0xf36e, fontFamily: 'MaterialIcons'),
                  label: "Setting(Logout)",
                ),
              ],
              onSelected: (index, value) {
                log("index : $index | label : ${value.label}");

                // if (index == 7) {
                //   //Might be do pop?
                //   Navigator.push(context,
                //       MaterialPageRoute(builder: (context) => LoginScreen()));
                // } else if (index == 3) {
                //   Navigator.push(context,
                //       MaterialPageRoute(builder: (context) => BusScreen()));
                // }

                Get.toNamed("/${value.label.toLowerCase()}");
              },
            ),
            // const Divider(thickness: 1),
          ],
        ),
      ),
    );
  }
}
