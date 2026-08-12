import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksSection extends StatelessWidget {
  const LinksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.12,
              vertical: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'LINKS',
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 30),
                isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildLinksGrid()),
                          const SizedBox(width: 40),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: _buildProfileImage(
                                height: _calculateImageHeight(),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildLinksGrid(),
                          const SizedBox(height: 40),
                          _buildProfileImage(height: _calculateImageHeight()),
                        ],
                      ),
                const SizedBox(height: 60),
                _buildFooter(),
              ],
            ),
          ),
          const _FooterGlowWave(), // Moved outside padding for edge-to-edge width
        ],
      ),
    );
  }

  double _calculateImageHeight() {
    return 160;
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
                      launchUrl(Uri.parse('https://github.com/Pratyush-Who'));
                      print('GitHub clicked');
                    },
                  ),
                  const SizedBox(height: 12),
                  _LinkItem(
                    label: '> twitter',
                    onTap: () {
                      launchUrl(Uri.parse('https://x.com/o_g_pratyush'));
                      print('Twitter clicked');
                    },
                  ),
                  const SizedBox(height: 12),
                  _LinkItem(
                    label: '> linkedin',
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                          'https://www.linkedin.com/in/pratyushmehra22/',
                        ),
                      );
                      print('LinkedIn clicked');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LinkItem(
                    label: '> email',
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                          "https://mail.google.com/mail/?view=cm&fs=1&to=pratyushmehra2005@gmail.com",
                        ),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),

                  const SizedBox(height: 12),
                  _LinkItem(
                    label: '> discord',
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                          'https://discord.com/users/825183697594613770',
                        ),
                      );
                      print('Discord clicked');
                    },
                  ),
                  const SizedBox(height: 12),
                  _LinkItem(
                    label: '> calendly',
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                          'https://calendly.com/pratyushmehra2005/30min',
                        ),
                      );
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

  Widget _buildProfileImage({double height = 160}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400, maxHeight: height),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[700]!, width: 1),
          image: const DecorationImage(
            image: NetworkImage(
              'https://media1.tenor.com/m/Nt6Zju-KjTsAAAAC/luffy-one-piece.gif',
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
        SizedBox(
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack(
                children: [
                  // Outline
                  Text(
                    'PRATYUSH-WHO',
                    style: GoogleFonts.pixelifySans(
                      fontSize: 240,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 10,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = const Color(
                          0xFFFF6B35,
                        ).withOpacity(0.3), // Orange outline
                    ),
                  ),
                  // Solid Fill
                  Text(
                    'PRATYUSH-WHO',
                    style: GoogleFonts.pixelifySans(
                      fontSize: 240,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 10,
                      color: Colors.white.withOpacity(0.02), // Very faint fill
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterGlowWave extends StatelessWidget {
  const _FooterGlowWave();

  @override
  Widget build(BuildContext context) {
    final heights = [0.3, 0.55, 0.8, 1.0, 0.8, 0.55, 0.3];
    return SizedBox(
      height: 290,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(7, (index) {
          final isLast = index == 6;
          return Expanded(
            child: Stack(
              children: [
                // Gradient Fill
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: heights[index],
                    widthFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFFFF6B35).withOpacity(0.6),
                            const Color(0xFFFF6B35).withOpacity(0.9),
                            const Color(0xFFFF6B35).withOpacity(0.9),
                          ],
                          stops: const [0.0, 0.4, 0.75, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                // Dotted Line on the right
                if (!isLast)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: CustomPaint(
                      size: const Size(1, double.infinity),
                      painter: _DottedLinePainter(),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    var max = size.height;
    var dashWidth = 2.0;
    var dashSpace = 4.0;
    double startY = 0;

    while (startY < max) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
