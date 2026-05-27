package installer

import (
	"fmt"
	"io/fs"
	"os"
	"path/filepath"

	"github.com/busycaesar/bheru/internal/targets"
)

// Install copies every file from skills into target, creating the directory if needed.
// Existing files are overwritten without prompting.
func Install(skills fs.FS, target targets.Target) (int, error) {
	if err := os.MkdirAll(target.Path, 0755); err != nil {
		return 0, fmt.Errorf("create directory %s: %w", target.Path, err)
	}

	entries, err := fs.ReadDir(skills, ".")
	if err != nil {
		return 0, fmt.Errorf("read embedded skills: %w", err)
	}

	count := 0
	for _, entry := range entries {
		if entry.IsDir() {
			continue
		}
		data, err := fs.ReadFile(skills, entry.Name())
		if err != nil {
			return count, fmt.Errorf("read skill %s: %w", entry.Name(), err)
		}
		dst := filepath.Join(target.Path, entry.Name())
		if err := os.WriteFile(dst, data, 0644); err != nil {
			return count, fmt.Errorf("write skill %s: %w", entry.Name(), err)
		}
		count++
	}
	return count, nil
}

// Uninstall removes files from target that match names in skills.
// Files not installed by bheru are left untouched.
func Uninstall(skills fs.FS, target targets.Target) (int, error) {
	entries, err := fs.ReadDir(skills, ".")
	if err != nil {
		return 0, fmt.Errorf("read embedded skills: %w", err)
	}

	count := 0
	for _, entry := range entries {
		if entry.IsDir() {
			continue
		}
		dst := filepath.Join(target.Path, entry.Name())
		err := os.Remove(dst)
		if err != nil && !os.IsNotExist(err) {
			return count, fmt.Errorf("remove %s: %w", entry.Name(), err)
		}
		if err == nil {
			count++
		}
	}
	return count, nil
}

// List returns the names of all skill files bundled in skills, sorted alphabetically.
// fs.ReadDir guarantees lexicographic order.
func List(skills fs.FS) ([]string, error) {
	entries, err := fs.ReadDir(skills, ".")
	if err != nil {
		return nil, fmt.Errorf("read embedded skills: %w", err)
	}

	var names []string
	for _, entry := range entries {
		if !entry.IsDir() {
			names = append(names, entry.Name())
		}
	}
	return names, nil
}
