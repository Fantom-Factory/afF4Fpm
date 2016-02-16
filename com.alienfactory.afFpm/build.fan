using build

class Build : BuildPod {

	new make() {
		podName = "afFpm"
		summary = "Fantom Pod Manager"
		version = Version("0.0.1.002")

		meta = [
			"proj.name"		: "Fantom Pod Manager",	
			"repo.tags"		: "sys",
			"repo.public"	: "false"
		]

		depends = [
			"sys        1.0.67 - 1.0",
			"fanr       1.0.67 - 1.0",
			"util       1.0.67 - 1.0",
			"concurrent 1.0.67 - 1.0",			
			"compiler   1.0.67 - 1.0"	// for afPlastic			
		]

		outPodDir = `./`

		srcDirs = [`fan/`, `fan/afPlastic/`, `fan/internal/`, `fan/internal/cmds/`, `fan/internal/util/`, `fan/public/`]
		resDirs = [,]
		
		docApi	= true
		docSrc	= true
	}
}

