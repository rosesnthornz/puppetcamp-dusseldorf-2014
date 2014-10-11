#!/bin/env ruby

@environment = { 
		 "p" => "production",
		 "s" => "staging",
		 "d" => "development",
		 "q" => "qa"
	       }

@parameter_data = { 
	      "pcd" => { 
			"location" => "puppetcamp_dusseldorf",
			"puppetserver" => "10.0.0.2",
			"adminserver" => "10.0.0.1"
		       },
	      "pcb" => {
			"location" => "puppetcamp_berlin",
			"puppetserver" => "10.0.0.2",
			"adminserver" => "192.168.0.1"
		       },
	      "pcm" => {
			"location" => "puppetcamp_munich",
			"puppetserver" => "10.0.0.2",
			"adminserver" => "172.16.0.1"
		       }
	          }

@role = {
	    "p" => {
		     "web" => "prod_web_server",
		     "dbs" => "prod_db_server",
		     "pms" => "puppetmaster_server",
		     "adm" => "admin_server"
		   },
	    "s" => {
		     "web" => "stg_web_server",
		     "dbs" => "stg_db_server"
		   },
	    "d" => {
		     "web" => "dev_web_server",
		     "dbs" => "dev_db_server"
		   }
	}

@module_definitions = {
    "base" => [ 
	  'groups',
    	  'sudo',
    	  'hostconfig',
    	  'ntp',
            ],
    
    "prod_servers" => [
    	  '@base',
    	  'users::ops',
    	  'users::keys',
	  'users::repo',
	  'users::git-keys'
    	],

    "puppetmaster" => [
	  '@prod_servers',
	  'puppetmaster',
	  'puppetmaster::utils'
	],

    "prod_admin" => [
	  '@prod_servers',
	  'dns_server',
	  'kickstart_server',
	  'utils::repobase'
	],

    "prod_web_server" => [
    	  '@prod_servers',
    	  'apache'
    	],
    
    "prod_db_server" => [
    	  '@prod_servers',
    	  'mysql'
    	],

    "puppetmaster_server" => [
	  '@puppetmaster'
	],

    "admin_server" => [
	  '@prod_admin'
	]
}
