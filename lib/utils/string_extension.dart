extension StringExtension on String {
  String capitalize() {
    String output = '';
    return this
        .split(' ')
        .map((word) {
          print(word);
          if (!word.isEmpty) {
            return output += word[0].toUpperCase() + word.substring(1) + " ";
          } else {
            return output;
          }
        })
        .toList()
        .last
        .toString();
  }
}
