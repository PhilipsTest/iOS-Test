## Latest Version 1803

 * Removed Objectmapper dependancy
 * Updated Apple docs

## Latest Version 2017.5.0

 * Updated Apple docs

## Platform version 2.3.0
 ### changes

Deprecated parameters/API:<br/>

1) public static var appFlowJsonPath : String?
   -    Variable to save the json path in BaseFlowManager Class<br/>
2) public init(withAppFlowJsonPath jsonPath : String) {}
   -    Initialzer method of BaseFlowManager class.

Added :<br/>

```
1) public func initialize(withAppFlowJsonPath jsonPath : String, @escaping successBlock : () -> (),@escaping  failureBlock : (FlowManagerErrors) -> () ) {}
```
## Platform Version 1.1.0

Flow manager added.

## Platform version 1.0.0

UappSettings, UappDependencies and UappLaunchInput added.<br/>
First version of the component is created.

## Description

UApp-framework is a component which provides framework to all common components to integrate each common component in uniform way and provides support of flow manager to support dynamic flow of micro-app.

## Installation

* Using cocoapods - add philips cocoapod repo and add  ``` pod 'UAPPFramework' ``` to pod file
* Using Frameworks - 

## References:

### Code Example - Quick integration

 - Refer integration document - [Document](http://tfsemea1.ta.philips.com:8080/tfs/TPC_Region24/CDP2/TEAM%20Griffin/_git/ufw-ios-uappframework?path=%2FDocuments%2FExternal%2FUFW000008_Integration%20Document_UAPPFramework_iOS_2.1.1.docx&version=GBdevelop&_a=contents)

## <a name="team-members"></a>Team Members
 * Team Huma - <DL_Huma@philips.com> 
 

## License
 * Copyright (c) Koninklijke Philips N.V., 2018 All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder. 

