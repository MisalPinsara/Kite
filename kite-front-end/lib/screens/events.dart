import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/event_card.dart';
import '../widgets/category_chip.dart';
import 'event_details.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_header.dart';
import '../widgets/responsive_wrapper.dart';

import '../models/events.dart';
import '../models/user.dart';
import '../sevices/event.dart';

class Events extends StatefulWidget {
  final User? user;
  const Events({super.key, this.user});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  int _selectedCategoryIndex = 0;
  bool _isDetailedView = false;
  final List<String> _categories = ["All", "Music", "Tech Meetups", "Hackathons", "Sports"];
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

                    // View Toggle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionTitleInLine("All Events"),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isDetailedView = !_isDetailedView;
                              });
                            },
                            icon: Icon(
                              _isDetailedView ? Icons.grid_view : Icons.view_list,
                              color: Colors.black,
                            ),
                            tooltip: _isDetailedView ? 'Switch to Grid View' : 'Switch to Detailed View',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_isDetailedView)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildDetailedVerticalList(isWide),
                      )
                    else ...[
                      // Featured Section
                      _buildSection(""),
                      const SizedBox(height: 40),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Nav Bar
            CustomBottomNavBar(selectedIndex: 1, user: widget.user,),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitleInLine(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildDetailedVerticalList(bool isWide) {
    return Column(
      children: List.generate(
        _events.length,
        (index) {
          final event = _events[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: double.infinity),
              child: Container(
                height: 140,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetails(event: event, user: widget.user,),
                      ),
                    ).then((_) => _fetchEvents());
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: Image.asset(
                          event.image ?? 'assets/images/hero-banner-bg.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.name,
                                style: GoogleFonts.inter(
                                  fontSize: isWide ? 20 : 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              _buildDetailItemSmall(Icons.calendar_month, event.date, isWide),
                              const SizedBox(height: 4),
                              _buildDetailItemSmall(Icons.access_time_filled, event.time, isWide),
                              const SizedBox(height: 4),
                              _buildDetailItemSmall(Icons.location_on, event.location, isWide),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItemSmall(IconData icon, String text, bool isWide) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: isWide ? 18 : 14, color: Colors.black),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: isWide ? 14 : 10,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title) {
    bool isWide = MediaQuery.of(context).size.width >= 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              title,
              style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 16),
        ],
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
                  _events.length,
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
