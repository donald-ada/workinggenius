---
type: tool_order
before:
  tool: Bash
  input_match: 'unittest'
after:
  tool: Edit
  input_match: '"file_path"\s*:\s*"[^"]*/greet\.py"'
---
