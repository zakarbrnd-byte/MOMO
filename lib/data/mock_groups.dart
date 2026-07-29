import '../models/entity_status.dart';
import '../models/group.dart';
import '../models/post.dart';
import 'mock_user.dart';

/// Fixed seed clock for Group / Event / RSVP / group-post mocks.
///
/// Same instant as [mockFeedSeedNow] so relative ages stay coherent in demos.
final DateTime mockGroupSeedNow = DateTime.utc(2026, 7, 28, 21, 0, 0);

// ── Groups ──────────────────────────────────────────────────────────────

final groupLa3 = Group(
  id: 'grp_la3',
  name: 'LA 3살 아이 엄마 모임',
  description: '한인타운·LA 근처 세 살 전후 아이 엄마들 모임이에요. '
      '놀이터·도서관·키즈카페 같이 가고, 육아 고민도 편하게 나눠요.',
  category: '육아',
  location: 'Koreatown, Los Angeles',
  childAgeRanges: const ['2–4세', '3세'],
  interestTags: const ['놀이터', '도서관', '한인타운'],
  ownerId: 'mom_sora',
  ownerName: '김소라',
  memberCount: 5,
  coverEmoji: '🧸',
  isFeatured: true,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 90)),
  recentActivityAt: mockGroupSeedNow.subtract(const Duration(hours: 2)),
);

final groupOcWork = Group(
  id: 'grp_ocwork',
  name: 'OC 워킹맘 모임',
  description: 'Irvine·Orange County 워킹맘 모임입니다. '
      '주말 일정, 방과 후, 육아·일 밸런스 정보를 나눠요.',
  category: '워킹맘',
  location: 'Irvine, Orange County',
  childAgeRanges: const ['3–6세', '초등'],
  interestTags: const ['워킹맘', '주말', 'Irvine'],
  ownerId: 'mom_eunji',
  ownerName: '한은지',
  memberCount: 4,
  coverEmoji: '💼',
  isFeatured: false,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 60)),
  recentActivityAt: mockGroupSeedNow.subtract(const Duration(hours: 6)),
);

final groupSwim = Group(
  id: 'grp_swim',
  name: '수영 배우는 아이 엄마들',
  description: '아이 수영 클래스 정보 공유하고, 연습 후 간식·수다도 해요. '
      '물 무서운 아이도 환영입니다!',
  category: '취미·운동',
  location: 'Torrance / South Bay',
  childAgeRanges: const ['3–5세', '4–6세'],
  interestTags: const ['수영', 'YMCA', '운동'],
  ownerId: 'mom_yuna',
  ownerName: '최유나',
  memberCount: 4,
  coverEmoji: '🏊',
  isFeatured: false,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 45)),
  recentActivityAt: mockGroupSeedNow.subtract(const Duration(hours: 12)),
);

final groupPreschool = Group(
  id: 'grp_preschool',
  name: '한인 프리스쿨 정보방',
  description: 'LA·OC 한인 프리스쿨·킨더·TK 정보 나눔방. '
      '입학 준비, 도시락, 적응기 팁을 공유해요.',
  category: '학교·킨더',
  location: 'Los Angeles / Orange County',
  childAgeRanges: const ['3–5세', 'TK·킨더'],
  interestTags: const ['프리스쿨', '킨더', '입학'],
  ownerId: 'mom_minji',
  ownerName: '박민지',
  memberCount: 3,
  coverEmoji: '📚',
  isFeatured: false,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 120)),
  recentActivityAt: mockGroupSeedNow.subtract(const Duration(days: 1)),
);

final groupPark = Group(
  id: 'grp_park',
  name: '주말 공원 나들이 모임',
  description: '주말에 공원·피크닉·산책 같이 가요. '
      '날씨 좋을 때 번개로 모이고, 돗자리·간식만 챙겨오세요.',
  category: '야외·나들이',
  location: 'LA / OC parks',
  childAgeRanges: const ['1–3세', '3–5세'],
  interestTags: const ['공원', '피크닉', '주말'],
  ownerId: 'mom_hyejin',
  ownerName: '이혜진',
  memberCount: 5,
  coverEmoji: '🌳',
  isFeatured: false,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 30)),
  recentActivityAt: mockGroupSeedNow.subtract(const Duration(hours: 4)),
);

