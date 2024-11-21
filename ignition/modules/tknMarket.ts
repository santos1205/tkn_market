// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const CONTRACT_URI =
  "https://green-obedient-minnow-170.mypinata.cloud/ipfs/QmY4gDgSt3SvwnrZX8USvK4FmprbW1Se48ZJaJT4NdUkch";
const TOKEN_NAME = "TKN Collection";
const TOKEN_SYMBOL = "TKC";

const TKNMarketModule = buildModule("TKNMarketModule", (m) => {
  const tokenName = m.getParameter("tokenName", TOKEN_NAME);
  const tokenSymbol = m.getParameter("contractUri", TOKEN_SYMBOL);
  const contractUri = m.getParameter("contractUri", CONTRACT_URI);

  const TKNMarket = m.contract("TKNMarket", [
    tokenName,
    tokenSymbol,
    contractUri,
  ]);
  // const TKNMarket = m.contract("TKNMarket");

  return { TKNMarket };
});

export default TKNMarketModule;