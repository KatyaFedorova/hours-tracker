# Hours — simple time tracker

A single-file web app to create projects and log hours, backed by Supabase.

- `index.html` — the entire app (open it or host it; the Supabase URL and anon key are inside, which is fine — every table is protected by row-level security).
- `hours-table.sql` — run in your Supabase project's SQL Editor to create/update the tables and RLS policies.

Projects and hours are stored per account in Supabase, so they follow you across
browsers and devices. Nothing is kept only in the browser. Tables: `projects`, `hours`.

## Hosting on GitHub Pages

The app is a single static file, so Pages serves it as-is from `main` / root:

```text
https://katyafedorova.github.io/hours-tracker/
```

## Auth setup

The app uses Supabase Auth with Google sign-in. In Supabase, enable the Google provider and add the deployed site URL as an allowed redirect URL:

```text
https://reliable-fenglisu-fabe33.netlify.app/
https://katyafedorova.github.io/hours-tracker/
```

Both URLs need to be listed, and both need to be authorized origins on the Google
OAuth client. Sign-in fails on any URL that is missing — the app loads but stays
empty, because no session means no data.

If you use another deployed URL later, add that URL too.
