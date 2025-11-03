import { defineConfig } from 'astro/config';

// For GitHub Project Pages, Astro needs a base path matching the repository name.
// The installer will replace __PROJECT_SLUG__ with your repository slug.
export default defineConfig({
  site: 'https://__GITHUB_USER__.github.io/__PROJECT_SLUG__/',
  base: '/__PROJECT_SLUG__/',
  outDir: 'dist',
  server: {
    host: true,
    port: 4321
  }
});
