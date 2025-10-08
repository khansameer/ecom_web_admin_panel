import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String selectedMenu = 'Home';

  // Menu options
  final List<String> menuItems = ['Home', 'Orders', 'Products'];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return commonScaffold(
      body: commonAppBackground(
        child: Row(
          children: [

            Container(
              width: size.width * 0.12, // 15% of screen width
              color: Colors.black,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  ...menuItems.map((menu) {
                    bool isSelected = menu == selectedMenu;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedMenu = menu;
                        });
                      },
                      child: Container(
                        color: isSelected ? Colors.grey[800] : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: Row(
                          children: [
                            Icon(
                              menu == 'Home'
                                  ? Icons.home
                                  : menu == 'Orders'
                                  ? Icons.shopping_cart
                                  : Icons.production_quantity_limits,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              menu,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: getPage(selectedMenu),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget getPage(String menu) {
    switch (menu) {
      case 'Home':
        return HomePage() ;
      case 'Orders':
        return const Text(
          'Orders Page',
          style: TextStyle(fontSize: 24),
        );
      case 'Products':
        return const Text(
          'Products Page',
          style: TextStyle(fontSize: 24),
        );
      default:
        return const Text(
          'Home Page',
          style: TextStyle(fontSize: 24),
        );
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

