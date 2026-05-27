package targets

import (
	"fmt"
	"os"
	"path/filepath"
)

// Target describes a destination directory for skill files.
type Target struct {
	Name string
	Path string
}

// Claude returns the target for Claude Code's custom commands directory.
func Claude() (Target, error) {
	home, err := os.UserHomeDir()
	if err != nil {
		return Target{}, fmt.Errorf("resolve home directory: %w", err)
	}
	return Target{
		Name: "Claude Code",
		Path: filepath.Join(home, ".claude", "commands"),
	}, nil
}
