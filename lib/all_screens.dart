import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/all_core.dart';


class DocumentationScreen extends StatelessWidget {
  const DocumentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Helper function to create a page view for the tabs
    Widget buildPage(List<Widget> children) {
      return ListView(
        padding: const EdgeInsets.all(16.0),
        children: children,
      );
    }

    return AppTab(
      title: 'AppTheme Library Docs',
      style: AppTabStyle.fixedHeader,
      tabs: [
        Tab(text: 'docs_readme'.tr),
        Tab(text: 'docs_example'.tr),
        Tab(text: 'docs_installing'.tr),
      ],
      children: [
        buildPage([
          const DocHeader(title: 'AppTheme & Language Guide'),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              Chip(label: const Text('Version 2.0.0'), backgroundColor: Colors.blue.shade100),
              Chip(label: const Text('Integrated'), backgroundColor: Colors.green.shade100),
              Chip(label: const Text('GetX & Supabase'), backgroundColor: Colors.purple.shade100),
            ],
          ),
          const SizedBox(height: 16),
          const DocParagraph(
            text: 'Welcome to the integrated Theme and Language library guide...',
          ),
          DocSection(title: 'configuration_properties'.tr),
          const PropertiesTable(
            properties: [
              { 'property': 'initialSetting', 'type': 'AppThemeSetting', 'description': 'The complete theme configuration object.'},
              { 'property': 'initialThemeMode', 'type': 'ThemeMode', 'description': 'Sets the starting theme mode (light, dark, or system).'},
            ],
          ),
        ]),
        buildPage([
          const DocHeader(title: 'Usage Examples'),
          const DocSection(title: 'Method 1: Default Theme'),
          const CodeBlock(code: "Get.put(AppTheme());"),
          const DocSection(title: 'Method 2: Select a Pre-built Theme'),
          const CodeBlock(code: "Get.put(AppTheme(initialSetting: AppThemes.vibrant()));"),
        ]),
        buildPage([
          const DocHeader(title: 'Installing'),
          const DocParagraph(text: 'Add dependencies to your `pubspec.yaml` file:'),
          const CodeBlock(code: """
dependencies:
  get: ^4.6.6
  google_fonts: ^6.2.1
  supabase_flutter: ^2.5.0
"""),
        ]),
      ],
    );
  }
}

class TranslationLookupScreen extends StatefulWidget {
  const TranslationLookupScreen({Key? key}) : super(key: key);

  @override
  State<TranslationLookupScreen> createState() => _TranslationLookupScreenState();
}

class _TranslationLookupScreenState extends State<TranslationLookupScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _results = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterTranslations);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTranslations);
    _searchController.dispose();
    super.dispose();
  }

  void _filterTranslations() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    final allTranslations = AppTranslator.instance.translations;
    final Set<String> foundKeys = {};

    allTranslations.forEach((langCode, translationsMap) {
      translationsMap.forEach((key, value) {
        if (key.toLowerCase().contains(query) || value.toLowerCase().contains(query)) {
          foundKeys.add(key);
        }
      });
    });

    final List<Map<String, String>> searchResults = [];
    for (var key in foundKeys) {
      final resultItem = <String, String>{'key': key};
      allTranslations.forEach((langCode, translationsMap) {
        resultItem[langCode] = translationsMap[key] ?? 'N/A';
      });
      searchResults.add(resultItem);
    }

    setState(() => _results = searchResults);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Translation Key Lookup"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search across all languages...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _results.isEmpty
                ? Center(
              child: Text(_searchController.text.isEmpty
                  ? "Start typing to search..."
                  : "No results found."),
            )
                : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final item = _results[index];
                final key = item['key']!;
                final languages = Map<String, String>.from(item)..remove('key');

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Key: $key", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.primary)),
                        const Divider(),
                        ...languages.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text("${entry.key}: ${entry.value}"),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}