using build

class Build : BuildPod {

	new make() {
		podName = "f4afFpm"
		summary = "A FPM Env extension for F4 projects"
		version = Version("1.1.6")

		meta = [
			"proj.name" : "F4 FPM_ENV"
		]

		depends = [
			"sys        1.0.78 - 1.0",
			"concurrent 1.0.78 - 1.0",
			"f4core     1.0",
			"afFpm      2.1.6  - 2.1",
		]

		srcDirs = [`fan/`]

		outPodDir = `./`

		docApi = true
		docSrc = true
	}
}
