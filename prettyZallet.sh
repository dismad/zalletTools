#!/bin/bash

source ~/.bashrc

echo
echo "=================================================================================="
echo "                        NON-CHANGE OUTPUTS (Payments to others)"
echo "=================================================================================="
echo "TXID                                                              Height     Pool    Amount   Fee  In Out"
echo "----------------------------------------------------------------------------------"

zallet rpc z_listtransactions | jq -r '
  .[] as $tx |
  $tx.outputs[] |
  select(.is_change == false) |
  [
    $tx.txid,
    ($tx.mined_height // "pending"),
    .pool,
    .value,
    ($tx.fee_paid // 0),
    $tx.received_note_count,
    $tx.sent_note_count
  ] | @tsv
' | column -t

echo
echo "=================================================================================="
echo "                        CHANGE OUTPUTS (Returned to you)"
echo "=================================================================================="
echo "TXID                                                              Height     Pool    Amount   Fee  In Out"
echo "----------------------------------------------------------------------------------"

zallet rpc z_listtransactions | jq -r '
  .[] as $tx |
  $tx.outputs[] |
  select(.is_change == true) |
  [
    $tx.txid,
    ($tx.mined_height // "pending"),
    .pool,
    .value,
    ($tx.fee_paid // 0),
    $tx.received_note_count,
    $tx.sent_note_count
  ] | @tsv
' | column -t

echo