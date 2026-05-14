import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfViewerPage extends StatefulWidget {
  final String url;
  final String fileName;

  const PdfViewerPage({super.key, required this.url, required this.fileName});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        title: Text(
          widget.fileName,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SfPdfViewer.network(
        widget.url,
        key: _pdfViewerKey,
        canShowScrollHead: false,
        canShowScrollStatus: false,
      ),
    );
  }
}
