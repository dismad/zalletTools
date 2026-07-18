#!/bin/bash

source ~/.bashrc

# Colors
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
LIGHTRED='\033[1;31m'
LIGHTGRAY='\033[0;37m'

echo "Fetching transactions with memos..."
echo

zallet rpc z_listtransactions | jq -r '
  .[] as $tx |
  $tx.outputs[] |
  select(.is_change == false) |
  select(.memo != null) |
  [
    $tx.block_datetime,
    $tx.txid,
    .pool,
    .value,
    ($tx.fee_paid // 0),
    .memo
  ] | @tsv
' | while IFS=$'\t' read -r date txid pool amount fee memo; do

    echo "----------------------------------------------------------------------------------------"
    echo -e "${RED}$date${NC} | ${GREEN}$txid${NC}"
    echo -e "${CYAN}Pool:${NC} $pool        |  ${YELLOW}Amount:${NC} $amount  |  ${LIGHTRED}Fee:${NC} $fee"
    echo -e "${CYAN}Memo:${NC}"
    echo -e "${LIGHTGRAY}$memo${NC}"
    echo

done