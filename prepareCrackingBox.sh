#!/bin/bash

mkdir CrackingJob
cd CrackingJob
wget https://raw.githubusercontent.com/n0kovo/hashcat-rules-collection/refs/heads/main/hob0rules/d3adhob0.rule
wget https://raw.githubusercontent.com/n0kovo/hashcat-rules-collection/refs/heads/main/nsa-rules/_NSAKEY.v2.dive.rule
wget https://weakpass.com/download/1858/Top2Billion-probable-v2.txt.gz
gunzip Top2Billion-probable-v2.txt.gz


#Don't forget to add your custom wordlist for the specific client engagement

#Kerberoasting
#hashcat -a 0 -m 13100 ./kerberoastHash.file ./Top2Billion-probable-v2.txt ./mycustomwordlist.txt -r _NSAKEY.v2.dive.rule -O -w 3
