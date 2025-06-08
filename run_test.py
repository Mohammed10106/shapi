"""Run test directly to debug import issues."""
import sys
import os

# Add the src directory to the Python path
sys.path.insert(0, os.path.abspath('.'))
sys.path.insert(0, os.path.abspath('src'))

print("Python path:", sys.path)
print("\nContents of src:", os.listdir('src'))
print("Contents of src/shapi:", os.listdir('src/shapi'))

try:
    import shapi
    print("\nSuccessfully imported shapi!")
    print(f"shapi module: {shapi}")
    print(f"shapi.__file__: {shapi.__file__}")
except ImportError as e:
    print(f"\nFailed to import shapi: {e}")
    import traceback
    traceback.print_exc()
