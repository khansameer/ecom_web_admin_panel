import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/feature/admin/store_details/store_details_screen.dart';
import 'package:neeknots/provider/admin_dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../core/component/animated_counter.dart';
import '../../provider/AdminMenuProvider.dart';
import 'CommonAdminLeftMenu.dart';

class AdminHomeSameer extends StatefulWidget {
  const AdminHomeSameer({super.key});

  @override
  State<AdminHomeSameer> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomeSameer> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    var menuProvider = Provider.of<AdminMenuProvider>(context);

    return commonScaffold(
      body: commonAppBackground(
        child: Row(
          children: [
            CommonAdminLeftMenu(
              selectedMenu: menuProvider.selectedMenu,
              menuItems: menuProvider.menuItems,
              onMenuSelect: (menu) => menuProvider.setSelectedMenu(menu),
            ),
            Container(
              width: 2, // slightly thicker for 3D effect
              margin: const EdgeInsets.symmetric(vertical: 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade300, // light top edge
                    Colors.grey.shade400, // middle
                    Colors.grey.shade500, // bottom shadow
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade600.withValues(alpha: 0.3),
                    blurRadius: 3,
                    offset: const Offset(2, 0), // shadow to the right
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(child: getPage(menuProvider.selectedMenu)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getPage(String menu) {
    switch (menu) {
      case 'All Store':
        return AllStorePage();
      case 'Orders':
        return const Text('Orders Page', style: TextStyle(fontSize: 24));
      case 'Products':
        return const Text('Products Page', style: TextStyle(fontSize: 24));
      default:
        return const Text('Home Page', style: TextStyle(fontSize: 24));
    }
  }
}

class AllStorePage extends StatefulWidget {
  const AllStorePage({super.key});

  @override
  State<AllStorePage> createState() => _StoreGridViewState();
}

class _StoreGridViewState extends State<AllStorePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  void init() {
    final customerProvider = Provider.of<AdminDashboardProvider>(
      context,
      listen: false,
    );

    customerProvider.getStoreUserCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminDashboardProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350, // maximum width of each box
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1, // square boxes
              ),
              itemCount: provider.storeCounts.length,
              itemBuilder: (context, index) {
                final store = provider.storeCounts[index];
                final storeColor = provider.getProfessionColor(
                  store['store_name'],
                  index,
                );

                return commonInkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>StoreDetailsScreen(storeName:  store['store_name'].toString())));
                    showCommonBottomSheet(
                      context: context,
                      content: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.8,
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                commonHeadingText(
                                  text: store['store_name']
                                      .toString()
                                      .toUpperCase(),
                                ),
                                commonInkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: commonBoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              child: StoreDetailsScreen(
                                storeName: store['store_name'].toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 350,
                    height: 350,
                    child: Container(
                      decoration: commonBoxDecoration(
                        color: storeColor.withValues(alpha: 0.08),
                        borderColor: storeColor,
                      ),

                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            commonText(
                              textAlign: TextAlign.center,
                              text: store['store_name']
                                  .toString()
                                  .toUpperCase(),
                              fontSize: 20,
                              color: storeColor,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 8),

                            Container(
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(2),
                              // border thickness
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: storeColor, // border color
                                  width: 1, // border width
                                ),
                              ),
                              child: Center(
                                child: AnimatedCounter(
                                  leftText: '',
                                  rightText: '',
                                  endValue: store['count'],
                                  duration: Duration(seconds: 2),
                                  style: commonTextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: storeColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            provider.isLoading ? showLoaderList() : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
