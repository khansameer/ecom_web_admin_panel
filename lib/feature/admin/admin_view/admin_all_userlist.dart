import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/component/context_extension.dart';
import 'package:provider/provider.dart';

import 'common_admin_widget.dart';
import '../../../core/component/common_switch.dart';
import '../../../core/component/responsive.dart';
import '../../../core/image/image_utils.dart';
import '../../../provider/admin_dashboard_provider.dart';

class AdminAllUserlist extends StatefulWidget {
  const AdminAllUserlist({super.key, required this.storeName});

  final String storeName;

  @override
  State<AdminAllUserlist> createState() => _AdminAllUserlistState();
}

class _AdminAllUserlistState extends State<AdminAllUserlist> {
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

    setState(() {
      customerProvider.getAllUser(storeRoom: widget.storeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    return Consumer<AdminDashboardProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            provider.allUserModel?.users?.isNotEmpty == true
                ? ListView.builder(
                    itemCount: provider.allUserModel?.users?.length ?? 0,
                    itemBuilder: (context, index) {
                      final user = provider.allUserModel?.users?[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: commonBoxDecoration(
                          color: Colors.white,
                          borderColor: colorBorder,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isMobile ? 10 : 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    ClipRRect(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        height: isMobile ? 60 : 100,
                                        width: isMobile ? 60 : 80,
                                        fit: BoxFit.cover,
                                        imageUrl: user?.logoUrl ?? '',
                                        placeholder: (context, url) => Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                              child: commonAssetImage(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                icErrorImage,
                                              ),
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          commonText(
                                            text:
                                                user?.name
                                                    .toString()
                                                    .toCapitalize() ??
                                                '',
                                            fontSize: isMobile ? 14 : 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                          const SizedBox(height: 3),
                                          commonText(
                                            overflow: TextOverflow.ellipsis,
                                            text: user?.email ?? '',

                                            fontSize: isMobile ? 12 : 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black45,
                                          ),
                                          const SizedBox(height: 4),
                                          commonText(
                                            text: (user?.mobile ?? '').startsWith('+')
                                                ? (user?.mobile ?? '')
                                                : '+${user?.mobile ?? ''}',
                                            fontSize: isMobile ? 12 : 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black45,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // 🟢 Switch (on/off)
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                spacing: 8,
                                children: [
                                  Row(
                                    children: [
                                      commonText(
                                        fontSize: isMobile ? 10 : 12,
                                        text: user?.activeStatus == 1
                                            ? "Active"
                                            : "Inactive",
                                        color: user?.activeStatus == 1
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      const SizedBox(width: 8),
                                      CommonSwitch(
                                        scale: isMobile ? 0.6 : 0.8,
                                        value: (user?.activeStatus == 1),
                                        // Convert int to bool
                                        onChanged: (value) {
                                          // Convert bool back to int (1 or 0)
                                          setState(() {
                                            user?.activeStatus = value ? 1 : 0;
                                          });
                                          Map<String, dynamic> body = {
                                            "id": user?.id ?? 0,
                                            "active_status": user?.activeStatus,
                                          };

                                          provider.updateUserDetails(
                                            body: body,
                                            storeRoom: widget.storeName,
                                          );
                                        },
                                        activeThumbColor: Colors.green,
                                        inactiveThumbColor: Colors.red,
                                      ),
                                    ],
                                  ),

                                  commonInkWell(
                                    onTap: () {
                                      showCommonBottomSheet(
                                        context: context,
                                        content: SizedBox(
                                          height:
                                              MediaQuery.sizeOf(
                                                context,
                                              ).height *
                                              0.8,
                                          child: ListView(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  commonHeadingText(
                                                    text: "Edit Information",
                                                  ),
                                                  commonInkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      width: 35,
                                                      height: 35,
                                                      decoration:
                                                          commonBoxDecoration(
                                                            color: Colors.black,
                                                            shape:
                                                                BoxShape.circle,
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
                                              CommonAdminWidget(
                                                storeRoom: widget.storeName,
                                                data: provider
                                                    .allUserModel
                                                    ?.users?[index],

                                                provider: provider,
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 20 : 30,
                                        vertical: isMobile ? 6 : 10,
                                      ),
                                      decoration: commonBoxDecoration(
                                        borderColor: colorBorder,
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: commonText(
                                          fontSize: isMobile ? 9 : 11,
                                          color: colorTextDesc1,

                                          fontWeight: FontWeight.w600,
                                          text: "Edit Info".toUpperCase(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : commonErrorView(),

            provider.isLoading ? showLoaderList() : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
