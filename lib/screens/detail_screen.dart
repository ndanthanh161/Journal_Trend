import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/work_model.dart';
import '../theme.dart';

class DetailScreen extends StatelessWidget {
  final Work work;

  const DetailScreen({super.key, required this.work});

  Future<void> _openDoi(BuildContext context, String doiUrl) async {
    final Uri url = Uri.parse(doiUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $doiUrl';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể mở liên kết: $e'),
            backgroundColor: AppTheme.critical,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết ấn phẩm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderSubdued),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Row(
                    children: [
                      _Tag(
                        text: work.publicationYear.toString(),
                        color: AppTheme.brandGreen,
                      ),
                      const SizedBox(width: 6),
                      _Tag(
                        text: '${work.citedByCount} trích dẫn',
                        color: AppTheme.interactiveBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Title
                  Text(
                    work.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      height: 1.35,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 10),
                  // Journal
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.bookmark_outlined,
                          color: AppTheme.textDisabled, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tạp chí',
                              style: TextStyle(
                                color: AppTheme.textDisabled,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              work.journalName,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Authors ──
            if (work.authors.isNotEmpty) ...[
              Text(
                'Tác giả (${work.authors.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: work.authors.map((author) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.pageBg,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppTheme.borderSubdued),
                    ),
                    child: Text(
                      author,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],

            // ── Abstract ──
            const Text(
              'Tóm tắt (Abstract)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderSubdued),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: AppTheme.brandGreen,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  work.abstractText,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.65,
                    fontStyle: work.abstractText.startsWith('No abstract')
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── DOI ──
            if (work.doi != null && work.doi!.isNotEmpty) ...[
              const Text(
                'Liên kết',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Material(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => _openDoi(context, work.doi!),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderSubdued),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.link_rounded,
                            color: AppTheme.interactiveBlue, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'DOI',
                                style: TextStyle(
                                  color: AppTheme.textDisabled,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                work.doi!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppTheme.interactiveBlue,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.open_in_new_rounded,
                            color: AppTheme.interactiveBlue, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;

  const _Tag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
