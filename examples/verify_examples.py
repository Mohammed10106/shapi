#!/usr/bin/env python3
"""
Simple verification script for ShAPI examples.
This script tests each example script directly without starting a server.
"""

import json
import subprocess
import sys
from pathlib import Path
from typing import Dict, Any, Tuple

def run_example(script: Path, params: Dict[str, Any] = None) -> Tuple[bool, str, str]:
    """Run an example script with the given parameters and return the result."""
    try:
        # Convert params to JSON string if provided
        input_data = json.dumps({"parameters": params or {}})
        
        # Run the script with the input
        result = subprocess.run(
            [str(script.absolute())],
            input=input_data,
            capture_output=True,
            text=True,
            encoding='utf-8'
        )
        
        # Check if the command was successful
        if result.returncode == 0:
            return True, result.stdout.strip(), result.stderr.strip()
        else:
            return False, result.stdout.strip(), result.stderr.strip()
            
    except Exception as e:
        return False, "", f"Error running {script.name}: {str(e)}"

def verify_example(name: str, script: Path, params: Dict[str, Any] = None, expected_text: str = None) -> bool:
    """Verify that an example script works as expected."""
    print(f"\n🔍 Testing {name}...")
    success, output, error = run_example(script, params)
    
    if not success:
        print(f"❌ {name} failed with error:")
        if error:
            print(f"   Error: {error}")
        if output:
            print(f"   Output: {output[:200]}..." if len(output) > 200 else f"   Output: {output}")
        return False
    
    print(f"✅ {name} succeeded")
    if expected_text and expected_text not in output:
        print(f"   Warning: Expected text '{expected_text}' not found in output")
    
    # Print a preview of the output
    preview = output[:200] + "..." if len(output) > 200 else output
    print(f"   Output: {preview}")
    return True

def main():
    """Main function to run all example verifications."""
    examples_dir = Path(__file__).parent
    examples = [
        ("ls", examples_dir / "ls.sh", {}, "total"),
        ("ps", examples_dir / "ps.sh", {}, "PID"),
        ("df", examples_dir / "df.sh", {}, "Filesystem"),
        ("free", examples_dir / "free.sh", {}, "total"),
        ("whoami", examples_dir / "whoami.sh", {}, "Username:"),
        ("date", examples_dir / "date.sh", {}, "202"),  # Should contain current year
        ("echo", examples_dir / "echo.sh", {"text": "test"}, "test"),
    ]
    
    print("🔍 Verifying ShAPI examples...")
    results = []
    
    for name, script, params, expected in examples:
        if not script.exists():
            print(f"❌ {name}: Script not found at {script}")
            results.append(False)
            continue
            
        results.append(verify_example(name, script, params, expected))
    
    # Print summary
    passed = sum(1 for r in results if r)
    total = len(results)
    
    print("\n📊 Verification Summary:")
    print(f"✅ {passed} out of {total} examples passed")
    print(f"❌ {total - passed} examples failed")
    
    sys.exit(0 if passed == total else 1)

if __name__ == "__main__":
    main()
