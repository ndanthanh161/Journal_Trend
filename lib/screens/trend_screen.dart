import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../state/analyzer_provider.dart';
import '../theme.dart';

class TrendScreen extends StatelessWidget {
  final VoidCallback onNavigateToSearch;

  const TrendScreen({super.key, required this.onNavigateToSearch});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyzerProvider>();
    final hasData = provider.works.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xu hướng'),
      ),
      body: !hasData
          ? _buildEmptyState(context)
          : _buildTrends(context, provider),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insights_rounded,
                color: AppTheme.textDisabled, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Chưa có dữ liệu xu hướng',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tìm kiếm một chủ đề để xem biểu đồ phân tích.',
              textAlign: TextAlign.center,
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

  Widget _buildTrends(BuildContext context, AnalyzerProvider provider) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (provider.isBackgroundLoading) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.greenSoft,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppTheme.brandGreen.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.brandGreen),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Đang cập nhật xu hướng (đã tải ${provider.allWorks.length} / ${provider.totalCount} bài)...',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.brandGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          _SectionTitle(title: 'Xuất bản theo năm'),
          const SizedBox(height: 8),
          _buildChart(provider),
          const SizedBox(height: 24),

          _SectionTitle(title: 'Tạp chí hàng đầu'),
          const SizedBox(height: 8),
          _buildRankingCard(
            entries: provider.topJournals
                .where((e) => e.key != 'Unknown Source')
                .take(5)
                .toList(),
            emptyMessage: 'Không đủ dữ liệu tạp chí.',
            barColor: AppTheme.brandGreen,
          ),
          const SizedBox(height: 24),

          _SectionTitle(title: 'Tác giả nổi bật'),
          const SizedBox(height: 8),
          _buildRankingCard(
            entries: provider.topAuthors
                .where((e) => e.key != 'Unknown Author')
                .take(5)
                .toList(),
            emptyMessage: 'Không đủ dữ liệu tác giả.',
            barColor: AppTheme.interactiveBlue,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildChart(AnalyzerProvider provider) {
    final trends = provider.yearlyTrends;
    final spots = <FlSpot>[];

    int minYear = 9999;
    int maxYear = 0;
    double maxCount = 0;

    trends.forEach((year, count) {
      if (year < minYear) minYear = year;
      if (year > maxYear) maxYear = year;
      if (count > maxCount) maxCount = count.toDouble();
      spots.add(FlSpot(year.toDouble(), count.toDouble()));
    });

    if (spots.isEmpty) {
      minYear = DateTime.now().year - 5;
      maxYear = DateTime.now().year;
      maxCount = 10;
    } else if (minYear == maxYear) {
      minYear = minYear - 2;
      maxYear = maxYear + 2;
    }

    final double xInterval = ((maxYear - minYear) / 4).clamp(1.0, 10.0);
    final double yInterval = (maxCount / 4).clamp(1.0, 100.0);

    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.only(right: 20, left: 6, top: 16, bottom: 6),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderSubdued),
      ),
      child: LineChart(
        LineChartData(
          minX: minYear.toDouble(),
          maxX: maxYear.toDouble(),
          minY: 0,
          maxY: maxCount * 1.2,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: yInterval,
            getDrawingHorizontalLine: (value) => const FlLine(
              color: AppTheme.borderSubdued,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: AppTheme.textDisabled,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: xInterval,
                getTitlesWidget: (value, meta) {
                  final year = value.toInt();
                  if (year < minYear || year > maxYear) {
                    return const SizedBox();
                  }
                  return Text(
                    year.toString(),
                    style: const TextStyle(
                      color: AppTheme.textDisabled,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: AppTheme.brandGreen,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: spots.length <= 15,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 3,
                  color: AppTheme.surface,
                  strokeColor: AppTheme.brandGreen,
                  strokeWidth: 2,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.brandGreen.withOpacity(0.12),
                    AppTheme.brandGreen.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingCard({
    required List<MapEntry<String, int>> entries,
    required String emptyMessage,
    required Color barColor,
  }) {
    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderSubdued),
        ),
        child: Text(emptyMessage,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
      );
    }

    final maxVal = entries.first.value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderSubdued),
      ),
      child: Column(
        children: entries.asMap().entries.map((indexed) {
          final index = indexed.key;
          final entry = indexed.value;
          final progress = maxVal > 0 ? entry.value / maxVal : 0.0;
          final isLast = index == entries.length - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Rank
                    SizedBox(
                      width: 20,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: index == 0
                              ? barColor
                              : AppTheme.textDisabled,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        entry.key,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.value} bài',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: barColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.pageBg,
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

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
