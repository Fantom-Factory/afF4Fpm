using concurrent::AtomicRef
using f4core
using afFpm

const class FpmCompileEnv : CompileEnv {

	override const Str label		:= "afFpm::FpmEnv"
	override const Str description	:= "Use Alien-Factory's awesome Fantom Pod Manager"	
	override const Uri? envPodUrl	:= `platform:/plugin/com.alienfactory.afFpm/afFpm.pod`

		FpmEnv?	fpmEnv {
			get { fpmEnvRef.val }
			set { fpmEnvRef.val = it }
		}
		const AtomicRef	fpmEnvRef	:= AtomicRef() 

	new make(FantomProject? fanProj := null) : super.make(fanProj) { }

	override Str:File resolvePods() {
		buildConsole.debug("\n\n")

		fpmEnv = FpmEnvF4(fpmConfig) {
			it.name		= fanProj.podName
			it.version	= fanProj.version
			it.depends	= fanProj.rawDepends
			it.log		= buildConsole
		}		
		
		// if we couldn't resolve any pods - default to ALL pods, latest versions thereof
		podFiles := fpmEnv.resolvedPodFiles.isEmpty ? fpmEnv.allPodFiles : fpmEnv.resolvedPodFiles
		return podFiles.map { it.file }
	}
	
	override Err[] resolveErrs() {
		errs := Err[,]
		if (fpmEnv.error != null)
			errs.add(fpmEnv.error)
		fpmEnv.unresolvedPods.each {
			errs.add(Err(it.toStr))
		}
		return errs
	}
	
	override Void tweakLaunchEnv(Str:Str envVars) {
		setEnvVar(envVars, "FAN_ENV", 		FpmEnv#.qname)
		setEnvVar(envVars, "FPM_TARGET",	fanProj.podName)
	}
	
	override Void publishPod(File podFile) {
		prefs	:= FpmEnvPrefs(fanProj)
		repo	:= prefs.publishToDefault ? "default" : prefs.publishRepo
		PodManager() { it.fpmConfig = this.fpmConfig }.publishPod(podFile, repo)
	}
	
	private FpmConfig fpmConfig() {
		FpmConfig(fanProj.baseDir, fanProj.fanHomeDir, Env.cur.vars["FAN_ENV_PATH"])
	}
	
	private Void setEnvVar(Str:Str envVars, Str key, Str val) {
		if (envVars.containsKey(key)) {
			if (envVars[key] != val)
				buildConsole.warn("Did not set environment variable $key to [$val] as it is already set to: ${envVars[key]}")
		} else
			envVars[key] = val
	}
}

