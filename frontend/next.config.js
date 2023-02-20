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
        : "http://127.0.0.1:8080", // production api
  },
};

module.exports = nextConfig;
