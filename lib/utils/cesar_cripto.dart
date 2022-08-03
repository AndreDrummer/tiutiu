class GenerateHashKey {
  static String encodeCaracter(int element) {
    switch (element) {
      case 0:
        return 'A';
        break;
      case 1:
        return 'B';
        break;
      case 2:
        return 'C';
        break;
      case 3:
        return 'D';
        break;
      case 4:
        return 'E';
        break;
      case 5:
        return 'F';
        break;
      case 6:
        return 'G';
        break;
      case 7:
        return 'H';
        break;
      case 8:
        return 'I';
        break;
      case 9:
        return 'J';
        break;
      case 10:
        return 'K';
        break;
      case 11:
        return 'L';
        break;
      case 12:
        return 'M';
        break;
      case 13:
        return 'N';
        break;
      case 14:
        return 'O';
        break;
      case 15:
        return 'P';
        break;
      case 16:
        return 'Q';
        break;
      case 17:
        return 'R';
        break;
      case 18:
        return 'S';
        break;
      case 19:
        return 'T';
        break;
      case 20:
        return 'U';
        break;
      case 21:
        return 'V';
        break;
      case 22:
        return 'W';
        break;
      case 23:
        return 'X';
        break;
      case 24:
        return 'Y';
        break;
      case 25:
        return 'Z';
        break;
      default:
        return '';
    }
  }

  static int decodeCaracter(String element) {
    switch (element) {
      case 'A':
        return 0;
        break;
      case 'B':
        return 1;
        break;
      case 'C':
        return 2;
        break;
      case 'D':
        return 3;
        break;
      case 'E':
        return 4;
        break;
      case 'F':
        return 5;
        break;
      case 'G':
        return 6;
        break;
      case 'H':
        return 7;
        break;
      case 'I':
        return 8;
        break;
      case 'J':
        return 9;
        break;
      case 'K':
        return 10;
        break;
      case 'L':
        return 11;
        break;
      case 'M':
        return 12;
        break;
      case 'N':
        return 13;
        break;
      case 'O':
        return 14;
        break;
      case 'P':
        return 15;
        break;
      case 'Q':
        return 16;
        break;
      case 'R':
        return 17;
        break;
      case 'S':
        return 18;
        break;
      case 'T':
        return 19;
        break;
      case 'U':
        return 20;
        break;
      case 'V':
        return 21;
        break;
      case 'W':
        return 22;
        break;
      case 'X':
        return 23;
        break;
      case 'Y':
        return 24;
        break;
      case 'Z':
        return 25;
        break;
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

  static String generateHash(String palavra1, String palavra2) {
    return cesar(palavra1.toUpperCase(), palavra2.toUpperCase());
  }
}
