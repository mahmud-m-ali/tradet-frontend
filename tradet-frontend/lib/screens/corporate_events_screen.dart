import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../utils/asset_emoji.dart';
import '../widgets/responsive_layout.dart';

// ─── Model ───────────────────────────────────────────────────────────────────

enum CorporateEventType {
  earnings,    // Annual report / earnings release
  agm,         // Annual General Meeting
  dividend,    // Dividend / Profit Share
  marketHoliday, // Market closed — national holiday
  ecxSession,  // ECX special session / notice
}

class CorporateEvent {
  final DateTime date;
  final String assetSymbol;   // empty string for market-wide events
  final String assetName;
  final CorporateEventType type;
  final String? detail;       // e.g. "ETB 3.50 per share"

  const CorporateEvent({
    required this.date,
    required this.assetSymbol,
    required this.assetName,
    required this.type,
    this.detail,
  });

  bool get isMarketEvent =>
      type == CorporateEventType.marketHoliday ||
      type == CorporateEventType.ecxSession;
}

// ─── Static event data (Ethiopian calendar, 2026) ────────────────────────────

List<CorporateEvent> get corporateEvents {
  final y = DateTime.now().year;
  return [
    // ── National holidays / ECX closed days ──────────────────────────────────
    CorporateEvent(
      date: DateTime(y, 1, 7),
      assetSymbol: '',
      assetName: 'Genna (Ethiopian Christmas)',
      type: CorporateEventType.marketHoliday,
      detail: 'Market closed — National Holiday',
    ),
    CorporateEvent(
      date: DateTime(y, 1, 19),
      assetSymbol: '',
      assetName: 'Timkat (Ethiopian Epiphany)',
      type: CorporateEventType.marketHoliday,
      detail: 'Market closed — National Holiday',
    ),
    CorporateEvent(
      date: DateTime(y, 3, 2),
      assetSymbol: '',
      assetName: 'Adwa Victory Day',
      type: CorporateEventType.marketHoliday,
      detail: 'Market closed — National Holiday',
    ),
    CorporateEvent(
      date: DateTime(y, 4, 11),
      assetSymbol: '',
      assetName: 'Good Friday',
      type: CorporateEventType.marketHoliday,
      detail: 'Market closed — National Holiday',
    ),
    CorporateEvent(
      date: DateTime(y, 5, 1),
      assetSymbol: '',
      assetName: 'International Labour Day',
      type: CorporateEventType.marketHoliday,
      detail: 'Market closed — National Holiday',
    ),
    CorporateEvent(
      date: DateTime(y, 5, 5),
      assetSymbol: '',
      assetName: 'Ethiopian Patriots\' Victory Day',
      type: CorporateEventType.marketHoliday,
      detail: 'Market closed — National Holiday',
    ),
    CorporateEvent(
      date: DateTime(y, 5, 28),
      assetSymbol: '',
      assetName: 'Downfall of the Derg',
      type: CorporateEventType.marketHoliday,
      detail: 'Market closed — National Holiday',
    ),
    CorporateEvent(
      date: DateTime(y, 9, 11),
      assetSymbol: '',
      assetName: 'Ethiopian New Year (Enkutatash)',
      type: CorporateEventType.marketHoliday,
      detail: 'Market closed — National Holiday',
    ),
    CorporateEvent(
      date: DateTime(y, 9, 27),
      assetSymbol: '',
      assetName: 'Meskel (Finding of the True Cross)',
      type: CorporateEventType.marketHoliday,
      detail: 'Market closed — National Holiday',
    ),

    // ── Corporate earnings / AGM events ──────────────────────────────────────
    CorporateEvent(
      date: DateTime(y, 4, 25),
      assetSymbol: 'ZAMZAM',
      assetName: 'Zamzam Bank',
      type: CorporateEventType.agm,
      detail: 'Annual General Meeting — FY2025',
    ),
    CorporateEvent(
      date: DateTime(y, 4, 28),
      assetSymbol: 'HIJRA',
      assetName: 'Hijra Bank',
      type: CorporateEventType.earnings,
      detail: 'Q1 2026 Financial Results',
    ),
    CorporateEvent(
      date: DateTime(y, 5, 6),
      assetSymbol: 'BUNNA',
      assetName: 'Bunna International Bank',
      type: CorporateEventType.earnings,
      detail: 'Annual Report 2025 Release',
    ),
    CorporateEvent(
      date: DateTime(y, 5, 12),
      assetSymbol: 'RAMMIS',
      assetName: 'Rammis Bank',
      type: CorporateEventType.agm,
      detail: 'Annual General Meeting — FY2025',
    ),
    CorporateEvent(
      date: DateTime(y, 5, 20),
      assetSymbol: 'ZAMZAM',
      assetName: 'Zamzam Bank',
      type: CorporateEventType.dividend,
      detail: 'Profit share — ETB 3.50 per share',
    ),
    CorporateEvent(
      date: DateTime(y, 6, 3),
      assetSymbol: 'OROMIA',
      assetName: 'Oromia Bank',
      type: CorporateEventType.earnings,
      detail: 'H1 2026 Financial Results',
    ),
    CorporateEvent(
      date: DateTime(y, 6, 15),
      assetSymbol: 'AWASH',
      assetName: 'Awash Bank',
      type: CorporateEventType.agm,
      detail: 'Annual General Meeting — FY2025',
    ),
    CorporateEvent(
      date: DateTime(y, 6, 22),
      assetSymbol: 'HIJRA',
      assetName: 'Hijra Bank',
      type: CorporateEventType.dividend,
      detail: 'Profit share — ETB 2.80 per share',
    ),
    CorporateEvent(
      date: DateTime(y, 7, 10),
      assetSymbol: 'COFFEE',
      assetName: 'ECX Coffee Market',
      type: CorporateEventType.ecxSession,
      detail: 'Extended trading session — export season',
    ),
    CorporateEvent(
      date: DateTime(y, 8, 5),
      assetSymbol: 'BUNNA',
      assetName: 'Bunna International Bank',
      type: CorporateEventType.dividend,
      detail: 'Profit share — ETB 4.00 per share',
    ),
    CorporateEvent(
      date: DateTime(y, 9, 2),
      assetSymbol: 'DASHEN',
      assetName: 'Dashen Bank',
      type: CorporateEventType.earnings,
      detail: 'H1 2026 Financial Results',
    ),
    CorporateEvent(
      date: DateTime(y, 10, 14),
      assetSymbol: 'ZAMZAM',
      assetName: 'Zamzam Bank',
      type: CorporateEventType.earnings,
      detail: 'Q3 2026 Financial Results',
    ),
    CorporateEvent(
      date: DateTime(y, 11, 8),
      assetSymbol: 'RAMMIS',
      assetName: 'Rammis Bank',
      type: CorporateEventType.earnings,
      detail: 'Q3 2026 Financial Results',
    ),
    CorporateEvent(
      date: DateTime(y, 12, 3),
      assetSymbol: 'HIJRA',
      assetName: 'Hijra Bank',
      type: CorporateEventType.agm,
      detail: 'Annual General Meeting — FY2026',
    ),
  ]..sort((a, b) => a.date.compareTo(b.date));
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

Color _eventColor(CorporateEventType type) {
  switch (type) {
    case CorporateEventType.earnings:
      return TradEtTheme.primaryLight;
    case CorporateEventType.agm:
      return TradEtTheme.accent;
    case CorporateEventType.dividend:
      return TradEtTheme.positive;
    case CorporateEventType.marketHoliday:
      return const Color(0xFFF59E0B); // amber
    case CorporateEventType.ecxSession:
      return const Color(0xFF8B5CF6); // purple
  }
}

String _eventLabel(CorporateEventType type) {
  switch (type) {
    case CorporateEventType.earnings:
      return 'Earnings / Report';
    case CorporateEventType.agm:
      return 'Annual Meeting';
    case CorporateEventType.dividend:
      return 'Profit Share';
    case CorporateEventType.marketHoliday:
      return 'Market Holiday';
    case CorporateEventType.ecxSession:
      return 'ECX Session';
  }
}

IconData _eventIcon(CorporateEventType type) {
  switch (type) {
    case CorporateEventType.earnings:
      return Icons.bar_chart_rounded;
    case CorporateEventType.agm:
      return Icons.groups_rounded;
    case CorporateEventType.dividend:
      return Icons.monetization_on_rounded;
    case CorporateEventType.marketHoliday:
      return Icons.event_busy_rounded;
    case CorporateEventType.ecxSession:
      return Icons.swap_horiz_rounded;
  }
}

// ─── Full Screen ─────────────────────────────────────────────────────────────

class CorporateEventsScreen extends StatefulWidget {
  const CorporateEventsScreen({super.key});

  @override
  State<CorporateEventsScreen> createState() => _CorporateEventsScreenState();
}

class _CorporateEventsScreenState extends State<CorporateEventsScreen> {
  int _tab = 0;
  String _search = '';
  CorporateEventType? _filterType;
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _monthKeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToNextEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToNextEvent() {
    final now = DateTime.now();
    final allEvents = corporateEvents;
    if (allEvents.isEmpty) return;
    final next = allEvents.firstWhere(
      (e) => !e.date.isBefore(now.subtract(const Duration(days: 1))),
      orElse: () => allEvents.last,
    );
    final targetMonth = DateFormat('MMMM yyyy').format(next.date);
    final key = _monthKeys[targetMonth];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        alignment: 0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  List<CorporateEvent> _filtered(Set<String> mySymbols) {
    var list = corporateEvents;
    if (_tab == 0) {
      list = list
          .where((e) => e.isMarketEvent || mySymbols.contains(e.assetSymbol))
          .toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list
          .where((e) =>
              e.assetName.toLowerCase().contains(q) ||
              e.assetSymbol.toLowerCase().contains(q) ||
              (e.detail?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    if (_filterType != null) {
      list = list.where((e) => e.type == _filterType).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final mySymbols =
        provider.holdings.map((h) => h.symbol).toSet().cast<String>();
    final filtered = _filtered(mySymbols);
    final wide = isWideScreen(context);

    // Group by month
    final Map<String, List<CorporateEvent>> grouped = {};
    for (final e in filtered) {
      final key = DateFormat('MMMM yyyy').format(e.date);
      grouped.putIfAbsent(key, () => []).add(e);
    }

    // Build month widgets with GlobalKeys for scroll targeting
    final monthWidgets = grouped.entries.map((entry) {
      _monthKeys.putIfAbsent(entry.key, () => GlobalKey());
      return _MonthGroup(
        key: _monthKeys[entry.key],
        month: entry.key,
        events: entry.value,
        mySymbols: mySymbols,
      );
    }).toList();

    // Scrollable content body
    Widget listBody = filtered.isEmpty
        ? _empty()
        : SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: wide ? 0 : 16,
              vertical: 12,
            ),
            child: Column(children: monthWidgets),
          );

    // Search + tabs + list
    Widget content = Column(
      children: [
        Container(
          color: TradEtTheme.surface,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search events...',
              hintStyle: const TextStyle(color: TradEtTheme.textMuted),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: TradEtTheme.textMuted, size: 20),
              filled: true,
              fillColor: TradEtTheme.cardBg,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Container(
          color: TradEtTheme.surface,
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: TradEtTheme.cardBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _tabBtn('My events', 0),
                const SizedBox(width: 3),
                _tabBtn('All events', 1),
              ],
            ),
          ),
        ),
        Expanded(child: listBody),
      ],
    );

    // Action buttons shared between both layouts
    final actions = <Widget>[
      IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _filterType != null
                ? TradEtTheme.accent.withValues(alpha: 0.2)
                : TradEtTheme.cardBg,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.filter_list_rounded,
              size: 18,
              color:
                  _filterType != null ? TradEtTheme.accent : Colors.white),
        ),
        onPressed: _showFilterSheet,
      ),
      IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: TradEtTheme.cardBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.calendar_today_rounded,
              size: 16, color: Colors.white),
        ),
        onPressed: _scrollToNextEvent,
      ),
      const SizedBox(width: 8),
    ];

    // ── Desktop layout: no AppBar, sidebar provided by HomeScreen ──────────
    if (wide) {
      return Scaffold(
        backgroundColor: TradEtTheme.surface,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 8, 12),
              child: Row(
                children: [
                  const Text('Corporate Events',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  const Spacer(),
                  ...actions,
                ],
              ),
            ),
            Divider(
                height: 1,
                color: TradEtTheme.divider.withValues(alpha: 0.3)),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: content,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ── Mobile layout: AppBar with back button ─────────────────────────────
    return Scaffold(
      backgroundColor: TradEtTheme.surface,
      appBar: AppBar(
        backgroundColor: TradEtTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TradEtTheme.cardBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_rounded,
                size: 18, color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Corporate Events',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        centerTitle: true,
        actions: actions,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: content,
      ),
    );
  }

  Widget _tabBtn(String label, int idx) {
    final sel = _tab == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = idx),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: sel ? TradEtTheme.cardBgLight : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          sel ? FontWeight.w700 : FontWeight.w500,
                      color: sel ? Colors.white : TradEtTheme.textMuted)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.event_note_rounded,
              size: 48, color: TradEtTheme.textMuted),
          const SizedBox(height: 12),
          const Text('No events found',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Text(
              _tab == 0
                  ? 'Events for your holdings will appear here'
                  : 'Try adjusting your search or filter',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, color: TradEtTheme.textMuted)),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TradEtTheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filter by Type',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _filterChip(null, 'All', Icons.apps_rounded),
                  ...CorporateEventType.values.map((t) =>
                      _filterChip(t, _eventLabel(t), _eventIcon(t))),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip(CorporateEventType? type, String label, IconData icon) {
    final selected = _filterType == type;
    final color =
        type != null ? _eventColor(type) : TradEtTheme.primaryLight;
    return GestureDetector(
      onTap: () {
        setState(() => _filterType = type);
        Navigator.pop(context);
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.2)
              : TradEtTheme.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected
                  ? color
                  : TradEtTheme.divider.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: selected ? color : TradEtTheme.textMuted),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? color : TradEtTheme.textSecondary)),
          ],
        ),
      ),
    );
  }

  void _scrollToToday() => _scrollToNextEvent();
}

