#!/bin/sh -x

S3DIR=/mnt/s3-backup
umount /mnt/s3-backup || mkdir -p $S3DIR
umount /tmp/enc || mkdir -p /tmp/enc
s3fs asmundg-backup -o passwd_file=/root/s3-password $S3DIR || exit 1

for dir in /root/off-site-backup/*; do
    encfs --stdinpass --standard --reverse $(readlink $dir) /tmp/enc/ < $dir/.encfs_password || exit 1
    rsync --delete --inplace -aPh /tmp/enc/ $S3DIR/$(basename $dir)
    cp $dir/.encfs6.xml $S3DIR/$(basename $dir)/
    umount /tmp/enc/
done

umount $S3DIR

