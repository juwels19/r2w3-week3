require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    mumbai: {
      url: process.env.MUMBAI_RPC,
      accounts: [process.env.DEV_PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
  }
};
