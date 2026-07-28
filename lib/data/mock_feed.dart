import '../models/playdate.dart';
import '../models/post.dart';
import 'mock_user.dart';

/// Seed playdates / posts for [MockPlaydateDataSource] / [MockPostDataSource].
///
/// Do not import from UI or providers — go through repository → data source.
///
/// Content reflects a Southern California Korean mom community (LA / OC).
/// Structural fields (ids, creatorId, capacity, participant counts) are kept
/// stable for existing join / leave / ownership / capacity tests.
const playdateSaturdayPark = Playdate(
  id: 'pd1',
  creatorId: 'mom_sora',
  title: '이번 토요일 공원에서 같이 놀아요 😊',
  date: '7월 19일 토요일',
  time: '오전 10:00',
  location: 'Lafayette Park, Koreatown',
  childAge: '3–5세',
  description:
      '토요일 오전에 아이 데리고 놀이터 가려고 해요. 또래 친구들이랑 같이 놀면 더 좋아할 것 같아서 올려봐요! 간단한 간식이랑 물만 챙겨오시면 돼요 :)',
  hostName: '김소라',
  participantIds: ['mom_yuna', 'mom_eunji'],
  maxParticipants: 5,
  viewCount: 186,
  commentCount: 12,
  likeCount: 28,
);

const playdateLibrary = Playdate(
  id: 'pd2',
  creatorId: 'mom_minji',
  title: '도서관 스토리타임 같이 가실 분?',
  date: '7월 23일 수요일',
  time: '오후 2:30',
  location: 'Pio Pico Library, Los Angeles',
  childAge: '2–4세',
  description:
      '수요일 스토리타임 같이 가실 분 계실까요? 끝나고 키즈존에서 잠깐 놀다 오려구요. 비 오거나 더울 때 진짜 좋아요ㅎㅎ',
  hostName: '박민지',
  participantIds: ['mom_eunji', 'mom_hyejin', 'mom_sora'],
  maxParticipants: null, // unlimited
  viewCount: 142,
  commentCount: 8,
  likeCount: 19,
);

const playdateCafe = Playdate(
  id: 'pd3',
  creatorId: 'mom_hyejin',
  title: '키즈카페에서 엄마들도 같이 수다해요',
  date: '7월 25일 금요일',
  time: '오전 11:00',
  location: 'Kids Café, Cerritos',
  childAge: '4–6세',
  description:
      '금요일 오전 키즈카페에서 아이들 놀리고 엄마들끼리 수다해요. 자리가 많지 않아서 미리 올려봐요! snack time 전에 오시면 편해요.',
  hostName: '이혜진',
  participantIds: [
    'mom_minji',
    'mom_yuna',
    'mom_eunji',
    'mom_sora',
    'mom_jiwoo',
  ],
  maxParticipants: 5,
  viewCount: 231,
  commentCount: 15,
  likeCount: 34,
);

/// Near-capacity limited playdate for fill/leave tests (4/5).
const playdateNearFull = Playdate(
  id: 'pd4',
  creatorId: 'mom_yuna',
  title: '비 오는 날 실내 놀이터 번개해요',
  date: '7월 24일 목요일',
  time: '오후 3:00',
  location: 'Indoor Playground, Fullerton',
  childAge: '1–3세',
  description:
      '비 온다고 해서 실내 놀이터 번개해요. 한 자리만 남았어요! 아이 낯가림 있어도 괜찮아요, 천천히 적응하면 돼요ㅎㅎ',
  hostName: '최유나',
  participantIds: ['mom_minji', 'mom_eunji', 'mom_hyejin', 'mom_sora'],
  maxParticipants: 5,
  viewCount: 97,
  commentCount: 6,
  likeCount: 14,
);

/// Owned by the mock current user for creator-control demos/tests.
const playdateOwnedByDemo = Playdate(
  id: 'pd5',
  creatorId: currentUserId,
  title: '저녁 먹고 동네 산책 같이 하실 분',
  date: '7월 26일 일요일',
  time: '오전 9:30',
  location: 'Eagle Rock neighborhood walk',
  childAge: '3–5세',
  description: '일요일 아침에 유모차 끌고 동네 산책하려구요. 커피 한 잔 들고 천천히 걸어요. 같이 가실 분 계실까요?',
  hostName: '장하은',
  participantIds: ['mom_yuna'],
  maxParticipants: 4,
  viewCount: 54,
  commentCount: 3,
  likeCount: 9,
);

const playdateGriffithPicnic = Playdate(
  id: 'pd6',
  creatorId: 'mom_jiwoo',
  title: 'Griffith Park에서 피크닉해요',
  date: '7월 27일 월요일',
  time: '오전 11:00',
  location: 'Griffith Park, Los Angeles',
  childAge: '2–4세',
  description:
      '날씨 좋으면 Griffith Park에서 피크닉하려고요. 돗자리랑 간단한 lunch box만 챙겨오시면 돼요. 아직 참여 엄마 없어서 같이 가실 분 구해요!',
  hostName: '한지우',
  participantIds: [],
  maxParticipants: 6,
  viewCount: 38,
  commentCount: 0,
  likeCount: 5,
);

