# nf-cloud-gpu-test
Simple Nextflow pipeline for testing GPU capabilities with cloud systems such as AWS Batch

Execution test

```
nextflow run main.nf -bg -profile awsbatch -bucket-dir s3://frankfurt-nf/work --GPU ON &> log
```