final groupBook = Group(
  id: 'grp_book',
  name: 'LA 한국어 책 읽기 모임',
  description: '한인타운·인근 도서관에서 한국어 그림책·동화 같이 읽어요. '
      '아이 연령에 맞는 책 추천도 나눕니다.',
  category: '육아',
  location: 'Koreatown, Los Angeles',
  childAgeRanges: const ['2–4세', '3–5세'],
  interestTags: const ['도서관', '한국어', '책'],
  ownerId: 'mom_sora',
  ownerName: '김소라',
  memberCount: 6,
  coverEmoji: '📖',
  isFeatured: true,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 14)),
  recentActivityAt: mockGroupSeedNow.subtract(const Duration(hours: 5)),
);

final groupTorrance = Group(
  id: 'grp_torrance',
  name: '토런스 초등맘 정보 모임',
  description: 'Torrance·South Bay 초등 엄마들 정보 공유. '
      '방과후, 학원, 급식·캠퍼스 생활 tip을 나눠요.',
  category: '학교·킨더',
  location: 'Torrance / South Bay',
  childAgeRanges: const ['초등', '6–8세'],
  interestTags: const ['초등', '방과후', 'Torrance'],
  ownerId: 'mom_yuna',
  ownerName: '최유나',
  memberCount: 3,
  coverEmoji: '🎒',
  isFeatured: false,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 75)),
  recentActivityAt: mockGroupSeedNow.subtract(const Duration(days: 2)),
);

final groupPasadena = Group(
  id: 'grp_pasadena',
  name: 'Pasadena 자연놀이 모임',
  description: 'Pasadena·Glendale 쪽 자연·하이킹·공원 놀이 모임. '
      '날씨 좋은 날 가벼운 산책부터 시작해요.',
  category: '야외·나들이',
  location: 'Pasadena / Glendale',
  childAgeRanges: const ['2–4세', '4–6세'],
  interestTags: const ['자연놀이', '하이킹', '공원'],
  ownerId: 'mom_jiwoo',
  ownerName: '한지우',
  memberCount: 4,
  coverEmoji: '🥾',
  isFeatured: false,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 10)),
  recentActivityAt: mockGroupSeedNow.subtract(const Duration(hours: 9)),
);

final groupCafe = Group(
  id: 'grp_cafe',
  name: '한인타운 키즈카페 수다',
  description: '한인타운 키즈카페에서 비 오는 날·더운 날 모여요. '
      '카페 후기랑 할인 정보도 공유합니다.',
  category: '육아',
  location: 'Koreatown, Los Angeles',
  childAgeRanges: const ['1–3세', '2–4세'],
  interestTags: const ['키즈카페', '한인타운', '실내'],
  ownerId: 'mom_minji',
  ownerName: '박민지',
  memberCount: 4,
  coverEmoji: '☕',
  isFeatured: false,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 7)),
  recentActivityAt: mockGroupSeedNow.subtract(const Duration(hours: 1)),
);

final groupOcPark = Group(
  id: 'grp_ocpark',
  name: 'OC 주말 놀이터 모임',
  description: 'Irvine·Orange County 주말 놀이터 번개. '
      '워킹맘·전업맘 모두 환영이에요.',
  category: '야외·나들이',
  location: 'Irvine, Orange County',
  childAgeRanges: const ['2–4세', '3–6세'],
  interestTags: const ['놀이터', '주말', 'Irvine'],
  ownerId: 'mom_eunji',
  ownerName: '한은지',
  memberCount: 3,
  coverEmoji: '🛝',
  isFeatured: false,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 5)),
  recentActivityAt: mockGroupSeedNow.subtract(const Duration(hours: 3)),
);

final mockGroups = [
  groupLa3,
  groupOcWork,
  groupSwim,
  groupPreschool,
  groupPark,
  groupBook,
  groupTorrance,
  groupPasadena,
  groupCafe,
  groupOcPark,
];

// ── Members ─────────────────────────────────────────────────────────────
// currentUserId is a member of grp_la3 and grp_park only.

