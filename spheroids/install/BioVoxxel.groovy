/*
 * Copyright 2024, BioVoxxel (Jan Brocher)
 */


List<String> publicUpdateSites = 	[
									"3D ImageJ Suite", 
									"Biomedgroup", 
									"BioVoxxel",
									"BioVoxxel Figure Tools",
									"BioVoxxel 3D Box",
									"BoneJ",
									"clij", 
									"clij2", 
									"clijx-assistant", 
									"clijx-assistant-extensions", 
									"Excel Functions",
									];





















































//---------------------------------------------------------------
// Here, the magic happens
//---------------------------------------------------------------

import net.imagej.updater.CommandLine;
import net.imagej.updater.UpdateService;
import net.imagej.updater.UpdateSite;
import ij.IJ;
import java.io.IOException;
import java.lang.RuntimeException;
import java.util.ArrayList;
import java.util.List;



#@UpdateService us

CommandLine cmd = new CommandLine();
List<String> args = new ArrayList<>(2);



//add public update sites
try {
	
	for (s = 0; s < publicUpdateSites.size(); s++) {
		
		UpdateSite site = us.getUpdateSite(publicUpdateSites.get(s));
		
		if (!site.isActive()) {
			println "Adding update site = " + site.getName() + " --> URL = " + site.getURL();
			
			args = new ArrayList<>(2);
			args.add(site.getName());
			args.add(site.getURL());
			
			cmd.addOrEditUploadSite(args, false);
			
			println "Activated " + publicUpdateSites.get(s);
		} else {
			println site.getName() + " is already active";
		}
	}

	List<String> cmd_args = new ArrayList<>(2);
	cmd_args.add("update");
	cmd_args.add("--updateall");
	cmd.refreshUpdateSites(cmd_args);
	
} catch (IOException e) {
	println e.getMessage();
}

//run the Fiji updater to download and install all updatable files
IJ.run("Update...", "");