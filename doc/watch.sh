set -e

make $1

while inotifywait --exclude '\..*sw.' -r -q -e modify ./; do
    make $1
done
