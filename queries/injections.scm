; Tree-sitter injections for makefiles
; Recipes are typically shell scripts.
(recipe_line
  (shell_text) @injection.content
  (#set! injection.language "bash"))
