import type { Metadata } from 'next';
import './globals.css';
import { SiteHeader } from '../components/site-header';
import { SiteFooter } from '../components/site-footer';

export const metadata: Metadata = { metadataBase:new URL('https://shalimoosavi.github.io/DevXchange/'), title:{default:'DevXchange — The marketplace for production-ready software',template:'%s | DevXchange'}, description:'A developer-first marketplace for production-ready source code, SaaS, web, AI, blockchain and developer projects.', openGraph:{type:'website',siteName:'DevXchange',title:'DevXchange — Know what you are buying',description:'Buy and sell production-ready software with transparent verification, licensing and versioning.',url:'https://shalimoosavi.github.io/DevXchange/'}, twitter:{card:'summary_large_image',title:'DevXchange — Know what you are buying',description:'A developer-first marketplace for production-ready software.'} };
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="en"><body><SiteHeader/><main>{children}</main><SiteFooter/></body></html>}
