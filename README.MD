some scripts that are useful
try running deploy.sh on a fresh box - it will setup the following:
- agave rpc validator at the set version
- yellowstone grpc geyser plugin w/ an x token
- nginx reverse proxy for rpc to make it permissioned from outside

what needs to be done manually?:
- preferably 2 disks, one mounted at /solana/accounts, one at /solana/ledger