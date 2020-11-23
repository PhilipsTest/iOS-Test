fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

## Choose your installation method:

<table width="100%" >
<tr>
<th width="33%"><a href="http://brew.sh">Homebrew</a></td>
<th width="33%">Installer Script</td>
<th width="33%">Rubygems</td>
</tr>
<tr>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS or Linux with Ruby 2.0.0 or above</td>
</tr>
<tr>
<td width="33%"><code>brew cask install fastlane</code></td>
<td width="33%"><a href="https://download.fastlane.tools">Download the zip file</a>. Then double click on the <code>install</code> script (or run it in a terminal window).</td>
<td width="33%"><code>sudo gem install fastlane -NV</code></td>
</tr>
</table>

# Available Actions
## iOS
### ios continuous
```
fastlane ios continuous
```
Continuous build. Cleans the output, runs all tests and gathers code coverage and lint information.

Arguments:

 * [scheme:"SchemeName"]
 (app name is used by default)

 * [configuration:"ConfigurationName"]
 (Debug is used by default)

### ios test
```
fastlane ios test
```
Run all tests. 

Arguments:

 * [scheme:"SchemeName"]
 (app name is used by default)

 * [configuration:"ConfigurationName"]
 (Debug is used by default)

### ios coverage
```
fastlane ios coverage
```
Code coverage. 

Arguments:

 * [scheme:"SchemeName"]
 (app name is used by default)

### ios analyse
```
fastlane ios analyse
```
Analyse the static code using lint tools (OCLint & SwiftLint)
### ios analyse_objc
```
fastlane ios analyse_objc
```
Analyse the static Objective-C code using OCLint
### ios analyse_swift
```
fastlane ios analyse_swift
```
Analyse the static Swift code using SwiftLint
### ios release
```
fastlane ios release
```
Release build. Creates an xcarchive and IPA file. Optionally, the version and build
number can be updated in the project file automatically.

Arguments:

 * [scheme:"SchemeName"] (app name is used by default)
 * [configuration:"SomeConfiguration"] (Optionally provide a custom configuration. Default: "")
 * [version:"x.x.x"] (retrieved from xcode project by default)
 * [build:"x.x.x"] (retrieved from xcode project by default)
 * [release_name:"SomeAppName"] (Optionally provide a release name. Default: "{app_name}-{scheme}-v{version}({build})
 * [release_type:"app-store, ad-hoc, enterprise or development"](Optionally provide a release type. Default: "app-store)
 * [plist_path:"Path to your plist file from the project source root](Default: "{app_name)/Info.plist)"
 * [extension_plist_paths: "Path to your plist files of your extensions from the project source root. This list should be comma seperated](Default: "{app_name)/Info.plist)"
 * [team_id:"Code Sign team id"] (Optionally provide a custom team id i.e CS7SZ6KGXK which will use by "gym" to export .ipa file. Required field for xcode8.3.2+). Default: "None"
### ios create_ipa
```
fastlane ios create_ipa
```
Creates an IPA file including symbols.

 Arguments:

  * [scheme:"SchemeName"] (app name is used by default)
  * [configuration:"SomeConfiguration"] (Optionally provide a custom configuration. Default: "")
  * [release_name:"SomeAppName"] (Optionally provide a release name. Default: App name)
  * [team_id:"Code sign team id"] (Useful to export .ipa file). Default: "None" 

### ios create_documentation
```
fastlane ios create_documentation
```
Created API documentation html output.

 Note: jazzy tries to get its configuration from a file named `.jazzy.yaml`,

  located in your project's root folder

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
