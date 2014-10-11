#!/bin/env ruby

require 'yaml'
require File.join(File.dirname(__FILE__), 'node_definitions')

def generate_yaml(location, environment, function)
    @enc_output["environment"] = @environment[environment]
    @enc_output["parameters"]["location"] = @parameter_data[location]["location"]
    @enc_output["parameters"]["puppetserver"] = @parameter_data[location]["puppetserver"]
    @enc_output["parameters"]["adminserver"] = @parameter_data[location]["adminserver"]
    role = @role[environment][function]
    for module_name in @module_definitions[role]
        if module_name.chars.first == "@"
	    parse_modules(module_name[1..-1])
	else
    	    @enc_output["classes"].push(module_name)
        end
    end
    puts @enc_output.to_yaml
end

def parse_modules(module_name)
    if @module_definitions[module_name]
	for rec_module_name in @module_definitions[module_name]
	    if rec_module_name.chars.first == "@"
		parse_modules(rec_module_name[1..-1])
	    else
		@enc_output["classes"].push(rec_module_name)
	    end
	end
    end
end

if ARGV.size != 1
    abort("Correct number of arguments not found. Aborting...")
end

hostname = ARGV[0]

begin
    location = hostname[0..2]
    environment = hostname.split(//)[3]
    function = hostname[4..6]
rescue Exception => msg
    abort(msg)
end

@enc_output = { "classes" => [], "parameters" => {} }
generate_yaml(location, environment, function)
