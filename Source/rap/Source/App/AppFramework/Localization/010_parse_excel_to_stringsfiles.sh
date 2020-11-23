#!/usr/bin/sh

project_dir="../AppFramework/BaseApp/Common/Resources/Localization"
source_excel="../../../../../../plf-common/Resources/rap/Localization/StringLocalization.xlsx"
target_os="ios"

if [ -d "${project_dir}" ]; then
  echo "Cleaning existing resources"
  rm -r "${project_dir}"
fi

 ../../../../../../plf-common/Tools/Localization/generate_language_files.rb -x "${source_excel}" -o "${target_os}" -d "${project_dir}"