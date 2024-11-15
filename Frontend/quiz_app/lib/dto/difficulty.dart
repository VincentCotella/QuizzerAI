Difficulty difficultyFromString(String value) {
  if (value == Difficulty.BEGINNER.name) {
    return Difficulty.BEGINNER;
  }
  else if (value == Difficulty.EASY.name) {
    return Difficulty.EASY;
  }
  else if (value == Difficulty.INTERMEDIATE.name) {
    return Difficulty.INTERMEDIATE;
  }
  else if (value == Difficulty.HARD.name) {
    return Difficulty.HARD;
  }
  else if (value == Difficulty.ADVANCED.name) {
    return Difficulty.ADVANCED;
  }
  throw ArgumentError("Unknown difficulty");
}

enum Difficulty {
  BEGINNER("Débutant"),
  EASY("Facile"),
  INTERMEDIATE("Intermédiaire"),
  HARD("Difficile"),
  ADVANCED("Avancé");

  const Difficulty(this.label);
  final String label;
}