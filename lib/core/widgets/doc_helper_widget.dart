import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


// ===================================================================
// القسم 12: الويدجتات المساعدة (Helper Widgets)
// ===================================================================

class DocHeader extends StatelessWidget {
  final String title;
  const DocHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class DocSection extends StatelessWidget {
  final String title;
  const DocSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class DocParagraph extends StatelessWidget {
  final String text;
  const DocParagraph({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
      ),
    );
  }
}

class CodeBlock extends StatelessWidget {
  final String code;
  const CodeBlock({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2B2B2B) : Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dart',
                  style: GoogleFonts.sourceCodePro(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_all_outlined, size: 20),
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                  tooltip: 'Copy Code',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code.trim()));
                    Get.snackbar(
                      'copied_to_clipboard'.tr, '',
                      titleText: Text('copied_to_clipboard'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      messageText: const SizedBox.shrink(),
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green.withOpacity(0.9),
                      margin: const EdgeInsets.all(12),
                      borderRadius: 8,
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                code.trim(),
                style: GoogleFonts.sourceCodePro(
                  color: isDark ? Colors.lightBlue[200] : Colors.deepPurple,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PropertiesTable extends StatelessWidget {
  final List<Map<String, String>> properties;
  const PropertiesTable({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    final cellStyle = Theme.of(context).textTheme.bodyMedium!;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade400;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(flex: 1.5),
          1: IntrinsicColumnWidth(flex: 1),
          2: FlexColumnWidth(2.5),
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: borderColor, width: 1),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))
            ),
            children: [
              Padding(padding: const EdgeInsets.all(12.0), child: Text('Property', style: headerStyle)),
              Padding(padding: const EdgeInsets.all(12.0), child: Text('Type', style: headerStyle)),
              Padding(padding: const EdgeInsets.all(12.0), child: Text('Description', style: headerStyle)),
            ],
          ),
          ...properties.map((prop) {
            return TableRow(
                children: [
                  Padding(padding: const EdgeInsets.all(12.0), child: Text(prop['property']!, style: GoogleFonts.sourceCodePro())),
                  Padding(padding: const EdgeInsets.all(12.0), child: Text(prop['type']!, style: cellStyle.copyWith(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w500))),
                  Padding(padding: const EdgeInsets.all(12.0), child: Text(prop['description']!, style: cellStyle)),
                ]
            );
          }).toList(),
        ],
      ),
    );
  }
}

class AppColorSwatch extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const AppColorSwatch({super.key, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400, width: 2),
        ),
      ),
    );
  }
}
