# nf-cloud-gpu-test

Simple Nextflow pipeline for testing GPU capabilities with cloud systems such as AWS Batch

## Nextflow installation

```
curl -s https://get.nextflow.io | bash
export NXF_VER=21.04.3
nextflow self-update
```

## Execution test

With GPU

```
nextflow run main.nf -bg -profile awsbatch --GPU ON &> log.gpu
```

Without GPU

```
nextflow run main.nf -bg -profile awsbatch --GPU OFF &> log
```

## TODO

* Add Terraform scripts here

