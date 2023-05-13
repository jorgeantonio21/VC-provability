# VC-provability
Polygon Verifiable Credentials proof verification for DAO voting.

Sketch of protocol:

1. A user registers on a DAO via its public key (traditionally). 
2. The DAO emits a certificate membership, in the form of a Verifiable Certificate (VC).
2. The user private-public key can be used to (ecdsa) sign its Polygon's Verifiable Credentials (more precisely, its hash).
3. A ZK proof is generated for this signature, so the user can only claim this signed hash VCs.
4. A vote registry smart contract is deployed to keep track of DAO voting. The user publishes (on-chain) the above
ZK proof, on the registry.
5. The user picks a voting choice on the DAO voting session. Signs the voting with its private-public key pair. 
6. The user 
