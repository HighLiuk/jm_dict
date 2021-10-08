# jm_dict

[![Pub](https://img.shields.io/pub/v/jm_dict.svg)](https://pub.dartlang.org/packages/jm_dict)

Implementation of the Open Source [JMdict Japanese Dictionary Project](http://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project) as a Flutter plugin.

## Getting Started

This plugin enables your app to load and use the Japanese Dictionary provided by JMdict/EDICT Project.<br>Supports looking up entries by kana, romaji, kanji and the meaning/glossary content.<br/>Currently doesn't support entry editing.

This plugin stores the dictionary locally and uses [ObjectBox](https://pub.dev/packages/objectbox) as it's local database architecture.<br/>There are **three ways** to initiate the plugin and it requires the file [JMdict.gz](http://ftp.edrdg.org/pub/Nihongo/JMdict.gz),<br/>which contains the **JMdict XML** file.

### Provide from Asset
Place the **JMdict.gz** file within your project, typically on the same level as the lib folder/inside a folder<br/>on the same level as the lib folder, then include it on the project's **_pubspec.yaml_**.

```yaml
# For example, the file is placed inside assets folder,
# which is located on the same level with the lib folder
assets:
    - assets/JMdict.gz
```

Then call the **_initFromAsset_** method
```dart
import 'package:jm_dict/jm_dict.dart';

JMDict().initFromAsset(assetPath: "assets/JMdict.gz",);
```
Why init from the gz file? The real XML file has the size of ±100MBs, which is too large to be<br/> included locally as an asset

### Provide from File
Let's say you obtained the content of JMdict.gz, which is the JMdict XML file somewhere, you can<br/>call the **_initFromFile_** method.
```dart
import 'package:jm_dict/jm_dict.dart';
import 'package:path_provider/path_provider.dart' as PathProvider;

final tempDir = await PathProvider.getTemporaryDirectory();
final File jmDictXmlFile = File("${tempDir.uri.getFilePath()}JMdict",);

JMDict().initFromFile(xmlFile: jmDictXmlFile,);
```

### Provide Online
You can provide the JMdict.gz file by downloading it. This plugin can download it from a default URL, or<br/>you can provide an alternative download URL.
```dart
import 'package:jm_dict/jm_dict.dart';

JMDict().initFromNetwork();

/// with alternative download URL
JMDict().initFromNetwork(
  archiveUri: Uri.parse(
    "https://mystorage.somewhere.com/download/JMdict.gz",
  ),
);
```
**Note**: this will take a while, since it will download a file with a size of ±20 MBs, on a slower connection, might<br/> take minutes.

## Searching Entries
### Basic Search Usage
Look for results by providing a single keyword.
```dart
import 'package:jm_dict/jm_dict.dart';

final dict = JMDict();

/// Returns result that has romaji readings of "kensaku", or if the glossary/meaning
/// contains the word "kensaku"
dict.search(
  keyword: "kensaku",
)

/// Should return the same result as the above one, but might return less results since
/// glossaries usually don't contain kana
dict.search(
  keyword: "けんさく",
);

/// This will return more specific results, looking for entries that contain this
/// kanji keyword
dict.search(
  keyword: "検索",
);
```

### Limiting Results/Pagination
You can provide additional argument to limit the search result count, and how many results to skip.
```dart
import 'package:jm_dict/jm_dict.dart';

final dict = JMDict();

/// Limit search results to 10
dict.search(
  keyword: "sakai", limit: 10,
);

/// Skip first 10 results
dict.search(
  keyword: "sakai", offset: 10,
);

/// Limit search results to 10, skips the first 20 results
dict.search(
  keyword: "saka", limit: 10, offset: 20,
);
```

## Limitations
There are some use cases to consider when searching:
- Searching using mixed keywords won't work, e.g "hige男", "kamisatoけ". This will be considered in future<br/>versions
- Each entry in the dictionary has more accessible traits, which is available on search results, e.g: dialects,<br/> word category, etc. For this release, the query process will only look for keywords in kana, romaji, and<br/> kanji texts only and further filters can be created manually, e.g using **_List.where_**. This will be considered<br/> in future releases as well.
- Sorting isn't available for now. You can use **_List.sort_** for now and specify your own sorting preferences.
- There's a consideration of writing certain entries into the local database, to reduce the DB size. For now<br/> this plugin writes the whole file.