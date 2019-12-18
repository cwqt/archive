import StoreItem from "../components/StoreItem"

export default function StoreList() {
	var items = [
		{
			title: "powerboost",
			desc: `
				A high-power all-in-one Li-Po charger and boost converter.
				<ul>
					<li>USB-C input, 1A charge current using an <b>MCP73837</b> with a cut-off voltage of 4.2V</li>
					<li><b>TPS61088</b> provides a stable 5V @ 3A output via 10A internal switch</li>
					<li>Implements load-sharing when charging</li>
				</ul>
			`,
			price: "£14.99",
			tindie_url: "",
			stock: 5,
			images: [
				"https://i.imgur.com/alx0cPi.png",
				"https://i.imgur.com/mUukzNN.png",
			],
		},
		{
			title: "micro:bit breakout",
			desc: `SMT straight-edge-connector to DIL-40 breakout
				<ul>
					<li>Uses: <a href="https://thepihut.com/products/adafruit-smt-straight-connector-for-micro-bit-ada3888">https://thepihut.com/products/adafruit-smt-straight-connector-for-micro-bit-ada3888</a></li>
				</ul>
			`,
			price: "£5.99",
			tindie_url: "",
			stock: 10,
			images: [
				"https://i.imgur.com/f5ko8uc.png",
				"https://i.imgur.com/ahuGqF2.png",
			],
		},
	]

	var itemList = items.map((item, index) => {
		return <StoreItem
			title={item.title}
			images={item.images}
			price={item.price}
			stock={item.stock}
			desc={item.desc}
			key={index}/> 
	})

	return (
		<div>
			{itemList}
		</div>
	)
}
