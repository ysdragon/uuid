/*
 * Nil UUID Example
 * 
 * This example demonstrates the nil UUID (all zeros), which is a special UUID
 * consisting entirely of zeros.
 */

# Load the Ring UUID library
load "uuid.ring"

? "=========================================="
? "  Nil UUID Example"
? "=========================================="

# Generate a nil UUID
cNilUUID = uuid_nil()

? nl + "Nil UUID: " + cNilUUID

# Verify it's all zeros
? nl + "Verification:"
? "Character at position 1: '" + cNilUUID[1] + "'"
? "Character at position 10: '" + cNilUUID[10] + "'"
? "Character at position 20: '" + cNilUUID[20] + "'"
? "Character at position 30: '" + cNilUUID[30] + "'"

# Validate the nil UUID
? nl + "Validation check:"
if uuid_isvalid(cNilUUID)
	? "✓ Nil UUID is a valid UUID format"
else
	? "✗ Nil UUID is not valid (should not happen!)"
ok

# Compare with regular UUID
? nl + "Comparison with regular UUID:"
cRegularUUID = uuid_generate()
? "Nil UUID:     " + cNilUUID
? "Regular UUID: " + cRegularUUID

? "Example: Using nil UUID as default value"

aRecords = [
	[:id = cNilUUID, :name = "Uninitialized Record"],
	[:id = uuid_generate(), :name = "Record 1"],
	[:id = uuid_generate(), :name = "Record 2"]
]

for oRecord in aRecords
	? "Record: " + oRecord[:name] + " | ID: " + oRecord[:id]
next