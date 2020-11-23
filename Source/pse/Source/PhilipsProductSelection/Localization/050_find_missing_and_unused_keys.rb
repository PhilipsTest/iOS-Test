#!/usr/bin/env ruby
# encoding: utf-8

used_keys_file = "used_keys.txt"
translated_keys_file = "translated_keys.txt"
output_file = "missing_and_unused_keys.txt"

File.delete(output_file) if(File.exist?(output_file))

used_keys = File.readlines(used_keys_file)
translated_keys =  File.readlines(translated_keys_file)

not_translated = used_keys - translated_keys

open(output_file, 'w+') do |f|
  if(not_translated.count > 0)
    f.puts ""
    f.puts "=== Keys not translated: \n"
    f.puts used_keys - translated_keys
    f.puts "\n"
    
    puts "ERROR: Found not translated keys in the app: \n"
    puts used_keys - translated_keys
  end
  
  f.puts "=== Keys translated but not used: (WARNING: NOT ALWAYS CORRECT!)\n"
  f.puts translated_keys - used_keys
  
  puts "WARNING: Found translated but not used keys: \n"
  puts translated_keys - used_keys

end

File.delete(translated_keys_file) if(File.exist?(translated_keys_file))
File.delete(output_file) if(File.exist?(output_file))
File.delete(used_keys_file) if(File.exist?(used_keys_file))