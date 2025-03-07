// Author: Birju Vachhani
// Created Date: April 05, 2021

import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:analyzer/src/dart/analysis/analysis_context_collection.dart';
import 'package:args/args.dart';
import 'package:intl/intl.dart';
import 'package:screwdriver/screwdriver.dart';

class Stats {
  List<FunctionElement> functions = [];
  List<ClassElement> classes = [];
  List<PropertyAccessorElement> variables = [];
  List<ExtensionElement> extensions = [];
  List<ExtensionTypeElement> extensionTypes = [];
  List<TypeDefiningElement> typedefs = [];
  List<MixinElement> mixins = [];

  Stats({
    required this.functions,
    required this.classes,
    required this.variables,
    required this.extensions,
    required this.extensionTypes,
    required this.typedefs,
    required this.mixins,
  });

  Stats operator +(Stats other) => Stats(
        functions: functions + other.functions,
        classes: classes + other.classes,
        variables: variables + other.variables,
        extensions: extensions + other.extensions,
        extensionTypes: extensionTypes + other.extensionTypes,
        typedefs: typedefs + other.typedefs,
        mixins: mixins + other.mixins,
      );
}

/// Script to generate stats for this package.
/// Usage: dart scripts/extensions_docs_generator.dart [--dry]
/// --dry: if provided, it will not update EXTENSIONS.md file. It will only print
/// the stats to console.
void main(List<String> args) async {
  final screwdriverStats =
      await getStats('package:screwdriver/screwdriver.dart');
  final screwdriverIoStats =
      await getStats('package:screwdriver/screwdriver_io.dart');

  final parser = ArgParser()
    ..addFlag('dry', abbr: 'd', defaultsTo: false)
    ..addOption('output', abbr: 'o', defaultsTo: '../EXTENSIONS.md')
    ..parse(args);

  final argsResult = parser.parse(args);

  final isDry = argsResult.wasParsed('dry');

  final stats = screwdriverStats + screwdriverIoStats;

  final IOSink sink;
  if (!isDry) {
    final String path = argsResult.wasParsed('output')
        ? argsResult['output'].toString()
        : '../EXTENSIONS.md';

    print('Updating $path...');
    final outputFile = File(path);
    if (!outputFile.existsSync()) outputFile.createSync();

    var content = outputFile.readAsStringSync();
    outputFile.writeAsStringSync(content);
    sink = outputFile.openWrite();
  } else {
    print('Dry run, not updating EXTENSIONS.md...');
    sink = stdout;
  }

  sink.writeln('# Docs');
  sink.writeln(
      '> *This file is auto generated. Do not edit this file manually.*');
  sink.writeln(
      '> *Last Updated: ${DateFormat('EEE, MMM dd, yyyy - hh:mm a').format(DateTime.now())}*');
  sink.writeln('\n');
  generateTableOfContents(sink, stats);
  sink.writeln('\n');

  outputExtensions(sink, stats, isDry: isDry);
  outputFunctions(sink, stats, isDry: isDry);
  outputClasses(sink, stats, isDry: isDry);
  outputExtensionTypes(sink, stats, isDry: isDry);

  if (!isDry) sink.close();
}

