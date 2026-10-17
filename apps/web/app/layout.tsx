import type {Metadata} from 'next';
import './globals.css';
import {SiteHeader} from '../components/site-header';
import {SiteFooter} from '../components/site-footer';

const siteUrl='https://shalimoosavi.github.io/DevXchange/';

export const metadata:Metadata={
  metadataBase:new URL(siteUrl),
  title:{default:'DevXchange — The marketplace for production-ready software',template:'%s | DevXchange'},
  description:'A developer-first marketplace for production-ready source code, SaaS, web, AI, blockchain and developer projects.',
  alternates:{canonical:siteUrl},
  openGraph:{type:'website',siteName:'DevXchange',title:'DevXchange — Know what you are buying',description:'Buy and sell production-ready software with transparent verification, licensing and versioning.',url:siteUrl,images:[{url:'/images/og-image.png',width:1200,height:630,alt:'DevXchange — The marketplace for production-ready software.'}]},
  twitter:{card:'summary_large_image',title:'DevXchange — Know what you are buying',description:'A developer-first marketplace for production-ready software.',images:['/images/og-image.png']}
};

const organization={
  '@context':'https://schema.org','@type':'Organization','name':'DevXchange','url':siteUrl,'description':'Developer-first marketplace for production-ready software.','founder':{'@type':'Person','name':'Syed Ali Hasan Moosavi','jobTitle':'Founder and Managing Director','email':'mailto:shalimoosavi@gmail.com','url':'https://github.com/SHalimoosavi','worksFor':{'@type':'Organization','name':'SAYANJALI NEXUS PRIVATE LIMITED'}},'sameAs':['https://github.com/SHalimoosavi/DevXchange']
};
const website={'@context':'https://schema.org','@type':'WebSite','name':'DevXchange','url':siteUrl,'potentialAction':{'@type':'SearchAction','target':`${siteUrl}marketplace/?q={search_term_string}`,'query-input':'required name=search_term_string'}};

export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="en"><body><SiteHeader/><main>{children}</main><SiteFooter/><script type="application/ld+json" dangerouslySetInnerHTML={{__html:JSON.stringify(organization)}}/><script type="application/ld+json" dangerouslySetInnerHTML={{__html:JSON.stringify(website)}}/></body></html>}
