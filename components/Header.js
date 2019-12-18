import Link from 'next/link';

export default function Header() {
	return (
		<header>
			<img src="/static/daughtersystems.png" />
			<h1>ds</h1>
			<div className="left">
				<Link href="/">store</Link>
				<Link href="/about">about</Link>
				<Link href="/contact">contact</Link>
			</div>
		</header>
	)
}
