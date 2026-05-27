package main

import (
	"fmt"
	"os"

	"github.com/busycaesar/bheru/internal/installer"
	"github.com/busycaesar/bheru/internal/targets"
	"github.com/busycaesar/bheru/skills"
)

const version = "0.1.0"

const usage = `bheru — distribute AI skill files to your coding assistant tools

Commands:
  install    Copy all bundled skills to ~/.claude/commands/
  update     Re-copy all bundled skills (same as install)
  uninstall  Remove all bundled skills from ~/.claude/commands/
  list       List all skills bundled in this binary

Flags:
  --version, -v  Print version and exit
  --help, -h     Print this help and exit
`

func main() {
	if len(os.Args) < 2 {
		fmt.Print(usage)
		os.Exit(0)
	}

	switch os.Args[1] {
	case "--version", "-v":
		fmt.Printf("bheru %s\n", version)

	case "--help", "-h":
		fmt.Print(usage)

	case "install":
		runInstall()

	case "update":
		fmt.Println("Updating skills...")
		runInstall()

	case "uninstall":
		runUninstall()

	case "list":
		runList()

	default:
		fmt.Fprintf(os.Stderr, "bheru: unknown command %q\n\nRun 'bheru --help' for usage.\n", os.Args[1])
		os.Exit(1)
	}
}

func runInstall() {
	target, err := targets.Claude()
	if err != nil {
		fatal(err)
	}
	n, err := installer.Install(skills.FS, target)
	if err != nil {
		fatal(err)
	}
	fmt.Printf("Installed %d skills to %s\n", n, target.Path)
}

func runUninstall() {
	target, err := targets.Claude()
	if err != nil {
		fatal(err)
	}
	n, err := installer.Uninstall(skills.FS, target)
	if err != nil {
		fatal(err)
	}
	fmt.Printf("Removed %d skills from %s\n", n, target.Path)
}

func runList() {
	names, err := installer.List(skills.FS)
	if err != nil {
		fatal(err)
	}
	for _, name := range names {
		fmt.Println(name)
	}
	fmt.Printf("Total: %d skills\n", len(names))
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, "bheru:", err)
	os.Exit(1)
}
