const HDWalletProvider = require('@truffle/hdwallet-provider');

const fs = require('fs');
// const mnemonic = fs.readFileSync(".secret").toString().trim();
const testMnemonic = fs.readFileSync("test.secret").toString().trim();

module.exports = {
    // Uncommenting the defaults below
    // provides for an easier quick-start with Ganache.
    // You can also follow this format for other networks.
    // See details at: https://trufflesuite.com/docs/truffle/reference/configuration
    // on how to specify configuration options!
    //
    networks: {
        development: {
            host: "127.0.0.1",
            port: 7545,
            network_id: "*"
        },
        rinkeby_test: {
            provider: () => new HDWalletProvider(testMnemonic, `http://164.92.80.238:8545`),
            network_id: 1214,       // Ropsten's id
            gas: 5500000,        // Ropsten has a lower block limit than mainnet
            confirmations: 2,    // # of confs to wait between deployments. (default: 0)
            timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
            skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
        },
        goerli: {
            provider: () => new HDWalletProvider(testMnemonic, `https://goerli.infura.io/v3/62d7b5f33ae443e784919f1c2afe24a3`),
            network_id: 5,       // Ropsten's id
            gas: 5500000,        // Ropsten has a lower block limit than mainnet
            confirmations: 2,    // # of confs to wait between deployments. (default: 0)
            timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
            skipDryRun: true,     // Skip dry run before migrations? (default: false for public nets )
        },
    },
    //
    // Truffle DB is currently disabled by default; to enable it, change enabled:
    // false to enabled: true. The default storage location can also be
    // overridden by specifying the adapter settings, as shown in the commented code below.
    //
    // NOTE: It is not possible to migrate your contracts to truffle DB and you should
    // make a backup of your artifacts to a safe location before enabling this feature.
    //
    // After you backed up your artifacts you can utilize db by running migrate as follows:
    // $ truffle migrate --reset --compile-all
    //
    // db: {
    // enabled: false,
    // host: "127.0.0.1",
    // adapter: {
    //   name: "sqlite",
    //   settings: {
    //     directory: ".db"
    //   }
    // }
    // }
    mocha: {
        // timeout: 100000
    },
    compilers: {
        solc: {
            version: '^0.8.0',
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200
                }
            }
        }
    }
};
