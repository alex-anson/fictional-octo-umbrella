import React, { Component } from "react";
import Web3 from "web3";
import "./App.css";
import Decentragram from "../abis/Decentragram.json";
import Navbar from "./Navbar";
import Main from "./Main";

class App extends Component {
  async componentDidMount() {
    await this.loadWeb3();
    await this.loadBlockchainData();
  }
  // Gets the ethereum provider from MetaMask. MetaMask puts an ethereum provider into the browser, which allows us to connect to ethereum. Uses that ethereum provider to instantiate a connection to the blockchain
  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum);
      await window.ethereum.enable();
    } else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider);
    } else {
      window.alert("Non-Ethereum browser detected.");
    }
  }

  // Fetch the account from MetaMask
  async loadBlockchainData() {
    const web3 = window.web3;
    // Load account
    const accounts = await web3.eth.getAccounts();
    this.setState({ account: accounts[0] });

    // get the decentragram smart contract from the network ... create a js version of the contract, using web3.js
    // Network ID
    const networkID = await web3.eth.net.getId();
    // get the network data
    const networkData = Decentragram.networks[networkID];
    if (networkData) {
      // "final destination we want to go to"
      const decentragram = web3.eth.Contract(
        Decentragram.abi,
        networkData.address
      );
      this.setState({ decentragram });

      // load the images
      const imagesCount = await decentragram.methods.imageCount().call();
      // update the state with the image count
      this.setState({ imagesCount });
    } else {
      window.alert("Decentragram contract not deployed to detected network.");
    }
  }

  constructor(props) {
    super(props);
    this.state = {
      account: "",
      // store the smart contract into the state
      decentragram: null,
      images: [],
      loading: true,
    };
  }

  render() {
    return (
      <div>
        <Navbar account={this.state.account} />
        {this.state.loading ? (
          <div id="loader" className="text-center mt-5">
            <p>Loading...</p>
          </div>
        ) : (
          <Main
          // Code...
          />
        )}
        }
      </div>
    );
  }
}

export default App;
