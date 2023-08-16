local config = {
	cmd = { 
		'/opt/eclipse_jdt/bin/jdtls' 
	},

}

require('jdtls').start_or_attach(config)
