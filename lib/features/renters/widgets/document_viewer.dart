import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];

class DocumentViewerPage extends StatefulWidget {
  final String url;
  final String title;

  const DocumentViewerPage({super.key, required this.url, required this.title});

  @override
  State<DocumentViewerPage> createState() => _DocumentViewerPageState();
}

class _DocumentViewerPageState extends State<DocumentViewerPage> {
  bool _isImage = false;
  String? _pdfPath;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final url = widget.url;
    final ext = url.split('.').last.toLowerCase().split('?').first;

    if (imageExtensions.contains(ext)) {
      setState(() {
        _isImage = true;
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        setState(() {
          _error = 'Failed to download file (HTTP ${response.statusCode})';
          _isLoading = false;
        });
        return;
      }

      final file = File('${Directory.systemTemp.path}/${widget.title}.pdf');
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        _pdfPath = file.path;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load document: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: 'Open externally',
            onPressed: _openExternally,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _openExternally,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open externally'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isImage) {
      return InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: Image.network(
            widget.url,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              final total = loadingProgress.expectedTotalBytes;
              final progress = total != null
                  ? loadingProgress.cumulativeBytesLoaded / total
                  : null;
              return Center(
                child: CircularProgressIndicator(value: progress),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Failed to load image'),
                ],
              );
            },
          ),
        ),
      );
    }

    if (_pdfPath != null) {
      return PDFView(
        filePath: _pdfPath!,
        autoSpacing: true,
        enableSwipe: true,
        pageSnap: true,
        swipeHorizontal: true,
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _openExternally() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

bool isImageUrl(String url) {
  final ext = url.split('.').last.toLowerCase().split('?').first;
  return imageExtensions.contains(ext);
}
