import 'dart:convert';
import 'dart:io';

void main() async {
  File jsonFile = File('lib/test.json');
  var numbs = await jsonFile.readAsString();
  print(jsonDecode(numbs));
}
