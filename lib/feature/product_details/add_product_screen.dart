import 'package:flutter/cupertino.dart';
import 'package:neeknots/core/component/component.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        title: "ADD NEW PRODUCT",
        context: context,
        centerTitle: true,
      ),
      body: ListView(children: [Text("ADD PRODUCT")]),
    );
  }
}
