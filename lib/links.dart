import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolioflutter/widgets/pixel_character_footer/pixel_character_footer.dart';
import 'package:url_launcher/url_launcher.dart';

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '// ',
          style: GoogleFonts.jetBrainsMono(
            color: const Color(0xFFFF6B35),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            color: const Color(0xFFFF6B35),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
          ),
        ),
      ],
    );
  }
}

class LinksSection extends StatelessWidget {
  final ValueListenable<bool>? animationsEnabled;

  const LinksSection({super.key, this.animationsEnabled});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final isMobile = screenWidth < 640;
    final horizontalPadding = isMobile ? 20.0 : screenWidth * 0.12;

    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              30,
              horizontalPadding,
              isMobile ? 28 : 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _SectionLabel(label: 'LINKS'),
                SizedBox(height: isMobile ? 6 : 8),
                Text(
                  'FIND ME HERE',
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white,
                    fontSize: isMobile ? 22 : 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    height: 1.15,
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
              ],
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              const _FooterBanner(),
              if (animationsEnabled == null)
                const PixelCharacterFooter()
              else
                ValueListenableBuilder<bool>(
                  valueListenable: animationsEnabled!,
                  builder: (context, active, child) {
                    return TickerMode(enabled: active, child: child!);
                  },
                  child: const PixelCharacterFooter(),
                ),
            ],
          ),
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
}

class _FooterBanner extends StatelessWidget {
  const _FooterBanner();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 640;
    final height = (w * (isMobile ? 0.38 : 0.2)).clamp(140.0, 300.0);

    return ClipRect(
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.white, Colors.white],
              stops: [0.0, 0.18, 1.0],
            ).createShader(rect);
          },
          child: Image.asset(
            'assets/images/footer.png',
            width: double.infinity,
            height: height,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.medium,
            cacheWidth: 1600,
            semanticLabel: 'PRATYUSH-WHO',
          ),
        ),
      ),
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
