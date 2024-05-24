package tree_sitter_make_test

import (
	"testing"

	tree_sitter "github.com/smacker/go-tree-sitter"
	"github.com/tree-sitter/tree-sitter-make"
)

func TestCanLoadGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_make.Language())
	if language == nil {
		t.Errorf("Error loading Make grammar")
	}
}
