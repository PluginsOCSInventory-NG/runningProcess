
 
package Apache::Ocsinventory::Plugins::Runningprocess::Map;
 
use strict;
 
use Apache::Ocsinventory::Map;

$DATA_MAP{runningprocess} = {
		mask => 0,
		multi => 1,
		auto => 1,
		delOnReplace => 1,
		sortBy => 'PATH',
		writeDiff => 0,
		cache => 0,
		fields => {
                PROCESSNAME => {},
                PROCESSID => {},
                USERNAME => {},
                PROCESSMEMORY => {},
                COMMANDLINE => {},
                DESCRIPTION => {},
                COMPANY => {}
	}
};
1;