const playdateIrvinePark = Playdate(
  id: 'pd7',
  creatorId: 'mom_eunji',
  title: 'Irvine Regional Park 같이 가실래요?',
  date: '8월 2일 토요일',
  time: '오전 10:00',
  location: 'Irvine Regional Park, Orange County',
  childAge: '3–5세',
  description:
      '주말에 Irvine Regional Park 가보려고요. 기차도 타고 놀이터도 넓어서 애들이 좋아하더라구요. OC 쪽 엄마들 같이 가실래요?',
  hostName: '한은지',
  participantIds: ['mom_minji'],
  maxParticipants: 8,
  viewCount: 167,
  commentCount: 11,
  likeCount: 22,
);

const playdateTorranceBeach = Playdate(
  id: 'pd8',
  creatorId: 'mom_sora',
  title: '오후에 Torrance 해변 모래놀이해요',
  date: '8월 3일 일요일',
  time: '오후 3:00',
  location: 'Torrance Beach',
  childAge: '1–3세',
  description:
      '오후 Torrance Beach에서 모래놀이 해요. 자외선 강하니까 모자랑 sunscreen 꼭 챙기세요! 물놀이는 얕은 데서만 할 예정이에요.',
  hostName: '김소라',
  participantIds: ['mom_hyejin'],
  maxParticipants: 5,
  viewCount: 203,
  commentCount: 17,
  likeCount: 31,
);

/// Fixed seed clock for mock [Post.createdAt] values.
///
/// UI still formats against [DateTime.now]; widget tests inject a fixed clock.
final DateTime mockPostSeedNow = DateTime.utc(2026, 7, 28, 21, 0, 0);

final postSeolleung = Post(
  id: 'po1',
  title: '킨더 도시락 보통 뭐 싸주시나요?',
  content:
      '요번에 애기가 킨더 들어가는데 도시락을 싸가야 하네요. 엄마들 보통 어떤 거 싸 가나요? 입이 짧은 편이라 매일 뭘 싸야 할지 벌써 걱정이에요 ㅎㅎ 아이들이 잘 먹는 메뉴 있으면 추천 부탁드려요!',
  authorName: '최유나',
  creatorId: 'mom_yuna',
  category: PostCategory.school,
  viewCount: 386,
  commentCount: 24,
  likeCount: 47,
  createdAt: mockPostSeedNow.subtract(const Duration(minutes: 20)),
);

final postIndoorSpots = Post(
  id: 'po2',
  title: '아이가 등원할 때마다 울어요',
  content:
      'TK 시작한 지 일주일 됐는데 아직도 아침마다 많이 울어요. 선생님은 제가 가고 나면 괜찮아진다고 하는데 마음이 계속 쓰이네요. 보통 얼마나 지나야 적응하던가요?',
  authorName: '한은지',
  creatorId: 'mom_eunji',
  category: PostCategory.school,
  viewCount: 428,
  commentCount: 33,
  likeCount: 52,
  createdAt: mockPostSeedNow.subtract(const Duration(hours: 2)),
);

final postKinderLunchBox = Post(
  id: 'po3',
  title: '킨더 lunch box 어떤 거 쓰세요?',
  content:
      'Back to School 준비하다가 lunch box 보고 있는데 종류가 너무 많아요 ㅠㅠ 세척 쉬운 걸로 찾는데, 다들 어떤 브랜드 쓰세요? Costco에 괜찮은 거 있던가요?',
  authorName: '김소라',
  creatorId: 'mom_sora',
  category: PostCategory.school,
  viewCount: 271,
  commentCount: 17,
  likeCount: 34,
  createdAt: mockPostSeedNow.subtract(const Duration(hours: 5)),
);

final postKinderBackpack = Post(
  id: 'po4',
  title: '킨더 백팩 사이즈 어떤 걸로 사셨어요?',
  content:
      '애가 아직 어린데 백팩이 너무 크면 힘들어할 것 같아서요. TK/킨더용으로 작은 사이즈 쓰신 분 계신가요? 추천 부탁드려요!',
  authorName: '박민지',
  creatorId: 'mom_minji',
  category: PostCategory.school,
  viewCount: 194,
  commentCount: 12,
  likeCount: 26,
  createdAt: mockPostSeedNow.subtract(const Duration(days: 1)),
);

final postPickyEating = Post(
  id: 'po5',
  title: '편식 심한 아이 반찬 추천해주세요',
  content:
      '우리 애가 밥을 너무 안 먹어서 고민이에요. 고기만 찾고 채소는 거의 안 먹네요 ㅠㅠ 집에서 잘 먹던 반찬 있으면 공유 부탁드려요ㅎㅎ',
  authorName: '이혜진',
  creatorId: 'mom_hyejin',
  category: PostCategory.food,
  viewCount: 512,
  commentCount: 41,
  likeCount: 68,
  createdAt: mockPostSeedNow.subtract(const Duration(days: 2)),
);

