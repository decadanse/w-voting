# Voting with PrimeDAO and Gnosis Safe

This repo contains weighted Voting app which allows members of PrimeDAO seed vote and add/remove owners from Gnosis Safe if they stake enough funds in % on DAO.

Repository is organized as follows:

- `/contracts/test/`- contracts used for tests.
- `/contracts/seed/`- Prime Launch seed module contracts.
- `/contracts/gnosis/`- Gnosis Safe contracts.
- `/contracts/voting/`- Voting contract.
- `/docs/`- additional PrimeDAO v2 documentation.

## Development

requires

```
node >= 12.0
```

to install node modules

```
npm i
```

to compile run

```
npm run compile
```

to test

```
npm run test
```

to run coverage

```
npm run coverage
```

## Environment setup

please prepare `.env` file

```bash
touch .env
```

delete 
```safe-deployments, safe-core-sdk-types, safe-core-sdk, safe-contracts
```
from node-modules/@gnosis.pm

Install module from npm
```bash
npm i -D @gnosis.pm/mock-contract
```

## Deployment

This project uses the hardhat-deploy plugin to deploy contracts. When a contract has been deployed, it is saved as JSON to the `deployments` directory, including its _address_ as well as its _abi_.

Since this is a project that is continuously being extended, it is generally not desirable to always deploy all contracts. Therefore, this project makes use of [deployment tags](https://hardhat.org/plugins/hardhat-deploy.html#deploy-scripts-tags-and-dependencies). These are specified at the end of each deploy script.


### Deployment to rinkeby

General (one tag):
`npm run deploy:contracts:rinkeby --tags=<YOUR_TAG_NAME>`

General (multiple tags):
`npm run deploy:contracts:rinkeby --tags=<YOUR_TAG_NAME1>,<YOUR_TAG_NAME2>`

Example (deploys Migration contracts):
`npm run deploy:contracts:rinkeby --tags=Migration`



## Interacting with contracts

This project uses hardhat tasks to interact with deployed contracts. The associated scripts can be found in the `tasks` directory. To get an **overview of all existing tasks** you can run `npx hardhat` on your command line.

To get more information on specific tasks (e.g. what they do, which parameters they require etc.) you can run `npx hardhat help <task_name>`.

Here's an example of a command to execute a task on rinkeby:
`npx hardhat --network rinkeby changeOwner --address <0xsome_address>`


## Code formatting

To format JS and Solidity code, run the following command:

`npm run format`



## References

(PrimeDAO contracts-v2)[https://github.com/PrimeDAO/contracts-v2]

(Gnosis Safe)[https://github.com/gnosis/safe-contracts]


