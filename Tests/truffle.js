module.exports = {
  networks: {
  development: {
    host: "localhost",
    port: 8545,
    network_id: "4", // Match any network id,
    gas: 7984452, // Block Gas Limit same as latest on Mainnet https://ethstats.net/
    gasPrice: 2000000000, // same as latest on Mainnet https://ethstats.net/
  },
  console: {
    host: "localhost",
    port: 8545,
    network_id: "4", // Match any network id,
    gas: 3000000,
    gasPrice: 2000000 // 20 gwei
  },
  rpc: {
    host: "localhost",
    port: 8545
  }
}
};