final mockGroupMembers = [
  // grp_la3
  GroupMember(
    groupId: 'grp_la3',
    userId: 'mom_sora',
    userName: '김소라',
    role: GroupMemberRole.owner,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 90)),
  ),
  GroupMember(
    groupId: 'grp_la3',
    userId: currentUserId,
    userName: '장하은',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 40)),
  ),
  GroupMember(
    groupId: 'grp_la3',
    userId: 'mom_yuna',
    userName: '최유나',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 70)),
  ),
  GroupMember(
    groupId: 'grp_la3',
    userId: 'mom_minji',
    userName: '박민지',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 55)),
  ),
  GroupMember(
    groupId: 'grp_la3',
    userId: 'mom_jiwoo',
    userName: '한지우',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 20)),
  ),

  // grp_ocwork
  GroupMember(
    groupId: 'grp_ocwork',
    userId: 'mom_eunji',
    userName: '한은지',
    role: GroupMemberRole.owner,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 60)),
  ),
  GroupMember(
    groupId: 'grp_ocwork',
    userId: 'mom_hyejin',
    userName: '이혜진',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 50)),
  ),
  GroupMember(
    groupId: 'grp_ocwork',
    userId: 'mom_minji',
    userName: '박민지',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 35)),
  ),
  GroupMember(
    groupId: 'grp_ocwork',
    userId: 'mom_sora',
    userName: '김소라',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 28)),
  ),

  // grp_swim
  GroupMember(
    groupId: 'grp_swim',
    userId: 'mom_yuna',
    userName: '최유나',
    role: GroupMemberRole.owner,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 45)),
  ),
  GroupMember(
    groupId: 'grp_swim',
    userId: 'mom_jiwoo',
    userName: '한지우',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 40)),
  ),
  GroupMember(
    groupId: 'grp_swim',
    userId: 'mom_eunji',
    userName: '한은지',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 30)),
  ),
  GroupMember(
    groupId: 'grp_swim',
    userId: 'mom_hyejin',
    userName: '이혜진',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 15)),
  ),

  // grp_preschool
  GroupMember(
    groupId: 'grp_preschool',
    userId: 'mom_minji',
    userName: '박민지',
    role: GroupMemberRole.owner,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 120)),
  ),
  GroupMember(
    groupId: 'grp_preschool',
    userId: 'mom_sora',
    userName: '김소라',
    role: GroupMemberRole.admin,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 100)),
  ),
  GroupMember(
    groupId: 'grp_preschool',
    userId: 'mom_yuna',
    userName: '최유나',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 80)),
  ),

  // grp_park
  GroupMember(
    groupId: 'grp_park',
    userId: 'mom_hyejin',
    userName: '이혜진',
    role: GroupMemberRole.owner,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 30)),
  ),
  GroupMember(
    groupId: 'grp_park',
    userId: currentUserId,
    userName: '장하은',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 18)),
  ),
  GroupMember(
    groupId: 'grp_park',
    userId: 'mom_jiwoo',
    userName: '한지우',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 25)),
  ),
  GroupMember(
    groupId: 'grp_park',
    userId: 'mom_eunji',
    userName: '한은지',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 12)),
  ),
  GroupMember(
    groupId: 'grp_park',
    userId: 'mom_sora',
    userName: '김소라',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 8)),
  ),

  // grp_book
  GroupMember(
    groupId: 'grp_book',
    userId: 'mom_sora',
    userName: '김소라',
    role: GroupMemberRole.owner,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 14)),
  ),
  GroupMember(
    groupId: 'grp_book',
    userId: 'mom_minji',
    userName: '박민지',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 12)),
  ),
  GroupMember(
    groupId: 'grp_book',
    userId: 'mom_yuna',
    userName: '최유나',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 10)),
  ),
  GroupMember(
    groupId: 'grp_book',
    userId: 'mom_jiwoo',
    userName: '한지우',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 9)),
  ),
  GroupMember(
    groupId: 'grp_book',
    userId: 'mom_hyejin',
    userName: '이혜진',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 6)),
  ),
  GroupMember(
    groupId: 'grp_book',
    userId: 'mom_eunji',
    userName: '한은지',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 4)),
  ),

  // grp_torrance
  GroupMember(
    groupId: 'grp_torrance',
    userId: 'mom_yuna',
    userName: '최유나',
    role: GroupMemberRole.owner,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 75)),
  ),
  GroupMember(
    groupId: 'grp_torrance',
    userId: 'mom_jiwoo',
    userName: '한지우',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 60)),
  ),
  GroupMember(
    groupId: 'grp_torrance',
    userId: 'mom_eunji',
    userName: '한은지',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 40)),
  ),

  // grp_pasadena
  GroupMember(
    groupId: 'grp_pasadena',
    userId: 'mom_jiwoo',
    userName: '한지우',
    role: GroupMemberRole.owner,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 10)),
  ),
  GroupMember(
    groupId: 'grp_pasadena',
    userId: 'mom_sora',
    userName: '김소라',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 8)),
  ),
  GroupMember(
    groupId: 'grp_pasadena',
    userId: 'mom_hyejin',
    userName: '이혜진',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 7)),
  ),
  GroupMember(
    groupId: 'grp_pasadena',
    userId: 'mom_minji',
    userName: '박민지',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 5)),
  ),

  // grp_cafe
  GroupMember(
    groupId: 'grp_cafe',
    userId: 'mom_minji',
    userName: '박민지',
    role: GroupMemberRole.owner,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 7)),
  ),
  GroupMember(
    groupId: 'grp_cafe',
    userId: 'mom_sora',
    userName: '김소라',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 6)),
  ),
  GroupMember(
    groupId: 'grp_cafe',
    userId: 'mom_yuna',
    userName: '최유나',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 5)),
  ),
  GroupMember(
    groupId: 'grp_cafe',
    userId: 'mom_jiwoo',
    userName: '한지우',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 3)),
  ),

  // grp_ocpark
  GroupMember(
    groupId: 'grp_ocpark',
    userId: 'mom_eunji',
    userName: '한은지',
    role: GroupMemberRole.owner,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 5)),
  ),
  GroupMember(
    groupId: 'grp_ocpark',
    userId: 'mom_hyejin',
    userName: '이혜진',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 4)),
  ),
  GroupMember(
    groupId: 'grp_ocpark',
    userId: 'mom_minji',
    userName: '박민지',
    role: GroupMemberRole.member,
    joinedAt: mockGroupSeedNow.subtract(const Duration(days: 2)),
  ),
];

