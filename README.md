# Movie Randomizer

A local-first film library and randomizer. The application is a single-page static site; all collection data is stored in the browser.

## Features

- Watch queue and watched archive.
- Random selection without repeats until the eligible pool is exhausted.
- Filters by era, genre, country, runtime, rating, and poster availability.
- List and poster-grid views with sorting.
- Personal ratings and notes.
- Letterboxd metadata import from a JSON file, a bookmarklet, or a direct film link.
- Poster and metadata refresh through a configurable CORS proxy.
- TXT and JSON import/export.

## Data

The application uses `localStorage`. No account, backend, or external database is required.

## Development

Open `index.html` directly, or serve the directory with any static HTTP server.

## Deployment

GitHub Pages serves `index.html` from the `main` branch root.
