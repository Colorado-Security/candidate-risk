import pluginHtml from "eslint-plugin-html";
import js from "@eslint/js";
import globals from "globals";

export default [
  js.configs.recommended,
  {
    files: ["**/*.html"],
    plugins: { html: pluginHtml },
    languageOptions: {
      globals: {
        ...globals.browser,
        React: "readonly",
        ReactDOM: "readonly",
      },
    },
    rules: {
      "no-unused-vars": "warn",
    },
  },
];
