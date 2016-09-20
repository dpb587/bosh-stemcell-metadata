#!/bin/bash

set -eu

git clone file://$PWD/gh-pages gh-pages-output

cd gh-pages-output

if [ ! -e "$stemcell.json" ]; then
  echo '[]' > "$stemcell.json"
fi

url=$( jq -r '.input[0].metadata | from_entries | .url' < ../stemcell/.datapact/result )
version=$( jq -r '.input[0].metadata | from_entries | .version' < ../stemcell/.datapact/result )

# build our record

jq -n \
  --arg version "$version" \
  --arg url "$url" \
  --slurpfile metadata ../stemcell-metadata/.datapact/result \
  '
    {
      "version": $version,
      "url": $url,
      "metadata": (
        $metadata[0].output
        | map({
          "key": ( .path | split(".gz")[0] ),
          "value": (
            . +
            {
              "url": (env.s3_endpoint + "/" + env.s3_bucket + "/" + env.s3_prefix + $metadata[0].branch + "/" + .blob)
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
    map(select(.version != $amend[0].version))
    + $amend
    # naive sorting
    | sort_by(.version | split(".") | map(tonumber)) | reverse
  ' \
  < "$stemcell.json" \
  > "$stemcell.json.new"

cp "$stemcell.json.new" "$stemcell.json"

git add "$stemcell.json"
git commit -m "Add $stemcell/$version" "$stemcell.json"
