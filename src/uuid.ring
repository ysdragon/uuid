# Load the Ring UUID library based on the operating system.

if isWindows()
	loadlib("ring_uuid.dll")
but isLinux() or isFreeBSD()
	loadlib("libring_uuid.so")
but isMacOSX()
	loadlib("libring_uuid.dylib")
else
	raise("Unsupported OS! You need to build the library for your OS.")
ok