import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/momo_button.dart';
import '../../models/entity_status.dart';
import '../../providers/current_user_provider.dart';
import '../../providers/group_provider.dart';

/// Event Announcement detail with local RSVP (참석 / 불참).
class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    final ampm = local.hour < 12 ? '오전' : '오후';
    final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.month}월 ${local.day}일 $ampm $hour12:$minute';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(groupProvider);
    final event = ref.read(groupProvider.notifier).eventById(eventId);
    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event')),
        body: const Center(child: Text('Event not found')),
      );
    }

    final rsvps = ref.read(groupProvider.notifier).rsvpsOf(event.id);
    final attending =
        rsvps.where((r) => r.status == RsvpStatus.attending).toList();
    final notAttending =
        rsvps.where((r) => r.status == RsvpStatus.notAttending).toList();
    final userId = ref.watch(currentUserProvider).id;
    RsvpStatus? mine;
    for (final r in rsvps) {
      if (r.userId == userId) {
        mine = r.status;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Event Announcement')),
      body: ListView(
        padding: AppSpacing.page,
        children: [
          Text(event.title, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(_formatDate(event.dateTime), style: AppTextStyles.body),
          Text(event.location, style: AppTextStyles.body),
          if (event.childAgeRange.isNotEmpty)
            Text(event.childAgeRange, style: AppTextStyles.caption),
          if (event.participantLimit != null)
            Text('정원 ${event.participantLimit}명', style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.md),
          Text(event.description, style: AppTextStyles.bodySmall),
          const SizedBox(height: AppSpacing.sm),
          Text('주최 ${event.creatorName}', style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.xl),
          const Text('내 응답', style: AppTextStyles.subtitle),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: MomoButton(
                  label: mine == RsvpStatus.attending ? '참석 ✓' : '참석',
                  onPressed: () {
                    ref.read(groupProvider.notifier).setRsvp(
                          eventId: event.id,
                          status: RsvpStatus.attending,
                        );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(groupProvider.notifier).setRsvp(
                          eventId: event.id,
                          status: RsvpStatus.notAttending,
                        );
                  },
                  child: Text(
                    mine == RsvpStatus.notAttending ? '불참 ✓' : '불참',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('참석 (${attending.length})', style: AppTextStyles.subtitle),
          const SizedBox(height: AppSpacing.sm),
          if (attending.isEmpty)
            const Text('아직 참석자가 없습니다.', style: AppTextStyles.caption)
          else
            ...attending.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text('· ${r.userName}', style: AppTextStyles.bodySmall),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          Text('불참 (${notAttending.length})', style: AppTextStyles.subtitle),
          const SizedBox(height: AppSpacing.sm),
          if (notAttending.isEmpty)
            const Text('아직 불참 응답이 없습니다.', style: AppTextStyles.caption)
          else
            ...notAttending.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text('· ${r.userName}', style: AppTextStyles.bodySmall),
              ),
            ),
        ],
      ),
    );
  }
}
