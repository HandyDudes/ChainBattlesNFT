# ChainBattles project 3 Road to Web3
This project demonstrates the creation of NFT's with their
metadata stored on-chain as opposed to using IPFS.  

The project runs on the Polygon Mumbia testnet and NFT's generated are 
displayed on Opensea.  The project uses OpenZeppelin's ERC721 base contract to
provide the NFT base functionality.

NFT's are created with four status types which are assigned (pseudo-)random 
values at creation.  These values can be queried with getters, but only one,
Level, is exposed to update via the train() function.

The project is on Mumbai at 0x67b69E1F31Dba8E3F1c8619FE1442D5a25B3bdCA
