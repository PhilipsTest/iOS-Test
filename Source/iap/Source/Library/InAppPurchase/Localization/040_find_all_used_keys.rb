#!/usr/bin/env ruby
require 'nokogiri'

output_file = "used_keys.txt"

if(ARGV[0] == '-dir')
  dir = ARGV[1]
end

def add_localizations_to_file(input, output)
  text = File.read(input)
  lines = text.force_encoding('iso-8859-1').split("\n")
  lines.each do |line|
    if (line.include? "=")
      key = line.gsub(/"/,"")
      key = key.slice(0..(key.index('=')-2)) if (key.include? "=")
      output.puts key.downcase.strip.gsub!(' ','')
    end
  end
  File.delete(input)
end

def find_localized_keys_in_dir(folder, f)
  localization_file = "Localizable.strings"
  
  filelist = %x( ls #{folder} ).split("\n")
  for item in filelist do
    if(item.include? ".m")
      test = `genstrings #{folder}#{item} 2>&1`
      if(test and File.exist?(localization_file))
        add_localizations_to_file(localization_file, f)
      end
    elsif (item.include? ".storyboard")
      doc = Nokogiri::XML(open(folder+item))

      doc.search('//userDefinedRuntimeAttribute').each do |element|
        key = element.values()[2]
        f.puts key.downcase.strip if(key)
      end
    elsif (!item.include? "." and !item.include? "guidance JSON")
      new_dir = folder+item+"/"
      find_localized_keys_in_dir(new_dir, f)
    end
  end
end

File.delete(output_file) if(File.exist?(output_file))

open(output_file, 'a') do |f|
  find_localized_keys_in_dir(dir, f)
end
unique_lines = File.readlines(output_file).uniq
open(output_file, 'w+') do |f|
  unique_lines.each do |line|
    f.puts line
  end
end
                                           
exit 0