# bosh-stemcell-metadata

Archiving metadata about stemcells in a more accessible manner.


## Example

Download the filesystem table and checksums of the AWS stemcell for version 3192...

    $ wget -O filelist.tgz "$(
      curl https://dpb587.github.io/bosh-stemcell-metadata/aws-ubuntu-trusty.json \
        | jq 'map(select(.version == "3192"))[0].metadata["filelist.gz"].url'
      )"


## Deployment

    $ git clone -b master git@github.com:dpb587/bosh-stemcell-metadata.git
    $ cd bosh-stemcell-metadata
    $ datapact-pipeline-generate | datapact-pipeline-apply


## License

[MIT License](./LICENSE)
