/*
 * SQLite UUID Example
 * 
 * This example demonstrates how to use UUIDs as primary keys in SQLite database.
 */

# Load required libraries
load "sqlitelib.ring"
load "uuid.ring"

? "=========================================="
? "  SQLite UUID Example"
? "=========================================="

# Initialize SQLite
oSQLite = sqlite_init()

# Create or open database
cDBFile = "uuid_demo.db"
sqlite_open(oSQLite, cDBFile)

? "Database: " + cDBFile + " opened successfully!"

# Create table with UUID as primary key
? nl + "Creating USERS table with UUID primary key..."
cSQL = "
	CREATE TABLE IF NOT EXISTS USERS (
		user_id    TEXT PRIMARY KEY NOT NULL,
		username   TEXT NOT NULL,
		email      TEXT NOT NULL,
		created_at TEXT DEFAULT CURRENT_TIMESTAMP
	);
"
sqlite_execute(oSQLite, cSQL)
? "Table created successfully!"

# Insert sample users with UUID primary keys
? nl + "Inserting sample users..."
aUsers = [
	["john_doe", "john@example.com"],
	["jane_smith", "jane@example.com"],
	["bob_wilson", "bob@example.com"],
	["alice_brown", "alice@example.com"]
]

for n = 1 to len(aUsers)
	# Generate UUID for primary key
	cUUID = uuid_generate()
	cUsername = aUsers[n][1]
	cEmail = aUsers[n][2]
	
	# Insert with UUID as primary key
	cSQL = "
		INSERT INTO USERS (user_id, username, email)
		VALUES ('" + cUUID + "', '" + cUsername + "', '" + cEmail + "');
	"
	sqlite_execute(oSQLite, cSQL)
	? "Inserted user: " + cUsername + " (UUID: " + cUUID + ")"
next

# Query and display all users
? nl + "=========================================="
? "  All Users in Database:"
? "=========================================="

aResult = sqlite_execute(oSQLite, "SELECT * FROM USERS ORDER BY created_at")

if len(aResult) > 0
	? "Total users: " + len(aResult)
	? ""
	
	for x in aResult
		? "User ID (UUID): " + x[:user_id]
		? "Username:       " + x[:username]
		? "Email:          " + x[:email]
		? "Created:        " + x[:created_at]
		? "----------------------------------------"
	next
else
	? "No users found in database."
ok

# Demonstrate UUID validation on query
? nl + "=========================================="
? "  Query by UUID (with validation):"
? "=========================================="

# Get first user's UUID from results
if len(aResult) > 0
	cTargetUUID = aResult[1][:user_id]
	? "Looking up UUID: " + cTargetUUID
	
	# Validate UUID before query
	if uuid_isvalid(cTargetUUID)
		? "✓ UUID is valid"
		
		# Query specific user
		cSQL = "SELECT * FROM USERS WHERE user_id = '" + cTargetUUID + "'"
		aUser = sqlite_execute(oSQLite, cSQL)
		
		if len(aUser) > 0
			? nl + "Found user:"
			? "Username: " + aUser[1][:username]
			? "Email:    " + aUser[1][:email]
		else
			? "User not found!"
		ok
	else
		? "✗ Invalid UUID format!"
	ok
ok

# Clean up
? nl + "=========================================="
? "  Cleanup"
? "=========================================="
? "Dropping USERS table..."
sqlite_execute(oSQLite, "DROP TABLE IF EXISTS USERS")
? "Table dropped."

# Close database
sqlite_close(oSQLite)
? "Database closed."

# Delete the demo database file
if fexists(cDBFile)
	remove(cDBFile)
	? "Demo database file removed."
ok

? nl + "✓ SQLite UUID example completed successfully!"