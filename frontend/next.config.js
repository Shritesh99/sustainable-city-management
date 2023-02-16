/** @type {import('next').NextConfig} */
module.exports = {
  // reactStrictMode: true,
  async rewrites() {
    return [
      {
        source: `/*`,
        destination: `http://127.0.0.1:8080/:path*`,
      },
    ];
  },
};
