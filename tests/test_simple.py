"""Simple test file to verify the testing setup."""

def test_import():
    """Test that the shapi package can be imported."""
    try:
        import shapi
        assert shapi is not None
        print("Successfully imported shapi package")
        return True
    except ImportError as e:
        print(f"Failed to import shapi: {e}")
        return False

if __name__ == "__main__":
    test_import()
