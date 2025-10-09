import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/component/context_extension.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/feature/admin/admin_view1/admin_order_list_view.dart';
import 'package:neeknots/feature/admin/store_details/contact_list_page.dart';
import 'package:neeknots/feature/admin/admin_view1/order_filter_list_page.dart';
import 'package:provider/provider.dart';

import '../../core/firebase/auth_service.dart';
import '../../provider/admin_dashboard_provider.dart';
import 'admin_view1/admin_all_userlist.dart';

import 'admin_view1/admin_product_list.dart';
import 'admin_view1/common_admin_list_view.dart';

class AdminUserModel {
  final String name;
  final String email;
  final String phone;
  bool isActive; // for switch toggle

  AdminUserModel({
    required this.name,
    required this.email,
    required this.phone,
    this.isActive = true,
  });
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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

  // 🧩 Helper: responsive columns
  int _getCrossAxisCount(double width) {
    if (width >= 1400) return 4; // Desktop / large MacBook
    if (width >= 1000) return 3; // Small desktop / large tablet
    if (width >= 600) return 2; // Tablet / iPad
    return 1; // Mobile
  }

  // 🔹 Detail page for selected section (e.g., Orders, Products)
  Widget _buildSectionContent({
    required BuildContext context,
    required String section,
    required AdminDashboardProvider provider,
  }) {
    final AuthService _authService = AuthService();
    switch (section) {
      case "Orders":
        return OrderFilterListPage(
          storeName: provider.storeCounts[provider.selectedIndex]['store_name'],
          collectionName: _authService.orderFilterCollection,
        );
      case "Products":
        return AdminProductList(
          storeName: provider.storeCounts[provider.selectedIndex]['store_name'],
          collectionName: _authService.productCollection,
        );
      case "Users":
        return AdminAllUserlist(
          storeName: provider.storeCounts[provider.selectedIndex]['store_name'],
        );
      case "Contacts":
        return ContactListPage(
          storeName: provider.storeCounts[provider.selectedIndex]['store_name'],
          collectionName: _authService.contactUsCollection,
        );
      default:
        return AdminAllUserlist(
          storeName: provider.storeCounts[provider.selectedIndex]['store_name'],
        );
    }
  }

  Widget _buildContactListPage() {
    return Center(
      child: Text(
        "📞 Contact Enquiries",
        style: TextStyle(fontSize: 18, color: Colors.deepPurple.shade700),
      ),
    );
  }

  //Main contnet
  Widget _buildDashboardGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        // 🧩 Dynamic grid column count
        int crossAxisCount;
        if (screenWidth >= 1200) {
          crossAxisCount = 4;
        } else if (screenWidth >= 800) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }
        return GridView.builder(
          itemCount: dashboardItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final item = dashboardItems[index];
            return InkWell(
              onTap: () {
                setState(() => selectedSection = item["title"]);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item["icon"] as IconData,
                      size: 40,
                      color: Colors.black54,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item["title"].toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 🧩 Example widgets for each section
  Widget _buildOrderListPage() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order #${index + 1001}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Placed on Oct 8, 2025"),
                ],
              ),
              Text(
                "₹${(index + 1) * 199}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductListPage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 🧠 Determine grid columns dynamically
        int crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
        return GridView.builder(
          itemCount: 8,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.all(8),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🖼 Product Image
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: commonNetworkImage(
                      "https://picsum.photos/400",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product ${(index + 1)} Name",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Requested: ${_formatDate(DateTime.now().subtract(Duration(days: index * 2)))}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        spacing: 16,
                        children: [
                          Expanded(
                            child: commonButton(
                              height: 44,
                              radius: 8,
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 6,
                              ),
                              color: Colors.white.withValues(alpha: 0.3),
                              colorBorder: Colors.green.withValues(alpha: 0.7),
                              textColor: Colors.green,
                              text: "Approve",

                              fontSize: 12,
                              onPressed: () {},
                            ),
                          ),
                          Expanded(
                            child: commonButton(
                              height: 44,
                              radius: 8,
                              color: Colors.white.withValues(alpha: 0.3),
                              colorBorder: Colors.red.withValues(alpha: 0.7),
                              text: "DisApprove",
                              fontSize: 12,
                              textColor: Colors.red,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildUserListPage() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.phone,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
                // 🟢 Switch (on/off)
                Row(
                  children: [
                    Text(
                      user.isActive ? "Active" : "Inactive",
                      style: TextStyle(
                        color: user.isActive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: user.isActive,
                      onChanged: (value) {
                        setState(() => user.isActive = value);
                      },
                      activeThumbColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      body: commonAppBackground(
        child: Consumer<AdminDashboardProvider>(
          builder: (context, provider, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                double screenHeight = constraints.maxHeight;

                double screenWidth = constraints.maxWidth;
                double sidebarWidth = screenWidth >= 1200
                    ? screenWidth * 0.20
                    : screenWidth >= 800
                    ? screenWidth * 0.25
                    : screenWidth * 0.30;

                return Row(
                  children: [
                    // 🟪 LEFT PANEL (Sidebar)
                    Container(
                      width: sidebarWidth,
                      height: screenHeight,
                      decoration: commonBoxDecoration(
                        borderRadius: 0,
                        borderColor: colorBorder,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔹 Store Name / Logo
                            Align(
                              alignment:
                                  Alignment.center, // or Alignment.center
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 18.0,
                                  right: 18,
                                ),
                                child: commonAssetImage(icAppLogo, height: 100),
                              ),
                            ),
                            const SizedBox(height: 16),
                            commonText(
                              text: "My Stores",
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 24),
                            Expanded(
                              child: ListView.builder(
                                itemCount: provider.storeCounts.length,
                                itemBuilder: (context, index) {
                                  final store = provider.storeCounts[index];
                                  bool isSelected =
                                      provider.selectedIndex == index;
                                  return GestureDetector(
                                    onTap: () async {
                                      provider.setSelectedStore(index);
                                      provider.setSelectedSection(null);
                                      await provider.fetchStoreCounts(
                                        storeName: provider
                                            .storeCounts[index]['store_name'],
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.black
                                            // ✅ subtle selection
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.store,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey.shade600,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: commonText(
                                              text: store['store_name']
                                                  .toString()
                                                  .toCapitalize(),
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontSize: 16,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              //overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 🟩 RIGHT PANEL (Main content)
                    Expanded(
                      child: Container(
                        color: colorBg,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔹 Header with store name
                            // 🏷 Top header with back arrow
                            Row(
                              children: [
                                if (provider.selectedSection != null)
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: () {
                                      // provider.setSelectedStore(index);
                                      provider.setSelectedSection(null);
                                      // setState(() => selectedSection = null);
                                    },
                                  ),
                                commonText(
                                  text: provider.selectedSection == null
                                      ? provider
                                            .storeCounts[provider
                                                .selectedIndex]['store_name']
                                            .toString()
                                            .toUpperCase() // optional
                                      : "${provider.storeCounts[provider.selectedIndex]['store_name'].toString().toCapitalize()} / ${provider.selectedSection!}",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // 🧩 Main content (grid or detail)
                            Expanded(
                              child: provider.selectedSection == null
                                  ? CommonAdminListView(
                                      storeName:
                                          provider.storeCounts[provider
                                              .selectedIndex]['store_name'],
                                    )
                                  : _buildSectionContent(
                                      context: context,
                                      provider: provider,
                                      section: provider.selectedSection ?? '',
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
