import React, { Component } from "react";
import Web3 from "web3";
import {
  MDBCard,
  MDBCardBody,
  MDBCardTitle,
  MDBCardText,
  MDBCardImage,
  MDBBtn,
} from "mdb-react-ui-kit";
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
    // console.log("accounts:");
    // console.log(accounts);
    this.setState({ account: accounts[0] });

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
      const totalSupply = parseInt(
        await contract.methods.totalSupply().call(),
        10
      );
      // console.log("Total Supply:");
      // console.log(totalSupply);
      this.setState({ totalSupply });
      // Load KryptoBirdz
      for (let i = 0; i < totalSupply; i++) {
        const kryptoBird = await contract.methods.kryptoBirdz(i).call();
        this.setState((state) => ({
          ...state,
          kryptoBirdz: [...state.kryptoBirdz, kryptoBird],
        }));
        // console.log("kryptoBird");
        // console.log(kryptoBird);
      }
    } else {
      window.alert("Error: Smart contract not deployed.");
    }
  }

  /** Minting function.
   *  With minting, we are seding information. And we need to specify the account.
   */
  mint = (kryptoBird) => {
    // console.log("Minting kryptobird: ");
    // console.log(kryptoBird);
    this.state.contract.methods
      .mint(kryptoBird)
      .send({ from: this.state.account });
    this.state.contract.once("Transfer", (receipt) => {
      this.setState((state) => ({
        ...state,
        kryptoBirdz: [...state.kryptoBirdz, kryptoBird],
        totalSupply: state.totalSupply + 1,
      }));
    });
  };

  constructor(props) {
    super(props);
    this.state = {
      account: "",
      contract: null,
      totalSupply: 0,
      kryptoBirdz: [],
    };
    this.kryptoBirdInput = React.createRef();
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

        <div className="container-fluid mt-1">
          <div className="row">
            <main rols="main" className="col-lg-12 d-flex text-center">
              <div
                className="content mr-auto ml-auto"
                style={{ opacity: "0.8" }}
              >
                <h1 style={{ color: "white" }}>
                  KryptoBirdz - NFT marketplace
                </h1>
                <form
                  onSubmit={(event) => {
                    event.preventDefault();
                    this.mint(this.kryptoBirdInput.current.value);
                  }}
                >
                  <input
                    type="text"
                    placeholder="Add a file location"
                    className="form-control mb-1"
                    ref={this.kryptoBirdInput}
                  ></input>
                  <input
                    type="submit"
                    className="btn btn-primary btn-black"
                    style={{ margin: "6px" }}
                    value="MINT"
                  ></input>
                </form>
                <div>Minted tokens:</div>
                <div>
                  {this.state.kryptoBirdz.map((bird) => (
                    <div key={bird}>{bird}</div>
                  ))}
                </div>
              </div>
            </main>
          </div>
          <hr />
          <div className="row text-center">
            {this.state.kryptoBirdz.map((bird) => (
              <div key={bird}>
                <div>
                  <MDBCard className="token img" style={{ maxWidth: "22rem" }}>
                    <MDBCardImage
                      src={bird}
                      position="top"
                      style={{ marginRight: "4px" }}
                    />
                    <MDBCardBody>
                      <MDBCardTitle>KryptoBirdz</MDBCardTitle>
                      <MDBCardText>
                        The KryptoBirdz are 20 uniquely generated KBirdz from
                        cyberpunk galaxy Mystopia! There is only one of each
                        bird which can only be owned by a single person. {bird}
                      </MDBCardText>
                      <MDBBtn href={bird}>Download</MDBBtn>
                    </MDBCardBody>
                  </MDBCard>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    );
  }
}

export default App;
