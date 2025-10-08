import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return commonScaffold(
      body: commonAppBackground(
        child: Center(
          child: Column(
            children: [
              Align(
                alignment: AlignmentGeometry.center,
                child: commonAssetImage(
                  icAppLogo,
                  height: 72,
                  width: size.width * 0.7,
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount;

                    if (constraints.maxWidth >= 1200) {
                      crossAxisCount = 4; // 🖥️ Desktop
                    } else if (constraints.maxWidth >= 800) {
                      crossAxisCount = 3; // 💻 Tablet
                    } else {
                      crossAxisCount = 2; // 📱 Mobile
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      padding: const EdgeInsets.all(16),
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Item $index',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
