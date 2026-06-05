import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/analyzer_provider.dart';
import '../theme.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _suggestions = [
    'Artificial Intelligence',
    'Software Engineering',
    'Data Science',
    'Cybersecurity',
    'Internet of Things',
    'Blockchain',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSearch(String query) {
    if (query.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    context.read<AnalyzerProvider>().search(query);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyzerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppTheme.brandGreen,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.auto_stories_rounded,
                  color: Colors.white, size: 14),
            ),
            const SizedBox(width: 10),
            const Text('Journal Analyzer'),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search area ──
          Container(
            color: AppTheme.surface,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search label (above field per Polaris)
                const Text(
                  'Từ khóa chủ đề',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'VD: Blockchain, Data Science...',
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close_rounded,
                                      color: AppTheme.textDisabled, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                        ),
                        onChanged: (val) => setState(() {}),
                        onSubmitted: _triggerSearch,
                        style: const TextStyle(
                            color: AppTheme.textPrimary, fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _triggerSearch(_searchController.text),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        minimumSize: const Size(48, 48),
                      ),
                      child: const Icon(Icons.search_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // ── Suggestion chips ──
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _suggestions.map((s) {
                    final isSelected = provider.currentQuery == s;
                    return GestureDetector(
                      onTap: () {
                        _searchController.text = s;
                        _triggerSearch(s);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.greenSoft
                              : AppTheme.pageBg,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.brandGreen
                                : AppTheme.borderColor,
                          ),
                        ),
                        child: Text(
                          s,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? AppTheme.brandGreen
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // ── Body ──
          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  Widget _buildBody(AnalyzerProvider provider) {
    if (provider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppTheme.brandGreen),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Đang truy xuất dữ liệu...',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.critical.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: AppTheme.critical, size: 36),
                const SizedBox(height: 12),
                const Text(
                  'Không thể tải dữ liệu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _triggerSearch(provider.currentQuery),
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (provider.works.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books_outlined,
                color: AppTheme.textDisabled, size: 48),
            const SizedBox(height: 12),
            Text(
              provider.currentQuery.isEmpty
                  ? 'Bắt đầu tìm kiếm'
                  : 'Không có kết quả',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              provider.currentQuery.isEmpty
                  ? 'Nhập từ khóa phía trên để khám phá ấn phẩm.'
                  : 'Thử một từ khóa khác.',
              style:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    // ── Results ──
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Tìm thấy ${provider.totalCount} ấn phẩm cho "${provider.currentQuery}"',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              if (provider.isBackgroundLoading) ...[
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.brandGreen),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Đã tải ${provider.allWorks.length} bài để phân tích',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.brandGreen,
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            physics: const BouncingScrollPhysics(),
            itemCount: provider.works.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final work = provider.works[index];
              return Material(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(work: work),
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
                        // Title
                        Text(
                          work.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Meta row
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
                            const Spacer(),
                            const Icon(Icons.chevron_right_rounded,
                                color: AppTheme.textDisabled, size: 20),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Journal
                        Text(
                          work.journalName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 12),
                        ),
                        if (work.authors.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            work.authors.take(3).join(', ') +
                                (work.authors.length > 3
                                    ? ' +${work.authors.length - 3}'
                                    : ''),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppTheme.textDisabled, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Pagination Footer
        if (provider.totalPages > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              border: Border(
                top: BorderSide(color: AppTheme.borderSubdued, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: provider.currentPage > 1 ? () => provider.previousPage() : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textPrimary,
                    disabledForegroundColor: AppTheme.textDisabled,
                    side: BorderSide(
                      color: provider.currentPage > 1 ? AppTheme.borderColor : AppTheme.borderSubdued,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: const Size(80, 36),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chevron_left_rounded, size: 18),
                      SizedBox(width: 4),
                      Text('Trước', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Text(
                  'Trang ${provider.currentPage} / ${provider.totalPages}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                OutlinedButton(
                  onPressed: provider.currentPage < provider.totalPages ? () => provider.nextPage() : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textPrimary,
                    disabledForegroundColor: AppTheme.textDisabled,
                    side: BorderSide(
                      color: provider.currentPage < provider.totalPages ? AppTheme.borderColor : AppTheme.borderSubdued,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: const Size(80, 36),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Sau', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right_rounded, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
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