// ── Group posts ─────────────────────────────────────────────────────────

final mockGroupPosts = [
  // grp_la3
  Post(
    id: 'gpo_la3_1',
    title: '이번 주 Lafayette Park 가실 분?',
    content: '토요일 오전 10시에 Lafayette Park 놀이터에서 만나면 어떨까요? '
        '간식이랑 물만 챙겨오시면 돼요. 3살 전후 아이들끼리 놀기 좋아요!',
    authorName: '김소라',
    creatorId: 'mom_sora',
    groupId: 'grp_la3',
    groupName: 'LA 3살 아이 엄마 모임',
    category: PostCategory.local,
    viewCount: 142,
    commentCount: 9,
    likeCount: 21,
    createdAt: mockGroupSeedNow.subtract(const Duration(hours: 2)),
  ),
  Post(
    id: 'gpo_la3_2',
    title: '낮잠 안 자는 아이 어떻게 하세요?',
    content: '요즘 낮잠을 갑자기 안 자네요 ㅠㅠ 저녁에 너무 피곤해해서 걱정이에요. '
        '같은 나이대 엄마들 어떻게 하시나요?',
    authorName: '장하은',
    creatorId: currentUserId,
    groupId: 'grp_la3',
    groupName: 'LA 3살 아이 엄마 모임',
    category: PostCategory.parenting,
    viewCount: 198,
    commentCount: 14,
    likeCount: 27,
    createdAt: mockGroupSeedNow.subtract(const Duration(hours: 8)),
  ),
  Post(
    id: 'gpo_la3_3',
    title: '한인타운 키즈카페 추천 부탁드려요',
    content: '비 오는 날 갈 만한 키즈카페 Koreatown 근처에 있을까요? '
        '자리가 너무 붐비지 않는 곳이면 좋겠어요.',
    authorName: '최유나',
    creatorId: 'mom_yuna',
    groupId: 'grp_la3',
    groupName: 'LA 3살 아이 엄마 모임',
    category: PostCategory.local,
    viewCount: 167,
    commentCount: 11,
    likeCount: 19,
    createdAt: mockGroupSeedNow.subtract(const Duration(days: 1)),
  ),
  Post(
    id: 'gpo_la3_4',
    title: '영어·한국어 병행 어떻게 하세요?',
    content: '집에서 한국어, 밖에서는 영어라 아이가 가끔 헷갈려해요. '
        '엄마들 언어 루틴 있으면 공유해주세요!',
    authorName: '박민지',
    creatorId: 'mom_minji',
    groupId: 'grp_la3',
    groupName: 'LA 3살 아이 엄마 모임',
    category: PostCategory.parenting,
    viewCount: 221,
    commentCount: 18,
    likeCount: 33,
    createdAt: mockGroupSeedNow.subtract(const Duration(days: 2)),
  ),

  // grp_ocwork
  Post(
    id: 'gpo_oc_1',
    title: '주말 데이케어 대타 있으신가요?',
    content: '토요일 오전에 반나절만 일이 생겼어요. Irvine 쪽 믿을 만한 babysitter '
        '아시는 분 계신가요?',
    authorName: '한은지',
    creatorId: 'mom_eunji',
    groupId: 'grp_ocwork',
    groupName: 'OC 워킹맘 모임',
    category: PostCategory.parenting,
    viewCount: 156,
    commentCount: 7,
    likeCount: 12,
    createdAt: mockGroupSeedNow.subtract(const Duration(hours: 6)),
  ),
  Post(
    id: 'gpo_oc_2',
    title: 'Irvine 방과후 프로그램 추천',
    content: '내년에 TK 들어가는데 방과후 enrichment 알아보고 있어요. '
        '스포츠·미술 중에 괜찮았던 곳 있으면 알려주세요!',
    authorName: '이혜진',
    creatorId: 'mom_hyejin',
    groupId: 'grp_ocwork',
    groupName: 'OC 워킹맘 모임',
    category: PostCategory.school,
    viewCount: 203,
    commentCount: 15,
    likeCount: 24,
    createdAt: mockGroupSeedNow.subtract(const Duration(days: 1)),
  ),
  Post(
    id: 'gpo_oc_3',
    title: '워킹맘 저녁 루틴 공유해요',
    content: '퇴근 후 밥·목욕·이불까지 전쟁이네요. '
        '저녁 루틴 단순하게 하신 분들 tip 부탁드려요!',
    authorName: '박민지',
    creatorId: 'mom_minji',
    groupId: 'grp_ocwork',
    groupName: 'OC 워킹맘 모임',
    category: PostCategory.daily,
    viewCount: 278,
    commentCount: 22,
    likeCount: 41,
    createdAt: mockGroupSeedNow.subtract(const Duration(days: 3)),
  ),

  // grp_swim
  Post(
    id: 'gpo_swim_1',
    title: 'YMCA 수영 레벨 어떻게 나뉘나요?',
    content: '4살인데 물이 좀 무서워해요. YMCA parent-child랑 private 중에 '
        '어떤 게 나을까요?',
    authorName: '최유나',
    creatorId: 'mom_yuna',
    groupId: 'grp_swim',
    groupName: '수영 배우는 아이 엄마들',
    category: PostCategory.parenting,
    viewCount: 134,
    commentCount: 10,
    likeCount: 16,
    createdAt: mockGroupSeedNow.subtract(const Duration(hours: 12)),
  ),
  Post(
    id: 'gpo_swim_2',
    title: 'Torrance 사설 수영장 후기',
    content: 'Torrance 쪽 사설 수영장 다니는데 선생님이 차분하게 알려주셔서 '
        '우리 애가 잘 적응했어요. 궁금하신 분 DM 주세요!',
    authorName: '한지우',
    creatorId: 'mom_jiwoo',
    groupId: 'grp_swim',
    groupName: '수영 배우는 아이 엄마들',
    category: PostCategory.local,
    viewCount: 189,
    commentCount: 8,
    likeCount: 29,
    createdAt: mockGroupSeedNow.subtract(const Duration(days: 2)),
  ),
  Post(
    id: 'gpo_swim_3',
    title: '수영 후 간식 뭐 챙겨가세요?',
    content: '수업 끝나면 배가 고프다고 보채서요. '
        '젖지 않게 챙기기 좋은 간식 있으면 추천해주세요!',
    authorName: '한은지',
    creatorId: 'mom_eunji',
    groupId: 'grp_swim',
    groupName: '수영 배우는 아이 엄마들',
    category: PostCategory.food,
    viewCount: 97,
    commentCount: 6,
    likeCount: 14,
    createdAt: mockGroupSeedNow.subtract(const Duration(days: 4)),
  ),
  Post(
    id: 'gpo_swim_4',
    title: '물안경·수영모 브랜드 추천',
    content: '아이가 물안경을 싫어해서 계속 벗어요. '
        '얼굴에 안 아픈 제품 쓰신 분 계신가요?',
    authorName: '이혜진',
    creatorId: 'mom_hyejin',
    groupId: 'grp_swim',
    groupName: '수영 배우는 아이 엄마들',
    category: PostCategory.parenting,
    viewCount: 112,
    commentCount: 5,
    likeCount: 11,
    createdAt: mockGroupSeedNow.subtract(const Duration(days: 5)),
  ),

  // grp_preschool (lighter)
  Post(
    id: 'gpo_pre_1',
    title: '킨더 도시락 보통 뭐 싸주시나요?',
    content: '요번에 애기가 킨더 들어가는데 도시락을 싸가야 하네요. '
        '입이 짧은 편이라 메뉴 추천 부탁드려요!',
    authorName: '박민지',
    creatorId: 'mom_minji',
    groupId: 'grp_preschool',
    groupName: '한인 프리스쿨 정보방',
    category: PostCategory.school,
    viewCount: 312,
    commentCount: 19,
    likeCount: 38,
    createdAt: mockGroupSeedNow.subtract(const Duration(days: 1)),
  ),

  // grp_park (lighter)
  Post(
    id: 'gpo_park_1',
    title: '이번 주말 Griffith Park 피크닉?',
    content: '일요일 오전 Griffith Park에서 돗자리 피크닉 어때요? '
        '기차 타기 전에 놀이터도 들를 수 있어요.',
    authorName: '이혜진',
    creatorId: 'mom_hyejin',
    groupId: 'grp_park',
    groupName: '주말 공원 나들이 모임',
    category: PostCategory.local,
    viewCount: 88,
    commentCount: 4,
    likeCount: 13,
    createdAt: mockGroupSeedNow.subtract(const Duration(hours: 4)),
  ),
];

