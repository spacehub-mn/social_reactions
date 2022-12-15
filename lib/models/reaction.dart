class Reaction {
  final String emoji;
  final String value;

  const Reaction({required this.emoji, required this.value});
  const Reaction.single(String reaction)
      : emoji = reaction,
        value = reaction;
}
