import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _isHovering = false;
  String _currentTime = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 800;

    return Container(
      width: double.infinity,
      color: Colors.black,
      constraints: BoxConstraints(minHeight: screenHeight * 0.6),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.12,
          20,
          screenWidth * 0.12,
          8,
        ),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 3, child: _buildContent()),
                  const SizedBox(width: 60),
                  SizedBox(
                    width: screenWidth * 0.20 > 420 ? 420 : screenWidth * 0.20,
                    height: screenWidth * 0.20 > 420 ? 420 : screenWidth * 0.20,
                    child: _buildRiveAnimation(),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildContent(),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: (screenWidth * 0.55) > 350
                        ? 350
                        : screenWidth * 0.55,
                    height: (screenWidth * 0.55) > 350
                        ? 350
                        : screenWidth * 0.55,
                    child: _buildRiveAnimation(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildContent() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '\$ flutter_developer --    mobile_specialist_',
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Building cross-platform mobile applications with Flutter. Specializing in state management, UI/UX design, and scalable app architecture. Currently crafting beautiful mobile experiences and exploring new technologies.',
            style: GoogleFonts.jetBrainsMono(
              color: Colors.grey[300],
              fontSize: 18,
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 24),
          _buildStatusRow(),
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border.all(color: Colors.grey[600]!, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _currentTime,
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 28),
        _buildOpenToWorkButton(),
      ],
    );
  }

  Widget _buildOpenToWorkButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () {
          // Add your contact action here
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _isHovering ? const Color(0xFFFF6B35) : Colors.transparent,
            border: Border.all(color: const Color(0xFFFF6B35), width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Open to work',
            style: GoogleFonts.jetBrainsMono(
              color: _isHovering ? Colors.black : const Color(0xFFFF6B35),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRiveAnimation() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isHovering ? const Color(0xFFFF6B35) : Colors.grey[600]!,
            width: _isHovering ? 3 : 2,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isHovering
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: Colors.grey[900],
              child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
            ),
          ),
        ),
      ),
    );
  }
}
