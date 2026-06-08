# Kế hoạch cải thiện giao diện Journal Trend Analyzer

> **Ngày tạo:** 2026-06-08  
> **Mục tiêu:** Làm đẹp toàn bộ UI và thêm chức năng chuyển chế độ sáng/tối

---

## Tình trạng hiện tại

| Vấn đề | Chi tiết |
|--------|----------|
| Chỉ có 1 theme | `theme.dart` chỉ định nghĩa theme tối, đặt tên nhầm là `lightTheme` |
| Không có toggle | Không có nút chuyển sáng/tối ở đâu cả |
| Màu sắc cứng nhắc | Các screen dùng `AppTheme.color` thẳng → không đổi theo theme |
| Bottom nav đơn giản | Custom `_NavTab` thiếu animation active indicator |
| Card thiếu chiều sâu | Card phẳng, chỉ có border 1px |
| Typography chưa cân bằng | Một số chỗ dùng hardcode `fontSize`, không nhất quán |

---

## Kiến trúc thay đổi

```
lib/
├── main.dart                  ← Thêm ThemeProvider vào MultiProvider
├── theme.dart                 ← Thêm darkTheme + lightTheme thực sự
├── state/
│   ├── analyzer_provider.dart (không đổi)
│   └── theme_provider.dart    ← MỚI: quản lý ThemeMode
└── screens/
    └── navigation_shell.dart  ← Thêm nút toggle vào AppBar
```

---

## Giai đoạn 1 — Hệ thống Theme sáng/tối

### 1.1 Tạo `ThemeProvider`

**File:** `lib/state/theme_provider.dart`

```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.dark;
  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
```

### 1.2 Cập nhật `theme.dart`

Tách thành 2 theme thực sự:

**Dark Theme** (giữ nguyên màu hiện tại):
- Background: `#08111F` (xanh đêm đậm)
- Surface: `#0F1B2D`
- Text: `#E5EEF9`

**Light Theme** (thêm mới):
- Background: `#F0F4F8` (xám trắng nhẹ)
- Surface: `#FFFFFF`
- Surface muted: `#EBF0F6`
- Text primary: `#0D1B2A`
- Text secondary: `#4A6080`
- Border: `#CBD5E1`
- Accent xanh: `#2563EB` (đậm hơn để đọc được trên nền sáng)
- Accent green: `#059669`

```dart
class AppTheme {
  // Shared accent colors
  static const Color accentBlue  = Color(0xFF3B82F6);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color warning     = Color(0xFFF59E0B);
  static const Color critical    = Color(0xFFEF4444);

  static ThemeData get darkTheme  { ... }   // theme tối hiện tại (refactor lại)
  static ThemeData get lightTheme { ... }   // theme sáng mới
}
```

### 1.3 Cập nhật `main.dart`

```dart
return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AnalyzerProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),   // ← THÊM
  ],
  child: Consumer<ThemeProvider>(
    builder: (_, themeProvider, __) => MaterialApp(
      theme:      AppTheme.lightTheme,
      darkTheme:  AppTheme.darkTheme,
      themeMode:  themeProvider.mode,          // ← THÊM
      home: const NavigationShell(),
    ),
  ),
);
```

---

## Giai đoạn 2 — Nút chuyển sáng/tối

### 2.1 Vị trí nút

Đặt nút **trong AppBar** của từng screen (hoặc tập trung ở `NavigationShell`).  
Dùng icon `Icons.dark_mode_rounded` / `Icons.light_mode_rounded` với animation.

### 2.2 Widget `ThemeToggleButton`

**File:** `lib/widgets/theme_toggle_button.dart`

```dart
class ThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tp = context.watch<ThemeProvider>();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) =>
          RotationTransition(turns: anim, child: FadeTransition(opacity: anim, child: child)),
      child: IconButton(
        key: ValueKey(tp.isDark),
        icon: Icon(tp.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
        tooltip: tp.isDark ? 'Chuyển sang sáng' : 'Chuyển sang tối',
        onPressed: tp.toggle,
      ),
    );
  }
}
```

### 2.3 Tích hợp vào các screen

Mỗi screen có AppBar → thêm `ThemeToggleButton()` vào `actions`:

```dart
AppBar(
  title: const Text('Explore'),
  actions: [
    ThemeToggleButton(),      // ← THÊM
    const SizedBox(width: 8),
  ],
)
```

---

## Giai đoạn 3 — Cải thiện Bottom Navigation

Thay custom `_NavTab` bằng `NavigationBar` (Material 3) để có animation indicator đẹp hơn:

