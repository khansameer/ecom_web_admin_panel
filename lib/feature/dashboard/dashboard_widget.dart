

/*
notificationWidget() {
  return commonInkWell(
    onTap: () {
      navigatorKey.currentState?.pushNamed(RouteName.notificationScreen);
    },
    child: Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            commonPrefixIcon(
              image: icNotification,
              width: 24,
              height: 24,
              colorIcon: Colors.white,
            ),

            Positioned(
              right: -4,
              top: -9,
              child: Container(
                width: 20,
                height: 20,
                decoration: commonBoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: commonText(
                    text: provider.notifications.isNotEmpty
                        ? '${provider.notifications.length}'
                        : "0",
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
*/