// ─── Month group widget ───────────────────────────────────────────────────────

class _MonthGroup extends StatelessWidget {
  final String month;
  final List<CorporateEvent> events;
  final Set<String> mySymbols;
  const _MonthGroup(
      {super.key, required this.month, required this.events, required this.mySymbols});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isCurrentMonth = DateFormat('MMMM yyyy').format(now) == month;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 4),
          child: Row(
            children: [
              Text(month,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isCurrentMonth
                          ? TradEtTheme.primaryLight
                          : Colors.white)),
              if (isCurrentMonth) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: TradEtTheme.primaryLight.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Current',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: TradEtTheme.primaryLight)),
                ),
              ],
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: TradEtTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: TradEtTheme.divider.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: events.asMap().entries.map((entry) {
              final i = entry.key;
              final e = entry.value;
              return Column(
                children: [
                  _EventRow(event: e, isOwned: mySymbols.contains(e.assetSymbol)),
                  if (i < events.length - 1)
                    Divider(
                        height: 1,
                        indent: 56,
                        color: TradEtTheme.divider.withValues(alpha: 0.15)),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─── Individual event row ─────────────────────────────────────────────────────

class _EventRow extends StatelessWidget {
  final CorporateEvent event;
  final bool isOwned;
  const _EventRow({required this.event, required this.isOwned});

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event.type);
    final emoji = event.assetSymbol.isNotEmpty
        ? assetEmoji(event.assetSymbol, null)
        : _holidayEmoji(event.assetName);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date column
          SizedBox(
            width: 36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  event.date.day.toString(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1),
                ),
                Text(
                  DateFormat('MMM').format(event.date),
                  style: const TextStyle(
                      fontSize: 11,
                      color: TradEtTheme.textMuted,
                      height: 1.1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Event card
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isOwned ? 0.13 : 0.07),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: color.withValues(alpha: isOwned ? 0.35 : 0.18)),
              ),
              child: Row(
                children: [
                  // Emoji circle
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(emoji,
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.assetName,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          event.detail ?? _eventLabel(event.type),
                          style: TextStyle(
                              fontSize: 12,
                              color: color.withValues(alpha: 0.85)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Owned badge
                  if (isOwned) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: TradEtTheme.positive.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text('Held',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: TradEtTheme.positive)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _holidayEmoji(String name) {
    final n = name.toLowerCase();
    if (n.contains('christmas') || n.contains('genna')) return '🎄';
    if (n.contains('epiphany') || n.contains('timkat')) return '✝️';
    if (n.contains('adwa')) return '🦁';
    if (n.contains('easter') || n.contains('fasika') || n.contains('good friday')) return '✝️';
    if (n.contains('labour') || n.contains('labor')) return '👷';
    if (n.contains('patriots')) return '⚔️';
    if (n.contains('derg') || n.contains('downfall')) return '🇪🇹';
    if (n.contains('new year') || n.contains('enkutatash')) return '🌸';
    if (n.contains('meskel') || n.contains('cross')) return '✝️';
    return '🗓️';
  }
}
