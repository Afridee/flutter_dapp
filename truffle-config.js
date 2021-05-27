module.exports = {
  networks: {
    development: {
      host: "192.168.0.160",
      port: 7545,
      network_id: "*", // Match any network id
      from: '0xae580050638569B8B7957bF6E53779E9745a842e'
    },
    advanced: {
      websockets: true, // Enable EventEmitter interface for web3 (default: false)
    },
  },
  contracts_build_directory: "./src/abis/",
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};