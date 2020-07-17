import 'dart:io';
import 'dart:math';

Map<String, List<String>> matched = Map();
Map<String, String> newMatches = Map();

main() {
  File namesData= new File("data/names.csv");
  namesData.readAsLines().then(addNames);

  File jul10Data = new File("data/jul-10.csv");
  jul10Data.readAsLines().then(addMatches).whenComplete(() {
    print(matched.keys.length.toString() + " people have been matched.\n");
    makeNewMatches();
    printNewMatches();
  });
}

// Initialize lists with new names.
void addNames(List<String> lines) {
  for (var line in lines) {
    List<String> names = line.split(",");
    for (String name in names) {
      if (name != "" && name != null) {
        matched.putIfAbsent(name, () => List());
      }
    }
  }
}

// Add history of pairings.
void addMatches(List<String> lines) {
  for (var line in lines) {
    List<String> names = line.split(",");
    for (int i = 0; i < names.length; i += 2) {
      if (names[i] != "" && names[i] != null) {
        matched[names[i]].add(names[i+1]);
        // print(names[i] + " matched with " + matched[names[i]].last);
      }
    }
  }
}

// Based on history, make new matches.
void makeNewMatches() {
  List<String> notMatched = List();
  matched.keys.forEach((name) => notMatched.add(name));

  // Iterate through every person
  while(notMatched.isNotEmpty && notMatched.length >= 2) {
    String person = notMatched.removeLast();

    // Random their matches with the length of the array.
    int matchIndex =  notMatched.length > 1 ? Random().nextInt(notMatched.length) : 0;

    // Check for already-matched.
    if (matched[person].contains(notMatched[matchIndex])) {
      // Check if we still have other unmatched pairings, if we do, we just keep
      // going. We will retry another pair and fix when people cannot be
      // matched from unmatched.
      if (notMatched.isEmpty) {
        int newIndex =  Random().nextInt(newMatches.length);
        String newPerson = newMatches.keys.elementAt(newIndex);
        while (matched[person].contains(newPerson)) {
          newIndex =  Random().nextInt(newMatches.length);
          newPerson = newMatches.keys.elementAt(newIndex);
        }

        // Remove that person's match, add them to unmatched and continue.
        newMatches[person] = newPerson;
        notMatched.add(newMatches[newPerson]);
        newMatches.remove(newPerson);
      } else {
        // Add them back in.
        notMatched.add(person);
      }
    } else {
      // Remove the matched person and add to matches.
      newMatches[person]= notMatched[matchIndex];
      notMatched.removeAt(matchIndex);
    }
  }

  // If there is an odd number of people.
  if (notMatched.isNotEmpty) {
    notMatched.forEach((person) => print(person + " is single and ready to mingle."));
  }
}

// Shuffle the list and print it out.
void printNewMatches() {
  List<String> newMatchesList = List();
  newMatches.forEach((key, value) {
    newMatchesList.add(key + " " + value);
  });
  newMatchesList.shuffle();
  newMatchesList.forEach((match) => print(match));
}