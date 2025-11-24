arch = getarch()
if isWindows()
	if arch = "x64"
		loadlib("../lib/windows/amd64/ring_uuid.dll")
	but arch = "arm64"
		loadlib("../lib/windows/arm64/ring_uuid.dll")
	but arch = "x86"
		loadlib("../lib/windows/i386/ring_uuid.dll")
	ok
but isLinux()
	if arch = "x64"
		loadlib("../lib/linux/amd64/libring_uuid.so")
	but arch = "arm64"
		loadlib("../lib/linux/arm64/libring_uuid.so")
	ok
but isFreeBSD()
	if arch = "x64"
		loadlib("../lib/freebsd/amd64/libring_uuid.so")
	but arch = "arm64"
		loadlib("../lib/freebsd/arm64/libring_uuid.so")
	ok
but isMacOSX()
	if arch = "x64"
		loadlib("../lib/macos/amd64/libring_uuid.dylib")
	but arch = "arm64"
		loadlib("../lib/macos/arm64/libring_uuid.dylib")
	ok
else
	raise("Unsupported OS! You need to build the library for your OS.")
ok

load "utils/color.ring"

func main
	? colorText([:text = "--- Testing UUID Library ---", :color = :BRIGHT_YELLOW, :style = :BOLD])

	# Test Case 1: Generate UUID
	? colorText([:text = "Test Case 1: Generate UUID", :color = :BRIGHT_CYAN])
	
	uuid1 = uuid_generate()
	? colorText([:text = "Generated UUID: ", :color = :GREEN]) + uuid1
	
	if uuid_isvalid(uuid1)
		? colorText([:text = "UUID validation: OK", :color = :BRIGHT_GREEN])
	else
		? colorText([:text = "UUID validation: FAILED", :color = :BRIGHT_RED])
	ok
	? colorText([:text = copy("-", 50), :color = :BRIGHT_BLACK])

	# Test Case 2: Generate multiple UUIDs (ensure uniqueness)
	? colorText([:text = "Test Case 2: Generate multiple UUIDs", :color = :BRIGHT_CYAN])
	
	uuid2 = uuid_generate()
	uuid3 = uuid_generate()
	uuid4 = uuid_generate()
	
	? colorText([:text = "UUID 1: ", :color = :GREEN]) + uuid1
	? colorText([:text = "UUID 2: ", :color = :GREEN]) + uuid2
	? colorText([:text = "UUID 3: ", :color = :GREEN]) + uuid3
	? colorText([:text = "UUID 4: ", :color = :GREEN]) + uuid4
	
	# Check uniqueness
	if uuid1 != uuid2 and uuid1 != uuid3 and uuid1 != uuid4 and uuid2 != uuid3 and uuid2 != uuid4 and uuid3 != uuid4
		? colorText([:text = "Uniqueness test: OK", :color = :BRIGHT_GREEN])
	else
		? colorText([:text = "Uniqueness test: FAILED", :color = :BRIGHT_RED])
	ok
	? colorText([:text = copy("-", 50), :color = :BRIGHT_BLACK])

	# Test Case 3: Nil UUID
	? colorText([:text = "Test Case 3: Nil UUID", :color = :BRIGHT_CYAN])
	
	nil_uuid = uuid_nil()
	? colorText([:text = "Nil UUID: ", :color = :GREEN]) + nil_uuid
	
	if uuid_isvalid(nil_uuid)
		? colorText([:text = "Nil UUID validation: OK", :color = :BRIGHT_GREEN])
	else
		? colorText([:text = "Nil UUID validation: FAILED", :color = :BRIGHT_RED])
	ok
	
	if nil_uuid = "00000000-0000-0000-0000-000000000000"
		? colorText([:text = "Nil UUID format: OK", :color = :BRIGHT_GREEN])
	else
		? colorText([:text = "Nil UUID format: FAILED", :color = :BRIGHT_RED])
	ok
	? colorText([:text = copy("-", 50), :color = :BRIGHT_BLACK])

	# Test Case 4: UUID validation
	? colorText([:text = "Test Case 4: UUID validation", :color = :BRIGHT_CYAN])
	
	valid_uuid = "550e8400-e29b-41d4-a716-446655440000"
	invalid_uuid1 = "not-a-uuid"
	invalid_uuid2 = "550e8400-e29b-41d4-a716-44665544000"  # missing digit
	invalid_uuid3 = "550e8400-e29b-41d4-a716-4466554400000" # extra digit
	
	? colorText([:text = "Valid UUID: ", :color = :MAGENTA]) + valid_uuid
	if uuid_isvalid(valid_uuid)
		? colorText([:text = "Valid UUID test: OK", :color = :BRIGHT_GREEN])
	else
		? colorText([:text = "Valid UUID test: FAILED", :color = :BRIGHT_RED])
	ok
	
	? colorText([:text = "Invalid UUID 1: ", :color = :MAGENTA]) + invalid_uuid1
	if not uuid_isvalid(invalid_uuid1)
		? colorText([:text = "Invalid UUID test 1: OK", :color = :BRIGHT_GREEN])
	else
		? colorText([:text = "Invalid UUID test 1: FAILED", :color = :BRIGHT_RED])
	ok
	
	? colorText([:text = "Invalid UUID 2: ", :color = :MAGENTA]) + invalid_uuid2
	if not uuid_isvalid(invalid_uuid2)
		? colorText([:text = "Invalid UUID test 2: OK", :color = :BRIGHT_GREEN])
	else
		? colorText([:text = "Invalid UUID test 2: FAILED", :color = :BRIGHT_RED])
	ok
	
	? colorText([:text = "Invalid UUID 3: ", :color = :MAGENTA]) + invalid_uuid3
	if not uuid_isvalid(invalid_uuid3)
		? colorText([:text = "Invalid UUID test 3: OK", :color = :BRIGHT_GREEN])
	else
		? colorText([:text = "Invalid UUID test 3: FAILED", :color = :BRIGHT_RED])
	ok
	? colorText([:text = copy("-", 50), :color = :BRIGHT_BLACK])

	# Test Case 5: UUID to bytes conversion
	? colorText([:text = "Test Case 5: UUID to bytes conversion", :color = :BRIGHT_CYAN])
	
	test_uuid = "550e8400-e29b-41d4-a716-446655440000"
	? colorText([:text = "Test UUID: ", :color = :MAGENTA]) + test_uuid
	
	try
		bytes = uuid_tobytes(test_uuid)
		? colorText([:text = "Bytes length: ", :color = :GREEN]) + len(bytes)
		? colorText([:text = "Conversion successful: OK", :color = :BRIGHT_GREEN])
	catch
		? colorText([:text = "Conversion failed: FAILED", :color = :BRIGHT_RED])
	end
	
	# Test with invalid UUID
	try
		invalid_bytes = uuid_tobytes(invalid_uuid1)
		? colorText([:text = "Invalid UUID conversion test: FAILED", :color = :BRIGHT_RED])
	catch
		? colorText([:text = "Invalid UUID conversion test: OK", :color = :BRIGHT_GREEN])
	end
	? colorText([:text = copy("-", 50), :color = :BRIGHT_BLACK])

	# Test Case 6: Edge cases
	? colorText([:text = "Test Case 6: Edge cases", :color = :BRIGHT_CYAN])
	
	# Test empty string
	if not uuid_isvalid("")
		? colorText([:text = "Empty string validation: OK", :color = :BRIGHT_GREEN])
	else
		? colorText([:text = "Empty string validation: FAILED", :color = :BRIGHT_RED])
	ok
	
	# Test nil UUID validation
	if uuid_isvalid(uuid_nil())
		? colorText([:text = "Nil UUID validation: OK", :color = :BRIGHT_GREEN])
	else
		? colorText([:text = "Nil UUID validation: FAILED", :color = :BRIGHT_RED])
	ok
	? colorText([:text = copy("-", 50), :color = :BRIGHT_BLACK])

	? colorText([:text = "All UUID tests completed!", :color = :BRIGHT_GREEN, :style = :BOLD])