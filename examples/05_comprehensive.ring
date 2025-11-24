/*
 * Comprehensive UUID Example
 * 
 * This example demonstrates all features of the Ring UUID library in a
 * comprehensive, real-world scenario. It shows generation, validation,
 * nil UUIDs, and byte conversion working together.
 */

# Load the Ring UUID library
load "uuid.ring"

? "=========================================="
? "  Comprehensive UUID Example"
? "=========================================="

# Section 1: UUID Generation
? nl + "1. UUID Generation"
? "=================="
? "Generating 3 random UUIDs:"
aUUIDs = []
for n = 1 to 3
	cUUID = uuid_generate()
	add(aUUIDs, cUUID)
	? "  " + n + ". " + cUUID
next


# Section 2: UUID Validation
? nl + "2. UUID Validation"
? "=================="
? "Validating the generated UUIDs:"
for cUUID in aUUIDs
	if uuid_isvalid(cUUID)
		? "  ✓ " + cUUID + " is valid"
	else
		? "  ✗ " + cUUID + " is invalid"
	ok
next


# Test with known valid and invalid UUIDs
? "Testing edge cases:"
aTestCases = [
	"550e8400-e29b-41d4-a716-446655440000",
	"invalid-uuid",
	"123e4567-e89b-12d3-a456-426614174000",
	"too-short"
]

for cTest in aTestCases
	bValid = uuid_isvalid(cTest)
	if bValid
		? "  ✓ " + cTest
	else
		? "  ✗ " + cTest
	ok
next


# Section 3: Nil UUID
? nl + "3. Nil UUID"
? "==========="
cNilUUID = uuid_nil()
? "Nil UUID: " + cNilUUID
bNilValid = uuid_isvalid(cNilUUID)
if bNilValid
	? "Is valid: Yes"
else
	? "Is valid: No"
ok


# Section 4: Byte Conversion
? nl + "4. Byte Conversion"
? "=================="
? "Converting first generated UUID to bytes:"
cFirstUUID = aUUIDs[1]
? "UUID: " + cFirstUUID

try
	aBytes = uuid_tobytes(cFirstUUID)
	? "Byte array (" + len(aBytes) + " bytes):"
	
	# Display in hex format
	cHex = ""
	for n = 1 to len(aBytes)
		cByteHex = str2hex(aBytes[n])
		if len(cByteHex) = 1
			cByteHex = "0" + cByteHex
		ok
		cHex += cByteHex + " "
		if n % 4 = 0
			cHex += " "
		ok
	next
	? "  Hex: " + cHex

catch
	? "  Error: " + cCatchError
done

# Section 5: Practical Application
? nl + "5. Practical Application"
? "========================"
? "Simulating a user database with UUID primary keys:"


# Create a mock user database
aUsers = []

# Add some users
add_user("Alice Johnson", "alice@example.com")
add_user("Bob Smith", "bob@example.com")
add_user("Carol Williams", "carol@example.com")

# Display users
? "User Database:"
for n = 1 to len(aUsers)
	oUser = aUsers[n]
	? "  User " + n + ":"
	? "    ID:    " + oUser[:id]
	? "    Name:  " + oUser[:name]
	? "    Email: " + oUser[:email]
	
next

# Section 6: UUID Lookup Simulation
? nl + "6. UUID Lookup Simulation"
? "========================="
? "Looking up user by UUID:"
cSearchUUID = aUsers[2][:id]
? "Searching for: " + cSearchUUID

bFound = false
for oUser in aUsers
	if oUser[:id] = cSearchUUID
		? "  ✓ Found: " + oUser[:name] + " (" + oUser[:email] + ")"
		bFound = true
		exit
	ok
next

if !bFound
	? "  ✗ User not found"
ok


# Section 7: Summary Statistics
? nl + "7. Summary Statistics"
? "====================="
? "Total UUIDs generated in this example: " + (len(aUUIDs) + len(aUsers))
? "Total users created: " + len(aUsers)
? "Nil UUID used: " + cNilUUID

# Function to add user with UUID
func add_user name, email
	oUser = [
		:id = uuid_generate(),
		:name = name,
		:email = email,
		:created_at = time()
	]
	add(aUsers, oUser)
	return oUser