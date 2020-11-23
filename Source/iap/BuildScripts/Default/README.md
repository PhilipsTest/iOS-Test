Default Build Scripts
=====================

This archive contains default (Jenkins) build scripts for Git-based iOS projects.

Setup
-----
1. In the Sources folder of your project, create a subfolder named `BuildScripts`.
2. Inside that folder, add the default build scripts as an git submodule or subtree. (See [Git Submodules: Core Concept, Workflows And Tips](http://blogs.atlassian.com/2013/03/git-submodules-workflows-tips/) and [Alternatives To Git Submodule: Git Subtree](http://blogs.atlassian.com/2013/05/alternatives-to-git-submodule-git-subtree/)).
3. Copy the config template file to your `BuildScripts` folder, rename it to `confg.sh`, and edit it (see instructions in that file).


Customization
-------------
The build scripts are designed to be customizable without having to change the default 
scripts. This way, you can take advantage of updates to the default build scripts, and at the same
time keep your project-specific customizations.

There are two types of customization: adding own scripts and overriding default scripts.

### Adding Scripts
You can add scripts by putting them directly in your `BuildScripts` folder, side by side to
your `config.sh`. The only requirement is that their file names should match the following regular
expression: `[0-9]*.sh` (in other words: start with a number and end with extension `.sh`).

Such scripts will automatically be run, the order is determined by the number in the file name.

### Overriding Scripts
If you copy a file in the default build scripts folder to your `BuildScripts` folder, this copy will
be used instead of the default script.

***Note**: the complete file name of your copy must be identical to the default script you want to override!* If a single character is different, both your version and the default version will be run.


Dependencies
------------
For building, by default [xctool](https://github.com/facebook/xctool) is used instead of xcodebuild. For computing code complexity, [hfcca](https://code.google.com/p/headerfile-free-cyclomatic-complexity-analyzer/) is used.


Jenkins Integration
-------------------
When using Jenkins you can setup a configuration that calls `Source/BuildScripts/Default/run-all.sh Debug`. When you use xctool, unit test output is written in standard JUnit format, so the default Jenkins plugin for JUnit format test results can be used to visualize them. Code complexity results are written in CppNcss format, for which there is a Jenkins plugin available.
