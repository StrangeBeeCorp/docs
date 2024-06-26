##  Analyzers / Responders communication


From version 3, cortexutils 2.x is required because communication between Cortex and the analyzers/responders has changed. **Analyzers and responders doesn't need to be rewritten if they use cortexutils**. Cortex 2 send data using stdin and receive result from stdout.

Cortex 3 uses files: a job is stored in a folder with the following structure:

```
job_folder
  \_ input
   |    \_ input.json    <- input data, equivalent to stdin with Cortex 2.x
   |    |_ attachment    <- optional extra file when analysis concerns a file
   |_ output
        \_ output.json   <- report of the analysis (generated by analyzer or responder)
        |_ extra_file(s) <- optional extra files linked to report (generated by analyzer)
```

Job folder is provided to analyzer/responder as argument. Currently, only one job is acceptable but in future release, analyzer/responder will accept several job at a time (bulk mode) in order to increase performance.