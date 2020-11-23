#!/usr/bin/env ruby
require 'fileutils'

output_dir = "ProductSelectionResources"
project_dir = "../ProductSelection"

FileUtils.mkdir_p(project_dir)
FileUtils.cp_r(Dir[output_dir + '/*'],project_dir)
FileUtils.rm_r(output_dir)
