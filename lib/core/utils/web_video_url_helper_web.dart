import 'dart:typed_data';
import 'dart:html' as html;

String createObjectUrlFromBytes(Uint8List bytes) {
  final blob = html.Blob([bytes]);
  return html.Url.createObjectUrlFromBlob(blob);
}

void revokeObjectUrl(String url) {
  html.Url.revokeObjectUrl(url);
}
