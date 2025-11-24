# Ring UUID

[license]: https://img.shields.io/github/license/ysdragon/uuid?style=for-the-badge&logo=opensourcehardware&label=License&logoColor=C0CAF5&labelColor=414868&color=8c73cc
[![][license]](https://github.com/ysdragon/uuid/blob/master/LICENSE)

[ring]: https://img.shields.io/badge/Made_with_❤️_for-Ring-2D54CB?style=for-the-badge
[![][ring]](https://ring-lang.net/)

A Ring language extension/library for UUID (Universally Unique Identifier) generation and validation, providing a simple and efficient API for working with UUIDs in Ring applications built on top of the [stduuid](https://github.com/mariusbancila/stduuid) C++ library.

## ✨ Key Features

- Generate random UUIDs (version 4)
- Validate UUID strings
- Create nil (all-zero) UUIDs
- Cross-platform support (Windows, Linux, macOS, FreeBSD)
- Multiple architecture support (x64/amd64, arm64, x86/i386/i686)

## 📦 Installation

This package can be installed using the Ring Package Manager (**RingPM**):

```
ringpm install uuid from ysdragon
```

## 💡 Usage

First, load the library in your Ring script:

```ring
load "uuid.ring"
```

### Basic UUID Generation

To generate a random UUID:

```ring
cUUID = uuid_generate()
see "Generated UUID: " + cUUID + nl
```

### UUID Validation

To validate if a string is a valid UUID:

```ring
cUUID = "550e8400-e29b-41d4-a716-446655440000"
if uuid_isvalid(cUUID)
    ? "Valid UUID!"
else
    ? "Invalid UUID!"
ok
```

### Nil UUID

To create a nil UUID (all zeros):

```ring
cNilUUID = uuid_nil()
? "Nil UUID: " + cNilUUID
```

### UUID to Bytes Conversion

To convert a UUID to a byte array:

```ring
cUUID = "550e8400-e29b-41d4-a716-446655440000"
try
    aBytes = uuid_tobytes(cUUID)
    ? "Byte array length: " + len(aBytes)
catch
    ? "Error: Invalid UUID format"
end
```

## 📚 API Reference

### Functions

- `uuid_generate()` - Generates a random UUID (version 4) and returns it as a string
- `uuid_isvalid(uuid_string)` - Validates if the provided string is a valid UUID format
  - Parameters:
    - `uuid_string` (string): The UUID string to validate
  - Returns: 1 (true) if valid, 0 (false) if invalid
- `uuid_nil()` - Returns a nil UUID (all zeros) as a string
- `uuid_tobytes(uuid_string)` - Converts a UUID string to a 16-byte array
  - Parameters:
    - `uuid_string` (string): The UUID string to convert
  - Returns: 16-byte array containing the UUID bytes
  - Throws: Error if the UUID string is invalid

## 🛠️ Development

If you wish to contribute to the development of Ring UUID or build it from the source, follow these steps.

### Prerequisites

- **CMake**: Version 3.16 or higher.
- **C++ Compiler**: A C++ compiler compatible with your platform (e.g., GCC, Clang, MSVC).
- **[Ring](https://ring-lang.net/) Source Code**: You will need to have the Ring language source code available on your machine.

### Build Steps

1. **Clone the Repository:**
   ```sh
   git clone https://github.com/ysdragon/uuid.git --recursive
   ```
   > **Note**: If you installed the library via RingPM, you can skip this step.

2. **Set the `RING` Environment Variable:**
   This variable must point to the root directory of the Ring language source code.

   - **Windows (Command Prompt):**
     ```cmd
     set RING=X:\path\to\ring
     ```
   - **Windows (PowerShell):**
     ```powershell
     $env:RING = "X:\path\to\ring"
     ```
   - **Unix-like Systems (Linux, macOS or FreeBSD):**
     ```bash
     export RING=/path/to/ring
     ```

3. **Configure with CMake:**
   Create a build directory and run CMake from within it.
   ```sh
   mkdir build
   cd build
   cmake ..
   ```

4. **Build the Project:**
   Compile the source code using the build toolchain configured by CMake.
   ```sh
   cmake --build .
   ```

   The compiled library will be available in the `lib/<os>/<arch>` directory.

## 🤝 Contributing

Contributions are always welcome! If you have suggestions for improvements or have identified a bug, please feel free to open an issue or submit a pull request.

## 📄 License

This project is licensed under the MIT License. See the [`LICENSE`](LICENSE) file for more details.