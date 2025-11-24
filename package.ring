aPackageInfo = [
	:name = "Ring UUID",
	:description = "UUID library for Ring with generation, validation, nil UUIDs, and byte conversion.",
	:folder = "uuid",
	:developer = "ysdragon",
	:email = "",
	:license = "MIT License",
	:version = "1.0.0",
	:ringversion = "1.24",
	:versions = 	[
		[
			:version = "1.0.0",
			:branch = "master"
		]
	],
	:libs = 	[
		[
			:name = "",
			:version = "",
			:providerusername = ""
		]
	],
	:files = 	[
		".clang-format",
		"CMakeLists.txt",
		"examples/01_basic_generation.ring",
		"examples/02_validation.ring",
		"examples/03_nil_uuid.ring",
		"examples/04_bytes_conversion.ring",
		"examples/05_comprehensive.ring",
		"examples/06_sqlite_uuid.ring",
		"lib.ring",
		"LICENSE",
		"main.ring",
		"package.ring",
		"README.md",
		"src/c_src/ring_uuid.cpp",
		"src/uuid.ring",
		"src/uuid_test.ring",
		"src/utils/color.ring",
		"src/utils/install.ring",
		"src/utils/uninstall.ring"
	],

	:ringfolderfiles = 	[

	],
	:windowsfiles = 	[
		"lib/windows/amd64/ring_uuid.dll",
		"lib/windows/arm64/ring_uuid.dll",
		"lib/windows/i386/ring_uuid.dll"
	],
	:linuxfiles = 	[
		"lib/linux/amd64/libring_uuid.so",
		"lib/linux/arm64/libring_uuid.so"
	],
	:ubuntufiles = 	[

	],
	:fedorafiles = 	[

	],
	:macosfiles = 	[
		"lib/macos/amd64/libring_uuid.dylib",
		"lib/macos/arm64/libring_uuid.dylib"
	],
	:freebsdfiles = 	[
		"lib/freebsd/amd64/libring_uuid.so",
		"lib/freebsd/arm64/libring_uuid.so"
	],
	:windowsringfolderfiles = 	[

	],
	:linuxringfolderfiles = 	[

	],
	:ubunturingfolderfiles = 	[

	],
	:fedoraringfolderfiles = 	[

	],
	:freebsdringfolderfiles = 	[

	],
	:macosringfolderfiles = 	[

	],
	:run = "ring main.ring",
	:windowsrun = "",
	:linuxrun = "",
	:macosrun = "",
	:ubunturun = "",
	:fedorarun = "",
	:setup = "ring src/utils/install.ring",
	:windowssetup = "",
	:linuxsetup = "",
	:macossetup = "",
	:ubuntusetup = "",
	:fedorasetup = "",
	:remove = "ring src/utils/uninstall.ring",
	:windowsremove = "",
	:linuxremove = "",
	:macosremove = "",
	:ubunturemove = "",
	:fedoraremove = ""
]
