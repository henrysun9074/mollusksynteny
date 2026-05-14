#!/usr/bin/env python3
"""
This program parses a NCBI GFF annotation and generates a .chrom file.
see https://github.com/conchoecia/odp for the specification.
"""

import gzip
import sys

prots = {}

gzipped = False
for thisend in [".gz", ".gzip", ".GZ", ".GZIP", ".gzipped", ".GZIPPED"]:
    if sys.argv[1].endswith(thisend):
        gzipped = True

if gzipped:
    handle = gzip.open(sys.argv[1],'rt')
else:
    handle = open(sys.argv[1], "r")

for line in handle:
    line = line.strip()
    splitd = line.split("\t")
    if not line or len(splitd) <= 7 or splitd[2] != "CDS":
        continue

    attrs = splitd[8]
    attr_dict = {}
    for field in attrs.split(";"):
        if "=" in field:
            k, v = field.split("=", 1)
            attr_dict[k] = v

    # prefer protein_id (NCBI), fall back to Parent
    if "protein_id" in attr_dict:
        pid = attr_dict["protein_id"]
    elif "Parent" in attr_dict:
        pid = attr_dict["Parent"]
    else:
        continue

    scaf = splitd[0]
    strand = splitd[6]
    start = int(splitd[3])
    stop = int(splitd[4])

    if pid not in prots:
        prots[pid] = {"scaf": scaf, "strand": strand,
                      "start": start, "stop": stop}
    else:
        if start < prots[pid]["start"]:
            prots[pid]["start"] = start
        if stop > prots[pid]["stop"]:
            prots[pid]["stop"] = stop

handle.close()

for pid in prots:
    print("{}\t{}\t{}\t{}\t{}".format(
        pid, prots[pid]["scaf"],
        prots[pid]["strand"], prots[pid]["start"], prots[pid]["stop"]))