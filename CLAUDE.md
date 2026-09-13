# The White Chapter — project context

Boutique hotel website. Read this before making changes.

## The property

- **Name:** The White Chapter
- **Tagline:** A new chapter in the mountains
- **Location:** Village Gondhla, near Sissu, Lahaul & Spiti, Himachal Pradesh, India — 10,300 ft. Gondhla is the precise village (used for the address); "Sissu" stays in marketing copy as the more recognizable nearby name. Sissu Waterfall is a ~20-minute drive away, not walking distance.
- **Founder / host:** Abhishek Jain
- **Opening:** Construction complete March 2027; bookings open from 1 April 2027
- **Domain:** thewhitechapter.in (owned; `.com` was unavailable)
- **Email:** hello@thewhitechapter.in

12 rooms in two categories:

| Category | Count | Rate | Notes |
|---|---|---|---|
| Mountain View | 6 | ₹6,000/night | Faces the ice-capped peaks and the river |
| Front Facing | 6 | ₹5,000/night | Front side, private balcony, no mountain view |

Two F&B outlets:

- **The Fir & Flame Café** — all-day. Open 10am–10pm to walk-ins; in-house guests can order from 6:30am.
- **The Glacier Table** — dinner restaurant, by reservation. 7pm and 9pm seatings.

The evening bar concept ("The Larch & Lantern") was cut. Don't reintroduce a third F&B outlet.

## Naming history (do not reintroduce)

The property was previously called **Glacier View Retreat**, then **Shukpa Retreat**, then briefly **Halda**. All three are dead:

- *Glacier View* — generic, other hotels in Sissu use it
- *Shukpa* — Shukpa Residency already exists in Leh
- *Halda* — the Lahaul community objected to a hotel using the name of their festival

If any of these strings appear anywhere in the codebase, they are stale and should be removed.

## Brand system

**Fonts** — Cormorant Garamond (serif; headings, dish names, prices) + Manrope (sans; body copy)

**Colours**

```css
--forest:      #2d3a2e;
--forest-deep: #1f2820;
--sage:        #7a8a7c;
--ember:       #c66b3d;
--ember-soft:  #d88a5f;
--cream:       #f5efe4;
--paper:       #faf6ec;
--bark:        #3d2f24;
--ink:         #1a1f1c;
```

**Logos** — raster PNGs in `brand-assets/`. The primary crest is a circular illustration: snow-capped peaks, pine trees, a river. The café has its own lockup (fir tree containing an ember flame).

These are low resolution — the crest is 180px, the café lockup 518px. Fine for screen, not enough for print. A vector redraw is pending. When SVGs arrive, swap them in.

The crest used on the site itself (`brand/crest.png`, also `brand/favicon-source.png`) has had its cream paper background keyed out to real alpha transparency — flood-filled from the edges so interior highlights (snow, water) survive. It drops cleanly onto any surface with plain `<img>`, no `mix-blend-mode` hack needed. The raw files in `brand-assets/` still have the cream background baked in — if one of those gets reused directly on a cream/white surface, either re-run the same flood-fill keying or fall back to `mix-blend-mode: multiply`; on dark surfaces, set it in a cream circular badge rather than inverting it (inverting wrecks the linework).

## Current files

| File | What it is |
|---|---|
| `index.html` | Main site. Single file, ~200 KB. Nine sections. |
| `menus.html` | Café and restaurant menus. Print-ready. |
| `menu-physical-mockup.html` | Visualisation of the menus as physical printed objects. |
| `brand-assets/*.png` | 11 logo and collateral images. |
| `images/{rooms,dining,experiences}/` | Room/dining/experience photos, WebP + JPEG fallback at 400/800/1600px. |
| `images-source/` | Full-res originals for the photos above. Not deployed (gitignored) — drop new photos here. |
| `scripts/convert-images.sh` | Regenerates `/images` from `/images-source`. Run after adding new photos. |
| `brand/crest.png`, `brand/favicon-source.png` | Transparent-background crest, used for the nav logo, footer crest, and favicon. |

`menus.html` and `menu-physical-mockup.html` still have their photos base64-embedded — that split hasn't been done yet.

`index.html` has no base64 image data left — the five site photos live in `/images`, and the nav/footer/favicon crest lives in `/brand`.

## Other launch tasks

- **Contact form has no destination.** It's markup only. Replace with a WhatsApp deep link (primary — this converts better than forms for Indian hospitality) plus a `mailto:` fallback. Web3Forms is the option if a real form is wanted.
- **Open Graph tags** — matters a lot; links get shared on WhatsApp constantly in this market. Needs `og:image` at 1200×630.
- **Favicon set** — 16/32/180/192/512. Currently a single 64px file (`brand/favicon-source.png`, transparent), still needs generating at the other sizes.
- `robots.txt` and `sitemap.xml`
- Schema.org `Hotel` markup for search results

## Deployment

**Cloudflare Pages.** Free tier, unlimited bandwidth, SSL included, good India edge coverage. Point the `thewhitechapter.in` nameservers at Cloudflare, connect the repo, done.

Deliberately rejected: S3 + CloudFront (four services and IAM policies for a static site), and any backend (nothing on the site needs one).

## Things that are not needed

- **No backend.** Nothing here requires a server.
- **No booking engine yet.** When the hotel opens, plug in a third-party channel manager (eZee, Djubo, Cloudbeds) that provides an embed snippet. Don't build one.
- **No CMS yet.** Add one only when non-technical staff need to edit content regularly. Sanity or Decap, free tier.
- **No framework.** Plain HTML/CSS is correct for this. Don't migrate to React.

## Content still missing

- Real photos: property exterior, finished rooms, café interior, construction progress, Sissu Monastery (Labrang Gompa)
- The chef's real name — menus currently credit an invented "Yudhvir" in the recipe stories
- Sissu pincode listed as 175132 — verify

## Style notes

Keep the writing plain. The current copy avoids marketing language and reads like a person talking. Don't add "nestled," "unparalleled," "oasis," or "luxurious." The founder's story section is deliberately understated — six years of searching, then Sissu. Leave that tone alone.
