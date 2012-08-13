Peet's Posh Ant
========

**Posh Ant** is a simple PowerShell script that provides tab completion support for Ant tasks

## Installation

1. (Optionally Fork and) Clone this project.

1. Edit your `$profile` to include<br>
> `. 'C:\<path-to-clone>\tabcomplete.ps1'`

1. Reset your current environment<br>
> `. $profile`

 Or start a new shell

## Usage
* In a directory with a build.xml:
 * Type `ant<space>` , then hit `<tab>` to cycle through all targets.
 * Type `ant<space>a`, then hit `<tab>` to cycle through all targets that start with `a`.
 * etc...


## Licence
* MIT - See LICENCE.txt