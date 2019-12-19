import Link from 'next/link';

export default function Header() {
	return (
		<header>
			<img src="/static/daughtersystems.png" />
			<h1>ds</h1>
			<div className="left">
				<Link href="/"><a>store</a></Link>
				<Link href="/about"><a>about</a></Link>
				<Link href="/contact"><a>contact</a></Link>
			</div>
		</header>
	)
}
