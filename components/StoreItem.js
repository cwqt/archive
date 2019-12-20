import Lightbox 				from 'react-image-lightbox';
import Slider 					from 'react-slick';
import ReactHtmlParser 	from 'react-html-parser';

export default function StoreItem(props) {
	var state = {}
  var settings = {
    dots: true,
    infinite: true,
    speed: 500,
    slidesToShow: 1,
    slidesToScroll: 1
  };
  var imageList = props.images.map((image, index) => {
  	return <img src={image} key={index}/>
  })

	return (
		<div className="store-item">
			<Slider {...settings}>
				{ imageList }
			</Slider>

			<div className="info">
				<h1>{props.title}</h1>

				{ReactHtmlParser(props.desc)}

				<div className="store-item-bottom">
					<p className="stock"><b>{props.stock}</b> in stock</p>
					<a href={props.source_url}><img src="/static/source.png"/></a>
					<a href={props.tindie_url} className="purchase-link">
						<span>{props.price}</span>
						<p>Buy on <b>Tindie</b> →</p>
					</a>
				</div>

			</div>
		</div>
	)
}