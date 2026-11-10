# Design Guidelines: Stark Group VMS

Single source of truth for the UI. Code uses tokens from `lib/theme/` only; never hard-code colors, font sizes or spacing in widgets.

## Color palette (the only colors the UI may use)

| Token | Name | Hex | Use |
|---|---|---|---|
| deepBlue | Deep Blue | #0B2545 | Navigation (sidebar, top bar, footer), headings |
| primary | Corporate Blue | #1D5FD1 | Primary actions, links, highlights, focus, selected nav item |
| background | Soft Gray | #F4F6F9 | Page background |
| surface | White | #FFFFFF | Cards, forms, tables, dialogs |
| textPrimary | Charcoal | #1F2933 | Main body text |
| textSecondary | Charcoal 70% | #5B6670 | Secondary text, captions, table headers |
| border | Light border | #E1E6EC | Dividers, card and input borders |
| success | Green | #15803D | Success messages, ACTIVE status |
| danger | Red | #D92D20 | Delete actions and errors ONLY |

Tints (e.g. primary at 10% for a badge background) may be derived from these tokens. No new hues.

## Rules of use
- **Deep Blue:** sidebar, top navigation, footer, headings (h1 to h3).
- **Corporate Blue:** the main action on a screen (Save, Register vehicle), links, selected nav item, focus rings. One primary button per view.
- **Soft Gray** is the page background. Cards, forms, tables and dialogs are **White** with a 1px border and a soft shadow.
- **Charcoal** is the default text color. Text and icons on Deep Blue or Corporate Blue are White.
- **Green** means success or ACTIVE only.
- **Red** is for delete actions and errors only. Never for decoration, warnings or inactive states.
- Gradients: only subtle blends of Deep Blue and Corporate Blue (landing hero, CTA banner).
- Contrast: text must meet WCAG AA (4.5:1 body, 3:1 large). If a token pair fails, raise it instead of changing the color silently.

## Status badges
| Status | Background | Text |
|---|---|---|
| ACTIVE | success tint | success |
| INACTIVE | neutral gray tint | textPrimary |
| MAINTENANCE | primary tint | primary |

## Typography
- One font family across the app.
- Scale: display, h1, h2, h3, body, bodySmall, label. Headings use deepBlue, body uses textPrimary, captions use textSecondary.

## Spacing, shape, elevation
- Spacing scale: 4, 8, 12, 16, 24, 32, 48.
- Radius: 8 for inputs and buttons, 16 for cards.
- Shadows: one soft card shadow, one elevated hover shadow.

## Components
- **Buttons:** Filled (primary), Outlined (secondary), Text, Destructive (danger, delete only).
- **Inputs:** white fill, border token, primary focus border, danger error border, error text in danger.
- **Tables:** white surface, header row in textSecondary on a subtle gray tint, row dividers, hover highlight.
- **Dialogs:** white surface; delete confirmation uses the Destructive button.
- **Snackbars:** success uses success, failure uses danger.
- Every screen handles loading, error and empty states in the same visual style.

## Open question (Assignment 2)
Expiring-soon document indicators may need a warning color. The palette has none. Decide before building that feature (proposal: one amber token used only for "expiring soon", with red for "expired").