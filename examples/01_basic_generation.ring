/*
 * Basic UUID Generation Example
 * 
 * This example demonstrates how to generate random UUIDs using the Ring UUID library.
 */

# Load the Ring UUID library
load "uuid.ring"

? "=========================================="
? "  Basic UUID Generation Example"
? "=========================================="

# Generate a single random UUID
? nl + "Generating a single UUID:"
cUUID = uuid_generate()
? "UUID: " + cUUID


# Generate multiple UUIDs to demonstrate uniqueness
? nl + "Generating 5 UUIDs to show uniqueness:"
for n = 1 to 5
	cUUID = uuid_generate()
	? "UUID " + n + ": " + cUUID
next