**Deprecated.** These scripts are no longer run automatically. For newer methods, see [dpb587/boshua](https://github.com/dpb587/boshua).

---

# bosh-stemcell-metadata

Archiving metadata about stemcells in a more accessible manner.


## Example

The `gh-pages` branch has the indexed stemcell metadata files.

    $ wget https://dpb587.github.io/bosh-stemcell-metadata/aws-xen-ubuntu-trusty.json

You'll find an array, each having a `version` key that you can search for.

    $ jq 'map(select(.version == "3192"))[0]' < aws-xen-ubuntu-trusty.json

Versions have artifact references, including a `url` for downloading.

    $ filelist_url=$( jq -r .metadata.filelist.url < aws-xen-ubuntu-trusty-3192.json )
    $ wget -O- "$filelist_url" | gunzip > filelist.txt
    $ tail filelist.txt


## Deployment

    $ git clone -b master git@github.com:dpb587/bosh-stemcell-metadata.git
    $ cd bosh-stemcell-metadata
    $ export GIT_PRIVATE_KEY="$( cat ~/.ssh/id_rsa )"
    $ export AWS_ACCESS_KEY_ID="...snip..."
    $ export AWS_SECRET_ACCESS_KEY="...snip..."
    $ fly set-pipeline -p bosh-stemcell-metadata -c <( datapact-pipeline )


## License

[MIT License](./LICENSE)
