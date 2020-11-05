Note this 'blueprint' should only be used to create an image adding turtles below this will break in many cases
 so this is used to create the starting point image

#directories
build the scripts the do the build
injections from the blueprint here in this repo for testing

#engines-base.json
Suite should come from blueprint (optional if already set in from image)

	"variables": {
		"suite": "beowulf",
		"tag": "",
		"datestamp": "{{isotime \"^^todays_date^^"}}"
	}
	
publish_properties should come from the blue print (optional if already set in from image)
	"builders": [
		{
			"name": "{{user `suite`}}",
			"type": "lxd",
			"image": "^^blueprint_base_image^^",
			"output_image": "engines/{{user `suite`}}/base/{{user `datestamp`}}{{user `tag`}}",
			"publish_properties": {
				"description": "Engines {{user `suite`}} image",
				"aliases": "{{user `suite`}}",
				"architecture": "amd64",
				"os": "devuan",
				"release": "Devuan GNU/Linux 3.0"
			}
		}
	]
Fixed static section

	"provisioners": [
		{
			"type": "file",
			"source": "injections",
			"destination": "tmp/"
		},
		{
			"type": "file",
			"source": "build",
			"destination": "tmp/"
		},
		{
			"type": "shell",
			"scripts": [
				"build/scripts/pre-provision-setup"
			]
		},

From Blueprint

		{
			"type": "shell",
			"environment_vars": [
				"a_build_time_env_var=something",
				"another_build_time_env_var=somethingelse"
			],
			
Fixed static section. Though we could add modules and package install after install-packages 
though these probably should go in post-provision-setup

			"scripts": [
				"build/scripts/install-packages",
				"build/scripts/post-provision-setup",
				"build/scripts/remove-packages"
			]
		},
		{
			"type": "shell",
			"scripts": "build/scripts/cleanup"
		}
	]

