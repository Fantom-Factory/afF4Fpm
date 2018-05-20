using build

class Build : BuildPod {

	new make() {
		podName = "f4afFpm"
		summary = "A FPM Env extension for F4 projects"
		version = Version("1.1.0")

		meta = [
			"proj.name" : "F4 FPM_ENV"
		]

		depends = [
			"sys        1.0.69 - 1.0",
			"concurrent 1.0.69 - 1.0",
			"f4core     1.0",
			"afFpm      0.2+"
		]

		srcDirs = [`fan/`, `fan/afConcurrent/`]

		outPodDir = `./`

		docApi = true
		docSrc = true
	}
}
