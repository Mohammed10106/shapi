"""Test package imports."""

def test_import_shapi():
    """Test that the shapi package can be imported."""
    try:
        import shapi
        assert shapi is not None
    except ImportError as e:
        assert False, f"Failed to import shapi: {e}"
