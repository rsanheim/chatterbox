map_for(:chatterbox) do |map|
  
  map.keep_a_watchful_eye_for 'lib', 'examples', 'rails'

  # map.add_mapping %r%examples/(.*)_example\.rb% do |match|
  #   ["examples/#{match[1]}_example.rb"]
  # end
  # 
  # map.add_mapping %r%examples/example_helper\.rb% do |match|
  #   Dir["examples/**/*_example.rb"]
  # end
  #  
  # map.add_mapping %r%lib/(.*)\.rb% do |match|
  #   Dir["examples/#{match[1]}_example.rb"]
  # end
  
  map.add_mapping %r%rails/(.*)\.rb% do |match|
    ["examples/#{match[1]}_example.rb"]
  end
  
  
end