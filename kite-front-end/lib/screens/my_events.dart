import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/registered_event_card.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/responsive_wrapper.dart';
import '../widgets/join_event_dialog.dart';
import '../models/user.dart';
import '../models/events.dart';
import '../sevices/event.dart';

class MyEvents extends StatefulWidget {
  final User? user;
  const MyEvents({super.key, this.user});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  List<Event> _myEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMyEvents();
  }

  Future<void> _fetchMyEvents() async {
    if (widget.user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    final events = await EventServices().getMyEvents(widget.user!.id!);
    if (mounted) {
      setState(() {
        _myEvents = events;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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

                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "My Events",
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_myEvents.isEmpty)
                      const Center(child: Text("No registered events."))
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            bool isWide = MediaQuery.of(context).size.width >= 800;
                            
                            if (isWide) {
                              return Wrap(
                                spacing: 24,
                                runSpacing: 0,
                                children: _myEvents.map((e) => _buildConstrainedCard(e)).toList(),
                              );
                            }
                            
                            return Column(
                              children: _myEvents.map((e) => _buildCard(e)).toList(),
                            );
                          }
                        ),
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Bottom Nav Bar
            CustomBottomNavBar(selectedIndex: 2, user: widget.user,),
          ],
        ),
      ),
    );
  }

  Widget _buildConstrainedCard(Event event) {
    return SizedBox(
      width: 550,
      child: _buildCard(event),
    );
  }

  Widget _buildCard(Event event) {
    return RegisteredEventCard(
      title: event.name,
      date: event.date,
      time: event.time,
      location: event.location,
      registeredMail: event.registeredMail,
      onCancel: () => _showCancelDialog(context, event),
      onUpdate: () => _showUpdateDialog(context, event),
    );
  }

  void _showUpdateDialog(BuildContext context, Event event) {
    showJoinEventDialog(
      context: context,
      message: 'Please enter your new email',
      initialEmail: event.registeredMail ?? widget.user?.email,
      onJoinSuccess: (String email) async {
        if (widget.user != null) {
          bool success = await EventServices().updateRegisteredMail(
            widget.user!.id!, 
            event.id, 
            email
          );
          
          if (success) {
            _fetchMyEvents();
            showCustomDialog(
              context: context,
              message: 'Email updated successfully!',
              type: DialogType.success,
              onPrimaryAction: () {},
            );
          } else {
            showCustomDialog(
              context: context,
              message: 'Failed to update email. Please try again.',
              type: DialogType.failure,
              onPrimaryAction: () {},
            );
          }
        }
      },
    );
  }

  void _showCancelDialog(BuildContext context, Event event) {
    showCustomDialog(
      context: context,
      message: 'Are you sure you want to cancel your registration?',
      type: DialogType.question,
      isConfirmation: true,
      primaryActionText: 'Yes',
      secondaryActionText: 'No',
      onPrimaryAction: () async {
        if (widget.user != null) {
          bool success = await EventServices().leaveEvent(widget.user!.id!, event.id);
          if (success) {
            _fetchMyEvents();
          }
        }
        showCustomDialog(
          context: context,
          message: 'Registration cancelled successfully!',
          type: DialogType.success,
          onPrimaryAction: () {},
        );
      },
      onSecondaryAction: () {},
    );
  }
}
