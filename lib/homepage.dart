import 'package:flutter/material.dart';
import 'package:my_internship_application_project/calculator_page.dart';
import 'package:my_internship_application_project/convert_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);

    controller.addListener(() {
      if (!controller.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Internship Project",
          style: TextStyle(color: Colors.black),
        ),
        bottom: TabBar(
          controller: controller,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: controller.index == 0 ? Colors.orange : Colors.green,
            borderRadius: BorderRadius.circular(5),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Calculator', icon: Icon(Icons.calculate)),
            Tab(text: 'Converter', icon: Icon(Icons.currency_exchange)),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [const CalculatorPage(), const ConvertPage()],
      ),
    );
  }
}
