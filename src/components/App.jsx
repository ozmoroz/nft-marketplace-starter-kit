import React, { Component } from "react";
import Web3 from "web3";
// import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from "../abis/KryptoBird.json";

class App extends Component {
  async componentDidMount() {
    await this.loadWeb3();
    await this.loadBlockchainData();
  }

  // Detect an Etherium provider
  async loadWeb3() {
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

    // Load the conract data
    // Get the Ganache blockchain network ID
    // const provider = await detectEthereumProvider();
    const networkId = await web3.eth.net.getId();
    const networkData = KryptoBird.networks[networkId];
    if (networkData) {
      // NOTE: The conract must already be deployed to the Blockchain.
      // Then its abi contains its network Id and address.
      // 1. Create a var abi set to KryptoBird abi.
      // 2. Create a var address and set to to the network address.
      // 3. Create a var contract which grabs a new instance of web3 eth contract.
      // 4. Console log te var conrtract successfully.
      const abi = KryptoBird.abi;
      const address = networkData.address;
      const contract = new web3.eth.Contract(abi, address);
      this.setState({ contract });
      // console.log("Contract: ");
      // console.log(contract);

      // call the total supply of our Krypto Birdz
      const totalSupply = await contract.methods.totalSupply().call();
      // console.log("Total Supply:");
      // console.log(totalSupply);
      this.setState({ totalSupply });
      // Load KryptoBirdz
      for (let i = 0; i < totalSupply; i++) {
        const kryptoBird = await contract.methods.kryptoBirdz(i - 1).call();
        console.log("kryptoBird");
        console.log(kryptoBird);
      }
    } else {
      window.alert("Error: Smart contract not deployed.");
    }
  }

  constructor(props) {
    super(props);
    this.state = {
      account: "",
      contract: null,
      totalSupply: 0,
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
