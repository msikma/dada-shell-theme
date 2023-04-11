#!/usr/bin/env python3

import unicodedata
import argparse

parser = argparse.ArgumentParser(description="Prints out a file with Unicode characters normalized")
parser.add_argument("path", help="Path to file to normalize", action="store", metavar="PATH")
parser.add_argument("-f", "--form", help="Normal form to use (NFC, NFKC, NFD, NKFD; default NFC)", action="store", default="NFC")

args = parser.parse_args()

with open(args.path, 'r') as file:
  data = file.read()
  norm = unicodedata.normalize(args.form, data)
  print(norm)
