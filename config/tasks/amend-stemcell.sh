#!/bin/bash

set -eu

git clone file://$PWD/gh-pages gh-pages-output

cd gh-pages-output

if [ ! -e "$stemcell.json" ]; then
  echo '[]' > "$stemcell.json"
fi

version=$( cat ../stemcell/version )

# build our record

jq -n \
  --arg version "$version" \
  --slurpfile metadata ../stemcell-metadata/.datapact/result \
  '
    {
      "version": $version,
      "metadata": (
        $metadata[0].output
        | map({
          "key": ( .path | gsub("\.gz$", "") ),
          "value": (
            . +
            {
              "url": (env.s3_endpoint + "/" + env.s3_bucket + "/" + env.s3_prefix + $metadata.branch + "/" + .blob)
            }
          )
        })
        | from_entries
      )
    }
  ' \
  > /tmp/amend.json

# add it

jq \
  --slurpfile amend /tmp/amend.json \
  '
    map(select(.version != $amend.version))
    + $amend
    # naive sorting
    | sort_by($amend.version | split(".")) | reverse
  ' \
  < "$stemcell.json" \
  > "$stemcell.json.new"

cp "$stemcell.json.new" "$stemcell.json"

git add "$stemcell.json"
git commit -m "Update $stemcell.json" "$stemcell.json"
