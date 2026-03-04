import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/feedback_dialog.dart';
import '../widgets/responsive_wrapper.dart';
import '../widgets/join_event_dialog.dart';

import '../models/events.dart';
import '../models/user.dart';
import '../models/review.dart';
import '../sevices/event.dart';
import '../sevices/review.dart';

class EventDetails extends StatefulWidget {
  final Event event;
  final User? user;

  const EventDetails({super.key, required this.event, this.user});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  List<Review> _reviews = [];
  bool _isLoadingReviews = true;
  bool _isJoining = false;
  bool _isJoined = false;
  late int _seatsLeft;

  @override
  void initState() {
    super.initState();
    _seatsLeft = widget.event.seatsLeft;
    _fetchReviews();
    _checkIfJoined();
  }

  Future<void> _checkIfJoined() async {
    if (widget.user != null) {
      final myEvents = await EventServices().getMyEvents(widget.user!.id!);
      if (mounted) {
        setState(() {
          _isJoined = myEvents.any((e) => e.id == widget.event.id);
        });
      }
    }
  }

  Future<void> _fetchReviews() async {
    final reviews = await ReviewServices().getReviews(widget.event.id);
    if (mounted) {
      setState(() {
        _reviews = reviews;
        _isLoadingReviews = false;
      });
    }
  }

  void _handleJoinEvent() {
    if (widget.user == null) {
      showCustomDialog(
        context: context,
        message: 'Please login to join the event.',
        type: DialogType.failure,
        onPrimaryAction: () {},
      );
      return;
    }

    showJoinEventDialog(
      context: context,
      message: 'Please confirm your email to join',
      initialEmail: widget.user!.email,
      onJoinSuccess: (email) async {
        setState(() { _isJoining = true; });
        bool success = await EventServices().joinEvent(widget.user!.id!, widget.event.id, email);
        setState(() { _isJoining = false; });
        if (success) {
          setState(() { 
            _isJoined = true; 
            if (_seatsLeft > 0) _seatsLeft--;
          });
          showCustomDialog(
            context: context,
            message: 'Successfully joined the event!',
            type: DialogType.success,
            onPrimaryAction: () {},
          );
        } else {
          showCustomDialog(
            context: context,
            message: 'Failed to join or already registered.',
            type: DialogType.failure,
            onPrimaryAction: () {},
          );
        }
      },
    );
  }

  void _handleAddReview() {
    if (widget.user == null) {
      showCustomDialog(
        context: context,
        message: 'Please login to add a review.',
        type: DialogType.failure,
        onPrimaryAction: () {},
      );
      return;
    }

    showFeedbackDialog(
      context,
      onSubmit: (text) async {
        Navigator.pop(context);
        setState(() { _isLoadingReviews = true; });
        Review newReview = Review(name: widget.user!.username, description: text, eventId: widget.event.id);
        bool success = await ReviewServices().postReview(newReview);
        if (success) {
          _fetchReviews();
          showCustomDialog(
            context: context,
            message: 'Feedback submitted successfully!',
            type: DialogType.success,
            onPrimaryAction: () {},
          );
        } else {
          setState(() { _isLoadingReviews = false; });
          showCustomDialog(
            context: context,
            message: 'Failed to submit feedback.',
            type: DialogType.failure,
            onPrimaryAction: () {},
          );
        }
      },
    );
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
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Section with Back Button
                    Stack(
                      children: [
                        Container(
                          height: isWide ? 500 : 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                            image: DecorationImage(
                              image: AssetImage(widget.event.image ?? 'assets/images/hero-banner-bg.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Row(
                              children: [
                                const Icon(Icons.arrow_back, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  'Back',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Event Info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event.name,
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.event.description ?? 'An exciting event for everyone to join and enjoy.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Details with Icons
                          _buildDetailItem(Icons.calendar_month, widget.event.date),
                          const SizedBox(height: 16),
                          _buildDetailItem(Icons.access_time_filled, widget.event.time),
                          const SizedBox(height: 16),
                          _buildDetailItem(Icons.location_on, widget.event.location),
                          const SizedBox(height: 16),
                          _buildDetailItem(
                            Icons.group, 
                            'Seats: ${widget.event.seats} | Available: $_seatsLeft'
                          ),
                          
                          const SizedBox(height: 40),

                          // Join Event Button
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: isWide ? 300 : double.infinity),
                                child: CustomButton(
                                  text: _isJoined ? 'Joined' : (_seatsLeft <= 0 ? 'Full' : (_isJoining ? 'Joining...' : 'Join event')),
                                  onPressed: (_isJoined || _seatsLeft <= 0 || _isJoining) ? null : _handleJoinEvent,
                                  icon: _isJoined ? Icons.check : Icons.arrow_forward,
                                  height: 64,
                                  borderRadius: 20,
                                ),
                            ),
                          ),
                          
                          const SizedBox(height: 48),

                          // Reviews Heading
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reviews',
                                style: GoogleFonts.inter(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF333333),
                                ),
                              ),
                              GestureDetector(
                                onTap: _handleAddReview,
                                child: Text(
                                  'Add review +',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Review Cards
                          if (_isLoadingReviews)
                            const CircularProgressIndicator()
                          else if (_reviews.isEmpty)
                            Text("No reviews yet.")
                          else
                            Wrap(
                              spacing: 24,
                              runSpacing: 24,
                              children: _reviews.map((r) => _buildConstrainedReviewCard(
                                r.name,
                                r.description,
                                isWide,
                              )).toList(),
                            ),
                          
                          const SizedBox(height: 32),

                          // Contact Info
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: '+94 124 542 1285 ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: '(for any inquiries regarding the event)',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.black),
        const SizedBox(width: 16),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildConstrainedReviewCard(String name, String content, bool isWide) {
    if (isWide) {
      return SizedBox(
        width: 550,
        child: _buildReviewCard(name, content),
      );
    }
    return _buildReviewCard(name, content);
  }

  Widget _buildReviewCard(String name, String content) {
    return DottedBorder(
      options: const RoundedRectDottedBorderOptions(
        radius: Radius.circular(24),
        dashPattern: [10.0, 5.0],
        color: Colors.black,
        strokeWidth: 2,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
