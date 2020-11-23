#!/bin/sh

project_dir="AppInfra/Resources/ailLocalizableStrings"
source_excel="../../../../plf-common/Resources/ail/Localization/StringLocalization.xlsx"
target_os="ios"
localization_script="../../../../plf-common/Tools/Localization/generate_language_files.rb"

if [ -d "en_US.lproj" ]; then
  echo "Cleaning existing resources"
  rm -r "*.lproj"
fi

 "${localization_script}" -x "${source_excel}" -o "${target_os}" -d "${project_dir}"