// ── Global community posts (Home feed) ──────────────────────────────────

final mockGlobalPosts = [
  Post(
    id: 'gpo_global_1',
    title: '한국어 가능한 소아과 추천 부탁드려요',
    content: '한인타운이나 Torrance 쪽으로 한국어 되는 소아과 찾고 있어요. '
        '애가 병원만 가면 울어서 설명 잘 해주시는 선생님이면 좋겠어요.',
    authorName: '장하은',
    creatorId: currentUserId,
    groupId: null,
    groupName: null,
    category: PostCategory.health,
    viewCount: 317,
    commentCount: 21,
    likeCount: 18,
    createdAt: mockGroupSeedNow.subtract(const Duration(hours: 3)),
  ),
  Post(
    id: 'gpo_global_2',
    title: 'Costco에서 아이 간식 뭐 사세요?',
    content: 'Costco 가면 간식 코너에서 한참 헤매요. '
        '당 덜 들어간 걸로 사려고 하는데, 엄마들 단골 간식 뭐 있으세요?',
    authorName: '한지우',
    creatorId: 'mom_jiwoo',
    groupId: null,
    groupName: null,
    category: PostCategory.food,
    viewCount: 573,
    commentCount: 36,
    likeCount: 82,
    createdAt: mockGroupSeedNow.subtract(const Duration(hours: 10)),
  ),
  Post(
    id: 'gpo_global_3',
    title: '비 오는 날 갈 만한 곳 어디 있을까요?',
    content: '이번 주 비 온다고 해서 실내 장소 찾고 있어요. '
        '키즈카페, 박물관, 도서관 중에 Glendale / Pasadena 쪽 추천 있으신가요?',
    authorName: '박민지',
    creatorId: 'mom_minji',
    groupId: null,
    groupName: null,
    category: PostCategory.local,
    viewCount: 187,
    commentCount: 14,
    likeCount: 31,
    createdAt: mockGroupSeedNow.subtract(const Duration(days: 1)),
  ),
  Post(
    id: 'gpo_global_4',
    title: '편식 심한 아이 반찬 추천해주세요',
    content: '우리 애가 밥을 너무 안 먹어서 고민이에요. '
        '고기만 찾고 채소는 거의 안 먹네요. 집에서 잘 먹던 반찬 있으면 공유 부탁드려요!',
    authorName: '이혜진',
    creatorId: 'mom_hyejin',
    groupId: null,
    groupName: null,
    category: PostCategory.food,
    viewCount: 512,
    commentCount: 41,
    likeCount: 68,
    createdAt: mockGroupSeedNow.subtract(const Duration(days: 2)),
  ),
  Post(
    id: 'gpo_global_5',
    title: 'Irvine 쪽 아이 키우기 어떤가요?',
    content: '혹시 Irvine / Orange County 쪽에서 아이 키우시는 분들 계세요? '
        '공원이나 도서관, 킨더 분위기 궁금해서요. LA에서 이사 고민 중이에요!',
    authorName: '한은지',
    creatorId: 'mom_eunji',
    groupId: null,
    groupName: null,
    category: PostCategory.local,
    viewCount: 441,
    commentCount: 28,
    likeCount: 39,
    createdAt: mockGroupSeedNow.subtract(const Duration(days: 3)),
  ),
  Post(
    id: 'gpo_global_6',
    title: '드디어 기저귀 졸업했어요!!',
    content: '몇 달 고생하더니 드디어 기저귀 뗐어요!! '
        '밤에만 조금 실수하는데 그래도 너무 기특하네요. 같은 시기 지나신분들 공감이죠?',
    authorName: '김소라',
    creatorId: 'mom_sora',
    groupId: null,
    groupName: null,
    category: PostCategory.daily,
    viewCount: 263,
    commentCount: 11,
    likeCount: 61,
    createdAt: mockGroupSeedNow.subtract(const Duration(days: 5)),
  ),
];

