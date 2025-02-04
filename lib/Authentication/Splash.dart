import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotifyplayer/Authentication/LoginPage.dart';
import 'package:spotifyplayer/Globals.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/TwentyTwo.jpg"),
        fit: BoxFit.cover,
      )),
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left:0 ,
            right:MediaQuery.of(context).size.width*0.8,
            child: Center(
              child: Text(
                "kimemia",
                style: GoogleFonts.badScript(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
     
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child:
            
             SlideToLoginButton(
            
                ),
          )
        ],
      ),
    ));
  }
}

class SlideToLoginButton extends StatefulWidget {
  // final Function(bool complete) onSlideComplete;
  final double width;
  final double height;

  const SlideToLoginButton({
    Key? key,
    // required this.onSlideComplete,
    this.width = 300.0,
    this.height = 60.0,
  }) : super(key: key);

  @override
  State<SlideToLoginButton> createState() => _SlideToLoginButtonState();
}

class _SlideToLoginButtonState extends State<SlideToLoginButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _glowAnimation;
  double _dragPosition = 0.0;
  bool _isDragging = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true); // Makes the glow effect continuous

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _glowAnimation = Tween<double>(begin: 2.0, end: 4.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_completed) return;
    setState(() {
      _isDragging = true;
      _dragPosition += details.delta.dx;
      _dragPosition = _dragPosition.clamp(0.0, widget.width - widget.height);
    });
  }

  void _onDragEnd(DragEndDetails details) async {
    if (_completed) return;
    setState(() {
      _isDragging = false;
      if (_dragPosition >= widget.width - widget.height - 20) {
        _completed = true;
        _dragPosition = widget.width - widget.height;
        // Navigate to the new page
        _dragPosition = 0.0;
  
    Navigator.of(context).push(FadeScaleRoute(page: LoginPage()));
        _isDragging = false;
        _completed = false;
      } else {
        _dragPosition = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.height / 2),
            gradient: LinearGradient(
              colors: [
                Color(0xFF1DB954), // Spotify green
                Color(0xFF191414), // Spotify dark
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF1DB954).withOpacity(0.3),
                blurRadius: _glowAnimation.value * 8,
                spreadRadius: _glowAnimation.value,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Animated background pattern
              _buildMusicPattern(),

              // Background text
              Center(
                child: Text(
                  'Slide to Login',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // Sliding button
              Positioned(
                left: _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
                  child: Container(
                    width: widget.height,
                    height: widget.height,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF1DB954).withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: Icon(
                          _completed ? Icons.check : Icons.play_arrow_rounded,
                          key: ValueKey(_completed),
                          color: Color(0xFF1DB954),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Enhanced shimmer effect
              if (_isDragging)
                Positioned(
                  left: _dragPosition + widget.height,
                  child: Container(
                    width: 80,
                    height: widget.height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Color(0xFF1DB954).withOpacity(0.3),
                          Colors.white.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMusicPattern() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.height / 2),
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: MusicPatternPainter(
          animation: _animation.value,
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }
}

// Custom painter for music pattern
class MusicPatternPainter extends CustomPainter {
  final double animation;
  final Color color;

  MusicPatternPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final spacing = size.height / 4;

    for (var i = 0; i < 5; i++) {
      final x = (size.width / 5) * i + (animation * 20);
      final path = Path();

      path.moveTo(x, size.height / 2);
      path.cubicTo(
        x + spacing,
        size.height / 4,
        x + spacing * 2,
        size.height * 3 / 4,
        x + spacing * 3,
        size.height / 2,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
