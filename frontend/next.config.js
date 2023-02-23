/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  async rewrites() {
    return [
      { source: `/api/:path*`, destination: `http://127.0.0.1:8080/:path*` },
    ];
  },

  publicRuntimeConfig: {
    apiUrl:
      // process.env.NODE_ENV === "development"
      // ? "" // development api
      // : "", // production api
      process.env.NODE_ENV === "development"
        ? "http://127.0.0.1:8080" // development api
        : "https://scm-backend.rxshri99.live:8080", // production api
  },

  env: {
    MAP_BOX_ACCESS_TOKEN:
      "pk.eyJ1IjoidmVlcXUiLCJhIjoiY2xlOGVzY2V4MGU0azNvcnp5ZzYwYTg2cSJ9.LlUjPBs8cJOMcGhZxWqEIg",
    AQI_ACCESS_TOKEN: "d3f5d975618dc64e01ed3df11688671d3e61dd7f",
  },
};

module.exports = nextConfig;
