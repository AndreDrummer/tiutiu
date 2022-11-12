class GenerateHashKey {
  static String encodeCaracter(int element) {
    switch (element) {
      case 0:
        return 'A';
      case 1:
        return 'B';
      case 2:
        return 'C';
      case 3:
        return 'D';
      case 4:
        return 'E';
      case 5:
        return 'F';
      case 6:
        return 'G';
      case 7:
        return 'H';
      case 8:
        return 'I';
      case 9:
        return 'J';
      case 10:
        return 'K';
      case 11:
        return 'L';
      case 12:
        return 'M';
      case 13:
        return 'N';
      case 14:
        return 'O';
      case 15:
        return 'P';
      case 16:
        return 'Q';
      case 17:
        return 'R';
      case 18:
        return 'S';
      case 19:
        return 'T';
      case 20:
        return 'U';
      case 21:
        return 'V';
      case 22:
        return 'W';
      case 23:
        return 'X';
      case 24:
        return 'Y';
      case 25:
        return 'Z';
      default:
        return '';
    }
  }

  static int decodeCaracter(String element) {
    switch (element) {
      case 'A':
        return 0;
      case 'B':
        return 1;
      case 'C':
        return 2;
      case 'D':
        return 3;
      case 'E':
        return 4;
      case 'F':
        return 5;
      case 'G':
        return 6;
      case 'H':
        return 7;
      case 'I':
        return 8;
      case 'J':
        return 9;
      case 'K':
        return 10;
      case 'L':
        return 11;
      case 'M':
        return 12;
      case 'N':
        return 13;
      case 'O':
        return 14;
      case 'P':
        return 15;
      case 'Q':
        return 16;
      case 'R':
        return 17;
      case 'S':
        return 18;
      case 'T':
        return 19;
      case 'U':
        return 20;
      case 'V':
        return 21;
      case 'W':
        return 22;
      case 'X':
        return 23;
      case 'Y':
        return 24;
      case 'Z':
        return 25;
      default:
        return int.parse(element);
    }
  }

  static String encodeWord(String palavra, int key) {
    List<String> arrChar = [];
    List<int> arrInt = [];
    List<int> arrInt2 = [];

    String output = '';

    for (int i = 0; i < palavra.length; i++) {
      arrChar.add(palavra[i]);
    }

    for (int i = 0; i < arrChar.length; i++) {
      arrInt.add(decodeCaracter(arrChar[i]));
    }

    for (int i = 0; i < arrInt.length; i++) {
      arrInt[i] = arrInt[i] + key;

      if (arrInt[i] < 0) {
        arrInt[i] = arrInt[i] + 26;
      } else if (arrInt[i] == 26) {
        arrInt[i] = 0;
      } else if (arrInt[i] > 26) {
        arrInt[i] = arrInt[i] % 26;
      }

      arrInt2.add(arrInt[i]);
    }

    for (int i = 0; i < arrInt2.length; i++) {
      output += encodeCaracter(arrInt2[i]);
    }

    return output;
  }

  static String decodeWord(String palavra, int key) {
    List<String> arrChar = [];
    List<int> arrInt2 = [];
    List<int> arr = [];
    String output = '';

    for (int i = 0; i < palavra.length; i++) {
      arrChar.add(palavra[i]);
    }

    for (int i = 0; i < arrChar.length; i++) {
      arr.add(decodeCaracter(arrChar[i]));
    }

    for (int i = 0; i < arr.length; i++) {
      arr[i] = arr[i] - key;

      if (arr[i] < 0) {
        arr[i] = arr[i] + 26;
      } else if (arr[i] == 26) {
        arr[i] = 0;
      }

      arrInt2.add(arr[i]);
    }

    for (int i = 0; i < arrInt2.length; i++) {
      output += encodeCaracter(arrInt2[i]);
    }

    return output;
  }

  static String cesar(String palavra1, String palavra2) {
    List<int> arrayNumber1 = [];
    List<int> arrayNumber2 = [];
    List<int> arrayNumberSum = [];

    palavra1 = palavra1.toUpperCase();
    palavra2 = palavra2.toUpperCase();

    String output = '';

    for (int i = 0; i < palavra1.length; i++) {
      arrayNumber1.add(decodeCaracter(palavra1[i]));
    }

    for (int i = 0; i < palavra2.length; i++) {
      arrayNumber2.add(decodeCaracter(palavra2[i]));
    }

    for (int i = 0; i < arrayNumber1.length; i++) {
      arrayNumberSum.add(arrayNumber1[i] + arrayNumber2[i]);
    }

    for (int k = 0; k < arrayNumberSum.length; k++) {
      output += encodeCaracter(arrayNumberSum[k]);
    }

    output += "\n";

    return output;
  }

  static String generateUniqueChatHash(String palavra1, String palavra2) {
    return cesar(palavra1.toUpperCase(), palavra2.toUpperCase());
  }
}
