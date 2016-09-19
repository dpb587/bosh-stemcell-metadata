# bosh-stemcell-metadata

Archiving metadata about stemcells in a more accessible manner.


## Example

The `gh-pages` branch has the indexed stemcell metadata files.

    $ wget https://dpb587.github.io/bosh-stemcell-metadata/aws-ubuntu-trusty.json

You'll find an array, each having a `version` key that you can search for.

    $ jq 'map(select("3262.14" == .version))[0]' < aws-ubuntu-trusty.json

Versions have artifact references, including a `url` and `checksum`.

    $ filelist_url=$( jq -r .metadata.filelist.url < aws-ubuntu-trusty-3262.14.json )
    $ wget -O- "$filelist_url" | gunzip > filelist.txt
    $ tail filelist.txt


## Deployment

    $ git clone -b master git@github.com:dpb587/bosh-stemcell-metadata.git
    $ cd bosh-stemcell-metadata
    $ fly set-pipeline -p bosh-stemcell-metadata -c <( datapact-pipeline )


## License

[MIT License](./LICENSE)
