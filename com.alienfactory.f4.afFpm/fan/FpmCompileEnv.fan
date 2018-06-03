using concurrent::ActorPool
using concurrent::AtomicRef
using concurrent::Future
using f4core
using afFpm

const class FpmCompileEnv : CompileEnv {
	override const Str label			:= "afFpm::FpmEnv"
	override const Str description		:= "Use Alien-Factory's awesome Fantom Pod Manager"	
	override const Uri? envPodUrl		:= `platform:/plugin/com.alienfactory.afFpm/afFpm.pod`

	const AtomicRef	fpmConfigRef		:= AtomicRef()
	const AtomicRef	resolveErrsRef		:= AtomicRef()

	new make(FantomProject? fanProj := null) : super.make(fanProj) { }

	override Str:File resolvePods() {
		// this method has been ripped and cut down from FpmEnv
		log 			:= buildConsole
		fpmConfig		:= fpmConfig
		targetPod		:= TargetPod(target, fanProj.rawDepends)
		resolvedPods	:= Str:PodFile[:]
		unresolvedPods	:= Str:UnresolvedPod[:]
		error			:= null as Err

		title := "FPM: ${targetPod.pod}"
		log.debug("")
		log.debug("")
		log.debug(title)
		log.debug("-" * title.size)

		resolver := Resolver(fpmConfig.repositories).localOnly { it.log	= log }
		
		try {
			satisfied	:= resolver.satisfy(targetPod)
			resolver.cleanUp
			
			resolvedPods	= satisfied.resolvedPods
			unresolvedPods	= satisfied.unresolvedPods
			
		} catch (UnknownPodErr err) {
			// todo auto-download / install the pod dependency!??
			// beware, also thrown by BuildPod on malformed dependency str
			error = err

		} catch (Err err) {
			error = err
		}
		
		// ---- dump stuff to logs ----

		dumped := false

		// if there's something wrong, then make sure the user sees the dump
		if (error != null || unresolvedPods.size > 0) {
			log.warn(FpmEnv.dumpEnv(target, resolvedPods.vals, fpmConfig))
			dumped = true
		}

		if (!dumped) {
			log.debug(FpmEnv.dumpEnv(target, resolvedPods.vals, fpmConfig))
			dumped = true
		}

		if (unresolvedPods.size > 0) {
			log.warn(dumpUnresolved(unresolvedPods.vals))
			log.warn("Defaulting to latest pod versions")
			resolvedPods = resolver.resolveAll(false).setAll(resolvedPods)
		}

		if (error != null) {
			log.err  (error.toStr)
			if (error isnot UnknownPodErr)
				log.debug(error.traceToStr)
		}		
		
		errs := Err[,]
		if (error != null) errs.add(error)
		unresolvedPods.vals.each { errs.add(Err(it.toStr)) }
		resolveErrsRef.val = errs.toImmutable

		pods := resolvedPods.map { it.file }
		return pods.toImmutable	// for the Future!
	}
	
	override Err[] resolveErrs() {
		resolveErrsRef.val ?: Err#.emptyList 
	}
	
	override Void tweakLaunchEnv(Str:Str envVars) {
		setEnvVar(envVars, "FAN_ENV", 		FpmEnv#.qname)
		setEnvVar(envVars, "FPM_TARGET",	fanProj.podName)
	}
	
	override Void publishPod(File podFile) {
		prefs		:= FpmEnvPrefs(fanProj)
		repoName	:= prefs.publishToDefault ? "default" : prefs.publishRepo
		repository	:= fpmConfig.repository(repoName) ?: throw Err("Could not find repository named '${repoName}' - " + fpmConfig.repositories.join(", ") { it.name })
		PodFile(podFile).installTo(repository)
	}
	
	private Depend target() {
		Depend("${fanProj.podName} ${fanProj.version}")
	}

	private FpmConfig fpmConfig() {
		if (fpmConfigRef.val == null)
			fpmConfigRef.val = FpmConfig(fanProj.projectDir, fanProj.fanHomeDir, Env.cur.vars["FAN_ENV_PATH"])
		return fpmConfigRef.val
	}
	
	private Void setEnvVar(Str:Str envVars, Str key, Str val) {
		if (envVars.containsKey(key)) {
			if (envVars[key] != val)
				buildConsole.warn("Did not set environment variable $key to [$val] as it is already set to: ${envVars[key]}")
		} else
			envVars[key] = val
	}
	
	private static Str dumpUnresolved(UnresolvedPod[] unresolvedPods) {
		out	:= "Could not satisfy the following constraints:\n"
		unresolvedPods.each |unresolvedPod| {
			out	+= unresolvedPod.dump
		}
		return out
	}
}
