import React, { Component } from "react";
import Web3 from "web3";
// import detectEthereumProvider from "@metamask/detect-provider";
// import KryptoBird from "../abis/KryptoBird.json";

class App extends Component {
  async componentDidMount() {
    await this.loadWeb3();
    await this.loadBlockchainData();
  }

  // Detect an Etherium provider
  async loadWeb3() {
    // const provider = await detectEthereumProvider();

    // Ref: https://medium.com/valist/how-to-connect-web3-js-to-metamask-in-2020-fee2b2edf58a
    if (window.ethereum) {
      console.log("Ethereum wallet is connected");
      await window.ethereum.send("eth_requestAccounts");
      window.web3 = new Web3(window.ethereum);
      return true;
    } else {
      // No Ethereum provider
      console.log("No Etherium wallet detected.");
    }
  }

  async loadBlockchainData() {
    const web3 = window.web3;
    const accounts = await web3.eth.getAccounts();
    this.setState({ account: accounts });
  }

  constructor(props) {
    super(props);
    this.state = {
      account: "",
    };
  }

  render() {
    return (
      <div>
        <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
          <div
            className="navbar-brand col-sm-3 col-md-3 mr-0"
            style={{ color: "white" }}
          >
            Krypto Birdz NFT (Non Fungible Tokens)
          </div>
          <ul className="navbar-nav px3">
            <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
              <small className="text-white">{this.state.account}</small>
            </li>
          </ul>
        </nav>
      </div>
    );
  }
}

export default App;
