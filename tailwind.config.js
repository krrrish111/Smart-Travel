/** @type {import('tailwindcss').Config} */
module.exports = {
  // Scan all JSP and JS files in the webapp for Tailwind utility classes
  content: [
    "./src/main/webapp/**/*.jsp",
    "./src/main/webapp/**/*.js",
    "./src/main/webapp/**/*.html"
  ],
  // Disable all core plugins except utilities to avoid clashing with existing vanilla CSS
  corePlugins: {
    preflight: false,
  },
  theme: {
    extend: {},
  },
  plugins: [],
}
