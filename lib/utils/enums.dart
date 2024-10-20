enum AnimalGender { mail, femail }

enum AnimalStatus {
  borrowed("Borrowed"),
  sold("Sold"),
  dead("Dead");

  const AnimalStatus(this.displayText);

  final String displayText;
}
