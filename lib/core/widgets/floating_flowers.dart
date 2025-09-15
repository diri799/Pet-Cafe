import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingFlowers extends StatefulWidget {
  final int numberOfFlowers;
  final double maxSize;
  final double minSize;
  final double maxSpeed;
  final double minSpeed;
  final double maxDistance;

  const FloatingFlowers({
    super.key,
    this.numberOfFlowers = 8,
    this.maxSize = 30,
    this.minSize = 20,
    this.maxSpeed = 2.0,
    this.minSpeed = 0.5,
    this.maxDistance = 50,
  });

  @override
  State<FloatingFlowers> createState() => _FloatingFlowersState();
}

class _FloatingFlowersState extends State<FloatingFlowers>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.numberOfFlowers,
      (index) => AnimationController(
        duration: Duration(milliseconds: (widget.minSpeed * 1000 + index * (widget.maxSpeed - widget.minSpeed) * 1000 / widget.numberOfFlowers).toInt()),
        vsync: this,
      )..repeat(reverse: true),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 2 * math.pi).animate(controller);
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.numberOfFlowers, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            final value = _animations[index].value;
            final screenSize = MediaQuery.of(context).size;
            final x = (index * (screenSize.width / widget.numberOfFlowers)) + math.sin(value) * widget.maxDistance;
            final y = (index * (screenSize.height / widget.numberOfFlowers)) + math.cos(value) * widget.maxDistance;

            final size = widget.minSize + (index / widget.numberOfFlowers) * (widget.maxSize - widget.minSize);

            return Positioned(
              left: x.clamp(0, screenSize.width - size),
              top: y.clamp(0, screenSize.height - size),
              child: Opacity(
                opacity: 0.3 + math.sin(value) * 0.2,
                child: Icon(
                  Icons.local_florist,
                  color: Color.fromRGBO(
                    255,
                    100 + index * 20,
                    150 + index * 10,
                    1,
                  ),
                  size: size,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

