import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/analyzer_provider.dart';
import '../theme.dart';
import 'detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onNavigateToSearch;

  const DashboardScreen({super.key, required this.onNavigateToSearch});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyzerProvider>();
    final hasData = provider.works.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tổng quan'),
      ),
      body: !hasData
          ? _buildEmptyState(context)
          : _buildDashboard(context, provider),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_rounded,
                color: AppTheme.textDisabled, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Chưa có dữ liệu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tìm kiếm một chủ đề để xem phân tích.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onNavigateToSearch,
              icon: const Icon(Icons.search_rounded, size: 16),
              label: const Text('Tìm kiếm'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, AnalyzerProvider provider) {
    final influentialPaper = provider.mostInfluentialPaper;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Topic banner ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.greenSoft,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppTheme.brandGreen.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.topic_rounded,
                    color: AppTheme.brandGreen, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chủ đề đang phân tích',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        provider.currentQuery,
                        style: const TextStyle(
                          color: AppTheme.darkGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (provider.isBackgroundLoading) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.brandGreen),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Đang thu thập dữ liệu phân tích (đã tải ${provider.allWorks.length} / ${provider.totalCount} bài)...',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.brandGreen,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Key metrics ──
          _SectionTitle(title: 'Chỉ số chính'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Tổng ấn phẩm',
                  value: provider.totalPublications.toString(),
                  icon: Icons.article_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  label: 'Trích dẫn TB',
                  value: provider.averageCitationCount.toStringAsFixed(1),
                  icon: Icons.format_quote_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Năm nổi bật',
                  value: provider.mostActivePublicationYear.toString(),
                  icon: Icons.event_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  label: 'Tạp chí hàng đầu',
                  value: provider.topJournal,
                  icon: Icons.bookmark_outline_rounded,
                  compact: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Top author ──
          _SectionTitle(title: 'Tác giả nổi bật'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderSubdued),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.greenSoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person_rounded,
                      color: AppTheme.brandGreen, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nghiên cứu tích cực nhất',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        provider.topAuthor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Most influential paper ──
          if (influentialPaper != null) ...[
            _SectionTitle(title: 'Ấn phẩm nổi bật nhất'),
            const SizedBox(height: 8),
            Material(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(work: influentialPaper),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.borderSubdued),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.warning.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.emoji_events_rounded,
                                    color: AppTheme.warning.withOpacity(0.9),
                                    size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${influentialPaper.citedByCount} trích dẫn',
                                  style: TextStyle(
                                    color: AppTheme.warning
                                        .withOpacity(0.9),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right_rounded,
                              color: AppTheme.textDisabled, size: 20),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        influentialPaper.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        influentialPaper.journalName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Reusable ──

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool compact;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderSubdued),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.textDisabled, size: 18),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: compact ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact && value.length > 16 ? 13 : 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
