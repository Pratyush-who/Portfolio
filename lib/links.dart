import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LinksSection extends StatelessWidget {
  const LinksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.12,
          vertical: 60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'LINKS',
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 60),
            isDesktop
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildLinksGrid()),
                        const SizedBox(width: 80),
                        Flexible(flex: 1, child: _buildProfileImage()),
                      ],
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLinksGrid(),
                      const SizedBox(height: 40),
                      _buildProfileImage(),
                    ],
                  ),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildLinksGrid() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LinkItem(
                    label: '> github',
                    onTap: () {
                      // Handle GitHub link
                      print('GitHub clicked');
                    },
                  ),
                  const SizedBox(height: 24),
                  _LinkItem(
                    label: '> twitter',
                    onTap: () {
                      // Handle Twitter link
                      print('Twitter clicked');
                    },
                  ),
                  const SizedBox(height: 24),
                  _LinkItem(
                    label: '> linkedin',
                    onTap: () {
                      // Handle LinkedIn link
                      print('LinkedIn clicked');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 80),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LinkItem(
                    label: '> email',
                    onTap: () {
                      // Handle Email link
                      print('Email clicked');
                    },
                  ),
                  const SizedBox(height: 24),
                  _LinkItem(
                    label: '> discord',
                    onTap: () {
                      // Handle Discord link
                      print('Discord clicked');
                    },
                  ),
                  const SizedBox(height: 24),
                  _LinkItem(
                    label: '> calendly',
                    onTap: () {
                      // Handle Calendly link
                      print('Calendly clicked');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 300),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[700]!, width: 1),
          image: const DecorationImage(
            // Replace with your actual image URL
            image: NetworkImage(
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop&crop=face',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(color: Color(0xFF333333), height: 1),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                '\$ echo "Built with passion for mobile development"',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.grey[500],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 20),
            Flexible(
              child: Text(
                '© 2025 BRROCODE Developer Portfolio',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.grey[500],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LinkItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _LinkItem({required this.label, required this.onTap});

  @override
  State<_LinkItem> createState() => _LinkItemState();
}

class _LinkItemState extends State<_LinkItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(
            widget.label,
            style: GoogleFonts.jetBrainsMono(
              color: _isHovering ? const Color(0xFFFF6B35) : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
