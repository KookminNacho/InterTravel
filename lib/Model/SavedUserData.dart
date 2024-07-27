class SavedUserData {
  String displayName;
  String email;
  List<String> tags;
  String uid;
  List<Map<String, DateTime>> lastSuggestions;

  SavedUserData({
    required this.displayName,
    required this.email,
    required this.tags,
    required this.uid,
    required this.lastSuggestions,
  });
}