```dart
NavigationBar(
  selectedIndex: _currentIndex,
  onDestinationSelected: (i) => setState(() => _currentIndex = i),
  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search_rounded),
      label: 'Explore',
    ),
    NavigationDestination(
      icon: Icon(Icons.dataset_outlined),
      selectedIcon: Icon(Icons.dataset_rounded),
      label: 'Summary',
    ),
    NavigationDestination(
      icon: Icon(Icons.query_stats_outlined),
      selectedIcon: Icon(Icons.query_stats_rounded),
      label: 'Analytics',
    ),
  ],
)
```

**Lợi ích:**
- Indicator pill animation khi chuyển tab
- Tự đổi màu theo theme (sáng/tối)
- Không cần viết màu cứng

---

## Giai đoạn 4 — Cải thiện từng Screen

### 4.1 Search Screen (`search_screen.dart`)

| Thay đổi | Cách làm |
|----------|----------|
| Search bar to hơn, có shadow | `elevation` + `borderRadius: 12` |
| Suggestion chip đẹp hơn | `FilterChip` với icon, wrap layout |
| Empty state có illustration | SVG hoặc icon lớn + text hướng dẫn |
| Kết quả load có skeleton | `shimmer` effect thay loading spinner |

### 4.2 Dashboard Screen (`dashboard_screen.dart`)

| Thay đổi | Cách làm |
|----------|----------|
| Metric card có gradient subtle | `LinearGradient` nhẹ trên header card |
| Stat number to, bold hơn | `fontSize: 32, fontWeight: w800` |
| Section header nhất quán | Widget `_SectionHeader` dùng chung |
| Spacing cân đối hơn | `16px` padding xung quanh, `12px` giữa các card |

### 4.3 Trend Screen (`trend_screen.dart`)

| Thay đổi | Cách làm |
|----------|----------|
| Chart màu theo theme | Lấy màu từ `Theme.of(context).colorScheme` |
| Legend rõ hơn | Row với color dot + label text |
| Chart tooltip đẹp | Custom `LineTooltipItem` với border radius |

### 4.4 Detail Screen (`detail_screen.dart`)

| Thay đổi | Cách làm |
|----------|----------|
| Hero header với màu accent | `Container` gradient + tiêu đề bài báo |
| Tag tác giả/journal cân đối | `Wrap` + `Chip` widget |
| DOI button nổi bật | `FilledButton` với icon mở ngoài |
| Abstract dễ đọc | `lineHeight: 1.7`, `fontSize: 15` |

---

## Giai đoạn 5 — Cải thiện nhỏ xuyên suốt

### 5.1 Card Component nâng cấp

```dart
// Thêm vào theme.dart
cardTheme: CardThemeData(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),   // 8 → 12
    side: BorderSide(color: borderColor, width: 1),
  ),
  surfaceTintColor: Colors.transparent,
),
```

### 5.2 Xóa màu hardcode trong các screen

Thay tất cả `AppTheme.xxxColor` thành:
```dart
Theme.of(context).colorScheme.primary      // thay dashboardBlue
Theme.of(context).colorScheme.secondary    // thay brandGreen
Theme.of(context).colorScheme.surface      // thay surface
Theme.of(context).colorScheme.onSurface    // thay textPrimary
```

### 5.3 Transition animation mượt hơn

Khi chuyển sang detail screen:
```dart
PageRouteBuilder(
  transitionDuration: const Duration(milliseconds: 280),
  pageBuilder: (_, __, ___) => DetailScreen(...),
  transitionsBuilder: (_, anim, __, child) =>
      FadeTransition(opacity: anim, child: child),
)
```

---

## Thứ tự thực hiện (ưu tiên)

```
[P0] Giai đoạn 1 — ThemeProvider + 2 theme (foundation)
[P0] Giai đoạn 2 — Nút toggle sáng/tối
[P1] Giai đoạn 3 — Bottom NavigationBar mới
[P1] Giai đoạn 5.2 — Xóa hardcode màu
[P2] Giai đoạn 4 — Cải thiện từng screen
[P3] Giai đoạn 5.1, 5.3 — Card + animation
```

---

## Dependency cần thêm (nếu cần)

```yaml
# pubspec.yaml — chỉ thêm nếu dùng skeleton loading
shimmer: ^3.0.0
```

Không cần thêm gì cho theme toggle — Flutter tự hỗ trợ.

---

## Kiểm thử sau khi làm

- [ ] Toggle sáng/tối hoạt động trên cả 3 tab
- [ ] Màu chuyển đổi hoàn toàn (không còn màu hardcode)
- [ ] Bottom nav có animation indicator
- [ ] Chart đổi màu theo theme
- [ ] Không bị overflow text khi theme thay đổi
- [ ] Hot reload không reset theme (ThemeProvider dùng `ChangeNotifier`)