void outputExtensions(IOSink sink, Stats stats, {required bool isDry}) {
  sink.writeln('## Extensions');
  sink.writeln('\n');

  for (final extension in stats.extensions) {
    String path = extension.source.toString();
    final String githubFilePath = path.replaceAll(RegExp(r'.*lib'),
        'https://github.com/BirjuVachhani/screwdriver/blob/main/lib');
    final String name = getDartTypeBaseName(extension.extendedType);
    sink.writeln('### on `${name.replaceAll('\\', '')}`');

    // table header
    sink.writeln('| Extension | Type | Description |');
    sink.writeln('|---|---|---|');

    for (final accessor in extension.accessors) {
      if (accessor.isPrivate) continue;
      final description =
          sanitizeDocComment(accessor.documentationComment ?? 'Not provided');
      final String type = accessor.isGetter
          ? 'getter'
          : accessor.isSetter
              ? 'setter'
              : accessor.isOperator
                  ? 'operator'
                  : 'operator';

      final lineNumber = LineInfo.fromContent(accessor.source.contents.data)
          .getLocation(accessor.nameOffset)
          .lineNumber;

      sink.writeln(
          '| [`${accessor.displayName}`]($githubFilePath#L$lineNumber) | `${type.toUpperCase()}` | $description |');
    }

    for (final MethodElement method in extension.methods) {
      if (method.isPrivate) continue;
      // Get the line number of the method
      final lineNumber = LineInfo.fromContent(method.source.contents.data)
          .getLocation(method.nameOffset)
          .lineNumber;

      final description =
          sanitizeDocComment(method.documentationComment ?? 'Not provided');
      sink.writeln(
          '| [`${method.displayName}`]($githubFilePath#L$lineNumber) | `METHOD` | $description |');
    }

    sink.writeln('\n');
  }
}

void outputFunctions(IOSink sink, Stats stats, {required bool isDry}) {
  sink.writeln('## Functions');

  // table header
  sink.writeln('| Name | Description |');
  sink.writeln('|---|---|');

  for (final function in stats.functions) {
    String path = function.source.toString();
    final String githubFilePath = path.replaceAll(RegExp(r'.*lib'),
        'https://github.com/BirjuVachhani/screwdriver/blob/main/lib');

    // Get the line number of the method
    final lineNumber = LineInfo.fromContent(function.source.contents.data)
        .getLocation(function.nameOffset)
        .lineNumber;

    final description =
        sanitizeDocComment(function.documentationComment ?? 'Not provided');
    sink.writeln(
        '| [`${function.displayName}`]($githubFilePath#L$lineNumber) | $description |');
  }
  sink.writeln('\n');
}

void outputClasses(IOSink sink, Stats stats, {required bool isDry}) {
  sink.writeln('## Helper Classes');

  // table header
  sink.writeln('| Name | Description |');
  sink.writeln('|---|---|');

  for (final helperClass in stats.classes) {
    String path = helperClass.source.toString();
    final String githubFilePath = path.replaceAll(RegExp(r'.*lib'),
        'https://github.com/BirjuVachhani/screwdriver/blob/main/lib');

    // Get the line number of the method
    final lineNumber = LineInfo.fromContent(helperClass.source.contents.data)
        .getLocation(helperClass.nameOffset)
        .lineNumber;

    final description =
        sanitizeDocComment(helperClass.documentationComment ?? 'Not provided');
    sink.writeln(
        '| [`${helperClass.displayName}`]($githubFilePath#L$lineNumber) | $description |');
  }
  sink.writeln('\n');
}

