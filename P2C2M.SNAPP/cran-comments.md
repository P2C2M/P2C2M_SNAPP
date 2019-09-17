## Resubmission
This is a resubmission. In this version I have:

* Enclosed software names in the title and description in quotes, e.g. 'SNAPP'.
* Converted mentions of the multispecies coalescent model to lowercase
* Examples are wrapped in \donttest{} because they require an external executable to run. 
  More details on this program (fastsimcoal2) can be found in the description and vignette.
  Without this executable, the only function in the package (run.p2c2m.snapp) can not run.
* Instances of using print()/cat() to write to the console have been replaced with 
  message() so they can be suppressed by the user.

* Added to the Description text that SNAPP is phylogenetic analysis software.
* Added examples to my Rd files. Please note these examples were not run with checks 
  because they require an outside program.
* Added a path argument (path_to_xml) to the function run.p2c2m.snapp so users must 
  specify a directory for output files.
* Added an argument (save_graphs) to the function run.p2c2m.snapp which determines whether
  graphs are written to files. Therefore the user can select which files to write and
  which directory to write files to.

## Test environments
* local OSX install, R 3.5.0
* local ubuntu 16.0.4 install, R 3.5.0
* win-builder (devel)

## R CMD check results
There were no ERRORs or WARNINGs.

There was 1 NOTE with win-builder:

* New submission

  Possibly mis-spelled words in DESCRIPTION:
    multispecies (10:55)

  The word is spelled correctly.
  
