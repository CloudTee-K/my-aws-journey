const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get("/", (req, res) => {
    res.json({
        message: "Project 07 Backend API is running"
    });
});

app.get("/health", (req, res) => {
    res.status(200).json({
        status: "healthy"
    });
});

app.get("/api/data", (req, res) => {
    res.json({
        project: "Project 07",
        service: "Node.js Backend",
        message: "Hello from the containerized backend!"
    });
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Backend server running on port ${PORT}`);
});