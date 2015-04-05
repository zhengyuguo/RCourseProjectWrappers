#!/usr/bin/env bash

. getoptheader.sh hd:s:p:S:o: help,outdir:,samplecol:,phenocol:,sampletable:,outname: "$@"

outdir=.
samplecol=FileName
phenocol=Phenotype
while true
do
  case "$1" in
    -h|--help)
      cat "$script_absdir/${script_name}_help.txt"
      exit
      ;;
    -d|--outdir)
      outdir="$2"
      shift 2
      ;;
    -s|--samplecol)
      samplecol="$2"
      shift 2
      ;;
    -p|--phenocol)
      phenocol="$2"
      shift 2
      ;;
    -S|--sampletable)
      sampletable="$2"
      shift 2
      ;;
    -o|--outname)
      outname="$2"
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

. die.sh
[ "$sampletable" -a -f "$sampletable" ] || die "$script_name.sh:Error:Sample table must be specified!" 

Rpkavail.sh pytools limma affy -c "$script_name.sh" || exit $?

function cmd {
local indir="$1"

[ -d "$indir" ] || die "$script_name.sh:Error:input should be a directory."

if [ "$outname" ]
then
  local bname="$outname"
else
  local bname=$(basename "$indir")
fi
local obname=$(subsuffix.sh "$bname" -x "$outsuffix.rds")

Rcmd.sh <<EOF
sampletable='$sampletable'
data_dir='$indir'
outfile='$outdir/$obname'
samplecol='$samplecol'
phenocol='$phenocol'
source('$script_absdir/R/$script_name.R')
EOF
}

if [ $# -ne 0 ]
then
  cmd "$1"
fi

