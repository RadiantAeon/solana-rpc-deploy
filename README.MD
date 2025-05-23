# some scripts that are useful

try running `deploy.sh` on a fresh box - it will setup the following:
- agave rpc validator at the set version
- yellowstone grpc geyser plugin w/ an x token
- nginx reverse proxy for rpc to make it permissioned from outside
- permissioned jupiter endpoint

what needs to be done manually?:
- preferably 2 disks, one mounted at /solana/accounts, one at /solana/ledger
- try `sudo mkfs -t ext4 /dev/<disk>` and then adding that disk to `/etc/fstab`
- also don't forget to change `sshd_config` to have `PasswordAuthentication no` :)
- setting up jupiter
- setup JITO
- set NTP server to relevant ntp server https://jito-labs.gitbook.io/mev/searcher-resources/block-engine/mainnet-addresses
- update kernel to use amd-pstate
- set swappiness/other tuning


IOWAIT issues?
try the following
- Edit `/etc/default/grub`.
- Add `nvme_core.default_ps_max_latency_us=0` to the `GRUB_CMDLINE_LINUX_DEFAULT` line. For example: `GRUB_CMDLINE_LINUX_DEFAULT="nvme_core.default_ps_max_latency_us=0"`.
- Run `update-grub`.
