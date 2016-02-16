using [java]org.eclipse.core.runtime.preferences::AbstractPreferenceInitializer
using [java]org.eclipse.core.runtime.preferences::DefaultScope
using [java]org.eclipse.core.resources::IProject
using [java]org.eclipse.dltk.core::PreferencesLookupDelegate
using f4core::FantomProject

class FpmEnvPrefs {
	static const Str publishToDefaultName	:= "publishToDefault"
	static const Str publishRepoName		:= "publishRepo"
	
	private PreferencesLookupDelegate	delegate
	private IProject 					project
	private Str 						qualifier
	
	new make(FantomProject project)	{
		this.project	= project.project
		this.delegate	= PreferencesLookupDelegate(this.project)
		this.qualifier	= FpmEnvPlugin.id
	}
	
	Bool publishToDefault() { 
		delegate.getBoolean(qualifier, publishToDefaultName)
	}
	
	Str publishRepo() { 
		delegate.getString(qualifier, publishRepoName)
	}
}

class FpmEnvPrefsInitializer : AbstractPreferenceInitializer {
	override Void initializeDefaultPreferences() {
		store := DefaultScope().getNode(FpmEnvPlugin.id)

		store.putBoolean(FpmEnvPrefs.publishToDefaultName, true)
		store.put		(FpmEnvPrefs.publishRepoName, "default")
	}
}