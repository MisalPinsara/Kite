import 'package:flutter/material.dart';
import 'package:kite/models/user.dart';
import '../screens/dashboard.dart';
import '../screens/events.dart';
import '../screens/my_events.dart';
import '../screens/settings.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final User? user;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          height: 75,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context,
                Icons.home_filled,
                isSelected: selectedIndex == 0,
                onTap: () => _navigateTo(context, Dashboard(user: user)),
              ),
              _buildNavItem(
                context,
                Icons.event,
                isSelected: selectedIndex == 1,
                onTap: () => _navigateTo(context, Events(user: user)),
              ),
              _buildNavItem(
                context,
                Icons.confirmation_number,
                isSelected: selectedIndex == 2,
                onTap: () => _navigateTo(context, MyEvents(user: user)),
              ),
              _buildNavItem(
                context,
                Icons.settings,
                isSelected: selectedIndex == 3,
                onTap: () => _navigateTo(context, Settings(currentUser: user,)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isSelected ? null : onTap,
      child: Icon(
        icon,
        size: 28,
        color: isSelected ? Colors.white : Colors.grey[400],
      ),
    );
  }
}
