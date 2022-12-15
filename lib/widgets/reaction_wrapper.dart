import 'package:flutter/material.dart';

import '../models/reaction_box_paramenters.dart';
import '../reaction_askany.dart';

class ReactionWrapper extends StatefulWidget {
  final Widget child;
  final Widget buttonReaction;
  final Function(Reaction?)? handlePressed;
  final Function()? handlePressedReactions;
  final ReactionBoxParamenters? boxParamenters;
  final List<Reaction> reactions;
  final Reaction? initialEmotion;

  const ReactionWrapper({
    super.key,
    required this.child,
    required this.buttonReaction,
    this.boxParamenters,
    this.handlePressed,
    this.handlePressedReactions,
    this.initialEmotion,
    required this.reactions,
  });

  @override
  State<StatefulWidget> createState() => _ReactionWrapperState();
}

class _ReactionWrapperState extends State<ReactionWrapper>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Offset? _beginOffset;
  late final ReactionBoxParamenters boxParamenters =
      widget.boxParamenters ?? ReactionBoxParamenters();
  Reaction? _reaction;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _reaction = widget.initialEmotion;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: _reaction != null ? 12.0 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              widget.child,
              Visibility(
                visible: _reaction != null,
                child: Positioned(
                  bottom: -11,
                  child: GestureDetector(
                    onTap: widget.handlePressedReactions,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: _beginOffset ?? Offset.zero,
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _controller,
                        curve: Curves.bounceOut,
                      )),
                      child: Container(
                          padding: const EdgeInsets.all(3.0),
                          margin: const EdgeInsets.only(
                            left: 20.0,
                          ),
                          decoration: BoxDecoration(
                            color: Brightness.light == boxParamenters.brightness
                                ? Colors.grey.shade100
                                : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          alignment: Alignment.center,
                          child: SizedBox.square(
                            dimension: 16.0,
                            child: Text(_reaction?.emoji ?? "👍"),
                          )),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 4.0),
          GestureDetector(
            onTapDown: (details) {
              setState(() {
                _beginOffset = Offset.zero;
              });

              ReactionAskany.showReactionBox(
                context,
                offset: details.globalPosition,
                boxParamenters: boxParamenters,
                currentValue: _reaction,
                reactions: widget.reactions,
                onPressed: (Reaction reaction) {
                  _controller.reset();

                  if (reaction == _reaction) {
                    setState(() {
                      _reaction = null;
                    });

                    if (widget.handlePressed != null) {
                      widget.handlePressed!(_reaction);
                    }

                    return;
                  }

                  setState(() {
                    _reaction = reaction;
                    _beginOffset = const Offset(.25, -1);
                  });

                  _controller.forward();

                  if (widget.handlePressed != null) {
                    widget.handlePressed!(_reaction);
                  }
                },
              );
            },
            child: widget.buttonReaction,
          ),
        ],
      ),
    );
  }
}
