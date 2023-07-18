#!/bin/sh
inotifywait -m /data -e create \
    -e modify \
    -e delete \
    -e move \
    -e moved_to | while read directory action file; do
    /geo2db-exec.sh
done