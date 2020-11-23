#!/usr/bin/env ruby

require 'json'

$isCOPPA = false
$registration_error_file = "Registration_errors.txt"

if(ARGV[0] == '-isCOPPA')
  $isCOPPA = ARGV[1]
end


$current_env = nil
$config = nil

def insert_error(errorMessage)
	open($registration_error_file, 'a') do |f|
  		f << "REGISTRATION_ERRORS: #{errorMessage}\n"
	end
end

def get_parsed_response(response)
	begin
		parsed_response = JSON.parse(response)
	rescue JSON::ParserError => e  
		insert_error("RegistrationConfiguration.json is contains invaild json error #{e.message}")
	end
	return parsed_response
end

def get_current_env
	pilConfiguration = $config['PILConfiguration']
	environment = pilConfiguration['RegistrationEnvironment']
	excepectedEnvironments = ['Development','Testing','Evaluation','Staging','Production']
	isCorrectEnvironment = excepectedEnvironments.include?(environment)
	insert_error("Environment is incorrect ,It should be #{excepectedEnvironments.join(',')}") if !isCorrectEnvironment
	return environment 
end

def validate_HSDP_Config(hsdpconfig)
	hsdpConfiguration = hsdpconfig[$current_env]
	if !hsdpConfiguration
		insert_error("HSDP is not configured for #$current_env environment")
		return
	end

	hsdpErrors = Array.new
	hsdpErrors.push("ApplicationName") if !hsdpConfiguration['ApplicationName']
	hsdpErrors.push("Shared") if !hsdpConfiguration['Shared']
	hsdpErrors.push("Secret") if !hsdpConfiguration['Secret']
	hsdpErrors.push("BaseURL") if !hsdpConfiguration['BaseURL']

	if !hsdpErrors.empty?
		insert_error("HSDP is not configured for #{hsdpErrors.join(",")} under #$current_env environment")
	end
end

def validate_janrian_Config(janrainConfig)
	janrainConfiguration = janrainConfig['RegistrationClientID'][$current_env]
	if !janrainConfiguration
		insert_error("janrain clientid is not configured for #$current_env environment")
		return
	end
end

def validate_PIL_Config(pilConfiguration)
	micrositeID = pilConfiguration['MicrositeID']
	insert_error("MicrositeID is not configured") if(!micrositeID)
	if $isCOPPA
		campaignID = pilConfiguration['CampaignID']
		insert_error("CampaignID is not configured") if(!campaignID)
	end
end

def validate_SigninProviders(signinProviders)
	defaultProviders = signinProviders['default']
	insert_error("default providers is not configured") if(!defaultProviders)
end

def validate_Config
	$current_env = get_current_env
	return if !$current_env
	hsdpconfig = $config['HSDPConfiguration']
	janrainConfig = $config['JanRainConfiguration']
	insert_error("janrainConfig is not configured") if(!janrainConfig)
	validate_janrian_Config(janrainConfig) if janrainConfig
	validate_HSDP_Config(hsdpconfig) if hsdpconfig
	validate_PIL_Config($config['PILConfiguration'])
	validate_SigninProviders($config['SigninProviders'])
end


File.delete($registration_error_file) if(File.exist?($registration_error_file))

configFiles = Dir["**/*RegistrationConfiguration.json"]

configFiles.each do |input_file|
	$config = nil
	$current_env = nil
	file = File.read(input_file)
	$config = get_parsed_response(file)
	validate_Config if $config
end

