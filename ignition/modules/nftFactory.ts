// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

// const JAN_1ST_2030 = 1893456000;
// const ONE_GWEI: bigint = 1_000_000_000n;

const CONTRACT_URI =
  "https://green-obedient-minnow-170.mypinata.cloud/ipfs/QmY4gDgSt3SvwnrZX8USvK4FmprbW1Se48ZJaJT4NdUkch";
const TOKEN_NAME = "TKN Collection";
const TOKEN_SYMBOL = "TKC";

const NFTFactoryModule = buildModule("NFTFactoryModule", (m) => {
  const tokenName = m.getParameter("tokenName", TOKEN_NAME);
  const tokenSymbol = m.getParameter("contractUri", TOKEN_SYMBOL);
  const contractUri = m.getParameter("contractUri", CONTRACT_URI);
  //const lockedAmount = m.getParameter("lockedAmount", ONE_GWEI);

  const NFTFactory = m.contract("NFTFactory", [tokenName, tokenSymbol, contractUri]);

  return { NFTFactory };
});

export default NFTFactoryModule;