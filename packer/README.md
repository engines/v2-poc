Note this 'blueprint' should only be used to create an image adding turtles below this will break in many cases
 so this is used to create the starting point image


 From Blue print			
	"variables": {
		"suite": "beowulf",
		"tag": "",
		"datestamp": "{{isotime \"20060102\/0304\"}}"
	},

 From Blue print			

	"builders": [
		{		
			"name": "{{user `suite`}}",

			"type": "lxd",

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
	],
Fixed
{
	"provisioners": [
		{
			"type": "file",
			"source": "setup",
			"destination": "tmp/"
		},
		{
			"type": "shell",
			"scripts": [
				"setup/build/scripts/provision-setup"
			]
		},
		{
			"type": "shell",
			"environment_vars": [
				"DEBIAN_FRONTEND=noninteractive",
				"a_build_time_env_var=something",
				"another_build_time_env_var=somethingelse"
			],
			"scripts": [
				"setup/build/scripts/install-packages",
				"setup/build/scripts/provision-injections",
				"setup/build/scripts/remove-packages"
			]
		},
		{
			"type": "shell",
			"scripts": "setup/build/scripts/post-provision"
		}
	]
}
