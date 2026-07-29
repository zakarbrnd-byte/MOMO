import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/momo_card.dart';
import '../../models/entity_status.dart';
import '../../models/group.dart';
import '../../models/post.dart';
import '../../navigation/app_navigation.dart';
import '../../providers/group_provider.dart';
import '../../providers/post_provider.dart';
import '../detail/event_detail_screen.dart';
import '../detail/post_detail_screen.dart';
import 'group_info_screen.dart';

/// Content-first Group community surface: Posts · Events · Members.
///
/// Static group info, join/leave, and event creation live on [GroupInfoScreen].
class GroupDetailScreen extends ConsumerStatefulWidget {
  const GroupDetailScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(groupProvider);
    ref.watch(postProvider);
    final groups = ref.watch(groupProvider).valueOrNull ?? const <Group>[];
    Group? group;
    for (final g in groups) {
      if (g.id == widget.groupId) {
        group = g;
        break;
      }
    }
    group ??= ref.read(groupProvider.notifier).getById(widget.groupId);

    if (group == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Group')),
        body: const Center(child: Text('Group not found')),
      );
    }

    final current = group;
    final members = ref.read(groupProvider.notifier).membersOf(current.id);
    final events = ref.read(groupProvider.notifier).eventsOf(current.id);
    final posts = ref.read(postProvider.notifier).postsByGroup(current.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          current.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: '모임 정보',
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              AppNavigation.pushPage(
                context,
                GroupInfoScreen(groupId: current.id),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabs,
            labelColor: AppColors.primaryDark,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(text: 'Posts'),
              Tab(text: 'Events'),
              Tab(text: 'Members'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _PostsTab(posts: posts),
                _EventsTab(events: events),
                _MembersTab(members: members),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostsTab extends StatelessWidget {
  const _PostsTab({required this.posts});

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(
        child: Text('아직 게시글이 없습니다.', style: AppTextStyles.bodyMedium),
      );
    }
    return ListView.separated(
      padding: _tabListPadding(context),
      itemCount: posts.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppSpacing.cardListGap),
      itemBuilder: (context, index) {
        final post = posts[index];
        return MomoCard(
          onTap: () {
            AppNavigation.pushPage(context, PostDetailScreen(post: post));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title, style: AppTextStyles.cardTitle),
              const SizedBox(height: AppSpacing.sm),
              Text(
                post.content,
                style: AppTextStyles.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(post.authorName, style: AppTextStyles.caption),
            ],
          ),
        );
      },
    );
  }
}

class _EventsTab extends ConsumerWidget {
  const _EventsTab({required this.events});

  final List<EventAnnouncement> events;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (events.isEmpty) {
      return const Center(
        child: Text('예정된 이벤트가 없습니다.', style: AppTextStyles.bodyMedium),
      );
    }
    return ListView.separated(
      padding: _tabListPadding(context),
      itemCount: events.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppSpacing.cardListGap),
      itemBuilder: (context, index) {
        final event = events[index];
        final rsvps = ref.read(groupProvider.notifier).rsvpsOf(event.id);
        final attending =
            rsvps.where((r) => r.status == RsvpStatus.attending).length;
        final notAttending =
            rsvps.where((r) => r.status == RsvpStatus.notAttending).length;
        final local = event.dateTime.toLocal();
        final ampm = local.hour < 12 ? '오전' : '오후';
        final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
        final minute = local.minute.toString().padLeft(2, '0');
        final when = '${local.month}월 ${local.day}일 $ampm $hour12:$minute';

        return MomoCard(
          onTap: () {
            AppNavigation.pushPage(
              context,
              EventDetailScreen(eventId: event.id),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.title, style: AppTextStyles.cardTitle),
              const SizedBox(height: AppSpacing.sm),
              Text(when, style: AppTextStyles.bodySmall),
              Text(event.location, style: AppTextStyles.bodySmall),
              if (event.childAgeRange.isNotEmpty)
                Text(event.childAgeRange, style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '참석 $attending · 불참 $notAttending'
                '${event.participantLimit == null ? '' : ' · 정원 ${event.participantLimit}'}',
                style: AppTextStyles.caption,
              ),
              Text('주최 ${event.creatorName}', style: AppTextStyles.caption),
            ],
          ),
        );
      },
    );
  }
}

class _MembersTab extends StatelessWidget {
  const _MembersTab({required this.members});

  final List<GroupMember> members;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const Center(
        child: Text('표시할 멤버가 없습니다.', style: AppTextStyles.bodyMedium),
      );
    }
    return ListView.separated(
      padding: _tabListPadding(context),
      itemCount: members.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final member = members[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: AppColors.primarySoft,
            foregroundColor: AppColors.primaryDark,
            child: Text(
              _initial(member.userName),
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          title: Text(member.userName, style: AppTextStyles.bodyMedium),
          subtitle: member.role == GroupMemberRole.member
              ? null
              : Text(_roleLabel(member.role), style: AppTextStyles.caption),
        );
      },
    );
  }

  static String _initial(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return String.fromCharCode(trimmed.runes.first);
  }

  static String _roleLabel(GroupMemberRole role) {
    return switch (role) {
      GroupMemberRole.owner => 'Owner',
      GroupMemberRole.admin => 'Admin',
      GroupMemberRole.member => 'Member',
    };
  }
}

EdgeInsets _tabListPadding(BuildContext context) {
  final bottomInset = MediaQuery.paddingOf(context).bottom;
  return EdgeInsets.fromLTRB(
    AppSpacing.xl,
    AppSpacing.sm,
    AppSpacing.xl,
    AppSpacing.xl + bottomInset,
  );
}
