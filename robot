#!/usr/bin/env python

import os
import json
import sys
import argparse
import configparser

config = configparser.ConfigParser()
config.read(os.environ["HOME"] + "/.config/robot/config")
bmarks = config['general']['bmarks']

def listBmarks(args):
    bookmarkfile = open(str(bmarks))
    bookmarks = json.loads(bookmarkfile.read())

    for x in bookmarks:
        print(x['name'] + "   " + x['url'] +"   " + ', '.join(x['tags']) + "   " + x['group'])

def addBmarks(args):
    bookmarkfile = open(str(bmarks), 'r')
    bookmarks = json.loads(bookmarkfile.read(), 'r')
    bookmarkfile.close
    bookmarkfile = open(str(bmarks), 'w')
    bookmarks.append({"name": str(args.name), "url": str(args.url), "group": str(args.group), "tags": args.tags.split(" ")})
    bookmarks_final = json.dumps(bookmarks, sort_keys=True, indent=4, separators=(',', ': '))
    with open("bookmarks", "w") as text_file:
        print((bookmarks_final), file=bookmarkfile)


def findUrlbyName(args):
    if args.name:
        bookmarkfile = open(str(bmarks), 'r')
        bookmarks = json.loads(bookmarkfile.read(), 'r')
        bookmarkfile.close
        url = [bookmark['url'] for bookmark in bookmarks if bookmark['name'] == str(args.name)]
        print(", ".join(url))

    if args.group:
        bookmarkfile = open(str(bmarks), 'r')
        bookmarks = json.loads(bookmarkfile.read(), 'r')
        bookmarkfile.close
        url = [bookmark['url'] for bookmark in bookmarks if bookmark['group'] == str(args.group)]
        print(", ".join(url))

    if args.tag:
        bookmarkfile = open(str(bmarks), 'r')
        bookmarks = json.loads(bookmarkfile.read(), 'r')
        bookmarkfile.close
        url = [bookmark['url'] for bookmark in bookmarks if args.tag in bookmark['tags']]
        print("\n".join(url))

parser = argparse.ArgumentParser(prog='robot', description='Simple bookmark tool')
subparsers = parser.add_subparsers()

parser_list = subparsers.add_parser('list', help="list all bookmarks")
parser_list.set_defaults(call=listBmarks)

parser_add = subparsers.add_parser('add', help="Add a bookmark")
parser_add.set_defaults(call=addBmarks)
parser_add.add_argument('--url', help="URL of bookmark")
parser_add.add_argument('--name', help="Name of bookmark")
parser_add.add_argument('--tags', help="tags of bookmark")
parser_add.add_argument('--group', help="group of bookmark")

parser_add = subparsers.add_parser('geturl', help="find url for matching name")
parser_add.set_defaults(call=findUrlbyName)
parser_add.add_argument('--name', help="Name of bookmark")
parser_add.add_argument('--group', help="Group of bookmark")
parser_add.add_argument('--tag', nargs="?", help="Tag of bookmark")

args = parser.parse_args()
args.call(args)
