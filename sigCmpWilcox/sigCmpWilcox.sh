#!/usr/bin/env bash

. getoptheader.sh hd:r:s:z: help,outdir:,drugsig:,symbol_col:,zthr: "$@"
outdir=.
symbol_col=pr_gene_symbol
zthr=2
while true
do
  case "$1" in
    -h|--help)
      cat "$script_absdir/${script_name}_help.txt"
      exit
      ;;  
    -d|--outdir)
      outdir=$2
      shift 2
      ;;
    -r|--drugsig)
      drugsig=$2
      shift 2
      ;;
    -s|--symbol_col)
      symbol_col=$2
      shift 2
      ;;
    -z|--zthr)
      zthr=$2
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "$script_name.sh:Internal error!" >&2
      exit -1
      ;;
  esac
done

source die.sh
[ "$drugsig" -a -f "$drugsig" ] || die "$script_name.sh:Error:drug signature file must be specified!"

Rpkavail.sh gCMAP pytools -c "$script_name.sh" || exit $?

function cmd {
local f="$1"
local bname=$(basename "$f" .txt)
local dbname=$(basename "$drugsig" .txt)
Rcmd.sh <<-EOF
file_drug='$drugsig'
file_disease='$f'
symbol_col='$symbol_col'
output_file='$outdir/${bname}_${dbname}_sigCmp.txt'
zthr=$zthr
source('$script_absdir/R/$script_name.R')
EOF
} 
if [ $# -ne 0 ]
then
  cmd "$1"
fi
