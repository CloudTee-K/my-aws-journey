const request = require("supertest");
const app = require("../src/index");

describe("Application API", () => {
  test("GET / should return project message", async () => {
    const response = await request(app).get("/");

    expect(response.statusCode).toBe(200);
    expect(response.body.message).toBe(
      "CI/CD Pipeline Project is running"
    );
  });

  test("GET /health should return healthy status", async () => {
    const response = await request(app).get("/health");

    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe("healthy");
  });

  test("GET /api/info should return project information", async () => {
    const response = await request(app).get("/api/info");

    expect(response.statusCode).toBe(200);
    expect(response.body.project).toBe(
      "Project 05 - CI/CD Pipeline with GitHub Actions"
    );
  });
});