final postCostcoSnacks = Post(
  id: 'po6',
  title: 'Costco에서 아이 간식 뭐 사세요?',
  content:
      'Costco 가면 간식 코너에서 한참 헤매요 😂 당 덜 들어간 걸로 사려고 하는데, 엄마들 단골 간식 뭐 있으세요? Trader Joe’s도 괜찮으면 같이 추천해주세요!',
  authorName: '한지우',
  creatorId: 'mom_jiwoo',
  category: PostCategory.food,
  viewCount: 573,
  commentCount: 36,
  likeCount: 82,
  createdAt: mockPostSeedNow.subtract(const Duration(days: 4)),
);

final postPediatrician = Post(
  id: 'po7',
  title: '한국어 가능한 소아과 추천 부탁드려요',
  content:
      '한인타운이나 Torrance 쪽으로 한국어 되는 소아과 찾고 있어요. 애가 병원만 가면 울어서 설명 잘 해주시는 선생님이면 좋겠어요. 가보신 분 계신가요?',
  authorName: '장하은',
  creatorId: currentUserId,
  category: PostCategory.health,
  viewCount: 317,
  commentCount: 21,
  likeCount: 18,
  createdAt: DateTime.utc(2026, 7, 19, 15, 0),
);

final postSwimClass = Post(
  id: 'po8',
  title: '4살 수영 클래스 어디가 괜찮나요?',
  content:
      '4살인데 수영 시작하려고요. YMCA랑 사설 수영장 고민 중인데, OC나 LA 남쪽 쪽에서 추천 있으실까요? 물이 무서운 편이라 천천히 알려주시는 곳이면 좋겠어요.',
  authorName: '최유나',
  creatorId: 'mom_yuna',
  category: PostCategory.parenting,
  viewCount: 208,
  commentCount: 15,
  likeCount: 29,
  createdAt: mockPostSeedNow.subtract(const Duration(minutes: 45)),
);

final postRainyDay = Post(
  id: 'po9',
  title: '비 오는 날 갈 만한 곳 어디 있을까요?',
  content:
      '이번 주 비 온다고 해서 실내 playdate 장소 찾고 있어요. 키즈카페, 박물관, 도서관 중에 아이 데리고 가기 괜찮은 데 있을까요? Glendale / Pasadena 쪽도 좋아요!',
  authorName: '박민지',
  creatorId: 'mom_minji',
  category: PostCategory.local,
  viewCount: 187,
  commentCount: 14,
  likeCount: 31,
  createdAt: mockPostSeedNow.subtract(const Duration(hours: 3)),
);

final postShadyPlayground = Post(
  id: 'po10',
  title: '한인타운 근처 그늘 많은 놀이터 있나요?',
  content:
      '한여름이라 놀이터 바닥이 너무 뜨거워요 ㅠㅠ Koreatown이나 Lafayette Park 근처에서 그늘 많은 놀이터 아시는 분 계신가요? 오전에만 나가려구요.',
  authorName: '한은지',
  creatorId: 'mom_eunji',
  category: PostCategory.local,
  viewCount: 356,
  commentCount: 22,
  likeCount: 43,
  createdAt: mockPostSeedNow.subtract(const Duration(days: 3)),
);

final postIrvineParenting = Post(
  id: 'po11',
  title: 'Irvine 쪽 아이 키우기 어떤가요?',
  content:
      '혹시 Irvine / Orange County 쪽에서 아이 키우시는 분들 계세요? 공원이나 도서관, 킨더 분위기 궁금해서요. LA에서 이사 고민 중이라 솔직한 후기 듣고 싶어요!',
  authorName: '이혜진',
  creatorId: 'mom_hyejin',
  category: PostCategory.local,
  viewCount: 441,
  commentCount: 28,
  likeCount: 39,
  createdAt: mockPostSeedNow.subtract(const Duration(days: 6)),
);

final postDiaperGraduation = Post(
  id: 'po12',
  title: '드디어 기저귀 졸업했어요!! 🎉',
  content:
      '몇 달 고생하더니 드디어 기저귀 뗐어요!! 밤에만 조금 실수하는데 그래도 너무 기특하네요 ㅎㅎ 같은 시기 지나신분들 공감이죠?',
  authorName: '김소라',
  creatorId: 'mom_sora',
  category: PostCategory.daily,
  viewCount: 263,
  commentCount: 11,
  likeCount: 61,
  createdAt: DateTime.utc(2026, 7, 10, 9, 30),
);

const mockPlaydates = [
  playdateSaturdayPark,
  playdateLibrary,
  playdateCafe,
  playdateNearFull,
  playdateOwnedByDemo,
  playdateGriffithPicnic,
  playdateIrvinePark,
  playdateTorranceBeach,
];

final mockPosts = [
  postSeolleung,
  postIndoorSpots,
  postKinderLunchBox,
  postKinderBackpack,
  postPickyEating,
  postCostcoSnacks,
  postPediatrician,
  postSwimClass,
  postRainyDay,
  postShadyPlayground,
  postIrvineParenting,
  postDiaperGraduation,
];
