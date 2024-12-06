module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 7545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    }
  },

  // Set default mocha options here, use special reporters, etc.
  mocha: {
    // timeout: 100000
  },
  contracts_build_directory: "./src/artifacts/",
  // Configure your compilers
  compilers: {
  solc: {
  optimizer: {
  enabled: false,
  runs: 200
  },
  evmVersion: "byzantium"}}}