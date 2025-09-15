import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String status; // Active / Inactive
  final String avatar; // Profile image

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.avatar,
  });
}
class CustomerProvider with ChangeNotifier{
  final List<Customer> _customers = [
    Customer(
      id: "1",
      name: "John Doe",
      email: "john@example.com",
      phone: "9876543210",
      status: "Active",
      avatar: "https://i.pravatar.cc/150?img=1",
    ),
    Customer(
      id: "2",
      name: "Jane Smith",
      email: "jane@example.com",
      phone: "8765432109",
      status: "Inactive",
      avatar: "https://i.pravatar.cc/150?img=2",
    ),
    Customer(
      id: "3",
      name: "Michael Johnson",
      email: "michael@example.com",
      phone: "7654321098",
      status: "Active",
      avatar: "https://i.pravatar.cc/150?img=3",
    ),
    Customer(
      id: "4",
      name: "Emily Davis",
      email: "emily@example.com",
      phone: "6543210987",
      status: "Active",
      avatar: "https://i.pravatar.cc/150?img=4",
    ),
    Customer(
      id: "5",
      name: "David Wilson",
      email: "david@example.com",
      phone: "5432109876",
      status: "Inactive",
      avatar: "https://i.pravatar.cc/150?img=5",
    ),
    Customer(
      id: "6",
      name: "Sophia Taylor",
      email: "sophia@example.com",
      phone: "4321098765",
      status: "Active",
      avatar: "https://i.pravatar.cc/150?img=6",
    ),
    Customer(
      id: "7",
      name: "James Anderson",
      email: "james@example.com",
      phone: "3210987654",
      status: "Active",
      avatar: "https://i.pravatar.cc/150?img=7",
    ),
    Customer(
      id: "8",
      name: "Olivia Thomas",
      email: "olivia@example.com",
      phone: "2109876543",
      status: "Inactive",
      avatar: "https://i.pravatar.cc/150?img=8",
    ),
    Customer(
      id: "9",
      name: "Daniel Martinez",
      email: "daniel@example.com",
      phone: "1098765432",
      status: "Active",
      avatar: "https://i.pravatar.cc/150?img=9",
    ),
    Customer(
      id: "10",
      name: "Emma Garcia",
      email: "emma@example.com",
      phone: "9988776655",
      status: "Active",
      avatar: "https://i.pravatar.cc/150?img=10",
    ),
  ];

  String _searchQuery = "";
  String _statusFilter = "All"; // All, Active, Inactive

  List<Customer> get customers {
    return _customers.where((c) {
      final matchesSearch = c.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _statusFilter == "All" || c.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Inactive":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}