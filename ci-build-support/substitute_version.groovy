#!/usr/bin/env groovy

/* Extracts component versions from "/ci-build-support/Versions.rb" file 
* and after applying filter replace the component version in podspec file to publish into podspec repo
*/

def podspecPath = args[0]
File versionsFile = new File( "./ci-build-support/Versions.rb" )
def lines = versionsFile.readLines()

def podspecFile = new File(podspecPath)
String podspecContents = podspecFile.text
println "Original Podspec:"
println podspecContents

//Replacing versions
lines.each { String line ->
  def tokens = line.tokenize("=")
  if (tokens.size == 2) {
	def name = tokens[0].trim()
	def value = tokens[1].trim()
	podspecContents = podspecContents.replace(name, value)
  }   
}

// Delete the line with require_relative
podspecContents = podspecContents.replaceAll('require_relative.*','')

//println("New Podspec")
println podspecContents
podspecFile.write('')
podspecFile << podspecContents
