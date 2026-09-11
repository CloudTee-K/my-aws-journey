const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.json({
    message: "CI/CD Pipeline Project is running",
  });
});

app.get("/health", (req, res) => {
  res.json({
    status: "healthy",
  });
});

app.get("/api/info", (req, res) => {
  res.json({
    project: "Project 05 - CI/CD Pipeline with GitHub Actions",
    environment: "development",
  });
});

const PORT = process.env.PORT || 3000;

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

module.exports = app;