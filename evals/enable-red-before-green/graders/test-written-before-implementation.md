---
type: tool_order
before:
  tool: Write
  input_match: '"file_path"\s*:\s*"[^"]*test_greet\.py"'
after:
  tool: Edit
  input_match: '"file_path"\s*:\s*"[^"]*/greet\.py"'
---
