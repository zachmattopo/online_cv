# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Primary: UK hiring teams (recruiters and engineering managers) evaluating a senior mobile/Flutter engineer, often skimming between many candidates. Secondary: engineering peers and the Flutter community looking at craft, projects and the repository itself. Hiring comes first; the site must also hold up as a craft showcase.

## Product Purpose

The online CV of Hafiz Nordin, Senior Software Engineer (mobile/Flutter). It exists to get the right hiring team to reach out (email, LinkedIn, or a Calendly call) and, secondarily, to demonstrate engineering and design craft. Success is a qualified conversation started.

## Positioning

A career that literally spans the globe: born and raised in Malaysia (Kelantan), a scholarship-funded Mechanical Engineering degree in Nashville, failure analysis at Intel in Penang, mobile engineering across Kuala Lumpur, Flutter at BT/EE in Birmingham, now independent in Aberdeen. The engineering-to-software path and the multi-country journey are facts no other candidate can copy.

## Operating Context

- Viewed on desktop by hiring teams during screening, and on phones via LinkedIn links.
- Visitors skim: the full story must be available, but a fast lane to any stop and a plain "CV at a glance" must always be reachable.
- The repository is itself part of the pitch (README: "showcase my code work").

## Capabilities and Constraints

- Existing stack: Flutter web (Flutter 3.41.7 via FVM), BLoC/Cubit, content in `lib/core/static_data.dart`. Whether the rebuild stays pure Flutter, embeds a WebGL globe, or moves to Jaspr is delegated to the designer's recommendation, to be confirmed with the direction.
- Deployed as a static site to GitHub Pages (`zachmattopo.github.io/online-cv-live`).
- Visitor counter via visitorbadge.io must keep working.
- Experience is presented most-recent-first (Aberdeen → Birmingham → Kuala Lumpur → Penang → Nashville → Kelantan).

## Evidence on Hand

- All CV content, metrics and links in `lib/core/static_data.dart` (BT/EE 10M+ users, +15% CSAT, 99.7% crash-free; GoGetter ratings 3.7→4.6 / 2.4→4.3; Intel RM10M/quarter saved; EPF first-of-its-kind integration).
- Company logos in `assets/images/` (BT, GoGet, MIMOS, Arise, Trigger Next, Intel, Vanderbilt) and project icons (WhereToFuel, Movement to Work).
- GitHub avatar as profile photo. No testimonials, no press beyond the linked EPF article; do not invent any.

## Product Principles

1. Hiring clarity first: title, availability and a way to reach out are never more than one action away.
2. The journey is the proof: every place carries real, specific accomplishments, not decoration.
3. Skimmable by design: any stop, and the plain CV, is reachable without sitting through the animation.
4. The build is part of the portfolio: code quality and performance are on show.

## Accessibility & Inclusion

Respect `prefers-reduced-motion` with a non-animated path through the same content. Keep contrast and text sizes readable over map imagery; keyboard-reachable stop navigation.
