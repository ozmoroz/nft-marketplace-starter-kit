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
    // console.log(accounts);
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
        <h1>NFT Marketplace</h1>
      </div>
    );
  }
}

export default App;
