import '../models/comment.dart';
import 'mock_groups.dart';
import 'mock_user.dart';

/// Fixed seed clock for comment mocks (aligned with group/post seeds).
final DateTime mockCommentSeedNow = mockGroupSeedNow;

/// Deterministic Korean mock comments / one-level replies.
///
/// Posts with seeded threads:
/// - [gpo_la3_1] Lafayette Park — comments + replies
/// - [gpo_global_1] 소아과 — comments + replies
/// - [gpo_global_6] 기저귀 — no comments (empty)
final mockComments = <Comment>[
  // ── gpo_la3_1 ─────────────────────────────────────────────────────────
  Comment(
    id: 'cmt_la3_1_a',
    postId: 'gpo_la3_1',
    authorId: 'mom_minji',
    authorName: '박민지',
    body: '저도 이번 주말에 가려고 했어요!',
    createdAt: mockCommentSeedNow.subtract(
      const Duration(hours: 1, minutes: 40),
    ),
  ),
  Comment(
    id: 'cmt_la3_1_a1',
    postId: 'gpo_la3_1',
    authorId: 'mom_yuna',
    authorName: '최유나',
    body: '몇 시쯤 가실 예정이에요?',
    createdAt: mockCommentSeedNow.subtract(
      const Duration(hours: 1, minutes: 20),
    ),
    parentCommentId: 'cmt_la3_1_a',
  ),
  Comment(
    id: 'cmt_la3_1_a2',
    postId: 'gpo_la3_1',
    authorId: currentUserId,
    authorName: '장하은',
    body: '저도 같이 가도 될까요?',
    createdAt: mockCommentSeedNow.subtract(const Duration(hours: 1)),
    parentCommentId: 'cmt_la3_1_a',
  ),
  Comment(
    id: 'cmt_la3_1_b',
    postId: 'gpo_la3_1',
    authorId: 'mom_jiwoo',
    authorName: '한지우',
    body: '날씨 좋으면 돗자리도 챙길게요!',
    createdAt: mockCommentSeedNow.subtract(const Duration(minutes: 50)),
  ),
  Comment(
    id: 'cmt_la3_1_b1',
    postId: 'gpo_la3_1',
    authorId: 'mom_sora',
    authorName: '김소라',
    body: '좋아요~ 간식은 각자 조금씩 가져와요.',
    createdAt: mockCommentSeedNow.subtract(const Duration(minutes: 30)),
    parentCommentId: 'cmt_la3_1_b',
  ),

  // ── gpo_global_1 ──────────────────────────────────────────────────────
  Comment(
    id: 'cmt_g1_a',
    postId: 'gpo_global_1',
    authorId: 'mom_sora',
    authorName: '김소라',
    body: '한인타운 CHA 소아과 한국어 잘 돼요. 예약은 조금 미리 하세요!',
    createdAt: mockCommentSeedNow.subtract(
      const Duration(hours: 2, minutes: 30),
    ),
  ),
  Comment(
    id: 'cmt_g1_a1',
    postId: 'gpo_global_1',
    authorId: 'mom_eunji',
    authorName: '한은지',
    body: '선생님 성함 기억나시면 알려주세요~',
    createdAt: mockCommentSeedNow.subtract(const Duration(hours: 2)),
    parentCommentId: 'cmt_g1_a',
  ),
  Comment(
    id: 'cmt_g1_b',
    postId: 'gpo_global_1',
    authorId: 'mom_hyejin',
    authorName: '이혜진',
    body: 'Torrance 쪽도 괜찮은데 대기가 길어요. 급한 날은 한인타운이 나았어요.',
    createdAt: mockCommentSeedNow.subtract(
      const Duration(hours: 1, minutes: 15),
    ),
  ),
];

/// Comment totals for seeded posts (comments + replies).
const mockCommentCountsByPostId = <String, int>{
  'gpo_la3_1': 5,
  'gpo_global_1': 3,
  'gpo_global_6': 0,
};
