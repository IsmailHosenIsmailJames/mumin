import 'dart:math';

class FuzzyMatcher {
  /// Calculates the Levenshtein distance between two strings.
  static int levenshtein(String s1, String s2) {
    s1 = s1.toLowerCase(); //convert to lower case to avoid case sensitivity.
    s2 = s2.toLowerCase();

    if (s1 == s2) {
      return 0;
    }
    if (s1.isEmpty) {
      return s2.length;
    }
    if (s2.isEmpty) {
      return s1.length;
    }

    List<List<int>> d = List.generate(
        s1.length + 1, (i) => List<int>.filled(s2.length + 1, 0),
        growable: false);

    for (int i = 0; i <= s1.length; i++) {
      d[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      d[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        int cost = (s1[i - 1] == s2[j - 1]) ? 0 : 1;
        d[i][j] = min(
            d[i - 1][j] + 1, // deletion
            min(
                d[i][j - 1] + 1, // insertion
                d[i - 1][j - 1] + cost)); // substitution
      }
    }
    return d[s1.length][s2.length];
  }

  /// Finds the closest key in a map based on Levenshtein distance.
  static String? findClosestKey(
      Map<String, dynamic> dataMap, String targetKey) {
    String? closestKey;
    int minDistance = 999999; // Start with a large distance

    for (String key in dataMap.keys) {
      int distance = levenshtein(targetKey, key);
      if (distance < minDistance) {
        minDistance = distance;
        closestKey = key;
      }
    }

    // Optional: Add a threshold.  If the closest match is still very far,
    // you might not want to consider it a match.
    if (minDistance > 3) {
      // Example threshold:  More than 3 edits is probably not a match.
      return null;
    }

    return closestKey;
  }
}
