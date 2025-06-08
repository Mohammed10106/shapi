#!/usr/bin/env python3
"""
Test script for ShAPI examples.
This script tests each example service by starting it, making requests, and verifying responses.
"""

import json
import subprocess
import time
import unittest
from typing import Dict, Any, Optional
import requests
from pathlib import Path

# Base URL for the services
BASE_URL = "http://localhost:{port}/run"

# Example configurations
EXAMPLES = {
    "ls": {
        "port": 8001,
        "params": {},
        "expected_contains": ["total"],
    },
    "ps": {
        "port": 8002,
        "params": {"pattern": "python"},
        "expected_contains": ["python"],
    },
    "df": {
        "port": 8003,
        "params": {},
        "expected_contains": ["Filesystem", "Size", "Use%"],
    },
    "free": {
        "port": 8004,
        "params": {},
        "expected_contains": ["total", "used", "free", "available"],
    },
    "whoami": {
        "port": 8005,
        "params": {},
        "expected_contains": ["Username:", "User ID:", "Groups:"],
    },
    "date": {
        "port": 8006,
        "params": {"format": "%Y"},
        "expected_contains": ["202"],  # Current year should be in the output
    },
    "echo": {
        "port": 8007,
        "params": {"text": "test123"},
        "expected_contains": ["test123"],
    },
}


class TestExamples(unittest.TestCase):
    """Test cases for ShAPI example services."""

    @classmethod
    def setUpClass(cls):
        """Start all example services before running tests."""
        cls.processes = {}
        for name, config in EXAMPLES.items():
            port = config["port"]
            cmd = [
                "shapi",
                "serve",
                f"examples/{name}.sh",
                "--name",
                f"test-{name}",
                "--port",
                str(port),
                "--daemon",
            ]
            # Start the service in the background
            proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            cls.processes[name] = proc
            # Give the service time to start
            time.sleep(1)

    @classmethod
    def tearDownClass(cls):
        """Stop all example services after tests complete."""
        for name, proc in cls.processes.items():
            try:
                # Try to stop the service gracefully
                subprocess.run(
                    ["shapi", "service", "stop", f"test-{name}"],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                )
                # If still running, terminate the process
                if proc.poll() is None:
                    proc.terminate()
                    try:
                        proc.wait(timeout=5)
                    except subprocess.TimeoutExpired:
                        proc.kill()
            except Exception as e:
                print(f"Error stopping {name}: {e}")

    def make_request(self, name: str, params: Dict[str, Any]) -> str:
        """Make a request to a service and return the response text."""
        port = EXAMPLES[name]["port"]
        url = BASE_URL.format(port=port)
        response = requests.post(
            url, json={"parameters": params}, timeout=10
        )
        self.assertEqual(response.status_code, 200, f"Request to {name} failed")
        return response.text

    def test_examples(self):
        """Test each example service."""
        for name, config in EXAMPLES.items():
            with self.subTest(example=name):
                # Make the request
                response = self.make_request(name, config["params"])
                
                # Check that expected strings are in the response
                for expected in config["expected_contains"]:
                    self.assertIn(
                        expected,
                        response,
                        f"Expected '{expected}' not found in {name} response",
                    )


if __name__ == "__main__":
    unittest.main()
