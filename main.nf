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
email                     : ${params.email}
"""

// Help and avoiding typos
if (params.help) exit 1
if (params.resume) exit 1, "Are you making the classical --resume typo? Be careful!!!! ;)"

// GPU maybe can be removed as param if there is a way to detect it
if (params.GPU != "ON" && params.GPU != "OFF") exit 1, "Please specify ON or OFF in GPU processors are available"


// TODO: To be changed to test CPU and GPU call properly
process gpuCall {

    publishDir "$baseDir/output", mode: 'copy'

    errorStrategy 'ignore'
    output:
    file ("*.log") into output

    script:
    if (params.GPU == "ON") {

        accelerator: 1

        """
echo GPU > gpu.log ; env > env.log ; find / -name 'libcuda*' > libcuda.log 2> libcuda.err || true ; nvidia-smi &> nvidia.log || true ; ls -l /proc/driver/nvidia/* > proc.log || true
tensortest.py &> tensortest.log || true ;
				"""

    } else {
        """
echo CPU > gpu.log ; env > env.log ; find / -name 'libcuda*' > libcuda.log 2> libcuda.err || true ; nvidia-smi &> nvidia.log || true
tensortest.py &> tensortest.log || true ;
        """
   }
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
