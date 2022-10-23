rule BWA:
    input:
        "ref/genome/GCF_000005845.2_ASM584v2_genomic.fna",
        "SRR20043619.fastq"
    output:
        "idk/{res}.bam"
    shell:
        "./bwa/bwa mem {input} |./samtools-1.16.1/samtools view -Sb - > {output}"
rule SamConvert:
    input:
        "idk/{res}.bam"
    output:
        "idk/{res}_out.txt"
    shell:
        "./samtools-1.16.1/samtools flagstat {input} > {output}"

rule checkRes:
    input:
        "idk/{res}_out.txt"
    output:
        "idk/{res}_report.txt"
    shell:
        "python3 parser.py {input} > {output}"
