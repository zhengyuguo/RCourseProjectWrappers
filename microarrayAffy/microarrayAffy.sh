#!/usr/bin/env bash

. getoptheader.sh ha:d:s:p:S:o: help,annotation,outdir:,samplecol:,phenocol:,sampletable:,outname: "$@"

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
    -a|--annotation)
      annotation=$2
      shift 2
      ;;
    -d|--outdir)
      outdir=$2
      shift 2
      ;;
    -s|--samplecol)
      samplecol=$2
      shift 2
      ;;
    -p|--phenocol)
      phenocol=$2
      shift 2
      ;;
    -S|--sampletable)
      sampletable=$2
      shift 2
      ;;
    -o|--outname)
      outname=$2
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
[  "$annotation" ] || die "$script_name.sh:Error:annotation package name must be specified!"

Rpkavail.sh pytools limma affy "$annotation" -c "$script_name.sh" || exit $?

function cmd {
local indir="$1"

[ -d "$indir" ] || die "$script_name.sh:Error:input should be a directory."

if [ "$outname" ]
then
  local bname="$outname"
else
  local bname=$(basename "$indir")
fi
local obname=$(subsuffix.sh "$bname" -x "$outsuffix")

Rcmd.sh <<EOF
sampletable='$sampletable'
data_dir='$indir'
outall='$outdir/$obname.txt'
samplecol='$samplecol'
phenocol='$phenocol'
annotation='$annotation'
outsig='$outdir/${obname}_sig.txt'
suppressPackageStartupMessages(library(annotate))
suppressPackageStartupMessages(library($annotation))
source('$script_absdir/R/$script_name.R')
EOF
}

if [ $# -ne 0 ]
then
  cmd "$1"
fi

