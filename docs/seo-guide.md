# SEO / AEO / GEO guide

Public pages use semantic headings, unique metadata and clean paths. The static export includes sitemap and robots directives. `llms.txt` and `llms-full.txt` describe the entity, policies and licensing in concise machine-readable prose.

## Search Console

1. Deploy the site.
2. Add the GitHub Pages URL as a property in Google Search Console.
3. Verify using the HTML tag or DNS method offered for the property.
4. Submit `/DevXchange/sitemap.xml`.
5. Inspect the home page and representative category/product URLs.

## Bing Webmaster

Add the same public URL to Bing Webmaster Tools, verify ownership and submit the sitemap. IndexNow can be added to a server-side publisher workflow when a public domain is available; GitHub Pages itself cannot keep a long-lived secret for authenticated IndexNow submissions.

## AEO/GEO

Use question-style headings, concise answers, explicit entity definitions, visible update dates and structured JSON-LD. Never promise rankings. Do not generate reviews, ratings or product facts that do not exist in Supabase.

## Core Web Vitals

Target LCP < 2.5s and CLS < 0.1. Run Lighthouse against the deployed URL after deployment; the repository does not claim a score it has not measured.
