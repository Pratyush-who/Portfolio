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
      child: Padding(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLinksGrid(),
                      const SizedBox(height: 16),
                      _buildProfileImage(height: 180),
                    ],
                  ),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
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
        const Divider(color: Color(0xFF333333), height: 1),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                '\$ echo "Built in Flutter , build without sense...!!!"',
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
                '© 2025 Pratyush-Who Developer Portfolio',
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
