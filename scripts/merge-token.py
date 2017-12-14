#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import unicode_literals
from __future__ import print_function
from io import open
import argparse
import sys
import re


# pattern for a line showing sentence id 
sid_pat_in_org = re.compile(r'^#\s+S-ID:\s*([0-9]+-[0-9]+)')
offset_pat = re.compile(r'(TOKEN_([0-9]+)_([0-9]+))[/\s\)]')

sid_line_in_morph = '## ID: '

def merge_tree(text_file, tr_file):
    with open(text_file, 'r', encoding='euc-jp') as text_f, open(tr_file, 'r', encoding='utf-8') as tr_f:
        for tr_line in tr_f:
            tree_id, tree = tr_line.rstrip('\n').partition('\t')[::2]

            # search text_file for the same id
            text_id, sent = search_sent_for(tree_id, text_f)
            if text_id != None and sent != None:
                print(tree_id + '\t' + merge_token(sent, tree))


def merge_morph(text_file, morph_file):
    with open(text_file, 'r', encoding='euc-jp') as text_f, open(morph_file, 'r', encoding='utf-8') as morph_f:

        morph_sid, morphs = None, []
        for line in morph_f:
            morph_line = line.rstrip('\n')
            morphs.append(morph_line)

            if morph_line == 'EOS':
                if morph_sid is not None:
                    text_id, sent = search_sent_for(morph_sid, text_f) # search text_file for the same id
                    if text_id is not None and sent is not None:
                        for m in morphs:
                            print(merge_token(sent, m))
                morph_sid, morphs = None, []
                            
            elif morph_line.startswith(sid_line_in_morph):  #sentence id
                morph_sid = morph_line[len(sid_line_in_morph):]



def search_sent_for(sid, text_f):
    ''' search text_file for the id '''
    text_id, sent = None, None
    for text_line in text_f:
        text_line = text_line.rstrip('\n')

        sid_match = sid_pat_in_org.search(text_line)
        if sid_match and sid_match.group(1) == sid:
            text_id = sid
        elif text_id != None and not text_line.startswith('#'):
            sent = text_line
            return (text_id, sent)


def merge_token(sent, tree):
    offset, ret = 0, ''
    for match in re.finditer(offset_pat, tree):
        start, end = int(match.group(2)), int(match.group(3))
        ret += tree[offset:match.start(1)] + sent[start:end]
        offset = match.end(1)
    ret += tree[offset:]

    return ret



if __name__ == '__main__':
    argparser = argparse.ArgumentParser(description = "Merge the original text to Kaede annotation data")
    argparser.add_argument("org_file", type=str, help="file containing original text")
    argparser.add_argument("annot_file", type=str, help="file containing Kaede annotation for the 1st arg")
    argparser.add_argument("--annot", "-a", choices=['tree', 'morph'], default='tree', help="type of annotaion")
    args = argparser.parse_args()

    if args.annot == 'tree':
        merge_tree(args.org_file, args.annot_file)
    else:
        merge_morph(args.org_file, args.annot_file)
