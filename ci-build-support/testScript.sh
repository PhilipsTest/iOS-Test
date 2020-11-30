#!/bin/bash -l
export PATH=/.rbenv/shims:/usr/local/bin/xcpretty/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

killall Simulator || true
xcrun simctl erase all || true

cd ${"Source"}

#Set XCPretty output format
export LC_CTYPE=en_US.UTF-8

xcodebuild test \
        -workspace ${"PLF-IOS-WORKSPACE.xcworkspace"} \
        -scheme $1 CLANG_WARN_DOCUMENTATION_COMMENTS='NO'\
        -destination \'platform=iOS Simulator,name=iPhone 8,OS=latest\' \
        -UseModernBuildSystem='YES'\
        -resultBundlePath ${resultBundlePath} \
        | xcpretty --report junit --report html

mkdir -p "Coverage"
if [ -d "${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/4B0465A0-EB0F-47D0-97A6-15FCB16B26E4" ]
    then
        echo "Directory exists in iet-iOS-blr-001"
            if [ "$1" == "AppFramework" ]
                then
                    xcrun llvm-cov show ${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/products/Debug-iphonesimulator/$1.app/$1 -instr-profile=${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/4B0465A0-EB0F-47D0-97A6-15FCB16B26E4/Coverage.profdata -arch=x86_64 &> ${{github.workspace}}/Source/Coverage/llvm-cov-show-AppFramework_Profile.txt
            elif [ "$1" == "AppInfraDev" ] 
                then
                    xcrun llvm-cov show ${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/products/Debug-iphonesimulator/$2.framework/$2 -instr-profile=${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/4B0465A0-EB0F-47D0-97A6-15FCB16B26E4/Coverage.profdata -arch=x86_64 &> ${{github.workspace}}/Source/Coverage/llvm-cov-show-$1_Profile.txt
            else
                xcrun llvm-cov show ${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/products/Debug-iphonesimulator/$1.framework/$1 -instr-profile=${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/4B0465A0-EB0F-47D0-97A6-15FCB16B26E4/Coverage.profdata -arch=x86_64 &> ${{github.workspace}}/Source/Coverage/llvm-cov-show-$1_Profile.txt
            fi
elif [ -d "${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/BF86F4D9-4F86-4F54-AB68-562AEEE9AE57" ]
    then
        echo "Directory exists in iet-iOS-blr-002"
            if [ "$1" == "AppFramework" ]
                then
                    xcrun llvm-cov show ${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/products/Debug-iphonesimulator/$1.app/$1 -instr-profile=${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/BF86F4D9-4F86-4F54-AB68-562AEEE9AE57/Coverage.profdata -arch=x86_64 &> ${{github.workspace}}/Source/Coverage/llvm-cov-show-AppFramework_Profile.txt
            elif [ "$1" == "AppInfraDev" ] 
                then
                    xcrun llvm-cov show ${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/products/Debug-iphonesimulator/$2.framework/$2 -instr-profile=${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/BF86F4D9-4F86-4F54-AB68-562AEEE9AE57/Coverage.profdata -arch=x86_64 &> ${{github.workspace}}/Source/Coverage/llvm-cov-show-$1_Profile.txt
            else
                xcrun llvm-cov show ${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/products/Debug-iphonesimulator/$1.framework/$1 -instr-profile=${{github.workspace}}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/BF86F4D9-4F86-4F54-AB68-562AEEE9AE57/Coverage.profdata -arch=x86_64 &> ${{github.workspace}}/Source/Coverage/llvm-cov-show-$1_Profile.txt
            fi
else    
    echo "Error: Directory does not exist in both the nodes"
fi
