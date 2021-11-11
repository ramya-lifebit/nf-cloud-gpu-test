#!/usr/bin/env nextflow


/*
 * Define the pipeline parameters
 *
 */

// Pipeline version
version = '0.1'

params.help            = false
params.resume          = false

log.info """

GPU                       : ${params.GPU}
container                 : ${params.container}
email                     : ${params.email}
"""

// Help and avoiding typos
if (params.help) exit 1
if (params.resume) exit 1, "Are you making the classical --resume typo? Be careful!!!! ;)"

if (params.GPU != "ON" && params.GPU != "OFF") exit 1, "Please specify ON or OFF in GPU processors are available"


process gpuCall {

    publishDir "$baseDir/output", mode: 'copy'

    errorStrategy 'ignore'
    output:
    file ("*.log") into output

    script:
    """
echo ${params.GPU} > gpu.log ; env > env.log ; find / -name 'libcuda*' > libcuda.log 2> libcuda.err || true ; nvidia-smi &> nvidia.log || true ; ls -l /proc/driver/nvidia/* > proc.log || true
nvcc --version &> nvcc.log || true ;
tensortest.py &> tensortest.log || true ;
		"""
}


if (params.email == "yourmail@yourdomain" || params.email == "") {
    log.info 'Skipping the email\n'
}
else {
    log.info "Sending the email to ${params.email}\n"

    workflow.onComplete {

    def msg = """\
        Pipeline execution summary
        ---------------------------
        Completed at: ${workflow.complete}
        Duration    : ${workflow.duration}
        Success     : ${workflow.success}
        workDir     : ${workflow.workDir}
        exit status : ${workflow.exitStatus}
        Error report: ${workflow.errorReport ?: '-'}
        """
        .stripIndent()

        sendMail(to: params.email, subject: "NF GPU test", body: msg)
    }
}

workflow.onComplete {
    println "Pipeline BIOCORE@CRG completed at: $workflow.complete"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}
