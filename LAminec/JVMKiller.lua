require("lfs")

function JVMArgs()

	local JVMArgs = {
		"-XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe.heapdump",
		"-XX:+UseG1GC",
        "-XX:-UseAdaptiveSizePolicy",
        "-XX:-OmitStackTraceInFastThrow",
		"-Xmn128m",
		"-Xmx1024m",
		"\"-Djava.library.path="..lfs.currentdir().."/.minecraft/natives\"",
        "-Dfml.ignoreInvalidMinecraftCertificates=true",
        "-Dfml.ignorePatchDiscrepancies=true"
		}
	
	return JVMArgs
end