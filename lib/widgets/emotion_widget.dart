import 'package:flutter/material.dart';
import 'package:social_reactions/models/reaction.dart';
import 'package:social_reactions/models/reaction_box_paramenters.dart';

class EmotionWidget extends StatefulWidget {
  final Reaction emotion;
  final Function(Reaction) handlePressed;
  final ReactionBoxParamenters boxParamenters;
  final bool isSelected;

  const EmotionWidget({
    super.key,
    required this.emotion,
    required this.handlePressed,
    required this.boxParamenters,
    this.isSelected = false,
  });

  @override
  State<EmotionWidget> createState() => _EmotionWidgetState();
}

class _EmotionWidgetState extends State<EmotionWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    if (widget.isSelected) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.handlePressed(widget.emotion);
        Navigator.pop(context);
      },
      child: widget.isSelected
          ? ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.2).animate(
                CurvedAnimation(
                  curve: Curves.easeInOut,
                  parent: _controller,
                ),
              ),
              child: _buildBody(),
            )
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: widget.boxParamenters.iconSpacing,
      ),
      alignment: Alignment.center,
      child: SizedBox.square(
        dimension: widget.boxParamenters.iconSize,
        child: Text(
          widget.emotion.emoji,
          style: TextStyle(fontSize: widget.boxParamenters.iconSize - 2.0),
        ),
      ),
    );
  }
}
