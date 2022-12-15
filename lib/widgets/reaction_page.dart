import 'package:flutter/material.dart';
import 'package:reaction_askany/models/reaction.dart';
import 'package:reaction_askany/models/reaction_box_paramenters.dart';
import 'package:reaction_askany/widgets/emotion_widget.dart';

class ReactionPage extends StatelessWidget {
  final List<Reaction> reactions;
  final Function(Reaction) onPressed;
  final ReactionBoxParamenters boxParamenters;
  final Reaction? currentValue;

  const ReactionPage({
    super.key,
    required this.reactions,
    required this.onPressed,
    required this.boxParamenters,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: boxParamenters.paddingHorizontal,
      ),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reactions.length,
      itemBuilder: (context, index) {
        return EmotionWidget(
          emotion: reactions[index],
          handlePressed: onPressed,
          boxParamenters: boxParamenters,
          isSelected: reactions[index] == currentValue,
        );
      },
    );
  }
}