void outputExtensionTypes(IOSink sink, Stats stats, {required bool isDry}) {
  sink.writeln('## Extensions Types');
  sink.writeln('\n');

  // table header
  // sink.writeln('| Extension Type | on | Description |');
  // sink.writeln('|---|---|---|');
  //
  // for (final extensionType in stats.extensionTypes) {
  //   String path = extensionType.source.toString();
  //   final String githubFilePath = path.replaceAll(RegExp(r'.*lib'),
  //       'https://github.com/BirjuVachhani/screwdriver/blob/main/lib');
  //
  //   // Get the line number of the method
  //   final lineNumber = LineInfo.fromContent(extensionType.source.contents.data)
  //       .getLocation(extensionType.nameOffset)
  //       .lineNumber;
  //
  //   final description = sanitizeDocComment(
  //       extensionType.documentationComment ?? 'Not provided');
  //
  //   sink.writeln(
  //       '| [`${extensionType.displayName}`]($githubFilePath#L$lineNumber) | `${extensionType.representation.type.element?.name ?? 'N/A'}` | $description |');
  // }

  for (final extensionType in stats.extensionTypes) {
    String path = extensionType.source.toString();
    final String githubFilePath = path.replaceAll(RegExp(r'.*lib'),
        'https://github.com/BirjuVachhani/screwdriver/blob/main/lib');
    sink.writeln('### ${extensionType.displayName}');

    // table header
    sink.writeln('| Field/Method | Type | Description |');
    sink.writeln('|---|---|---|');

    for (final accessor in extensionType.accessors) {
      if (accessor.isPrivate) continue;
      final description =
          sanitizeDocComment(accessor.documentationComment ?? 'Not provided');
      final String type = accessor.isGetter
          ? 'getter'
          : accessor.isSetter
              ? 'setter'
              : accessor.isOperator
                  ? 'operator'
                  : 'operator';

      final lineNumber = LineInfo.fromContent(accessor.source.contents.data)
          .getLocation(accessor.nameOffset)
          .lineNumber;

      sink.writeln(
          '| [`${accessor.displayName}`]($githubFilePath#L$lineNumber) | `${type.toUpperCase()}` | $description |');
    }

    for (final MethodElement method in extensionType.methods) {
      if (method.isPrivate) continue;
      // Get the line number of the method
      final lineNumber = LineInfo.fromContent(method.source.contents.data)
          .getLocation(method.nameOffset)
          .lineNumber;

      final description =
          sanitizeDocComment(method.documentationComment ?? 'Not provided');
      sink.writeln(
          '| [`${method.displayName}`]($githubFilePath#L$lineNumber) | `METHOD` | $description |');
    }

    sink.writeln('\n');
  }
  sink.writeln('\n');
}

void generateTableOfContents(IOSink sink, Stats stats) {
  sink.writeln('## Table of Contents');

  sink.writeln(
      '| Extension on (${stats.extensions.length}) | Functions (${stats.functions.length}) | Helper Classes (${stats.classes.length}) | Extension Type (${stats.extensionTypes.length}) |');
  sink.writeln('|---|---|---|---|');

  final maxLength = [
    stats.extensions.length,
    stats.functions.length,
    stats.classes.length,
    stats.extensionTypes.length,
  ].max.toInt();

  for (int index = 0; index <= maxLength; index++) {
    sink.write('|');
    if (index < stats.extensions.length) {
      final String name =
          getDartTypeBaseName(stats.extensions[index].extendedType);
      sink.write(' [$name](#on-${formatMarkdownLink(name)})');
    } else {
      sink.write(' ');
    }
    sink.write(' |');
    if (index < stats.functions.length) {
      sink.write(' [${stats.functions[index].displayName}](#functions)');
    } else {
      sink.write(' ');
    }
    sink.write(' |');
    if (index < stats.classes.length) {
      sink.write(' [${stats.classes[index].displayName}](#helper-classes)');
    } else {
      sink.write(' ');
    }
    sink.write(' |');
    if (index < stats.extensionTypes.length) {
      final extensionType = stats.extensionTypes[index];
      sink.write(
          ' [${extensionType.displayName}](#${formatMarkdownLink(extensionType.displayName)})');
    } else {
      sink.write(' ');
    }
    sink.writeln(' |');
  }

  // Extensions
  // sink.writeln('- [Extensions](#extensions)');
  // for (final extension in stats.extensions) {
  //   final DartType type = extension.extendedType;
  //   if (type is TypeParameterType) {
  //     sink.writeln('  - [${type.bound}](#on-${type.bound})');
  //   } else {
  //     sink.writeln(
  //         '  - [${extension.extendedType}](#on-${extension.extendedType})');
  //   }
  // }
  //
  // // Functions
  // sink.writeln('- [Functions](#functions)');
  // for (final function in stats.functions) {
  //   sink.writeln('  - [${function.displayName}](#functions)');
  // }
  //
  // // Extension Types
  // sink.writeln('- [Extension Types](#extension-types)');
  // for (final extensionType in stats.extensionTypes) {
  //   sink.writeln('  - [${extensionType.displayName}](#extension-types)');
  // }
}

