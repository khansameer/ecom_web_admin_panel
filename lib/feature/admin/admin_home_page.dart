import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';

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
  // 🏪 Dummy store list
  final List<String> stores = [
    "Neeknots",
    "FashionFiesta",
    "MegaMart",
    "ShopEase",
    "UrbanCart",
    "StyleHub",
    "QuickBuy",
    "Trendify",
  ];

  // 🟣 Selected store index
  int selectedIndex = 0;

  String? selectedSection; // null = dashboard grid view

  // 🔹 Dashboard items
  final List<Map<String, dynamic>> dashboardItems = [
    {"title": "Users", "icon": Icons.people},
    {"title": "Orders", "icon": Icons.shopping_cart},
    {"title": "Products", "icon": Icons.inventory},
    {"title": "Contacts", "icon": Icons.contact_mail},
    {"title": "Filter", "icon": Icons.filter_alt},
  ];

  List<AdminUserModel> users = [
    AdminUserModel(
      name: "Girish Chauhan",
      email: "girish@redefinesolution.com",
      phone: "9558697986",
      isActive: true,
    ),
    AdminUserModel(
      name: "Sameer Khan",
      email: "sammerkhan@example.com",
      phone: "9558697987",
      isActive: false,
    ),
    AdminUserModel(
      name: "Jane Smith",
      email: "jane@example.com",
      phone: "9558697988",
      isActive: true,
    ),
  ];

  // 🔹 Detail page for selected section (e.g., Orders, Products)
  Widget _buildSectionContent(String section) {
    switch (section) {
      case "Orders":
        return _buildOrderListPage();
      case "Products":
        return _buildProductListPage();
      case "Users":
        return _buildUserListPage();
      case "Contacts":
        return _buildContactListPage();
      default:
        return const SizedBox();
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
    return GridView.builder(
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
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
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: commonButton(
                          radius: 8,
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          color: Colors.white.withValues(alpha: 0.3),
                          colorBorder: Colors.green.withValues(alpha: 0.7),
                          textColor: Colors.green,
                          text: "Approve",
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: commonButton(
                          radius: 8,
                          color: Colors.white.withValues(alpha: 0.3),
                          colorBorder: Colors.red.withValues(alpha: 0.7),
                          text: "DisApprove",
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenHeight = constraints.maxHeight;
            // 🧩 Dynamic sidebar width
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
                              Alignment.centerLeft, // or Alignment.center
                          child: commonAssetImage(icAppLogo, height: 54),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "My Stores",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: ListView.builder(
                            itemCount: stores.length,
                            itemBuilder: (context, index) {
                              bool isSelected = selectedIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    selectedSection = null; // reset menu
                                  });
                                  // reset menu
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
                                        child: Text(
                                          stores[index],
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                            fontSize: 16,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Header with store name
                        // 🏷 Top header with back arrow
                        Row(
                          children: [
                            if (selectedSection != null)
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  setState(() => selectedSection = null);
                                },
                              ),
                            Text(
                              selectedSection == null
                                  ? stores[selectedIndex] // Store name only
                                  : "${stores[selectedIndex]} / ${selectedSection!}", // Store + Section
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // 🧩 Main content (grid or detail)
                        Expanded(
                          child: selectedSection == null
                              ? _buildDashboardGrid()
                              : _buildSectionContent(selectedSection!),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
