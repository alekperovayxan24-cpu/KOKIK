# BUTSI Azerbaijan — production static frontend

This version includes:
- RU / AZ / EN language switcher
- no black strip above the header
- clean discount presentation without stickers over product images
- cart + WhatsApp ordering
- shared Supabase product database
- Supabase email/password admin login
- admin CRUD: add, edit price, old price, stock, sizes, color, image URL, category; deactivate products

## Setup
1. Create a Supabase project.
2. Open SQL Editor and run `supabase.sql`.
3. Create an admin user in Authentication > Users.
4. Put the Supabase Project URL and anon/public key into `config.js`.
5. Deploy `index.html` and `config.js` to GitHub Pages.

Do not put a `service_role` key in the website.
