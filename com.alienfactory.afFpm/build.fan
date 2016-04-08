using build

class Build : BuildPod {

	new make() {
		podName = "afFpm"
		summary = "Provides a targeted environment for compiling, testing, and running Fantom applications"
		version = Version("0.0.2")

		meta = [
			"proj.name"		: "Fantom Pod Manager",
			"repo.internal"	: "true",
			"repo.tags"		: "sys, app",
			"repo.public"	: "true"
		]

		depends = [
			"sys        1.0.67 - 1.0",
			"fanr       1.0.67 - 1.0",
			"util       1.0.67 - 1.0",
			"concurrent 1.0.67 - 1.0",			
			"compiler   1.0.67 - 1.0",	// for afPlastic			
		]

		srcDirs = [`fan/`, `fan/afPlastic/`, `fan/internal/`, `fan/internal/cmds/`, `fan/internal/util/`, `fan/public/`]
		resDirs = [`doc/`, `res/`]
		
		docApi	= true
		docSrc	= true
	}
}

