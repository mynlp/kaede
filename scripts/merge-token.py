#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import argparse
import sys
import re


# pattern for a line showing sentence id 
sid_pat = re.compile(ur'^#\s+S-ID:\s*([0-9]+-[0-9]+)')
offset_pat = re.compile(ur'\s+(TOKEN_([0-9]+)_([0-9]+))[\s\)]')

def merge(text_file, tr_file):
    with open(text_file, 'r') as text_f, open(tr_file, 'r') as tr_f:
        for tr_line in tr_f:
            tree_id, tree = tr_line.decode('utf-8').rstrip('\n').partition('\t')[::2]

            # search text_file for the same id
            text_id, sent = None, None
            for text_line in text_f:
                text_line = text_line.decode('euc-jp').rstrip('\n')

                sid_match = sid_pat.search(text_line)
                if sid_match and sid_match.group(1) == tree_id:
                        text_id = tree_id
                elif text_id != None and not text_line.startswith('#'):
                    sent = text_line
                    break

            if text_id != None and sent != None:
                print(tree_id.encode('utf-8') + '\t' + merge_token(sent, tree).encode('utf-8'))


def get_conll_sid(lines):
    if len(lines) <= 0:
        return None
    match = sid_pat.search(lines[0])
    if not match:
        sys.stderr.write('the first line must be a comment line showing sentence id')
        sys.exit()
    return match.group(1)


def merge_token(sent, tree):
    offset, ret = 0, ''
    for match in re.finditer(offset_pat, tree):
        start, end = int(match.group(2)), int(match.group(3))
        ret += tree[offset:match.start(1)] + sent[start:end]
        offset = match.end(1)
    ret += tree[offset:]

    return ret



if __name__ == '__main__':
    argparser = argparse.ArgumentParser(description = "Find and extract tree annotations with specified ids")
    argparser.add_argument("org_file", type=str, help="file containing original text")
    argparser.add_argument("tr_file", type=str, help="file containing tree annotations for the 1st argument")
    args = argparser.parse_args()

    merge(args.org_file, args.tr_file)

