import type { NextConfig } from 'next';
const nextConfig: NextConfig = { output:'export', trailingSlash:true, basePath:process.env.NEXT_PUBLIC_BASE_PATH || '/DevXchange', images:{unoptimized:true}, poweredByHeader:false, reactStrictMode:true };
export default nextConfig;