/// All posts for [MockPostDataSource] seed (group + global).
final mockAllPosts = [
  ...mockGroupPosts,
  ...mockGlobalPosts,
];

// ── Event announcements ─────────────────────────────────────────────────

final eventLa3Park = EventAnnouncement(
  id: 'evt_la3_park',
  groupId: 'grp_la3',
  creatorId: 'mom_sora',
  creatorName: '김소라',
  title: '토요일 Lafayette Park 놀이터',
  description: '오전 10시 Lafayette Park에서 만나요. '
      '간단한 간식과 물만 챙겨오시면 됩니다.',
  dateTime: DateTime.utc(2026, 8, 2, 17, 0), // 10:00 AM PDT
  location: 'Lafayette Park, Koreatown',
  childAgeRange: '2–4세',
  participantLimit: 8,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 2)),
);

final eventLa3Library = EventAnnouncement(
  id: 'evt_la3_lib',
  groupId: 'grp_la3',
  creatorId: 'mom_minji',
  creatorName: '박민지',
  title: '수요일 도서관 스토리타임',
  description: 'Pio Pico Library 스토리타임 같이 가요. '
      '끝나고 키즈존에서 잠깐 놀다 옵니다.',
  dateTime: DateTime.utc(2026, 8, 6, 21, 30), // 2:30 PM PDT
  location: 'Pio Pico Library, Los Angeles',
  childAgeRange: '2–4세',
  participantLimit: 6,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 1)),
);

