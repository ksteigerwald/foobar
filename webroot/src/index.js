import React from 'react';
import ReactDOM from 'react-dom';

class Coins extends React.Component {
	constructor(props) {
		super(props)
		this.state = { data: [] }
	}
	
	loadData() {
		fetch('http://localhost:8181/api/v1/coins')
			.then(response => response.json())
			.then(data => {
				this.setState({data: data })
		  })
			.catch(err => console.error(this.props.url, err.toString()))
	}
	
	signOrder(id) {
		let ids = [ { 'id': id } ];
		console.log(ids)
		fetch('http://localhost:8181/api/v1/coins', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(ids)
		})
		
	}
	
	componentDidMount() {
		this.loadData()
	}
	
  render() {
    return <ul>
			<li className='title'>
				<span>SYMBOL</span>
				<span>USD</span>
				<span>BTC</span>
				<span></span>
			</li>
      { this.state.data.map((item, i) => {
				return <li className='item'>
					<span>{item.symbol}</span>
					<span>{item.price_usd}</span>
					<span>{item.price_btc}</span>
				</li>
        })
      }
    </ul>;
  }
}
			
ReactDOM.render(<Coins />, document.getElementById('app'));


const title = 'My Minimal React Webpack Babel Setup';

ReactDOM.render(
  <div>{title}</div>,
  document.getElementById('app')
);

module.hot.accept();
