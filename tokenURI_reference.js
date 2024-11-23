const { ethers } = require("ethers");
const axios = require("axios");

// Replace these with your actual values
const provider = new ethers.providers.JsonRpcProvider("<YOUR_RPC_URL>"); // Replace with your RPC URL
const contractAddress = "<YOUR_CONTRACT_ADDRESS>"; // Deployed contract address
const contractABI = [
  {
    constant: true,
    inputs: [],
    name: "totalSupply",
    outputs: [{ name: "", type: "uint256" }],
    type: "function",
  },
  {
    constant: true,
    inputs: [{ name: "tokenId", type: "uint256" }],
    name: "tokenURI",
    outputs: [{ name: "", type: "string" }],
    type: "function",
  },
  {
    constant: true,
    inputs: [{ name: "tokenId", type: "uint256" }],
    name: "ownerOf",
    outputs: [{ name: "", type: "address" }],
    type: "function",
  },
];

async function interactWithContract() {
  // Connect to the contract
  const contract = new ethers.Contract(contractAddress, contractABI, provider);

  try {
    // Get total supply of tokens
    const totalSupply = await contract.totalSupply();
    console.log(`Total Supply: ${totalSupply.toString()}`);

    // Fetch details for each token
    for (let tokenId = 1; tokenId <= totalSupply; tokenId++) {
      const tokenURI = await contract.tokenURI(tokenId);
      console.log(`Fetching metadata for Token ID: ${tokenId}...`);

      // Fetch the metadata JSON from tokenURI
      const metadata = await fetchMetadata(tokenURI);
      const price = parsePrice(metadata);

      console.log(`Token ID: ${tokenId}`);
      console.log(`Price: $${price}`);
    }
  } catch (error) {
    console.error("Error interacting with contract:", error);
  }
}

// Helper function to fetch metadata from tokenURI
async function fetchMetadata(tokenURI) {
  try {
    const response = await axios.get(tokenURI);
    return response.data;
  } catch (error) {
    console.error(`Error fetching metadata from ${tokenURI}:`, error);
    throw error;
  }
}

// Helper function to parse price from metadata
function parsePrice(metadata) {
  const attributes = metadata.attributes || [];
  const priceAttribute = attributes.find((attr) => attr.trait_type === "Price");
  return priceAttribute ? priceAttribute.value : "Unknown";
}

interactWithContract();
