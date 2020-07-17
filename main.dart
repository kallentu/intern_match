import 'dart:io';

main() {
//  File data= new File("data/jul-10.csv");
  File data= new File("data/names.csv");
  data.readAsLines().then(processLines);
}

processLines(List<String> lines) {
  // process lines:
  for (var line in lines) {
    List<String> names = line.split(",");
    for (String name in names) {
      if (name != "" && name != null) print(name);
    }
  }
}