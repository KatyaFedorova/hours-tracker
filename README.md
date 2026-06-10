# Hours — simple time tracker

A single-file web app to create projects and log hours, backed by Supabase.

- `index.html` — the entire app (open it or host it; database keys are inside).
- `hours-table.sql` — run in your Supabase project's SQL Editor to create/update the tables and RLS policies.

## Auth setup

The app uses Supabase Auth with Google sign-in. In Supabase, enable the Google provider and add the deployed site URL as an allowed redirect URL:

```text
https://reliable-fenglisu-fabe33.netlify.app/
```

If you use another deployed URL later, add that URL too.
