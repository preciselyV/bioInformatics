rule BWA:
    input:
        "ref/genome/GCF_000005845.2_ASM584v2_genomic.fna",
        "SRR20043619.fastq"
    output:
        "idk/{res}_conv.bam"
    shell:
        "./bwa/bwa mem {input} |./samtools-1.16.1/samtools view -Sb - > {output}"
rule SamConvert:
    input:
        "idk/{res}_conv.bam"
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

rule MaybeSort:
    input:
        "idk/{res}_report.txt", "idk/{res}_conv.bam"
    output:
        "idk/{res}.sorted.bam"
    run:
        with open(input[0], 'r') as f:
            lines = f.readlines()
            if lines[1].strip() == 'OK':
                shell('./samtools-1.16.1/samtools sort {input[1]} > {output}')
            else:
                shell('touch {output}')
                shell('echo "WARNING: result is not OK, sorted file will be empty"')
rule MaybeBayes:
    input: 
        "ref/genome/GCF_000005845.2_ASM584v2_genomic.fna", "idk/{res}.sorted.bam", "idk/{res}_report.txt"
    output:
        "idk/{res}.vcf"
    run:
        with open(input[2], "r") as f:
            res = f.readlines()[1].strip()
            if res == 'OK':
                shell("freebayes -f {input[0]} {input[1]} > {output}")
            else:
                shell('echo "WARNING, result is not OK .vsf file will be empty"')
                shell('touch {output}')
