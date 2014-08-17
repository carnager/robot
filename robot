#!/usr/bin/env python

import os
import json
import sys
import argparse
import configparser
import itertools

config = configparser.ConfigParser()
config.read(os.environ["HOME"] + "/.config/robot/config")
bmarks = config['general']['bmarks']
try:
    open(bmarks, 'r')
except FileNotFoundError:
    open(bmarks, 'w+').write('[]')
    print("No bookmarkfile found - creating empty one")
    print("Please run robot again")
    sys.exit()


def listURL(args):
    bookmarkfile = open(str(bmarks), 'r')
    bookmarks = json.loads(bookmarkfile.read(), 'r')
    bookmarkfile.close

    if args.group:
        url = [bookmark['name'] + "   " + bookmark['url'] + "   " + ', '.join(bookmark['tags']) + "   " + bookmark['group'] for bookmark in bookmarks if bookmark['group'] == str(args.group)]
        print("\n".join(url))

    if args.tag:
        url = [bookmark['name'] + "   " + bookmark['url'] + "   " + ', '.join(bookmark['tags']) + "   " + bookmark['group'] for bookmark in bookmarks if args.tag in bookmark['tags']]
        print("\n".join(url))



def listAll(args):
    bookmarkfile = open(str(bmarks))
    bookmarks = json.loads(bookmarkfile.read())
    bookmarkfile.close

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
    bookmarkfile = open(str(bmarks), 'r')
    bookmarks = json.loads(bookmarkfile.read(), 'r')
    bookmarkfile.close

    if args.name:
        url = [bookmark['url'] for bookmark in bookmarks if bookmark['name'] == str(args.name)]
        print(", ".join(url))

    if args.group:
        url = [bookmark['url'] for bookmark in bookmarks if bookmark['group'] == str(args.group)]
        print("\n".join(url))

    if args.tag:
        url = [bookmark['url'] for bookmark in bookmarks if args.tag in bookmark['tags']]
        print("\n".join(url))


def getGroups(args):
        bookmarkfile = open(str(bmarks), 'r')
        bookmarks = json.loads(bookmarkfile.read(), 'r')
        bookmarkfile.close
        groups = [bookmark['group'] for bookmark in bookmarks]
        print("\n".join(groups))

def getTags(args):
        bookmarkfile = open(str(bmarks), 'r')
        bookmarks = json.loads(bookmarkfile.read(), 'r')
        bookmarkfile.close
        tags = [bookmark['tags'] for bookmark in bookmarks]
        tags = [item for sublist in tags for item in sublist]
        print("\n".join(tags))


parser = argparse.ArgumentParser(prog='robot', description='Simple bookmark tool')
subparsers = parser.add_subparsers()

parser_list = subparsers.add_parser('list', help="list bookmarks by filter")
parser_list.set_defaults(call=listURL)
parser_list.add_argument('--group', help="List bookmarks by Groups")
parser_list.add_argument('--tag', help="List bookmarks by Tags")

parser_listall = subparsers.add_parser('listall', help="list all bookmarks")
parser_listall.set_defaults(call=listAll)

parser_getgroup = subparsers.add_parser('getgroups', help="List all Groups")
parser_getgroup.set_defaults(call=getGroups)

parser_gettags = subparsers.add_parser('gettags', help="List all Tags")
parser_gettags.set_defaults(call=getTags)

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
try:
    args.call(args)
except AttributeError:
    print("No or wrong arguments given. Run robot -h for help")
