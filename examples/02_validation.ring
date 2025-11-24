/*
 * UUID Validation Example
 * 
 * This example demonstrates how to validate UUID strings to ensure they
 * conform to the proper UUID format.
 */

# Load the Ring UUID library
load "uuid.ring"

? "=========================================="
? "  UUID Validation Example"
? "=========================================="

# Test cases for validation
aTestCases = [
	# Valid UUIDs
	"550e8400-e29b-41d4-a716-446655440000",
	"123e4567-e89b-12d3-a456-426614174000",
	"00000000-0000-0000-0000-000000000000",
	"ffffffff-ffff-ffff-ffff-ffffffffffff",
	
	# Invalid UUIDs
	"550e8400-e29b-41d4-a716-44665544000",     # Too short
	"550e8400-e29b-41d4-a716-4466554400000",   # Too long
	"550e8400-e29b-41d4-a716-44665544000g",    # Invalid character 'g'
	"550e8400-e29b-41d4-a716_446655440000",    # Invalid separator '_'
	"550e8400-e29b-41d4-a716446655440000",     # Missing hyphen
	"550e8400-e29b-41d4-a716-44665544000",     # Missing character
	"not-a-uuid-at-all",                        # Completely invalid
	"",                                         # Empty string
	"550e8400-e29b-41d4-a716-446655440000-extra"  # Extra characters
]

? nl + "Testing UUID Validation:" + nl

nValidCount = 0
nInvalidCount = 0

for cUUID in aTestCases
	bIsValid = uuid_isvalid(cUUID)
	
	if bIsValid
		nValidCount++
		? "✓ VALID:   " + cUUID
	else
		nInvalidCount++
		? "✗ INVALID: " + cUUID
	ok
next

? nl + "=========================================="
? "  Validation Summary:"
? "=========================================="
? "Valid UUIDs:   " + nValidCount
? "Invalid UUIDs: " + nInvalidCount
? "Total tested:  " + (nValidCount + nInvalidCount)