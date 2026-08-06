
import 'package:book_meeting_room/screens/login/status_screen.dart';
import 'package:flutter/material.dart';

import '../cab_list_screen.dart';

class HomeScreen extends StatefulWidget {
  final int isAdmin;

  const HomeScreen({super.key, required this.isAdmin});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<String> pages = ["Cabs", "Status"];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> screens = [CabListScreen(), StatusScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),

      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildNavItem(
                title: "Book Cab",
                icon: Icons.local_taxi,
                index: 0,
              ),
              _buildNavItem(
                title: widget.isAdmin == 0 ? "History" : 'Requests',
                icon: Icons.assignment_outlined,
                index: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String title,
    required IconData icon,
    required int index,
  }) {
    bool selected = selectedIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient:
                  selected
                      ? const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                      : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    icon,
                    key: ValueKey(selected),
                    size: 22,
                    color: selected ? Colors.white : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: selected ? Colors.white : Colors.grey.shade700,
                  ),
                  child: Text(title),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
