# nf-cloud-gpu-test

Simple Nextflow pipeline for testing GPU capabilities with cloud systems such as AWS Batch

## Nextflow installation

```
export NFX_VER=19.09.0-edge
nextflow self-update
```

## Execution test

With GPU

```
nextflow run main.nf -bg -profile awsbatch -bucket-dir s3://frankfurt-nf/work --GPU ON &> log
```

Without GPU

```
nextflow run main.nf -bg -profile awsbatch -bucket-dir s3://frankfurt-nf/work --GPU OFF &> log
```