final eventOcBrunch = EventAnnouncement(
  id: 'evt_oc_brunch',
  groupId: 'grp_ocwork',
  creatorId: 'mom_eunji',
  creatorName: '한은지',
  title: '주말 워킹맘 브런치 수다',
  description: '일요일 오전 Irvine에서 브런치하며 육아·일 이야기 나눠요. '
      '아이 데리고 오셔도 괜찮아요.',
  dateTime: DateTime.utc(2026, 8, 3, 18, 0), // 11:00 AM PDT
  location: 'Café near Irvine Spectrum',
  childAgeRange: '3–6세',
  participantLimit: 6,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 3)),
);

final eventSwimPractice = EventAnnouncement(
  id: 'evt_swim_prac',
  groupId: 'grp_swim',
  creatorId: 'mom_yuna',
  creatorName: '최유나',
  title: 'YMCA 수영 연습 후 간식',
  description: '수업 끝나고 로비에서 간식 나눠 먹어요. '
      '처음 오시는 분도 환영합니다!',
  dateTime: DateTime.utc(2026, 8, 1, 1, 0), // Fri 6:00 PM PDT Jul 31
  location: 'Torrance YMCA lobby',
  childAgeRange: '3–5세',
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 4)),
);

final eventParkPicnic = EventAnnouncement(
  id: 'evt_park_picnic',
  groupId: 'grp_park',
  creatorId: 'mom_hyejin',
  creatorName: '이혜진',
  title: 'Griffith Park 주말 피크닉',
  description: '돗자리·간단한 lunch box만 챙겨오세요. '
      '날씨 안 좋으면 단체 채팅으로 안내할게요.',
  dateTime: DateTime.utc(2026, 8, 3, 18, 0),
  location: 'Griffith Park, Los Angeles',
  childAgeRange: '1–5세',
  participantLimit: 10,
  createdAt: mockGroupSeedNow.subtract(const Duration(hours: 20)),
);

