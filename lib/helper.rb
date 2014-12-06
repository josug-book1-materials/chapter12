def print_out(yaml)
   puts yaml.
     sub(/^\-\-\- \|\n/,"").
     sub(/^ *--- !ruby\/object:.*\n/,"").
     sub(/^ */," - ").
     gsub(/\n/,"\n   ").
     gsub(/^ *$/,"")
end
