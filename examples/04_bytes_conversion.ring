/*
 * UUID to Bytes Conversion Example
 * 
 * This example demonstrates how to convert UUID strings to byte arrays
 * and back.
 */

# Load the Ring UUID library
load "uuid.ring"

? "=========================================="
? "  UUID to Bytes Conversion Example"
? "=========================================="

# Example UUID for conversion
cUUID = "550e8400-e29b-41d4-a716-446655440000"

? "Original UUID string:"
? cUUID

# Convert UUID to bytes
? "Converting to byte array..."
try
	aBytes = uuid_tobytes(cUUID)
	
	? "Conversion successful!"
	? "Byte array length: " + len(aBytes) + " bytes"
	
	
	# Display bytes in hex format
	? "Byte array content (hexadecimal):"
	cHexOutput = ""
	for n = 1 to len(aBytes)
		# Convert byte to 2-digit hex
		cHex = str2hex(aBytes[n])
		if len(cHex) = 1
			cHex = "0" + cHex
		ok
		cHexOutput += cHex + " "
		
		# New line every 4 bytes for readability
		if n % 4 = 0
			cHexOutput += nl
		ok
	next
	? cHexOutput
	
	
catch
	? "Error during conversion: " + cCatchError
done

# Demonstrate with nil UUID
? "=========================================="
? "  Nil UUID Conversion:"
? "=========================================="
cNilUUID = uuid_nil()
? "Nil UUID: " + cNilUUID

try
	aNilBytes = uuid_tobytes(cNilUUID)
	? "Nil UUID bytes (hex):"
	cNilHex = ""
	for n = 1 to len(aNilBytes)
		cHex = str2hex(aNilBytes[n])
		if len(cHex) = 1
			cHex = "0" + cHex
		ok
		cNilHex += cHex + " "
		if n % 4 = 0
			cNilHex += nl
		ok
	next
	? cNilHex
	
	
	# Verify all bytes are zero
	bAllZero = true
	for n = 1 to len(aNilBytes)
		if aNilBytes[n] != 0
			bAllZero = false
			exit
		ok
	next
	
	if bAllZero
		? "✓ All bytes are zero (as expected for nil UUID)"
	else
		? "✗ Unexpected: Not all bytes are zero!"
	ok
catch
	? "Error: " + cCatchError
done


# Demonstrate error handling with invalid UUID
? nl + "=========================================="
? "  Error Handling:"
? "=========================================="
? "Testing with invalid UUID: 'invalid-uuid-here'"
try
	aInvalidBytes = uuid_tobytes("invalid-uuid-here")
	? "Unexpected: Conversion succeeded!"
catch
	? "✓ Caught expected error: " + cCatchError
done