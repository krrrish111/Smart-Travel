import codecs

with codecs.open('src/main/webapp/pages/planner.jsp', 'r', 'utf-8') as f:
    text = f.read()

text = text.replace(
    "const UNSPLASH_KEY     = _config?.dataset?.unsplashKey  || '';",
    "let UNSPLASH_KEY = _config?.dataset?.unsplashKey || '';\n                if (!UNSPLASH_KEY) console.error('[Voyastra] Unsplash API key not set');"
)

text = text.replace(
    "async function generatePlan(event) {",
    "window.generatePlan = generatePlan;\n                      async function generatePlan(event) {"
)

# Replace unescaped backticks in replace functions
text = text.replace("replace(/\\\\'/g,\\`\\`)", "replace(/\\\\'/g, '')")
text = text.replace("replace(/\\\\'/g,``)", "replace(/\\\\'/g, '')")

with codecs.open('src/main/webapp/pages/planner.jsp', 'w', 'utf-8') as f:
    f.write(text)
