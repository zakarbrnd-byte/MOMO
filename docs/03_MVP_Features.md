# MVP Features

Canonical detail: [`../MVP_SPEC.md`](../MVP_SPEC.md).

## Target product (Group-first)

- Community / Home feed
- Groups (join / leave)
- Group Posts
- Comments, likes, view tracking
- Event Announcements + RSVP
- Profiles, search, filtering
- Korean & English Disclaimer

## Shipped foundation (legacy Playdate-shaped UI)

Still in the Flutter app as technical base:

- Bottom nav: Home · Create · Profile
- Home feed: Playdate cards + Post cards
- Detail / create / join-leave local flows
- Profile placeholder
- Local mock data + repository DI

Upcoming phases replace primary surfaces with Groups.

## Explicitly excluded

Marketplace, payments, AI recommendations, advanced moderation, real-time chat, advertising. Notifications wait for a later phase.
