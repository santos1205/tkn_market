// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const TKNMarketModule = buildModule("TKNMarketModule", (m) => { 
  const TKNMarket = m.contract("TKNMarket");

  return { TKNMarket };
});

export default TKNMarketModule;