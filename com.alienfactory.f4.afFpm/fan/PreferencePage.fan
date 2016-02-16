using [java]org.eclipse.core.resources::IProject
using [java]org.eclipse.ui.preferences::IWorkbenchPreferenceContainer

using [java]org.eclipse.dltk.ui::PreferencesAdapter
using [java]org.eclipse.dltk.ui.preferences::AbstractOptionsBlock
using [java]org.eclipse.dltk.ui.preferences::PreferenceKey
using [java]org.eclipse.dltk.ui.preferences::ControlBindingManager
using [java]org.eclipse.dltk.ui.util::IStatusChangeListener
using [java]org.eclipse.dltk.ui.util::SWTFactory
	
using [java]org.eclipse.swt.widgets::Control
using [java]org.eclipse.swt.widgets::Button
using [java]org.eclipse.swt.widgets::Composite
using [java]org.eclipse.swt.layout::GridData
using [java]org.eclipse.swt.graphics::Font
using [java]org.eclipse.swt::SWT
using [java]java.util::ArrayList

using [java]org.eclipse.jface.preference::IPreferenceStore

using [java]com.xored.f4.builder.ui::AbstractConfigurationBlockPropertyAndPreferencePageBridge as Base
using [java]fanx.interop::Interop

class PreferencePage : Base {	
	override Str? getPropertyPageId		:= "${FpmEnvPlugin.id}.propertyPage"
	override Str? getPreferencePageId	:= "${FpmEnvPlugin.id}.preferencePage"
	override Str? getHelpId				:= null
	override Str? getProjectHelpId		:= null
	
	override protected Str? getDefaultDescription					:= "FPM Env preferences"
	override protected IPreferenceStore? getDefaultPreferenceStore	:= null
	
	override protected AbstractOptionsBlock? createOptionsBlock(IStatusChangeListener? context, IProject? project, IWorkbenchPreferenceContainer? container) {
		EnvOptionsBlock(context, project, container)
	}
}

class EnvOptionsBlock : AbstractOptionsBlock {

	new make(IStatusChangeListener? context, IProject? project,	IWorkbenchPreferenceContainer? container) : super(context, project, allKeys, container) { }
	
	override protected Control? createOptionsBlock(Composite? parent) {
//		composite := SWTFactory.createComposite(parent, parent.getFont, 1, 1, GridData.FILL_HORIZONTAL)
//		group := SWTFactory.createGroup(composite, "FAN_ENV_PATH value", 4, 1, GridData.FILL_HORIZONTAL)
		
		composite := SWTFactory.createComposite(parent, parent.getFont, 4, 1, GridData.FILL_HORIZONTAL)
		group	  := composite
		
		SWTFactory.createLabel(group, "Repository to publish pods to:", 4)
		radio1	:= SWTFactory.createRadioButton(group, "Use 'default'", 4)
		radio2	:= SWTFactory.createRadioButton(group, "Use:", 1)
		text	:= SWTFactory.createSingleText(group, 3)
		
		SWTFactory.createLabel(group, "", 4)
		SWTFactory.createLabel(group, "Tip: Look at the 'Fantom Build Console' for resolved pod details", 4)
	
		// stoopid private field
		bindManagerField := Interop.toJava(AbstractOptionsBlock#).getDeclaredField("bindManager")
		bindManagerField.setAccessible(true)
		bindManager := (ControlBindingManager) bindManagerField.get(this)
		bindManager.bindRadioControl(radio1, publishToDefaultKey, "true", null)
		bindManager.bindRadioControl(radio2, publishToDefaultKey, "false", [text])
		bindManager.bindControl(text, publishRepoKey, null)

		// stoopid private field
		KeysField := Interop.toJava(AbstractOptionsBlock#).getDeclaredField("keys")
		KeysField.setAccessible(true)
		keys := (ArrayList) KeysField.get(this)
		allKeys.each { keys.add(it) }

		return composite
	}
	
	static PreferenceKey publishToDefaultKey() {
		PreferenceKey(FpmEnvPlugin.id, FpmEnvPrefs.publishToDefaultName)
	}
	
	static PreferenceKey publishRepoKey() {
		PreferenceKey(FpmEnvPlugin.id, FpmEnvPrefs.publishRepoName)
	}

	static PreferenceKey[] allKeys() {
		[publishToDefaultKey, publishRepoKey]
	}
}


