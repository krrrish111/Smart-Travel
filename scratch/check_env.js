const key = process.env.GEMINI_API_KEY;
if (key) {
    console.log("GEMINI_API_KEY is defined. Length:", key.length);
    console.log("Starts with:", key.substring(0, 8));
} else {
    console.log("GEMINI_API_KEY is not defined in process.env.");
}
