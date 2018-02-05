let project = new Project('Empty');
project.addLibrary('tweenx');
project.addAssets('assets/**');
project.addSources('src');
project.windowOptions.width = 1024;
project.windowOptions.height = 768;
resolve(project);