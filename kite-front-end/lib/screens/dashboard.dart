import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/event_card.dart';
import '../widgets/category_chip.dart';
import 'event_details.dart';
import '../models/user.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_header.dart';
import '../widgets/responsive_wrapper.dart';
import '../models/events.dart';
import '../sevices/event.dart';

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  User? user;
  Dashboard({super.key, this.user});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    "All",
    "Music",
    "Tech Meetups",
    "Hackathons",
    "Sports",
  ];
  
  List<Event> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final events = await EventServices().getAllEvents();
    if (mounted) {
      setState(() {
        _events = events;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width >= 800;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            ResponsiveWrapper(
              maxWidth: 1800,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const CustomHeader(),

                    // Hero Section
                    Container(
                      height: isWide ? 400 : 200,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.all(isWide ? 32 : 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(isWide ? 32 : 24),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/hero-banner-bg.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back!',
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: isWide ? 28 : 20,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              widget.user?.username ?? 'User',
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: isWide ? 48 : 30,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Categories
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: isWide
                          ? Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: List.generate(
                                _categories.length,
                                (index) => CategoryChip(
                                  label: _categories[index],
                                  isSelected: _selectedCategoryIndex == index,
                                  onTap: () {
                                    setState(() {
                                      _selectedCategoryIndex = index;
                                    });
                                  },
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  _categories.length,
                                  (index) => CategoryChip(
                                    label: _categories[index],
                                    isSelected: _selectedCategoryIndex == index,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategoryIndex = index;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 32),

                    // Sections
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      _buildSection("Featured"),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Bottom Nav Bar
            CustomBottomNavBar(selectedIndex: 0, user: widget.user,),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    bool isWide = MediaQuery.of(context).size.width >= 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            title,
            style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = isWide ? 4 : 2;
              double width = (constraints.maxWidth - ((crossAxisCount - 1) * 16)) / crossAxisCount;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  _events.length - 6,
                  (index) => EventCard(
                    event: _events[index],
                    width: width,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetails(event: _events[index], user: widget.user,),
                        ),
                      ).then((_) => _fetchEvents());
                    },
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
