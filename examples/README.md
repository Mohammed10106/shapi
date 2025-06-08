# 📚 ShAPI Examples

This directory contains example shell scripts that demonstrate how to use ShAPI to expose common Unix commands as RESTful APIs. Each script is implemented to handle JSON input and provide structured output.

## 📋 Available Examples

| Example | Port | Description |
|---------|------|-------------|
| [ls.sh](#1-lssh---list-directory-contents) | 8001 | List directory contents |
| [ps.sh](#2-pssh---process-status) | 8002 | Show running processes |
| [df.sh](#3-dfsh---disk-usage) | 8003 | Display disk usage |
| [free.sh](#4-freesh---memory-usage) | 8004 | Show memory usage |
| [whoami.sh](#5-whoamish---user-information) | 8005 | Show user information |
| [date.sh](#6-datesh---current-datetime) | 8006 | Show current date/time |
| [echo.sh](#7-echosh---echo-input) | 8007 | Echo back input text |

## 🚀 Getting Started

### Prerequisites

- Bash shell
- jq (for JSON processing in scripts)
- Python 3.7+
- Make (for convenience commands)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/wronai/shapi.git
   cd shapi
   ```

2. Install dependencies:
   ```bash
   pip install -e .
   ```

## 📝 Example Details

### 1. `ls.sh` - List Directory Contents

**Description**: Lists files and directories with detailed information.

**Parameters**:
- `directory` (string, optional): The directory to list (default: current directory)

**Example Usage**:
```bash
# List current directory
curl -X POST "http://localhost:8001/run" \
     -H "Content-Type: application/json" \
     -d '{}'

# List specific directory
curl -X POST "http://localhost:8001/run" \
     -H "Content-Type: application/json" \
     -d '{"parameters": {"directory": "/tmp"}}'
```

**Expected Output**:
```
total 312
drwxr-xr-x 1 user group   4096 Jun  1 10:30 .
drwxr-xr-x 1 user group   4096 May 28 14:15 ..
-rw-r--r-- 1 user group   1024 Jun  1 09:45 file1.txt
...
```

### 2. `ps.sh` - Process Status

**Description**: Lists currently running processes with optional filtering.

**Parameters**:
- `pattern` (string, optional): Filter processes by name pattern

**Example Usage**:
```bash
# List all processes
curl -X POST "http://localhost:8002/run" \
     -H "Content-Type: application/json" \
     -d '{}'

# Filter processes by name
curl -X POST "http://localhost:8002/run" \
     -H "Content-Type: application/json" \
     -d '{"parameters": {"pattern": "python"}}'
```

### 3. `df.sh` - Disk Filesystem Usage

**Description**: Shows disk space usage with human-readable output.

**Parameters**: None

**Example Usage**:
```bash
curl -X POST "http://localhost:8003/run" \
     -H "Content-Type: application/json" \
     -d '{}'
```

### 4. `free.sh` - Memory Usage

**Description**: Displays memory usage statistics.

**Parameters**: None

**Example Usage**:
```bash
curl -X POST "http://localhost:8004/run" \
     -H "Content-Type: application/json" \
     -d '{}'
```

### 5. `whoami.sh` - User Information

**Description**: Shows information about the current user.

**Parameters**: None

**Example Usage**:
```bash
curl -X POST "http://localhost:8005/run" \
     -H "Content-Type: application/json" \
     -d '{}'
```

### 6. `date.sh` - Current Date/Time

**Description**: Displays the current date and time with optional formatting.

**Parameters**:
- `format` (string, optional): strftime format string (default: "%Y-%m-%d %H:%M:%S")

**Example Usage**:
```bash
# Default format
curl -X POST "http://localhost:8006/run" \
     -H "Content-Type: application/json" \
     -d '{}'

# Custom format
curl -X POST "http://localhost:8006/run" \
     -H "Content-Type: application/json" \
     -d '{"parameters": {"format": "%Y-%m-%d"}}'
```

### 7. `echo.sh` - Echo Input

**Description**: Returns the input text as a response with optional prefix and suffix.

**Parameters**:
- `text` (string, optional): Text to echo back
- `prefix` (string, optional): Text to prepend to the output
- `suffix` (string, optional): Text to append to the output

**Example Usage**:
```bash
# Simple echo
curl -X POST "http://localhost:8007/run" \
     -H "Content-Type: application/json" \
     -d '{"parameters": {"text": "Hello, World!"}}'

# With prefix and suffix
curl -X POST "http://localhost:8007/run" \
     -H "Content-Type: application/json" \
     -d '{"parameters": {"text": "Hello", "prefix": "[", "suffix": "]"}}'
```

## 🚦 Running the Examples

### Using Makefile Commands

```bash
# Start all example services (ports 8001-8007)
make start-examples

# Verify all examples are working
make check-examples

# List running services
make list-examples

# Stop all services
make stop-examples
```

### Managing Individual Services

```bash
# Start a specific example
make start-example EXAMPLE=ls PORT=8001

# Stop a specific service
make stop-example NAME=ls-service

# View service logs
tail -f logs/ls-service.log
```

## 🧪 Testing

Run the complete test suite:

```bash
make test-examples
```

This will:
1. Start each service
2. Run tests against each endpoint
3. Verify the responses
4. Stop the services

## 🛠️ Development

### Adding a New Example

1. Create a new shell script in the `examples` directory
2. Make it executable: `chmod +x examples/your_script.sh`
3. Update the `EXAMPLE_PORTS` variable in the Makefile if needed
4. Add documentation to this README
5. Add tests to `test_examples.py`

### Debugging

To debug a service, run it directly:

```bash
# Run in foreground with debug output
SHAPI_DEBUG=1 ./examples/ls.sh
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.
