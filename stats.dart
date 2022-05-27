// Author: Birju Vachhani
// Created Date: April 05, 2021

import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/analysis/analysis_context_collection.dart';
import 'package:intl/intl.dart';

class Stats {
  List<String> functions = [];
  List<String> classes = [];
  List<String> variables = [];
  int extensions = 0;
  int typedefs = 0;
  int mixins = 0;

  Stats({
    required this.functions,
    required this.classes,
    required this.variables,
    required this.extensions,
    required this.typedefs,
    required this.mixins,
  });

  Stats operator +(Stats other) => Stats(
        functions: functions + other.functions,
        classes: classes + other.classes,
        variables: variables + other.variables,
        extensions: extensions + other.extensions,
        typedefs: typedefs + other.typedefs,
        mixins: mixins + other.mixins,
      );
}

void main() async {
  final screwdriverStats =
      await getStats('package:screwdriver/screwdriver.dart');
  final screwdriverIoStats =
      await getStats('package:screwdriver/screwdriver_io.dart');

  final stats = screwdriverStats + screwdriverIoStats;

  var output = '''

```yaml  
Extensions:                    ${stats.extensions}
Helper Classes:                ${stats.classes.length}
Helper Functions & Getters:    ${stats.functions.length + stats.variables.length}
```

> *Last Updated: ${DateFormat('EEE, MMM dd, yyyy - hh:mm a').format(DateTime.now())}*

''';

  final readMeFile = File('README.md');
  var content = readMeFile.readAsStringSync();
  final prefix = '<!---stats_start-->';
  final suffix = '<!---stats_end-->';

  final start = content.indexOf(prefix) + prefix.length;
  final end = content.indexOf(suffix);
  content = content.replaceRange(start, end, output);
  readMeFile.writeAsStringSync(content);

  print('\n\n');
  print('==================================================================');
  print('STATS');
  print('==================================================================');
  print('Helper Functions & Getters:    '
      '${stats.functions.length + stats.variables.length}');
  print('Helper Classes:                ${stats.classes.length}');
  print('Extensions:                    ${stats.extensions}');
  print('Typedefs:                      ${stats.typedefs}');
  print('Mixins:                        ${stats.mixins}');
  print('==================================================================');
}

Future<Stats> getStats(String library) async {
  final collection = AnalysisContextCollectionImpl(
      includedPaths: <String>[Directory('lib').absolute.path],
      resourceProvider: PhysicalResourceProvider.INSTANCE);
  final session = collection.contexts[0].currentSession;
  final libPath = session.uriConverter.uriToPath(Uri.parse(library)) ?? '';
  // ignore: deprecated_member_use
  final result =
      await session.getResolvedLibrary(libPath) as ResolvedLibraryResult;
  var helpersFunctions = <String>[];
  var helpersClasses = <String>[];
  var helperVariables = <String>[];
  var extensions = 0;
  var typedefs = 0;
  var mixins = 0;
  for (final part in result.element.parts) {
    helpersFunctions += part.functions.map((e) => e.displayName).toList();
    extensions += part.extensions.expand((element) => element.fields).length;
    extensions += part.extensions.expand((element) => element.methods).length;
    helpersClasses += part.classes.map((e) => e.displayName).toList();
    helperVariables += part.accessors.map((e) => e.displayName).toList();
    typedefs += part.typeAliases.length;
    mixins += part.mixins.length;
  }

  final stats = Stats(
    variables: helperVariables,
    classes: helpersClasses,
    functions: helpersFunctions,
    extensions: extensions,
    typedefs: typedefs,
    mixins: mixins,
  );

  collectExports(result.element, stats, checkForSrcDir: true);
  return stats;
}

void collectExports(LibraryElement element, Stats stats,
    {bool checkForSrcDir = false}) {
  for (final exp in element.exports) {
    if (!checkForSrcDir || exp.uri?.startsWith('src') == true) {
      for (final unit in exp.exportedLibrary!.units) {
        stats.classes.addAll(unit.classes.map((e) => e.displayName));
        stats.functions.addAll(unit.functions.map((e) => e.displayName));
        stats.variables.addAll(unit.accessors.map((e) => e.displayName));
        stats.extensions +=
            unit.extensions.expand((element) => element.methods).length;
        stats.extensions +=
            unit.extensions.expand((element) => element.fields).length;
        stats.typedefs += unit.typeAliases.length;
        stats.mixins += unit.mixins.length;

        if (unit.enclosingElement.exports.isNotEmpty) {
          collectExports(unit.enclosingElement, stats);
        }
      }
    }
  }
}
