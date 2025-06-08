#!/usr/bin/env python3
"""
Simple script to verify the example scripts work correctly.
"""

import subprocess
import sys
import time
from pathlib import Path

def run_command(cmd, check=True):
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            check=check,
            capture_output=True,
            text=True
        )
        return result.returncode == 0, result.stdout, result.stderr
    except subprocess.CalledProcessError as e:
        return False, e.stdout, e.stderr

def test_ls():
    print("Testing ls.sh...")
    success, out, err = run_command("examples/ls.sh")
    if success:
        print("✅ ls.sh works")
        print(out.strip())
    else:
        print(f"❌ ls.sh failed: {err}")
    return success

def test_ps():
    print("\nTesting ps.sh...")
    success, out, err = run_command("examples/ps.sh")
    if success:
        print("✅ ps.sh works")
        print(out.strip()[:200] + "..." if len(out) > 200 else out.strip())
    else:
        print(f"❌ ps.sh failed: {err}")
    return success

def test_df():
    print("\nTesting df.sh...")
    success, out, err = run_command("examples/df.sh")
    if success:
        print("✅ df.sh works")
        print(out.strip())
    else:
        print(f"❌ df.sh failed: {err}")
    return success

def test_free():
    print("\nTesting free.sh...")
    success, out, err = run_command("examples/free.sh")
    if success:
        print("✅ free.sh works")
        print(out.strip())
    else:
        print(f"❌ free.sh failed: {err}")
    return success

def test_whoami():
    print("\nTesting whoami.sh...")
    success, out, err = run_command("examples/whoami.sh")
    if success:
        print("✅ whoami.sh works")
        print(out.strip())
    else:
        print(f"❌ whoami.sh failed: {err}")
    return success

def test_date():
    print("\nTesting date.sh...")
    success, out, err = run_command("examples/date.sh")
    if success:
        print("✅ date.sh works")
        print(out.strip())
    else:
        print(f"❌ date.sh failed: {err}")
    return success

def test_echo():
    print("\nTesting echo.sh...")
    success, out, err = run_command("examples/echo.sh 'Hello, World!'")
    if success and out.strip() == "Hello, World!":
        print("✅ echo.sh works")
        print(out.strip())
    else:
        print(f"❌ echo.sh failed: {err}")
    return success

def main():
    print("🔍 Testing example scripts...")
    
    tests = [
        test_ls,
        test_ps,
        test_df,
        test_free,
        test_whoami,
        test_date,
        test_echo
    ]
    
    results = []
    for test in tests:
        results.append(test())
    
    passed = sum(1 for r in results if r)
    total = len(results)
    
    print("\n📊 Test Results:")
    print(f"✅ {passed} out of {total} tests passed")
    print(f"❌ {total - passed} tests failed")
    
    sys.exit(0 if passed == total else 1)

if __name__ == "__main__":
    main()