final eventPreschoolOpen = EventAnnouncement(
  id: 'evt_pre_open',
  groupId: 'grp_preschool',
  creatorId: 'mom_minji',
  creatorName: '박민지',
  title: '한인 프리스쿨 오픈하우스 동행',
  description: '이번 주 오픈하우스 같이 가실 분 모아요. '
      '끝나고 간단히 후기 나눕니다.',
  dateTime: DateTime.utc(2026, 8, 5, 17, 0),
  location: 'Koreatown preschool campus',
  childAgeRange: '3–5세',
  participantLimit: 5,
  createdAt: mockGroupSeedNow.subtract(const Duration(days: 5)),
);

final mockEvents = [
  eventLa3Park,
  eventLa3Library,
  eventOcBrunch,
  eventSwimPractice,
  eventParkPicnic,
  eventPreschoolOpen,
];

// ── RSVPs ───────────────────────────────────────────────────────────────

final mockRsvps = [
  // evt_la3_park — current user attending
  Rsvp(
    eventId: 'evt_la3_park',
    userId: currentUserId,
    userName: '장하은',
    status: RsvpStatus.attending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(days: 1)),
  ),
  Rsvp(
    eventId: 'evt_la3_park',
    userId: 'mom_yuna',
    userName: '최유나',
    status: RsvpStatus.attending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(days: 1, hours: 2)),
  ),
  Rsvp(
    eventId: 'evt_la3_park',
    userId: 'mom_jiwoo',
    userName: '한지우',
    status: RsvpStatus.notAttending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(hours: 30)),
  ),

  // evt_la3_lib
  Rsvp(
    eventId: 'evt_la3_lib',
    userId: 'mom_minji',
    userName: '박민지',
    status: RsvpStatus.attending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(hours: 12)),
  ),
  Rsvp(
    eventId: 'evt_la3_lib',
    userId: 'mom_sora',
    userName: '김소라',
    status: RsvpStatus.attending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(hours: 10)),
  ),

  // evt_oc_brunch
  Rsvp(
    eventId: 'evt_oc_brunch',
    userId: 'mom_eunji',
    userName: '한은지',
    status: RsvpStatus.attending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(days: 2)),
  ),
  Rsvp(
    eventId: 'evt_oc_brunch',
    userId: 'mom_hyejin',
    userName: '이혜진',
    status: RsvpStatus.notAttending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(days: 1)),
  ),
  Rsvp(
    eventId: 'evt_oc_brunch',
    userId: 'mom_minji',
    userName: '박민지',
    status: RsvpStatus.attending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(hours: 20)),
  ),

  // evt_swim_prac
  Rsvp(
    eventId: 'evt_swim_prac',
    userId: 'mom_yuna',
    userName: '최유나',
    status: RsvpStatus.attending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(days: 3)),
  ),
  Rsvp(
    eventId: 'evt_swim_prac',
    userId: 'mom_jiwoo',
    userName: '한지우',
    status: RsvpStatus.attending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(days: 2)),
  ),

  // evt_park_picnic — current user also attending
  Rsvp(
    eventId: 'evt_park_picnic',
    userId: currentUserId,
    userName: '장하은',
    status: RsvpStatus.attending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(hours: 8)),
  ),
  Rsvp(
    eventId: 'evt_park_picnic',
    userId: 'mom_hyejin',
    userName: '이혜진',
    status: RsvpStatus.attending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(hours: 16)),
  ),
  Rsvp(
    eventId: 'evt_park_picnic',
    userId: 'mom_sora',
    userName: '김소라',
    status: RsvpStatus.undecided,
    updatedAt: mockGroupSeedNow.subtract(const Duration(hours: 6)),
  ),

  // evt_pre_open
  Rsvp(
    eventId: 'evt_pre_open',
    userId: 'mom_minji',
    userName: '박민지',
    status: RsvpStatus.attending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(days: 4)),
  ),
  Rsvp(
    eventId: 'evt_pre_open',
    userId: 'mom_yuna',
    userName: '최유나',
    status: RsvpStatus.notAttending,
    updatedAt: mockGroupSeedNow.subtract(const Duration(days: 3)),
  ),
];
