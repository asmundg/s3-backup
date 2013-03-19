#!/bin/sh -x

S3DIR=/mnt/s3-backup
mkdir -p $S3DIR
s3fs asmundg-backup -o passwd_file=/root/s3-password $S3DIR || exit 1

for dir in /root/off-site-backup/*; do
    encfs --stdinpass --reverse $dir /tmp/enc/ < $dir/.encfs_password || exit 1
    cp $dir/.encfs6.xml /tmp/enc/
    rsync -aPh --size-only /tmp/enc/ $S3DIR/$(basename $dir)
    umount /tmp/enc/
done

umount $S3DIR

