import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/repositories/seerah_data.dart';

class SeerahScreen extends StatefulWidget {
  final int initialTabIndex;

  const SeerahScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<SeerahScreen> createState() => _SeerahScreenState();
}

class _SeerahScreenState extends State<SeerahScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Tab 1: Map & Timeline state
  String _selectedEra = 'all';
  int _selectedEventIndex = 0;

  // Tab 2: Genealogy state
  String _genealogyQuery = '';

  // Tab 3: Family state
  String _selectedFamilyCategory = 'all';
  String _familyQuery = '';

  // Tab 4: Companions state
  String _selectedCompanionRole = 'all';
  String _companionQuery = '';

  // Tab 5: Battles state
  String _selectedBattleFilter = 'all';
  String _battleQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 4),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<SeerahEvent> get _filteredEvents {
    if (_selectedEra == 'all') return SeerahData.events;
    return SeerahData.events.where((e) => e.era == _selectedEra).toList();
  }

  Color _eraColor(String era) {
    switch (era) {
      case 'pre_prophethood':
        return AppColors.amber;
      case 'makki':
        return AppColors.emerald;
      case 'hijrah':
        return const Color(0xFF0284C7);
      case 'madani':
        return const Color(0xFF7C3AED);
      default:
        return AppColors.emerald;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'সীরাতুন্নবী (ﷺ) বিশ্বকোষ',
              style: GoogleFonts.hindSiliguri(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'মানচিত্র • ৫০ প্রজন্মের বংশলতিকা • আহলে বাইত • সাহাবী • গাযওয়া',
              style: GoogleFonts.hindSiliguri(
                fontSize: 10.5,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppColors.emerald,
          labelColor: AppColors.emerald,
          unselectedLabelColor: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
          labelStyle: GoogleFonts.hindSiliguri(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.hindSiliguri(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: '🗺️ মানচিত্র ও সীরাত'),
            Tab(text: '🌳 বংশলতিকা (৫০)'),
            Tab(text: '👨‍👩‍👧‍👦 আহলে বাইত'),
            Tab(text: '🌟 সাহাবীগণ'),
            Tab(text: '⚔️ গাযওয়া ও যুদ্ধ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMapAndTimelineTab(isDark),
          _buildGenealogyTab(isDark),
          _buildFamilyTab(isDark),
          _buildCompanionsTab(isDark),
          _buildBattlesTab(isDark),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 1: INTERACTIVE SEERAH MAP & CHRONOLOGICAL TIMELINE
  // ===========================================================================
  Widget _buildMapAndTimelineTab(bool isDark) {
    final events = _filteredEvents;
    final safeIndex = events.isEmpty
        ? 0
        : _selectedEventIndex.clamp(0, events.length - 1);
    final activeEvent = events.isNotEmpty ? events[safeIndex] : null;

    final eras = [
      {'id': 'all', 'label': 'সকল যুগ (${BengaliNumerals.toBengali(SeerahData.events.length)})'},
      {'id': 'pre_prophethood', 'label': 'নবুওয়াত-পূর্ব (৫৭০–৬০৯)'},
      {'id': 'makki', 'label': 'মক্কী জীবন (৬১০–৬২২)'},
      {'id': 'hijrah', 'label': 'হিজরত (৬২২ খ্রি.)'},
      {'id': 'madani', 'label': 'মাদানী জীবন (১–১১ হি.)'},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Era Filter Chips
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: eras.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final era = eras[index];
              final isSelected = _selectedEra == era['id'];
              return ChoiceChip(
                label: Text(
                  era['label']!,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.emerald,
                backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                onSelected: (_) {
                  setState(() {
                    _selectedEra = era['id']!;
                    _selectedEventIndex = 0;
                  });
                },
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Interactive Arabian Peninsula Map Canvas
        if (activeEvent != null) ...[
          _buildInteractiveArabiaMap(events, safeIndex, isDark),
          const SizedBox(height: 12),
          _buildActiveEventSpotlightCard(
            activeEvent,
            safeIndex,
            events.length,
            isDark,
          ),
          const SizedBox(height: 18),
        ],

        // Timeline List Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'কালানুক্রমিক সীরাত টাইমলাইন',
              style: GoogleFonts.hindSiliguri(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              '${BengaliNumerals.toBengali(events.length)}টি ঐতিহাসিক ঘটনা',
              style: GoogleFonts.hindSiliguri(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.emerald,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Timeline Cards
        ...List.generate(events.length, (idx) {
          final ev = events[idx];
          final isSelected = idx == safeIndex;
          final badgeColor = _eraColor(ev.era);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedEventIndex = idx;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.emerald
                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  width: isSelected ? 1.6 : 0.9,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          BengaliNumerals.toBengali(idx + 1),
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                _pillBadge(ev.eraBn, badgeColor),
                                _pillBadge(ev.yearCe, AppColors.amberDark),
                                _pillBadge(ev.yearAh, AppColors.emerald),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              ev.titleBn,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                            Text(
                              ev.titleAr,
                              style: GoogleFonts.amiri(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ev.summaryBn,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12.5,
                      height: 1.5,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '📍 ${ev.placeBn}',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.emerald,
                          ),
                        ),
                      ),
                      Text(
                        '📚 ${ev.sourcesBn}',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInteractiveArabiaMap(
    List<SeerahEvent> events,
    int activeIndex,
    bool isDark,
  ) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF0B192C), const Color(0xFF0F2922)]
              : [const Color(0xFFE0F2FE), const Color(0xFFFEF3C7)],
        ),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            return GestureDetector(
              onTapDown: (details) {
                final tapPos = details.localPosition;
                int? nearestIdx;
                double minDistance = 28.0;
                for (int i = 0; i < events.length; i++) {
                  final pt = _SeerahMapPainter.project(
                    events[i].lat,
                    events[i].lng,
                    size,
                  );
                  final dist = (pt - tapPos).distance;
                  if (dist < minDistance) {
                    minDistance = dist;
                    nearestIdx = i;
                  }
                }
                if (nearestIdx != null) {
                  setState(() {
                    _selectedEventIndex = nearestIdx!;
                  });
                }
              },
              child: Stack(
                children: [
                  CustomPaint(
                    size: size,
                    painter: _SeerahMapPainter(
                      events: events,
                      activeIndex: activeIndex,
                      isDark: isDark,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.black : Colors.white)
                            .withOpacity(0.82),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '৭ম শতাব্দীর আরব উপদ্বীপ ও সীরাত মানচিত্র (পিনে ট্যাপ করুন)',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActiveEventSpotlightCard(
    SeerahEvent ev,
    int index,
    int total,
    bool isDark,
  ) {
    final badgeColor = _eraColor(ev.era);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.emerald.withOpacity(0.5),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _pillBadge(
                    'ধাপ ${BengaliNumerals.toBengali(index + 1)}/${BengaliNumerals.toBengali(total)}',
                    badgeColor,
                  ),
                  const SizedBox(width: 6),
                  _pillBadge('${ev.yearCe} • ${ev.yearAh}', AppColors.amberDark),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.chevron_left_rounded, size: 22),
                    onPressed: index > 0
                        ? () => setState(() => _selectedEventIndex = index - 1)
                        : null,
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.chevron_right_rounded, size: 22),
                    onPressed: index < total - 1
                        ? () => setState(() => _selectedEventIndex = index + 1)
                        : null,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            ev.titleBn,
            style: GoogleFonts.hindSiliguri(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          Text(
            '📍 ${ev.placeBn}  •  📚 ${ev.sourcesBn}',
            style: GoogleFonts.hindSiliguri(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.emerald,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ev.summaryBn,
            style: GoogleFonts.hindSiliguri(
              fontSize: 12.5,
              height: 1.45,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 2: 50-GENERATION GENEALOGY (ADAM AS TO MUHAMMAD ﷺ)
  // ===========================================================================
  Widget _buildGenealogyTab(bool isDark) {
    final q = _genealogyQuery.trim().toLowerCase();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSearchBox(
          hint: 'পিতৃপুরুষ বা নবীর নাম খুঁজুন (যেমন: আদম, ইবরাহীম, আদনান, হাশিম)...',
          value: _genealogyQuery,
          onChanged: (v) => setState(() => _genealogyQuery = v),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        ...SeerahData.genealogyEras.map((era) {
          final nodes = q.isEmpty
              ? era.generations
              : era.generations.where((g) {
                  return g.nameBn.toLowerCase().contains(q) ||
                      g.nameAr.contains(q) ||
                      g.noteBn.toLowerCase().contains(q) ||
                      g.branchesBn.toLowerCase().contains(q) ||
                      g.motherBn.toLowerCase().contains(q);
                }).toList();

          if (nodes.isEmpty) return const SizedBox.shrink();

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.emerald,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        era.roman,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            era.titleBn,
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            era.subtitleBn,
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...nodes.map((node) {
                  final isFinalProphet = node.gen == 0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isFinalProphet
                          ? AppColors.emerald.withOpacity(isDark ? 0.2 : 0.08)
                          : (isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: node.isProphet
                            ? AppColors.amber.withOpacity(0.6)
                            : (isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: node.isProphet
                                          ? AppColors.amber
                                          : AppColors.emerald,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      isFinalProphet
                                          ? 'ﷺ'
                                          : '#${BengaliNumerals.toBengali(node.gen)}',
                                      style: GoogleFonts.hindSiliguri(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      node.nameBn,
                                      style: GoogleFonts.hindSiliguri(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (node.isProphet)
                              _pillBadge('✦ নবী', AppColors.amberDark),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          node.nameAr,
                          style: GoogleFonts.amiri(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.amber,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          node.noteBn,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        if (node.motherBn.isNotEmpty ||
                            node.branchesBn.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              if (node.motherBn.isNotEmpty)
                                Text(
                                  '👩 মাতা: ${node.motherBn}',
                                  style: GoogleFonts.hindSiliguri(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.emerald,
                                  ),
                                ),
                              if (node.branchesBn.isNotEmpty)
                                Text(
                                  '🌿 শাখা: ${node.branchesBn}',
                                  style: GoogleFonts.hindSiliguri(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.amberDark,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ===========================================================================
  // TAB 3: AHLUL BAYT & PROPHET'S HOUSEHOLD
  // ===========================================================================
  Widget _buildFamilyTab(bool isDark) {
    final q = _familyQuery.trim().toLowerCase();
    final filterTabs = [
      {'key': 'all', 'label': 'সকল পরিজন'},
      {'key': 'wives', 'label': 'উম্মাহাতুল মুমিনীন (১১)'},
      {'key': 'children', 'label': 'সন্তানগণ (৭)'},
      {'key': 'grandchildren', 'label': 'দৌহিত্র ও দৌহিত্রী'},
      {'key': 'relatives', 'label': 'পিতা-মাতা, চাচা-ফুফু ও দুধ-মাতা'},
    ];

    final categories = _selectedFamilyCategory == 'all'
        ? SeerahData.familyCategories
        : SeerahData.familyCategories
            .where((c) => c.key == _selectedFamilyCategory)
            .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filterTabs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final tab = filterTabs[index];
              final isSelected = _selectedFamilyCategory == tab['key'];
              return ChoiceChip(
                label: Text(
                  tab['label']!,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.emerald,
                backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                onSelected: (_) {
                  setState(() => _selectedFamilyCategory = tab['key']!);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        _buildSearchBox(
          hint: 'আহলে বাইত ও পরিবারের সদস্যদের নাম খুঁজুন...',
          value: _familyQuery,
          onChanged: (v) => setState(() => _familyQuery = v),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        ...categories.map((cat) {
          final members = q.isEmpty
              ? cat.members
              : cat.members.where((m) {
                  return m.nameBn.toLowerCase().contains(q) ||
                      m.nameAr.contains(q) ||
                      m.relationBn.toLowerCase().contains(q) ||
                      m.descBn.toLowerCase().contains(q);
                }).toList();

          if (members.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cat.titleBn,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emerald,
                      ),
                    ),
                    _pillBadge(cat.countBn, AppColors.amberDark),
                  ],
                ),
              ),
              ...members.map((m) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color:
                          isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _pillBadge(m.relationBn, AppColors.emerald),
                          Text(
                            m.lifeBn,
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        m.nameBn,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        m.nameAr,
                        style: GoogleFonts.amiri(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.amber,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        m.descBn,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12.5,
                          height: 1.45,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          );
        }),
      ],
    );
  }

  // ===========================================================================
  // TAB 4: COMPANIONS DIRECTORY (SAHABAH)
  // ===========================================================================
  Widget _buildCompanionsTab(bool isDark) {
    final q = _companionQuery.trim().toLowerCase();
    final roles = [
      {'id': 'all', 'label': 'সকল সাহাবী'},
      {'id': 'caliph', 'label': 'খুলাফায়ে রাশেদীন'},
      {'id': 'asharah', 'label': 'আশারায়ে মুবাশশারাহ'},
      {'id': 'muhajir', 'label': 'মুহাজির'},
      {'id': 'ansar', 'label': 'আনসার'},
      {'id': 'badri', 'label': 'বদরী সাহাবী'},
      {'id': 'martyr', 'label': 'শহীদ সাহাবী'},
      {'id': 'commander', 'label': 'সেনাপতি'},
      {'id': 'envoy', 'label': 'রাসূলের দূত'},
    ];

    final filtered = SeerahData.companions.where((c) {
      final matchesRole = _selectedCompanionRole == 'all' ||
          c.roles.contains(_selectedCompanionRole);
      final matchesQuery = q.isEmpty ||
          c.nameBn.toLowerCase().contains(q) ||
          c.nameAr.contains(q) ||
          c.laqabBn.toLowerCase().contains(q) ||
          c.bioBn.toLowerCase().contains(q);
      return matchesRole && matchesQuery;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: roles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final r = roles[index];
              final isSelected = _selectedCompanionRole == r['id'];
              return ChoiceChip(
                label: Text(
                  r['label']!,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.emerald,
                backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                onSelected: (_) {
                  setState(() => _selectedCompanionRole = r['id']!);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        _buildSearchBox(
          hint: 'সাহাবীর নাম, উপাধি বা অবদান দিয়ে খুঁজুন...',
          value: _companionQuery,
          onChanged: (v) => setState(() => _companionQuery = v),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        ...filtered.map((c) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: c.rolesBn
                      .map((role) => _pillBadge(role, AppColors.emerald))
                      .toList(),
                ),
                const SizedBox(height: 6),
                Text(
                  c.nameBn,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  c.nameAr,
                  style: GoogleFonts.amiri(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.amber,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'উপাধি: ${c.laqabBn}',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.emerald,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  c.bioBn,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12.5,
                    height: 1.45,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ইসলাম গ্রহণ: ${c.acceptedBn}',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.amberDark,
                      ),
                    ),
                    Text(
                      c.lifeBn,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ===========================================================================
  // TAB 5: BATTLES & EXPEDITIONS (GHAZWAT & SARAYA + LOGARITHMIC CHART)
  // ===========================================================================
  Widget _buildBattlesTab(bool isDark) {
    final q = _battleQuery.trim().toLowerCase();
    final filters = [
      {'id': 'all', 'label': 'সকল অভিযান (${BengaliNumerals.toBengali(SeerahData.battles.length)})'},
      {'id': 'ghazwah', 'label': 'গাযওয়া (রাসূল ﷺ নেতৃত্ব দেন)'},
      {'id': 'sariyyah', 'label': 'সারিয়্যাহ (অভিযান)'},
    ];

    final filtered = SeerahData.battles.where((b) {
      final matchesType =
          _selectedBattleFilter == 'all' || b.type == _selectedBattleFilter;
      final matchesQuery = q.isEmpty ||
          b.nameBn.toLowerCase().contains(q) ||
          b.nameAr.contains(q) ||
          b.locationBn.toLowerCase().contains(q) ||
          b.summaryBn.toLowerCase().contains(q);
      return matchesType && matchesQuery;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Logarithmic Army Size Comparison Card
        _buildBattleComparisonChart(isDark),
        const SizedBox(height: 14),

        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final f = filters[index];
              final isSelected = _selectedBattleFilter == f['id'];
              return ChoiceChip(
                label: Text(
                  f['label']!,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.emerald,
                backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                onSelected: (_) {
                  setState(() => _selectedBattleFilter = f['id']!);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        _buildSearchBox(
          hint: 'গাযওয়া বা অভিযানের নাম খুঁজুন (বদর, উহুদ, খন্দক, খায়বার, তাবুক)...',
          value: _battleQuery,
          onChanged: (v) => setState(() => _battleQuery = v),
          isDark: isDark,
        ),
        const SizedBox(height: 12),

        ...filtered.map((b) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _pillBadge(b.yearAh, AppColors.emerald),
                    _pillBadge(b.typeBn, AppColors.amberDark),
                    _pillBadge(b.outcomeBn, const Color(0xFF0284C7)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  b.nameBn,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  b.nameAr,
                  style: GoogleFonts.amiri(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.amber,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🛡️ মুসলিম বাহিনী: ${b.muslimForceBn} (${b.muslimCmdBn})',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '⚔️ প্রতিপক্ষ বাহিনী: ${b.enemyForceBn} (${b.enemyCmdBn})',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFE11D48),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '📊 ফলাফল ও ক্ষয়ক্ষতি: ${b.lossesBn}',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  b.summaryBn,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12.5,
                    height: 1.45,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '📍 ${b.locationBn}  •  🗓️ ${b.dateBn}',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.emerald,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBattleComparisonChart(bool isDark) {
    final chartBattles = SeerahData.battles
        .where((b) => b.muslimForceNum >= 300)
        .toList();
    final maxLog = math.log(100000);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'সৈন্যসংখ্যার তুলনামূলক চিত্র (লগারিদমিক স্কেল)',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              Row(
                children: [
                  _legendDot('মুসলিম', AppColors.emerald, isDark),
                  const SizedBox(width: 8),
                  _legendDot('প্রতিপক্ষ', const Color(0xFFE11D48), isDark),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...chartBattles.map((b) {
            final mRatio =
                (math.log(math.max(b.muslimForceNum, 10)) / maxLog).clamp(0.1, 1.0);
            final eRatio =
                (math.log(math.max(b.enemyForceNum, 10)) / maxLog).clamp(0.1, 1.0);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${b.nameBn} (${b.yearAh})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      Text(
                        '${BengaliNumerals.toBengali(b.muslimForceNum)} বনাম ${BengaliNumerals.toBengali(b.enemyForceNum)}',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: mRatio,
                      minHeight: 5,
                      backgroundColor: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.emerald,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: eRatio,
                      minHeight: 5,
                      backgroundColor: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFE11D48),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _legendDot(String label, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.hindSiliguri(
            fontSize: 10.5,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBox({
    required String hint,
    required String value,
    required ValueChanged<String> onChanged,
    required bool isDark,
  }) {
    return TextField(
      onChanged: onChanged,
      style: GoogleFonts.hindSiliguri(fontSize: 13.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.hindSiliguri(fontSize: 12.5),
        prefixIcon: const Icon(Icons.search, color: AppColors.emerald, size: 20),
        isDense: true,
        filled: true,
        fillColor: isDark ? AppColors.cardDark : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
    );
  }

  Widget _pillBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: GoogleFonts.hindSiliguri(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _SeerahMapPainter extends CustomPainter {
  final List<SeerahEvent> events;
  final int activeIndex;
  final bool isDark;

  _SeerahMapPainter({
    required this.events,
    required this.activeIndex,
    required this.isDark,
  });

  // Bounding box covering Abyssinia, Makkah, Madinah, Khaybar, Tabuk, and Jerusalem
  static const double minLat = 13.0;
  static const double maxLat = 33.2;
  static const double minLng = 34.0;
  static const double maxLng = 43.5;

  static Offset project(double lat, double lng, Size size) {
    const padX = 24.0;
    const padY = 28.0;
    final usableW = size.width - padX * 2;
    final usableH = size.height - padY * 2;
    final x = padX + ((lng - minLng) / (maxLng - minLng)).clamp(0.0, 1.0) * usableW;
    final y = padY + (1.0 - ((lat - minLat) / (maxLat - minLat)).clamp(0.0, 1.0)) * usableH;
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle lat/lng grid lines
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.06)
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      final dy = size.height * (i / 5);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
      final dx = size.width * (i / 5);
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), gridPaint);
    }

    // Draw route lines connecting events chronologically
    if (events.length > 1) {
      final linePaint = Paint()
        ..color = AppColors.emerald.withOpacity(0.45)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      final path = Path();
      for (int i = 0; i < events.length; i++) {
        final pt = project(events[i].lat, events[i].lng, size);
        if (i == 0) {
          path.moveTo(pt.dx, pt.dy);
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      canvas.drawPath(path, linePaint);
    }

    // Draw reference city labels (Makkah, Madinah, Jerusalem, Abyssinia)
    final cities = [
      {'name': 'মক্কা', 'lat': 21.4225, 'lng': 39.8262},
      {'name': 'মদিনা', 'lat': 24.4672, 'lng': 39.6112},
      {'name': 'বাইতুল মুকাদ্দাস', 'lat': 31.7761, 'lng': 35.2358},
      {'name': 'হাবশা', 'lat': 14.1211, 'lng': 38.7233},
      {'name': 'তাবুক', 'lat': 28.3835, 'lng': 36.5662},
    ];

    for (final c in cities) {
      final pt = project(c['lat'] as double, c['lng'] as double, size);
      final tp = TextPainter(
        text: TextSpan(
          text: c['name'] as String,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: (isDark ? Colors.white70 : Colors.black87).withOpacity(0.65),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(pt.dx + 8, pt.dy - 6));
    }

    // Draw pins for each event
    for (int i = 0; i < events.length; i++) {
      final isSelected = i == activeIndex;
      final pt = project(events[i].lat, events[i].lng, size);

      if (isSelected) {
        final haloPaint = Paint()
          ..color = AppColors.amber.withOpacity(0.32)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pt, 16, haloPaint);
      }

      final pinPaint = Paint()
        ..color = isSelected ? AppColors.amber : AppColors.emerald
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pt, isSelected ? 10 : 7.5, pinPaint);

      final borderPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(pt, isSelected ? 10 : 7.5, borderPaint);

      final tp = TextPainter(
        text: TextSpan(
          text: BengaliNumerals.toBengali(i + 1),
          style: TextStyle(
            fontSize: isSelected ? 9.5 : 8,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(pt.dx - tp.width / 2, pt.dy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _SeerahMapPainter oldDelegate) {
    return oldDelegate.events != events ||
        oldDelegate.activeIndex != activeIndex ||
        oldDelegate.isDark != isDark;
  }
}
