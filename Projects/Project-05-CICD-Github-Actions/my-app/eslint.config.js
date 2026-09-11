const js = require("@eslint/js");
const globals = require("globals");

module.exports = [
  {
    ignores: ["node_modules/**"],
  },

  js.configs.recommended,

  {
    files: ["src/**/*.js"],
    languageOptions: {
      sourceType: "commonjs",
      globals: {
        ...globals.node,
      },
    },
  },

  {
    files: ["tests/**/*.js"],
    languageOptions: {
      sourceType: "commonjs",
      globals: {
        ...globals.node,
        ...globals.jest,
      },
    },
  },

  {
    files: ["eslint.config.js"],
    languageOptions: {
      sourceType: "commonjs",
      globals: {
        ...globals.node,
      },
    },
  },
];