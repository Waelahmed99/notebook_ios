import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:provider/provider.dart';

class PDFViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<FirebaseModel>(context, listen: false).downloadPDF(),
      builder: (context, AsyncSnapshot<File> snap) {
        // Data not yet loaded.
        if (snap.connectionState == ConnectionState.waiting)
          return _buildWaitingState(context);
        // No PDF found in the database.
        if (!snap.hasData) return _buildErrorNoPDF();
        // Data loaded, view PDF.
        return PDFViewerScaffold(path: snap.data.path);
      },
    );
  }

  // PDF not loaded due to network or database issues.
  Scaffold _buildErrorNoPDF() {
    return Scaffold(
        body: Center(
      child: Text(Values.NO_PDF_ERROR),
    ));
  }

  // Data still loading.
  Widget _buildWaitingState(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
