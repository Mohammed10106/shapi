# ShAPI Example Commands

This directory contains example shell scripts that demonstrate how to use ShAPI to expose common Unix commands as RESTful APIs. Each script is a simple wrapper around a standard command with some additional formatting and error handling.

## Available Examples

### 1. `ls.sh` - List Directory Contents

**Description**: Lists files and directories with detailed information.

**Parameters**:
- `directory` (optional): The directory to list (default: current directory)

**Example API Call**:
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

### 2. `ps.sh` - Process Status

**Description**: Lists currently running processes with optional filtering.

**Parameters**:
- `pattern` (optional): Filter processes by name pattern

**Example API Call**:
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

**Example API Call**:
```bash
curl -X POST "http://localhost:8003/run" \
     -H "Content-Type: application/json" \
     -d '{}'
```

### 4. `free.sh` - Memory Usage

**Description**: Displays memory usage statistics.

**Parameters**: None

**Example API Call**:
```bash
curl -X POST "http://localhost:8004/run" \
     -H "Content-Type: application/json" \
     -d '{}'
```

### 5. `whoami.sh` - User Information

**Description**: Shows information about the current user.

**Parameters**: None

**Example API Call**:
```bash
curl -X POST "http://localhost:8005/run" \
     -H "Content-Type: application/json" \
     -d '{}'
```

### 6. `date.sh` - Current Date/Time

**Description**: Displays the current date and time with optional formatting.

**Parameters**:
- `format` (optional): strftime format string (default: "%Y-%m-%d %H:%M:%S")

**Example API Call**:
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

**Description**: Returns the input text as a response.

**Parameters**:
- `text` (optional): Text to echo back

**Example API Call**:
```bash
curl -X POST "http://localhost:8007/run" \
     -H "Content-Type: application/json" \
     -d '{"parameters": {"text": "Hello, World!"}}'
```

## Running the Examples

### Start All Examples

You can start all example services using the Makefile:

```bash
# Start all example services in the background
make start-examples

# List running services
make list-examples

# Stop all example services
make stop-examples
```

### Start Individual Services

```bash
# Start a single service
make start-example EXAMPLE=ls PORT=8001

# Test the service
curl -X POST "http://localhost:8001/run" \
     -H "Content-Type: application/json" \
     -d '{}'

# Stop the service
make stop-example NAME=ls-service
```

## Testing

Run the test suite to verify all examples:

```bash
make test-examples
```

This will start each service, run tests against it, and then stop it.