String getDartTypeBaseName(DartType type) {
  if (type is TypeParameterType) type = type.bound;
  // return '${type.element!.displayName}${type.nullabilitySuffix == NullabilitySuffix.question ? '?' : ''}';
  return '$type'.replaceAll('<', r'\<').replaceAll('>', r'\>');
}

String formatMarkdownTitle(String title) {
  if (title.endsWith('?')) {
    title = '${title.substring(0, title.length - 1)} (Nullable)';
  }
  return title;
}

String formatMarkdownLink(String title) {
  return title
      .toLowerCase()
      .replaceAll('\\', '')
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('?', '')
      .replaceAll(RegExp(r"""[~`!@#\$%^&*()_+<>:"{},.;'[]/?]"""), '')
      .replaceAll(' ', '-');
}

String sanitizeDocComment(String comment) {
  String sanitized = comment;
  sanitized = sanitized
      .trim()
      .replaceAll('///', '')
      .split('\n')
      .takeWhile((line) => line.trim().isNotEmpty)
      .join(' ');
  // remove [] from description
  sanitized = sanitized.splitMapJoin(
    RegExp(r'\[(\S+)\]'),
    onMatch: (match) {
      final block = match.group(1);
      if (block == null) return match[0]!;
      return '`$block`';
    },
  ).capitalized;
  if (sanitized.indexOf('```') case int index) {
    if (index != -1) {
      sanitized = sanitized.substring(0, index);
    }
  }
  if (sanitized.indexOf('Example') case int index) {
    if (index != -1) {
      sanitized = sanitized.substring(0, index);
    }
  }
  return sanitized;
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
  var helpersFunctions = <FunctionElement>[];
  var helpersClasses = <ClassElement>[];
  var helperVariables = <PropertyAccessorElement>[];
  var extensions = <ExtensionElement>[];
  var extensionTypes = <ExtensionTypeElement>[];
  var typedefs = <TypeDefiningElement>[];
  var mixins = <MixinElement>[];

  for (final part in result.element.units) {
    helpersFunctions += part.functions.wherePublic().toList();
    extensions += part.extensions.wherePublic().toList();
    extensionTypes += part.extensionTypes.wherePublic().toList();
    helpersClasses += part.classes.wherePublic().toList();
    helperVariables += part.accessors.wherePublic().toList();
    typedefs += part.typeAliases.wherePublic().toList();
    mixins += part.mixins.wherePublic().toList();
  }

  final stats = Stats(
    variables: helperVariables,
    classes: helpersClasses,
    functions: helpersFunctions,
    extensions: extensions,
    extensionTypes: extensionTypes,
    typedefs: typedefs,
    mixins: mixins,
  );

  collectExports(result.element.definingCompilationUnit, stats,
      checkForSrcDir: true);
  return stats;
}

void collectExports(CompilationUnitElement element, Stats stats,
    {bool checkForSrcDir = false}) {
  for (final exp in element.libraryExports) {
    final uri = exp.uri;
    if (uri is! DirectiveUriWithLibrary) continue;
    if (!checkForSrcDir || uri.relativeUriString.startsWith('src') == true) {
      for (final unit in exp.exportedLibrary!.units) {
        stats.classes.addAll(unit.classes.wherePublic());
        stats.functions.addAll(unit.functions.wherePublic());
        stats.variables.addAll(unit.accessors.wherePublic());
        stats.extensions += unit.extensions.wherePublic().toList();
        stats.extensionTypes += unit.extensionTypes.wherePublic().toList();
        stats.typedefs += unit.typeAliases.wherePublic().toList();
        stats.mixins += unit.mixins.wherePublic().toList();

        if (unit.libraryExports.isNotEmpty) {
          collectExports(unit, stats);
        }
      }
    }
  }
}

extension ElementListExt<T extends Element> on List<T> {
  Iterable<T> wherePublic() => where((element) => element.isPublic);
}
