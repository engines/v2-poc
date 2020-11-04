#Note this 'blueprint' should only be used to create an image adding turtles below this will break in many cases
# so this is used to create the starting point image

{
 #From Blue print			
	"variables": {
		"suite": "beowulf",
		"tag": "",
		"datestamp": "{{isotime \"20060102\/0304\"}}"
	},
 # end from
	"builders": [
		{
	#From Blue print				
			"name": "{{user `suite`}}",
	 # end from
			"type": "lxd",
 #From Blue print			
			"image": "images:devuan/beowulf/cloud",
			"output_image": "engines/{{user `suite`}}/base/{{user `datestamp`}}{{user `tag`}}",
			"publish_properties": {
				"description": "Engines {{user `suite`}} image",
				"aliases": "{{user `suite`}}",
				"architecture": "amd64",
				"os": "devuan",
				"release": "Devuan GNU/Linux 3.0"
			}
		}
 # end from
	],
	"provisioners": [
		{
			"type": "file",
			"source": "files",
			"destination": "tmp/"
		},
		{
			"type": "file",
			"source": "build/",
			"destination": "tmp"
		},
		{
			"type": "file",
			"source": "injections",
			"destination": "tmp/"
		},
		{
			"type": "shell",
			"scripts": [
				"build/scripts/provision-setup"
			]
		},
		{
			"type": "shell",
			"environment_vars": [
				"DEBIAN_FRONTEND=noninteractive",
 #From Blue print
				"a_build_time_env_var=something",
				"another_build_time_env_var=somethingelse"
 # end from
			],
			"scripts": [
 # optional add repositories
				"build/scripts/install-packages",
				"build/scripts/provision-injections",
 # optional add_modules
				"build/scripts/remove-packages"
			]
		},
		{
			"type": "shell",
			"scripts": "build/scripts/post-provision"
		}
	]
}
