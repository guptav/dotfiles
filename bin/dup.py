#!/usr/local/bin/python3
"""
Find duplicate code in the given file.
"""
import sys
import logging
import hashlib

hash_funct = hashlib.md5
REV_HASH_MAP = {}
LINE_LENGTH = 5

def read_file(file_name):
    """read a given file"""
    with open(file_name, 'r') as file_handle:
        content = file_handle.read()
    return content

def pre_process(content):
    """Preprocess file"""
    out = [line.strip() for line in content if line is not ""]
    hash = [hash_funct(line.encode()).hexdigest() for line in out]
    hash_map  = {h:0 for h in set(hash)}
    for i, j in zip(hash, out):
        hash_map[i] = hash_map[i] + 1
        REV_HASH_MAP[i] = j
    logging.error(REV_HASH_MAP)
    return (hash, hash_map)

def process(data):
    """process file"""
    (hash, hash_map) = data
    print("=" * 10 + hash[0])
    for i in range(0, len(hash)):
        for j in range(i+1, len(hash)):
            if hash_map[hash[j]] == 1:
                continue
            length = 0
            while length + j < len(hash):
                if hash[i+length] == hash[j+length]:
                    length = length + 1
                else:
                    break
            if length > LINE_LENGTH:
                print("-" * 40)
                print(i, j, length)
                for k in range(j, j+length):
                    print(REV_HASH_MAP[hash[k]])

def print_all(content_list):
    """print content"""
    for i in content_list:
        for j in i:
            print(j)

def find_dup_code(file_list):
    """find duplicate code in a file"""
    content_list = [read_file(f).splitlines() for f in file_list]
    content_list = [pre_process(li) for li in content_list]
    _result = [process(li) for li in content_list]
    # print_all(content_list)

if __name__ == "__main__":
    find_dup_code(sys.argv[1:])
